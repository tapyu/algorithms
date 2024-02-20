using FileIO, JLD2, Random, LinearAlgebra, Plots, LaTeXStrings, DataStructures
include("grid_search_cross_validation.jl")
Σ=sum
⊙ = .* # Hadamard product

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

# load data
𝐗, 𝐝 = FileIO.load("../Datasets/Mama cancer [uci]/mama-cancer.jld2", "𝐗", "𝐝")
𝐝 = 𝐝.==4 # map malignant to true(=1)

## algorithm parameters and hyperparameters
K = 2 # number of classes (benign and malignant)
N = length(𝐝) # number of instances
Nₜᵣₙ = 80 # % percentage of instances for the train dataset
Nₜₛₜ = 20 # % percentage of instances for the test dataset
Nₐ = 9 # number of number of attributes (Clump Thickness, Uniformity of Cell Size, Uniformity of Cell Shape, Marginal Adhesion, Single Epithelial Cell Size, Bare Nuclei, Bland Chromatin, Normal Nucleoli, Mitoses)
Nᵣ = 20 # number of realizations
Nₑ = 100 # number of epochs
m₂ = 1 # number of perceptrons (neurons) of the output layer (only one since it is enough to classify)
η = 0.1 # learning step

# Standardize dataset (Preprocessing)
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
    𝐗ₜᵣₙ = 𝐗[:,1:(N*Nₜᵣₙ)÷100-6]
    𝐝ₜᵣₙ = 𝐝[1:(N*Nₜᵣₙ)÷100-6]
    𝐗ₜₛₜ = 𝐗[:,length(𝐝ₜᵣₙ)+1-6:end]
    𝐝ₜₛₜ = 𝐝[length(𝐝ₜᵣₙ)+1-6:end]

    # grid search with k-fold cross validation!
    # (m₁, (φ, φʼ, a)) = grid_search_cross_validation(𝐗ₜᵣₙ, 𝐝ₜᵣₙ, 5, (5:15, ((v₍ₙ₎ -> 1/(1+ℯ^(-v₍ₙ₎)), y₍ₙ₎ -> y₍ₙ₎*(1-y₍ₙ₎), 1), (v₍ₙ₎ -> (1-ℯ^(-v₍ₙ₎))/(1+ℯ^(-v₍ₙ₎)), y₍ₙ₎ -> .5(1-y₍ₙ₎^2), 2))))
    # println("For the realization $(nᵣ)")
    # println("best m₁: $(m₁)")
    # println("best φ: $(a==1 ? "logistic" : "Hyperbolic")")
    (m₁, (φ, φʼ)) = (6, (v₍ₙ₎ -> 1/(1+ℯ^(-v₍ₙ₎)), y₍ₙ₎ -> y₍ₙ₎*(1-y₍ₙ₎)))
    
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
    # savefig(fig, "figs/xor - training dataset accuracy evolution for realization $(nᵣ)- μ$(𝛍ₜₛₜ[nᵣ]).png")
    
    # confusion matrix
    if !isfile("figs/mama-cancer-confusion-matrix.png")
        𝐂 = zeros(2,2)
        𝐲ₜₛₜ = test(𝐗ₜₛₜ, 𝐝ₜₛₜ, 𝔚, φ, true)
        for n ∈ 1:length(𝐲ₜₛₜ)
            # predicted x true label
            𝐂[𝐲ₜₛₜ[n]+1, 𝐝ₜₛₜ[n]+1] += 1
        end
        h = heatmap(𝐂, xlabel="Predicted labels", ylabel="True labels", xticks=(1:2, ("benign", "malignant")), yticks=(1:2, ("benign", "malignant")), title="Confusion matrix")
        savefig(h, "figs/mama-cancer-confusion-matrix.png") # TODO: put the number onto each confusion square
    end
end

# analyze the accuracy statistics of each independent realization
μ̄ₜₛₜ = Σ(𝛍ₜₛₜ)/Nᵣ # mean
𝔼μ² = Σ(𝛍ₜₛₜ.^2)/Nᵣ
σμ = sqrt(𝔼μ² - μ̄ₜₛₜ^2) # standard deviation

println("Mean: $(μ̄ₜₛₜ)")
println("Standard deviation: $(σμ)")