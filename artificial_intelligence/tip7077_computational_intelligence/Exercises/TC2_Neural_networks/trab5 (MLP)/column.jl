using FileIO, JLD2, Random, LinearAlgebra, Plots, LaTeXStrings, DataStructures
include("grid_search_cross_validation.jl")
Σ=sum
⊙ = .* # Hadamard product

function one_hot_encoding(label)
    return ["DH", "SL", "NO"].==label
end

function shuffle_dataset(𝐗, 𝐃)
    shuffle_indices = Random.shuffle(1:size(𝐗,2))
    return 𝐗[:, shuffle_indices], 𝐃[:, shuffle_indices]
end

function train(𝐗, 𝐃, 𝔚, φ, φʼ)
    L = length(𝔚) # number of layers
    Nₑ = 0 # number of errors ➡ misclassifications
    for (𝐱₍ₙ₎, 𝐝₍ₙ₎) ∈ zip(eachcol(𝐗), eachcol(𝐃)) # n-th instance
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
                𝐞₍ₙ₎ = 𝐝₍ₙ₎ - 𝔶₍ₙ₎[L]
                i = findfirst(x->x==maximum(𝔶₍ₙ₎[L]), 𝔶₍ₙ₎[L]) # predicted value → choose the highest activation function output as the selected class
                Nₑ = 𝐝₍ₙ₎[i]==1 ? Nₑ : Nₑ+1 # count error if it occurs
                𝔡₍ₙ₎[L] = 𝔶ʼ₍ₙ₎[L] ⊙ 𝐞₍ₙ₎
            else # hidden layers
                𝔡₍ₙ₎[l] = 𝔶ʼ₍ₙ₎[l] ⊙ 𝔚[l+1][:,2:end]'*𝔡₍ₙ₎[l+1] # vector of local gradients of the l-th layer
            end
            𝔚[l] = l==1 ? 𝔚[l]+η*𝔡₍ₙ₎[l]*𝐱₍ₙ₎' : 𝔚[l]+η*𝔡₍ₙ₎[l]*[-1; 𝔶₍ₙ₎[l-1]]' # learning equation
        end
    end
    return 𝔚, (size(𝐃,2)-Nₑ)/size(𝐃,2) # trained neural network synaptic weights and its accuracy
end

function test(𝐗, 𝐃, 𝔚, φ, is_confusion_matrix=false)
    L = length(𝔚) # number of layers
    Nₑ = 0 # number of errors ➡ misclassification
    𝐘 = rand(size(𝐃)...)
    for (n, (𝐱₍ₙ₎, 𝐝₍ₙ₎)) ∈ enumerate(zip(eachcol(𝐗), eachcol(𝐃))) # n-th instance
        # initialize the output and the vetor of gradients of each layer!
        𝔶₍ₙ₎ = OrderedDict([(l, rand(size(𝐖⁽ˡ⁾₍ₙ₎, 1))) for (l, 𝐖⁽ˡ⁾₍ₙ₎) ∈ 𝔚])  # output of the l-th layer at the instant n
        # forward phase!
        for (l, 𝐖⁽ˡ⁾₍ₙ₎) ∈ 𝔚 # l-th layer
            𝐯⁽ˡ⁾₍ₙ₎ = l==1 ? 𝐖⁽ˡ⁾₍ₙ₎*𝐱₍ₙ₎ : 𝐖⁽ˡ⁾₍ₙ₎*[-1; 𝔶₍ₙ₎[l-1]] # induced local field
            𝔶₍ₙ₎[l] = map(φ, 𝐯⁽ˡ⁾₍ₙ₎)
            if l==L # output layer
                i = findfirst(x->x==maximum(𝔶₍ₙ₎[L]), 𝔶₍ₙ₎[L]) # predicted value → choose the highest activation function output as the selected class
                𝐘[:,n] = 1:length(𝐝₍ₙ₎).==i
                Nₑ = 𝐝₍ₙ₎[i]==1 ? Nₑ : Nₑ+1 # count error if it occurs
            end
        end
    end
    if is_confusion_matrix
        return Int.(𝐘)
    else
        return (size(𝐃,2)-Nₑ)/size(𝐃,2)
    end
end

## algorithm parameters and hyperparameters
K = 3 # number of classes: Normal (100 patients), Disk Hernia (60 patients) or Spondylolisthesis (150 patients)
N = 310 # number of instances
Nₜᵣₙ = 80 # % percentage of instances for the train dataset
Nₜₛₜ = 20 # % percentage of instances for the test dataset
Nₐ = 6 # number of number of attributes (pelvic incidence, pelvic tilt, lumbar lordosis angle, sacral slope, pelvic radius and grade of spondylolisthesis)
Nᵣ = 20 # number of realizations
Nₑ = 100 # number of epochs
m₂ = K # number of perceptrons (neurons) of the output layer = number of outputs = number of classes
η = 0.1 # learning step

## load dataset
𝐗, labels = FileIO.load("../Datasets/Vertebral column [uci]/dataset_3classes.jld2", "𝐗", "𝐝")
𝐃 = rand(K,0)
for label ∈ labels
    global 𝐃 = [𝐃 one_hot_encoding(label)]
