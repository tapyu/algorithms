using FileIO, JLD2, Random, LinearAlgebra, Plots, LaTeXStrings, DataStructures
include("grid_search_cross_validation.jl")
Σ=sum
⊙ = .* # Hadamard product

# generate dataset
N = 500 # number of instances
𝐱 = range(0, 2π, length=N)
𝐝 = map(x₍ₙ₎ -> 3sin(x₍ₙ₎)+1, 𝐱)

function shuffle_dataset(𝐱, 𝐝)
    shuffle_indices = Random.shuffle(1:length(𝐱))
    return 𝐱[shuffle_indices], 𝐝[shuffle_indices]
end

function train(𝐱, 𝐝, 𝔚, φ, φʼ)
    L = length(𝔚) # number of layers
    N = length(𝐝) # number of samples for the training dataset
    𝐞 = rand(length(𝐝)) # matrix with all errors
    for (n, (x₍ₙ₎, d₍ₙ₎)) ∈ enumerate(zip(𝐱, 𝐝)) # n-th instance
        # initialize the output and the vetor of gradients of each layer!
        𝔶₍ₙ₎ = OrderedDict([(l, rand(size(𝐖⁽ˡ⁾₍ₙ₎, 1))) for (l, 𝐖⁽ˡ⁾₍ₙ₎) ∈ 𝔚])  # output of the l-th layer at the instant n
        𝔶ʼ₍ₙ₎ = OrderedDict(𝔶₍ₙ₎) # diff of the output of the l-th layer at the instant n
        𝔡₍ₙ₎ = OrderedDict(𝔶₍ₙ₎) # all local gradients of all layers
        # forward phase!
        for (l, 𝐖⁽ˡ⁾₍ₙ₎) ∈ 𝔚 # l-th layer
            𝐯⁽ˡ⁾₍ₙ₎ = l==1 ? 𝐖⁽ˡ⁾₍ₙ₎*[-1; x₍ₙ₎] : 𝐖⁽ˡ⁾₍ₙ₎*[-1; 𝔶₍ₙ₎[l-1]] # induced local field
            𝔶₍ₙ₎[l] = map(φ, 𝐯⁽ˡ⁾₍ₙ₎)
            𝔶ʼ₍ₙ₎[l] = map(φʼ, 𝔶₍ₙ₎[l])
        end
        # backward phase!
        for l ∈ L:-1:1
            if l==L # output layer
                e₍ₙ₎ = d₍ₙ₎ - 𝔶₍ₙ₎[L][1]
                𝐞[n] = e₍ₙ₎
                𝔡₍ₙ₎[L] = 𝔶ʼ₍ₙ₎[L] ⊙ e₍ₙ₎
            else # hidden layers
                𝔡₍ₙ₎[l] = 𝔶ʼ₍ₙ₎[l] ⊙ 𝔚[l+1][:,2:end]'*𝔡₍ₙ₎[l+1] # vector of local gradients of the l-th layer
            end
            𝔚[l] = l==1 ? 𝔚[l]+η*𝔡₍ₙ₎[l]*[-1; x₍ₙ₎]' : 𝔚[l]+η*𝔡₍ₙ₎[l]*[-1; 𝔶₍ₙ₎[l-1]]' # learning equation
        end
    end
    RMSE = √(Σ(𝐞.^2)/N)
    return 𝔚, RMSE # trained neural network synaptic weights and its RMSE
end

function test(𝐱, 𝐝, 𝔚, φ, is_output=false)
    L = length(𝔚) # number of layers
    N = length(𝐝) # number of samples for the training dataset
    𝐞 = rand(length(𝐝)...) # matrix with all errors
    𝐲 = rand(length(𝐝)...)
    for (n, (x₍ₙ₎, e₍ₙ₎)) ∈ enumerate(zip(𝐱, 𝐝)) # n-th instance
        # initialize the output and the vetor of gradients of each layer!
        𝔶₍ₙ₎ = OrderedDict([(l, rand(size(𝐖⁽ˡ⁾₍ₙ₎, 1))) for (l, 𝐖⁽ˡ⁾₍ₙ₎) ∈ 𝔚])  # output of the l-th layer at the instant n
        # forward phase!
        for (l, 𝐖⁽ˡ⁾₍ₙ₎) ∈ 𝔚 # l-th layer
            𝐯⁽ˡ⁾₍ₙ₎ = l==1 ? 𝐖⁽ˡ⁾₍ₙ₎*[-1; x₍ₙ₎] : 𝐖⁽ˡ⁾₍ₙ₎*[-1; 𝔶₍ₙ₎[l-1]] # induced local field
            𝔶₍ₙ₎[l] = map(φ, 𝐯⁽ˡ⁾₍ₙ₎)
            l==L && (𝐞[n] = e₍ₙ₎ - 𝔶₍ₙ₎[L][1]; 𝐲[n]= 𝔶₍ₙ₎[L][1])
        end
    end
    RMSE = √(Σ(𝐞.^2)/N)
    return is_output ? (RMSE, 𝐲) : RMSE # RMSE of the test dataset
end

## algorithm parameters and hyperparameters
Nₜᵣₙ = 80 # % percentage of instances for the train dataset
Nₜₛₜ = 20 # % percentage of instances for the test dataset
Nₐ = 1 # number of number of attributes (only x(n))
Nᵣ = 20 # number of realizations
Nₑ = 100 # number of epochs
m₂ = 1 # regression problem
η = 0.5 # learning step

## Standardize dataset input and output in [-1,1] (Preprocessing)
μ = Σ(𝐝)/N # mean
𝔼μ² = Σ(𝐝.^2)/N # second moment of
σμ = sqrt.(𝔼μ² - μ.^2) # standard deviation
𝐝 = (𝐝 .- μ)./σμ # zero mean and unit variance
𝐝 = 𝐝./maximum(abs.(𝐝))

