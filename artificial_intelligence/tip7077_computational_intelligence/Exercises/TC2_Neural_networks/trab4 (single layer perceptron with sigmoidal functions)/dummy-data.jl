using FileIO, JLD2, Random, LinearAlgebra, Plots, LaTeXStrings
Σ=sum

## algorithm parameters and hyperparameters
Nᵣ = 20 # number of realizations
Nₑ = 100 # number of epochs
c = 3 # number of perceptrons (neurons) of the single layer
α = 0.1 # learning step
σₓ = .1 # signal standard deviation
N = 150 # number of instances
Nₐ = 2 # number of attributes
Nₜᵣₙ = 80 # % percentage of instances for the train dataset
Nₜₛₜ = 20 # % percentage of instances for the test dataset

## generate dummy data
𝐗⚫ = [σₓ*randn(50)'.+1.5; σₓ*randn(50)'.+1]
𝐗△ = [σₓ*randn(50)'.+1; σₓ*randn(50)'.+2]
𝐗⭐ = [σₓ*randn(50)'.+2; σₓ*randn(50)'.+2]

𝐗 = [fill(-1,N)'; [𝐗⚫ 𝐗△ 𝐗⭐]]
𝐃 = [repeat([1,0,0],1,50) repeat([0,1,0],1,50) repeat([0,0,1],1,50)]

## useful functions
function shuffle_dataset(𝐗, 𝐃)
    shuffle_indices = Random.shuffle(1:size(𝐗,2))
    return 𝐗[:, shuffle_indices], 𝐃[:, shuffle_indices]
end

function train(𝐗, 𝐃, 𝐖₍ₙ₎, is_training_accuracy=true)
    φ = u₍ₙ₎ -> 1/(1+ℯ^(-u₍ₙ₎)) # logistic function
    φʼ = y₍ₙ₎ -> y₍ₙ₎*(1-y₍ₙ₎) # where y₍ₙ₎=φ(u₍ₙ₎)
    Nₑ = 0 # number of errors ➡ misclassifications
    for (𝐱₍ₙ₎, 𝐝₍ₙ₎) ∈ zip(eachcol(𝐗), eachcol(𝐃))
        𝛍₍ₙ₎ = 𝐖₍ₙ₎*𝐱₍ₙ₎ # induced local field
        𝐲₍ₙ₎ = map(φ, 𝛍₍ₙ₎)
        𝐞₍ₙ₎ = 𝐝₍ₙ₎ - 𝐲₍ₙ₎
        𝐲ʼ₍ₙ₎ = map(φʼ, 𝐲₍ₙ₎)
        𝛅₍ₙ₎ = 𝐞₍ₙ₎ .* 𝐲ʼ₍ₙ₎ # vector of local gradients
        𝐖₍ₙ₎ += α*𝛅₍ₙ₎*𝐱₍ₙ₎' # learning equation (Julia performs broadcasting here)
        # this part is optional: only if it is interested in seeing the accuracy evolution of the training dataset throughout the epochs
        i = findfirst(x->x==maximum(𝐲₍ₙ₎), 𝐲₍ₙ₎) # predicted value → choose the highest activation function output as the selected class
        Nₑ = 𝐝₍ₙ₎[i]==1 ? Nₑ : Nₑ+1
    end
    if is_training_accuracy
        accuracy = (size(𝐃,2)-Nₑ)/size(𝐃,2)
        return 𝐖₍ₙ₎, accuracy
    else
        return  𝐖₍ₙ₎
    end
end

function test(𝐗, 𝐃, 𝐖₍ₙ₎, get_predictions=false)
    φ = u₍ₙ₎ -> 1/(1+ℯ^(-u₍ₙ₎)) # logistic function
    Nₑ = 0 # number of errors ➡ misclassifications
    𝐲 = Vector{Int64}(undef, size(𝐗, 2)) # vector of all predictions
    for (n, (𝐱₍ₙ₎, 𝐝₍ₙ₎)) ∈ enumerate(zip(eachcol(𝐗), eachcol(𝐃)))
        𝛍₍ₙ₎ = 𝐖₍ₙ₎*𝐱₍ₙ₎ # induced local field
        𝐲₍ₙ₎ = map(φ, 𝛍₍ₙ₎) # perceptron output (a vector) at instant n
        𝐲[n] = findfirst(x->x==maximum(𝐲₍ₙ₎), 𝐲₍ₙ₎) # predicted value → choose the highest activation function output as the selected class
        Nₑ = 𝐝₍ₙ₎[𝐲[n]]==1 ? Nₑ : Nₑ+1
    end
    accuracy = (size(𝐃,2)-Nₑ)/size(𝐃,2)
    if get_predictions
        return accuracy, 𝐲
    else
        return accuracy
    end
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
    
    # make plots!
    if nᵣ==1
        # training dataset accuracy evolution by epochs for the 1th realization
        local fig = plot(accₜᵣₙ, ylims=(0,1), xlabel="Epochs", ylabel="Accuracy", linewidth=2)
        savefig(fig, "trab4 (single layer perceptron with sigmoidal functions)/figs/dummy data - training dataset accuracy evolution.png")

        ## predictors of the class (basically it is what is done on test(), but only with the attributes as inputs)
        y = function predict_circle(x₃, x₄)
            φ = u₍ₙ₎ -> 1/(1+ℯ^(-u₍ₙ₎)) # logistic function
            𝐱₍ₙ₎ = [-1, x₃, x₄]
            𝛍₍ₙ₎ = 𝐖₍ₙ₎*𝐱₍ₙ₎ # induced local field
            𝐲₍ₙ₎ = map(φ, 𝛍₍ₙ₎) # perceptron output (a vector) at instant n
            return findfirst(x->x==maximum(𝐲₍ₙ₎), 𝐲₍ₙ₎)
        end

        # plot heatmap for the 1th realization
        local x₁_range = floor(minimum(𝐗[2,:])):.1:ceil(maximum(𝐗[2,:]))
        local x₂_range = floor(minimum(𝐗[3,:])):.1:ceil(maximum(𝐗[3,:]))

        fig = contour(x₁_range, x₂_range, y, xlabel = L"x_1", ylabel = L"x_2", fill=true, levels=2)
        # train circe label
        scatter!(𝐗ₜᵣₙ[2,𝐃ₜᵣₙ[1,:].==1], 𝐗ₜᵣₙ[3,𝐃ₜᵣₙ[1,:].==1], markershape = :hexagon, markersize = 8, markeralpha = 0.6, markercolor = :white, markerstrokewidth = 3, markerstrokealpha = 0.2, markerstrokecolor = :black, label = "circe class [train]")
            
        # test circle label
        scatter!(𝐗ₜₛₜ[2,𝐃ₜₛₜ[1,:].==1], 𝐗ₜₛₜ[3,𝐃ₜₛₜ[1,:].==1], markershape = :dtriangle, markersize = 8, markeralpha = 0.6, markercolor = :white, markerstrokewidth = 3, markerstrokealpha = 0.2, markerstrokecolor = :black, label = "circle class [test]")

        # train triangle label
        scatter!(𝐗ₜᵣₙ[2,𝐃ₜᵣₙ[2,:].==1], 𝐗ₜᵣₙ[3,𝐃ₜᵣₙ[2,:].==1], markershape = :hexagon, markersize = 8, markeralpha = 0.6, markercolor = :cyan, markerstrokewidth = 3, markerstrokealpha = 0.2, markerstrokecolor = :black, label = "triangle class [train]")

        # test triangle label
        scatter!(𝐗ₜₛₜ[2,𝐃ₜₛₜ[2,:].==1], 𝐗ₜₛₜ[3,𝐃ₜₛₜ[2,:].==1], markershape = :dtriangle, markersize = 8, markeralpha = 0.6, markercolor = :cyan, markerstrokewidth = 3, markerstrokealpha = 0.2, markerstrokecolor = :black, label = "triangle class [test]")

        # train star label
        scatter!(𝐗ₜᵣₙ[2,𝐃ₜᵣₙ[3,:].==1], 𝐗ₜᵣₙ[3,𝐃ₜᵣₙ[3,:].==1], markershape = :hexagon, markersize = 8, markeralpha = 0.6, markercolor = :green, markerstrokewidth = 3, markerstrokealpha = 0.2, markerstrokecolor = :black, label = "star class [train]")

        # test star label
        scatter!(𝐗ₜₛₜ[2,𝐃ₜₛₜ[3,:].==1], 𝐗ₜₛₜ[3,𝐃ₜₛₜ[3,:].==1], markershape = :dtriangle, markersize = 8, markeralpha = 0.6, markercolor = :green, markerstrokewidth = 3, markerstrokealpha = 0.2, markerstrokecolor = :black, label = "star class [test]")

        title!("Heatmap")
        savefig(fig, "trab4 (single layer perceptron with sigmoidal functions)/figs/dummy data - heatmap.png")
    end
end

# analyze the accuracy statistics of each independent realization
āc̄c̄ = Σ(accₜₛₜ)/Nᵣ # Mean
𝔼acc² = Σ(accₜₛₜ.^2)/Nᵣ
σacc = sqrt.(𝔼acc² .- āc̄c̄.^2) # standard deviation

println("Mean: $(āc̄c̄)")
println("Standard deviation: $(σacc)")