end

## Standardize dataset (Preprocessing)
𝛍ₓ = Σ(𝐗, dims=2)/N # mean vector
𝔼μ² = Σ(𝐗.^2, dims=2)/N # vector of the second moment of 𝐗
σμ = sqrt.(𝔼μ² - 𝛍ₓ.^2) # vector of the standard deviation
𝐗 = (𝐗 .- 𝛍ₓ)./σμ # zero-mean and unit variance dataset
𝐗 = [fill(-1, size(𝐗,2))'; 𝐗] # add the -1 input (bias)

## init
𝛍ₜₛₜ = fill(NaN, Nᵣ) # vector of accuracies for test dataset
for nᵣ ∈ 1:Nᵣ
    # prepare the data!
    global 𝐗, 𝐃 = shuffle_dataset(𝐗, 𝐃)
    # hould-out
    global 𝐗ₜᵣₙ = 𝐗[:,1:((N*Nₜᵣₙ)÷100)-8]
    global 𝐃ₜᵣₙ = 𝐃[:,1:((N*Nₜᵣₙ)÷100)-8]
    global 𝐗ₜₛₜ = 𝐗[:,size(𝐃ₜᵣₙ, 2)+1-8:end]
    global 𝐃ₜₛₜ = 𝐃[:,size(𝐃ₜᵣₙ, 2)+1-8:end]
    
    # grid search with k-fold cross validation!
    # (m₁, (φ, φʼ, a)) = grid_search_cross_validation(𝐗ₜᵣₙ, 𝐃ₜᵣₙ, 5, (6:7, ((v₍ₙ₎ -> 1/(1+ℯ^(-v₍ₙ₎)), y₍ₙ₎ -> y₍ₙ₎*(1-y₍ₙ₎), 1), (v₍ₙ₎ -> (1-ℯ^(-v₍ₙ₎))/(1+ℯ^(-v₍ₙ₎)), y₍ₙ₎ -> .5(1-y₍ₙ₎^2), 2))))
    # println("For the realization $(nᵣ)")
    # println("best m₁: $(m₁)")
    # println("best φ: $(a==1 ? "logistic" : "Hyperbolic")")
    (m₁, (φ, φʼ)) = (6, (v₍ₙ₎ -> 1/(1+ℯ^(-v₍ₙ₎)), y₍ₙ₎ -> y₍ₙ₎*(1-y₍ₙ₎)))
    
    # initialize!
    𝔚 = OrderedDict(1 => rand(m₁, Nₐ+1), 2 => rand(m₂, m₁+1)) # 1 => first layer (hidden layer) 2 => second layer
    𝛍ₜᵣₙ = fill(NaN, Nₑ) # vector of accuracies for train dataset (to see its evolution during training phase)
    
    # train!
    for nₑ ∈ 1:Nₑ # for each epoch
        𝔚, 𝛍ₜᵣₙ[nₑ] = train(𝐗ₜᵣₙ, 𝐃ₜᵣₙ, 𝔚, φ, φʼ)
        𝐗ₜᵣₙ, 𝐃ₜᵣₙ = shuffle_dataset(𝐗ₜᵣₙ, 𝐃ₜᵣₙ)
    end
    # test!
    global 𝛍ₜₛₜ[nᵣ] = test(𝐗ₜₛₜ, 𝐃ₜₛₜ, 𝔚, φ) # accuracy for this realization
    
    # plot training dataset accuracy evolution
    local fig = plot(𝛍ₜᵣₙ, ylims=(0,2), xlabel="Epochs", ylabel="Accuracy", linewidth=2)
    savefig(fig, "figs/column - training dataset accuracy evolution for realization $(nᵣ).png")

    # confusion matrix
    if nᵣ==1
        𝐂 = zeros(2,2)
        𝐘ₜₛₜ = test(𝐗ₜₛₜ, 𝐃ₜₛₜ, 𝔚, φ, true)
        for (l, label) ∈ enumerate(("Disk Hernia", "Spondylolisthesis", "Normal"))
            if !isfile("figs/column-$(label)-confusion-matrix.png")
                for n ∈ 1:size(𝐘ₜₛₜ, 2)
                    # predicted x true label
                    𝐂[𝐘ₜₛₜ[l, n]+1, Int(𝐃ₜₛₜ[l, n])+1] += 1
                end
                fig = heatmap(𝐂, xlabel="Predicted labels", ylabel="True labels", xticks=(1:2, ("not $(label)", "$(label)")), yticks=(1:2, ("not $(label)", "$(label)")), title="Confusion matrix for the label $(label)")
                savefig(fig, "figs/column-$(label)-confusion-matrix.png") # TODO: put the number onto each confusion square
            end
        end
    end
end

# analyze the accuracy statistics of each independent realization
μ̄ₜₛₜ = Σ(𝛍ₜₛₜ)/Nᵣ # mean
𝔼μ² = Σ(𝛍ₜₛₜ.^2)/Nᵣ
σμ = sqrt(𝔼μ² - μ̄ₜₛₜ^2) # standard deviation

println("Mean: $(μ̄ₜₛₜ)")
println("Standard deviation: $(σμ)")