μ = Σ(𝐱)/N # mean
𝔼μ² = Σ(𝐱.^2)/N # second moment of
σμ = sqrt.(𝔼μ² - μ.^2) # standard deviation
𝐱 = (𝐱 .- μ)./σμ # zero mean and unit variance
𝐱 = 𝐱./maximum(abs.(𝐱))

## init
𝛍ₜₛₜ = fill(NaN, Nᵣ) # vector of accuracies for test dataset
for nᵣ ∈ 1:Nᵣ
    # prepare the data!
    global 𝐱, 𝐝 = shuffle_dataset(𝐱, 𝐝)
    # hould-out
    𝐱ₜᵣₙ = 𝐱[1:(N*Nₜᵣₙ)÷100]
    𝐝ₜᵣₙ = 𝐝[1:(N*Nₜᵣₙ)÷100]
    𝐱ₜₛₜ = 𝐱[length(𝐝ₜᵣₙ)+1:end]
    𝐝ₜₛₜ = 𝐝[length(𝐝ₜᵣₙ)+1:end]

    # grid search with k-fold cross validation!
    # (m₁, (φ, φʼ, a)) = grid_search_cross_validation(𝐱ₜᵣₙ, 𝐝ₜᵣₙ, 10, (1:3, ((v₍ₙ₎ -> 1/(1+ℯ^(-v₍ₙ₎)), y₍ₙ₎ -> y₍ₙ₎*(1-y₍ₙ₎), 1), (v₍ₙ₎ -> (1-ℯ^(-v₍ₙ₎))/(1+ℯ^(-v₍ₙ₎)), y₍ₙ₎ -> .5(1-y₍ₙ₎^2), 2))), "RMSE")
    # println("For the realization $(nᵣ)")
    # println("best m₁: $(m₁)")
    # println("best φ: $(a==1 ? "logistic" : "Hyperbolic")")
    (m₁, (φ, φʼ, a)) = (7, (v₍ₙ₎ -> (1-ℯ^(-v₍ₙ₎))/(1+ℯ^(-v₍ₙ₎)), y₍ₙ₎ -> .5(1-y₍ₙ₎^2), 1))
    # (m₁, (φ, φʼ, a)) = (7, (v₍ₙ₎ -> 1/(1+ℯ^(-v₍ₙ₎)), y₍ₙ₎ -> y₍ₙ₎*(1-y₍ₙ₎), 1))
    
    # initialize!
    𝔚 = OrderedDict(1 => rand(m₁, Nₐ+1), 2 => rand(5, m₁+1), 3 => rand(m₂, 5+1)) # 1 => first layer (hidden layer) 2 => second layer 
    𝛍ₜᵣₙ = fill(NaN, Nₑ) # vector of accuracies for train dataset (to see its evolution during training phase)

    # train!
    for nₑ ∈ 1:1 # for each epoch
        𝔚, 𝛍ₜᵣₙ[nₑ] = train(𝐱ₜᵣₙ, 𝐝ₜᵣₙ, 𝔚, φ, φʼ)
        𝐱ₜᵣₙ, 𝐝ₜᵣₙ = shuffle_dataset(𝐱ₜᵣₙ, 𝐝ₜᵣₙ)
    end
    # test!
    if nᵣ==1
        global 𝛍ₜₛₜ[nᵣ], 𝐲 = test(𝐱ₜₛₜ, 𝐝ₜₛₜ, 𝔚, φ, true) # accuracy for this realization
        display(plot([𝐲 𝐝ₜₛₜ]))
        global 𝔚, φ
    else
        global 𝛍ₜₛₜ[nᵣ] = test(𝐱ₜₛₜ, 𝐝ₜₛₜ, 𝔚, φ) # accuracy for this realization
    end
end

# analyze the accuracy statistics of each independent realization
𝔼𝛍ₜₛₜ = Σ(𝛍ₜₛₜ)./Nᵣ # mean
𝔼𝛍ₜₛₜ² = Σ(𝛍ₜₛₜ.^2)./Nᵣ # second moment
σ𝛍ₜₛₜ = sqrt.(𝔼𝛍ₜₛₜ² .- 𝔼𝛍ₜₛₜ.^2) # standard deviation

println("* Mean RMSE: $(𝔼𝛍ₜₛₜ)")
println("* Standard deviation: $(σ𝛍ₜₛₜ)")


# make plot!
𝐱 = range(0, 2π, length=N)
𝐝 = map(x₍ₙ₎ -> 3sin(x₍ₙ₎)+1, 𝐱)
## Standardize dataset input and output in [-1,1] (Preprocessing)
μ = Σ(𝐝)/N # mean
𝔼μ² = Σ(𝐝.^2)/N # second moment of
σμ = sqrt.(𝔼μ² - μ.^2) # standard deviation
𝐝 = (𝐝 .- μ)./σμ # zero mean and unit variance
𝐝 = 𝐝./maximum(abs.(𝐝))

μ = Σ(𝐱)/N # mean
𝔼μ² = Σ(𝐱.^2)/N # second moment of
σμ = sqrt.(𝔼μ² - μ.^2) # standard deviation
𝐱 = (𝐱 .- μ)./σμ # zero mean and unit variance
𝐱 = 𝐱./maximum(abs.(𝐱))
display(plot(𝐱, 𝐝))

_, 𝐲 = test(𝐱, 𝐝, 𝔚, φ, true)

fig = plot(𝐱, [𝐲 𝐝], label=["Output signal" "Desired signal"], linewidth=3)

savefig(fig, "figs/sine_regression.png")