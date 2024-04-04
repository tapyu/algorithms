using FileIO, JLD2, Random, LinearAlgebra, Plots, LaTeXStrings, DataStructures
include("grid_search_cross_validation.jl")
Σ=sum
⊙ = .* # Hadamard product

function one_hot_encoding(label)
    return ["setosa", "virginica", "versicolor"].==label
end

function shuffle_dataset(𝐗, 𝐝)
    shuffle_indices = Random.shuffle(1:size(𝐗,2))
    return 𝐗[:, shuffle_indices], 𝐝[shuffle_indices]
end

function train(𝐗, 𝐝, 𝔚, φ, φʼ)
    L = length(𝔚) # number of layers
    Nₑ = 0 # number of errors ➡ misclassifications
    for (𝐱₍ₙ₎, d₍ₙ₎) ∈ zip(eachcol(𝐗), 𝐝) # n-th instance
        # initialize the output and the vetor of gradients of each layer!
        𝔶₍ₙ₎ = OrderedDict([(l, rand(size(𝐖⁽ˡ⁾₍ₙ₎, 1))) for (l, 𝐖⁽ˡ⁾₍ₙ₎) ∈ 𝔚])  # output of the l-th layer at the instant n
        𝔶ʼ₍ₙ₎ = OrderedDict(𝔶₍ₙ₎) # diff of the output of the l-th layer at the instant n
        𝔡₍ₙ₎ = OrderedDict(𝔶₍ₙ₎) # all local gradients of all layers
        # forward phase!
        for (l, 𝐖⁽ˡ⁾₍ₙ₎) ∈ 𝔚 # l-th layer
            𝐯⁽ˡ⁾₍ₙ₎ = l==1 ? 𝐖⁽ˡ⁾₍ₙ₎*𝐱₍ₙ₎ : 𝐖⁽ˡ⁾₍ₙ₎*[-1; 𝔶₍ₙ₎[l-1]] # induced local field
            𝔶₍ₙ₎[l] = map(φ, 𝐯⁽ˡ⁾₍ₙ₎)
            𝔶ʼ₍ₙ₎[l] = map(φʼ, 𝔶₍ₙ₎[l])
        end
        # backward phase!
        for l ∈ L:-1:1
            if l==L # output layer
                e₍ₙ₎ = [d₍ₙ₎] - 𝔶₍ₙ₎[L]
                y₍ₙ₎ = 𝔶₍ₙ₎[L][1]>.5 ? 1 : 0 # predicted value → get the result of the step function
                Nₑ = d₍ₙ₎==y₍ₙ₎ ? Nₑ : Nₑ+1 # count error if it occurs
                𝔡₍ₙ₎[L] = 𝔶ʼ₍ₙ₎[L] ⊙ e₍ₙ₎
            else # hidden layers
                𝔡₍ₙ₎[l] = 𝔶ʼ₍ₙ₎[l] ⊙ 𝔚[l+1][:,2:end]'*𝔡₍ₙ₎[l+1] # vector of local gradients of the l-th layer
            end
            𝔚[l] = l==1 ? 𝔚[l]+η*𝔡₍ₙ₎[l]*𝐱₍ₙ₎' : 𝔚[l]+η*𝔡₍ₙ₎[l]*[-1; 𝔶₍ₙ₎[l-1]]' # learning equation
        end
    end
    return 𝔚, (length(𝐝)-Nₑ)/length(𝐝) # trained neural network synaptic weights and its accuracy
end

