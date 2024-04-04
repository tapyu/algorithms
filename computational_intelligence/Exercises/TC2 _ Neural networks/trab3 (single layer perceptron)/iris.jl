using FileIO, JLD2, Random, LinearAlgebra, Plots, LaTeXStrings
Σ=sum

## algorithm parameters and hyperparameters
N = 150 # number of instances
Nₜᵣₙ = 80 # % percentage of instances for the train dataset
Nₜₛₜ = 20 # % percentage of instances for the test dataset
Nₐ = 4 # number of number of attributes, that is, input vector size at each intance n. They are: sepal length, sepal width, petal length, petal width
Nᵣ = 20 # number of realizations
Nₑ = 100 # number of epochs
c = 3 # number of perceptrons (neurons) of the single layer
α = 0.001 # learning step

## useful functions
function shuffle_dataset(𝐗, 𝐃)
    shuffle_indices = Random.shuffle(1:size(𝐗,2))
    return 𝐗[:, shuffle_indices], 𝐃[:, shuffle_indices]
end

function train(𝐗, 𝐃, 𝐖₍ₙ₎, is_training_accuracy=true)
    φ = u₍ₙ₎ -> u₍ₙ₎>0 ? 1 : 0 # McCulloch and Pitts's activation function (step function)
    Nₑ = 0 # number of errors ➡ misclassifications
    for (𝐱₍ₙ₎, 𝐝₍ₙ₎) ∈ zip(eachcol(𝐗), eachcol(𝐃))
        𝛍₍ₙ₎ = 𝐖₍ₙ₎*𝐱₍ₙ₎ # induced local field
        𝐲₍ₙ₎ = map(φ, 𝛍₍ₙ₎) # for the training phase, you do not pass y₍ₙ₎ to a harder decisor (the McCulloch and Pitts's activation function) (??? TODO)
        𝐞₍ₙ₎ = 𝐝₍ₙ₎ - 𝐲₍ₙ₎
        𝐖₍ₙ₎ += α*𝐞₍ₙ₎*𝐱₍ₙ₎'

        # this part is optional: only if it is interested in seeing the accuracy evolution of the training dataset throughout the epochs
        i = findfirst(x->x==maximum(𝛍₍ₙ₎), 𝛍₍ₙ₎)
        Nₑ = 𝐝₍ₙ₎[i]==1 ? Nₑ : Nₑ+1
    end
    if is_training_accuracy
        accuracy = (size(𝐃,2)-Nₑ)/size(𝐃,2)
        return 𝐖₍ₙ₎, accuracy
    else
        return  𝐖₍ₙ₎
    end
end

function test(𝐗, 𝐃, 𝐖₍ₙ₎)
    φ = u₍ₙ₎ -> u₍ₙ₎>0 ? 1 : 0 # McCulloch and Pitts's activation function (step function)
    Nₑ = 0 # number of errors ➡ misclassifications
    for (𝐱₍ₙ₎, 𝐝₍ₙ₎) ∈ zip(eachcol(𝐗), eachcol(𝐃))
        𝛍₍ₙ₎ = 𝐖₍ₙ₎*𝐱₍ₙ₎# induced local field
        # y₍ₙ₎ = map(φ, 𝛍₍ₙ₎) # theoretically, you need to pass 𝛍₍ₙ₎ through the activation function, but, in order to solve ambiguous instances (see Ajalmar's handwritings), we pick the class with the highest activation function input
        i = findfirst(x->x==maximum(𝛍₍ₙ₎), 𝛍₍ₙ₎) # predicted value → choose the highest activation function input as the selected class
        Nₑ = 𝐝₍ₙ₎[i]==1 ? Nₑ : Nₑ+1
    end
    accuracy = (size(𝐃,2)-Nₑ)/size(𝐃,2)
    return accuracy
end

function one_hot_encoding(label)
    return ["setosa", "virginica", "versicolor"].==label
end

## load dataset
𝐗, labels = FileIO.load("Datasets/Iris [uci]/iris.jld2", "𝐗", "𝐝") # 𝐗 ➡ [attributes X instances]
𝐗 = [fill(-1, size(𝐗,2))'; 𝐗] # add the -1 input (bias)
𝐃 = rand(c,0)
for label ∈ labels
    global 𝐃 = [𝐃 one_hot_encoding(label)]
end

## init
accₜₛₜ = fill(NaN, Nᵣ) # vector of accuracies for test dataset
for nᵣ ∈ 1:Nᵣ
    # initialize!
    𝐖₍ₙ₎ = rand(c, Nₐ+1) # [𝐰₁ᵀ; 𝐰₂ᵀ; ...; 𝐰ᵀ_c]
    accₜᵣₙ = fill(NaN, Nₑ) # vector of accuracies for train dataset (to see its evolution during training phase)

    # prepare the data!
    global 𝐗, 𝐃 = shuffle_dataset(𝐗, 𝐃)
    # hould-out
    global 𝐗ₜᵣₙ = 𝐗[:,1:(N*Nₜᵣₙ)÷100]
    global 𝐃ₜᵣₙ = 𝐃[:,1:(N*Nₜᵣₙ)÷100]
    global 𝐗ₜₛₜ = 𝐗[:,size(𝐃ₜᵣₙ, 2)+1:end]
    global 𝐃ₜₛₜ = 𝐃[:,size(𝐃ₜᵣₙ, 2)+1:end]

    # train!
    for nₑ ∈ 1:Nₑ # for each epoch
        𝐖₍ₙ₎, accₜᵣₙ[nₑ] = train(𝐗ₜᵣₙ, 𝐃ₜᵣₙ, 𝐖₍ₙ₎)
        𝐗ₜᵣₙ, 𝐃ₜᵣₙ = shuffle_dataset(𝐗ₜᵣₙ, 𝐃ₜᵣₙ)
    end
    # test!
    global accₜₛₜ[nᵣ] = test(𝐗ₜₛₜ, 𝐃ₜₛₜ, 𝐖₍ₙ₎) # accuracy for this realization
    
    # plot training dataset accuracy evolution
    local fig = plot(accₜᵣₙ, ylims=(0,2), label=["setosa" "virginica" "versicolor"], xlabel="Epochs", ylabel="Accuracy", linewidth=2)
    savefig(fig, "trab3 (single layer perceptron)/figs/iris - training dataset accuracy evolution for realization $(nᵣ).png")
end

# analyze the accuracy statistics of each independent realization
āc̄c̄ = Σ(accₜₛₜ)/Nᵣ # mean
𝔼acc² = Σ(accₜₛₜ.^2)/Nᵣ
σacc = sqrt.(𝔼acc² .- āc̄c̄.^2) # standard deviation

println("Mean: $(āc̄c̄)")
println("Standard deviation: $(σacc)")