function test(𝐗, 𝐝, 𝔚, φ, is_confusion_matrix=false)
    L = length(𝔚) # number of layers
    Nₑ = 0 # number of errors ➡ misclassification
    𝐲 = rand(length(𝐝))
    for (n, (𝐱₍ₙ₎, d₍ₙ₎)) ∈ enumerate(zip(eachcol(𝐗), 𝐝)) # n-th instance
        # initialize the output and the vetor of gradients of each layer!
        𝔶₍ₙ₎ = OrderedDict([(l, rand(size(𝐖⁽ˡ⁾₍ₙ₎, 1))) for (l, 𝐖⁽ˡ⁾₍ₙ₎) ∈ 𝔚])  # output of the l-th layer at the instant n
        # forward phase!
        for (l, 𝐖⁽ˡ⁾₍ₙ₎) ∈ 𝔚 # l-th layer
            𝐯⁽ˡ⁾₍ₙ₎ = l==1 ? 𝐖⁽ˡ⁾₍ₙ₎*𝐱₍ₙ₎ : 𝐖⁽ˡ⁾₍ₙ₎*[-1; 𝔶₍ₙ₎[l-1]] # induced local field
            𝔶₍ₙ₎[l] = map(φ, 𝐯⁽ˡ⁾₍ₙ₎)
            if l==L # output layer
                𝐲[n] = 𝔶₍ₙ₎[L][1]>.5 ? 1 : 0 # predicted value → get the result of the step function
                Nₑ = d₍ₙ₎==𝐲[n] ? Nₑ : Nₑ+1 # count error if it occurs
            end
        end
    end
    
    if is_confusion_matrix
        return Int.(𝐲)
    else
        return (length(𝐝)-Nₑ)/length(𝐝)
    end
end

## algorithm parameters and hyperparameters
K = 2 # number of classes (1 and 0)
N = 200 # number of instances
Nₜᵣₙ = 80 # % percentage of instances for the train dataset
Nₜₛₜ = 20 # % percentage of instances for the test dataset
Nₐ = 2 # number of number of attributes (x₁ and x₂)
Nᵣ = 20 # number of realizations
Nₑ = 100 # number of epochs
m₂ = 1 # number of perceptrons (neurons) of the output layer (only one since it is enough to classify 0 or 1)
η = 2 # learning step

𝐗 = [fill(0, 100)' fill(1, 100)'; fill(1, 50)' fill(0, 100)' fill(1, 50)']
𝐝 = map(x -> x[1] ⊻ x[2], eachcol(𝐗))
## Standardize dataset (Preprocessing)
𝛍ₓ = Σ(𝐗, dims=2)/N # mean vector
𝔼μ² = Σ(𝐗.^2, dims=2)/N # vector of the second moment of 𝐗
σμ = sqrt.(𝔼μ² - 𝛍ₓ.^2) # vector of the standard deviation
𝐗 = (𝐗 .- 𝛍ₓ)./σμ # zero mean and unit variance
𝐗 = [fill(-1, size(𝐗,2))'; 𝐗] # add the -1 input (bias)

## init
𝛍ₜₛₜ = fill(NaN, Nᵣ) # vector of accuracies for test dataset
for nᵣ ∈ 1:Nᵣ
    # prepare the data!
    global 𝐗, 𝐝 = shuffle_dataset(𝐗, 𝐝)
    # hould-out
    𝐗ₜᵣₙ = 𝐗[:,1:(N*Nₜᵣₙ)÷100]
    𝐝ₜᵣₙ = 𝐝[1:(N*Nₜᵣₙ)÷100]
    𝐗ₜₛₜ = 𝐗[:,length(𝐝ₜᵣₙ)+1:end]
    𝐝ₜₛₜ = 𝐝[length(𝐝ₜᵣₙ)+1:end]

    # grid search with k-fold cross validation!
    (m₁, (φ, φʼ, a)) = grid_search_cross_validation(𝐗ₜᵣₙ, 𝐝ₜᵣₙ, 10, (1:3, ((v₍ₙ₎ -> 1/(1+ℯ^(-v₍ₙ₎)), y₍ₙ₎ -> y₍ₙ₎*(1-y₍ₙ₎), 1), (v₍ₙ₎ -> (1-ℯ^(-v₍ₙ₎))/(1+ℯ^(-v₍ₙ₎)), y₍ₙ₎ -> .5(1-y₍ₙ₎^2), 2), (v₍ₙ₎ -> v₍ₙ₎>0 ? 1 : 0, y₍ₙ₎ -> 1, 3))))
    println("For the realization $(nᵣ)")
    println("best m₁: $(m₁)")
    println("best φ: $(a==1 ? "logistic" : (a==2 ? "Hyperbolic" : "Mcculloch and pitts"))")
    
    # initialize!
    𝔚 = OrderedDict(1 => rand(m₁, Nₐ+1), 2 => rand(m₂, m₁+1)) # 1 => first layer (hidden layer) 2 => second layer 
    𝛍ₜᵣₙ = fill(NaN, Nₑ) # vector of accuracies for train dataset (to see its evolution during training phase)

    # train!
    for nₑ ∈ 1:Nₑ # for each epoch
        𝔚, 𝛍ₜᵣₙ[nₑ] = train(𝐗ₜᵣₙ, 𝐝ₜᵣₙ, 𝔚, φ, φʼ)
        𝐗ₜᵣₙ, 𝐝ₜᵣₙ = shuffle_dataset(𝐗ₜᵣₙ, 𝐝ₜᵣₙ)
    end
    # test!
    global 𝛍ₜₛₜ[nᵣ] = test(𝐗ₜₛₜ, 𝐝ₜₛₜ, 𝔚, φ) # accuracy for this realization
    
    # plot training dataset accuracy evolution
    local fig = plot(𝛍ₜᵣₙ, xlabel="Epochs", ylabel="Accuracy", linewidth=2)
    # savefig(fig, "trab5 (MLP)/figs/xor - training dataset accuracy evolution for realization $(nᵣ)- μ$(𝛍ₜₛₜ[nᵣ]).png")
    
    ## predictor of the class (basically it is what is done on test(), but only with the attributes as inputs)
    y = function predict(x₁, x₂)
        𝔶₍ₙ₎ = OrderedDict([(l, rand(size(𝐖⁽ˡ⁾₍ₙ₎, 1))) for (l, 𝐖⁽ˡ⁾₍ₙ₎) ∈ 𝔚])
        L = length(𝔚)
        𝐱₍ₙ₎ = [-1, x₁, x₂]
        for (l, 𝐖⁽ˡ⁾₍ₙ₎) ∈ 𝔚 # l-th layer
            𝐯⁽ˡ⁾₍ₙ₎ = l==1 ? 𝐖⁽ˡ⁾₍ₙ₎*𝐱₍ₙ₎ : 𝐖⁽ˡ⁾₍ₙ₎*[-1; 𝔶₍ₙ₎[l-1]] # induced local field
            𝔶₍ₙ₎[l] = map(φ, 𝐯⁽ˡ⁾₍ₙ₎)
            if l==L # output layer
                return 𝔶₍ₙ₎[L][1]>.5 ? 1 : 0
            end
        end
    end

    y1 = function predict_hidden1(x₁, x₂) # the heatmap of the first hidden layer
        y⁽¹⁾₁₍ₙ₎ = rand(size(𝔚[1], 1))
        𝐱₍ₙ₎ = [-1, x₁, x₂]

        𝐯⁽ˡ⁾₍ₙ₎ = 𝔚[1]*𝐱₍ₙ₎# induced local field
        y⁽¹⁾₁₍ₙ₎ = map(φ, 𝐯⁽ˡ⁾₍ₙ₎)
        return y⁽¹⁾₁₍ₙ₎[1]>.5 ? 1 : 0
    end

    y2 = function predict_hidden2(x₁, x₂) # the heatmap of the first hidden layer
        y⁽¹⁾₁₍ₙ₎ = rand(size(𝔚[1], 1))
        𝐱₍ₙ₎ = [-1, x₁, x₂]

        𝐯⁽ˡ⁾₍ₙ₎ = 𝔚[1]*𝐱₍ₙ₎# induced local field
        y⁽¹⁾₁₍ₙ₎ = map(φ, 𝐯⁽ˡ⁾₍ₙ₎)
        return y⁽¹⁾₁₍ₙ₎[2]>.5 ? 1 : 0
    end
    
    # plot heatmap for the 1th realization
    x₁_range = -1:.1:2
    x₂_range = -1:.1:2
    
    fig = contour(x₁_range, x₂_range, y, xlabel = L"x_1", ylabel = L"x_2", fill=true, levels=1)
    
    # train 0 label
    scatter!(𝐗ₜᵣₙ[2, 𝐝ₜᵣₙ.==0], 𝐗ₜᵣₙ[3, 𝐝ₜᵣₙ.==0], markershape = :hexagon, markersize = 8, markeralpha = 0.6, markercolor = :green, markerstrokewidth = 3, markerstrokealpha = 0.2, markerstrokecolor = :black, label = "0 label [train]")
    
    # test 0 label
    scatter!(𝐗ₜₛₜ[2, 𝐝ₜₛₜ.==0], 𝐗ₜₛₜ[3, 𝐝ₜₛₜ.==0], markershape = :dtriangle, markersize = 8, markeralpha = 0.6, markercolor = :green, markerstrokewidth = 3, markerstrokealpha = 0.2, markerstrokecolor = :black, label = "0 label [test]")
    
    # train 1 label
    scatter!(𝐗ₜᵣₙ[2, 𝐝ₜᵣₙ.==1], 𝐗ₜᵣₙ[3, 𝐝ₜᵣₙ.==1], markershape = :hexagon, markersize = 8, markeralpha = 0.6, markercolor = :white, markerstrokewidth = 3, markerstrokealpha = 0.2, markerstrokecolor = :black, label = "1 label [train]")
        
    # test 1 label
    scatter!(𝐗ₜₛₜ[2, 𝐝ₜₛₜ.==1], 𝐗ₜₛₜ[3, 𝐝ₜₛₜ.==1], markershape = :dtriangle, markersize = 8, markeralpha = 0.6, markercolor = :white, markerstrokewidth = 3, markerstrokealpha = 0.2, markerstrokecolor = :black, label = "1 label [test]")
    
    title!("Heatmap")
    savefig(fig, "trab5 (MLP)/figs/XOR problem - heatmap - nr$(nᵣ).png") #  - μ$(𝛍ₜₛₜ[nᵣ])
    
    # heatmap for the hidden neuron 1!
    fig = contour(x₁_range, x₂_range, y1, xlabel=L"x_1", ylabel=L"x_2", fill=true, levels=1, title="Heatmap of the first hidden neuron")
    scatter!([1 1 0 0], [1 0 1 0], markershape = :hexagon, markersize = 8, markeralpha = 0.6, markercolor = :white, markerstrokewidth = 3, markerstrokealpha = 0.2, markerstrokecolor = :black)
    # savefig(fig, "trab5 (MLP)/figs/XOR problem - heatmap - hidden neuron 1 - nr$(nᵣ) - μ$(𝛍ₜₛₜ[nᵣ]).png")

    # heatmap for the hidden neuron 2!
    # fig = contour(x₁_range, x₂_range, y2, xlabel=L"x_1", ylabel=L"x_2", fill=true, levels=1, title="Heatmap of the second hidden neuron")
    scatter!([1 1 0 0], [1 0 1 0], markershape = :hexagon, markersize = 8, markeralpha = 0.6, markercolor = :white, markerstrokewidth = 3, markerstrokealpha = 0.2, markerstrokecolor = :black)
    # savefig(fig, "trab5 (MLP)/figs/XOR problem - heatmap - hidden neuron 2 - nr$(nᵣ) - μ$(𝛍ₜₛₜ[nᵣ]).png")
    # if 𝛍ₜₛₜ[nᵣ] != 1 # make heatmap plot!
    # end
    
    # confusion matrix
    if 𝛍ₜₛₜ[nᵣ] == 1 && !isfile("trab5 (MLP)/figs/xor-confusion-matrix.png")
        𝐂 = zeros(2,2)
        𝐲ₜₛₜ = test(𝐗ₜₛₜ, 𝐝ₜₛₜ, 𝔚, φ, true)
        for n ∈ 1:length(𝐲ₜₛₜ)
            # predicted x true label
            𝐂[𝐲ₜₛₜ[n]+1, 𝐝ₜₛₜ[n]+1] += 1
        end
        h = heatmap(𝐂, xlabel="Predicted labels", ylabel="True labels", xticks=(1:2, (0, 1)), yticks=(1:2, (0, 1)), title="Confusion matrix")
        savefig(h, "trab5 (MLP)/figs/xor-confusion-matrix.png") # TODO: put the number onto each confusion square
    end
end

# analyze the accuracy statistics of each independent realization
μ̄ₜₛₜ = Σ(𝛍ₜₛₜ)/Nᵣ # mean
𝔼μ² = Σ(𝛍ₜₛₜ.^2)/Nᵣ
σμ = sqrt(𝔼μ² - μ̄ₜₛₜ^2) # standard deviation

println("Mean: $(μ̄ₜₛₜ)")
println("Standard deviation: $(σμ)")

# plot(𝛍ₜₛₜ)