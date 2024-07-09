using FileIO, JLD2, Random, LinearAlgebra, Plots, LaTeXStrings
Σ=sum

### dataset 02 - artificial dataset ###

## algorithm parameters hyperparameters
σₓ = .1 # signal standard deviation
N = 40 # number of instances
Nₐ = 2 # number of attributes (not includes the bias)
Nᵣ = 20 # number of realizations
Nₑ = 100 # number of epochs
Nₜᵣₙ = 80 # % percentage of instances for the train dataset
Nₜₛₜ = 20 # % percentage of instances for the test dataset
α = 0.01 # learning step

## useful functions
function shuffle_dataset(𝐗, 𝐝)
    shuffle_indices = Random.shuffle(1:size(𝐗,2))
    return 𝐗[:, shuffle_indices], 𝐝[shuffle_indices]
end

function train(𝐗, 𝐝, 𝐰, is_training_accuracy=true)
    φ = u₍ₙ₎ -> u₍ₙ₎>0 ? 1 : 0 # McCulloch and Pitts's activation function (step function)
    Nₑ = 0 # number of errors ➡ misclassifications
    for (𝐱₍ₙ₎, d₍ₙ₎) ∈ zip(eachcol(𝐗), 𝐝)
        μ₍ₙ₎ = dot(𝐱₍ₙ₎,𝐰) # inner product
        y₍ₙ₎ = φ(μ₍ₙ₎) # for the training phase, you do not pass y₍ₙ₎ to a harder decisor (the McCulloch and Pitts's activation function) since you are in intended to classify y₍ₙ₎. Rather, you are interested in updating 𝐰 (??? TODO)
        e₍ₙ₎ = d₍ₙ₎ - y₍ₙ₎
        𝐰 += α*e₍ₙ₎*𝐱₍ₙ₎

        # this part is optional: only if it is interested in seeing the accuracy evolution of the training dataset throughout the epochs
        Nₑ = e₍ₙ₎==0 ? Nₑ : Nₑ+1
    end
    if is_training_accuracy
        accuracy = (length(𝐝)-Nₑ)/length(𝐝) # accuracy for this epoch
        return 𝐰, accuracy
    else
        return 𝐰
    end
end

function test(𝐗, 𝐝, 𝐰, is_confusion_matrix=false)
    φ = u₍ₙ₎ -> u₍ₙ₎>0 ? 1 : 0 # McCulloch and Pitts's activation function (step function)
    𝐲 = rand(length(𝐝)) # vector of predictions for confusion matrix
    Nₑ = 0
    for (n, (𝐱₍ₙ₎, d₍ₙ₎)) ∈ enumerate(zip(eachcol(𝐗), 𝐝))
        μ₍ₙ₎ = 𝐱₍ₙ₎⋅𝐰 # inner product
        y₍ₙ₎ = φ(μ₍ₙ₎) # for the single-unit perceptron, y₍ₙ₎ ∈ {0,1}. Therefore, it is not necessary to pass y₍ₙ₎ to a harder decisor since φ(⋅) already does this job
        𝐲[n] = y₍ₙ₎

        Nₑ = y₍ₙ₎==d₍ₙ₎ ? Nₑ : Nₑ+1
    end
    if !is_confusion_matrix
        accuracy = (length(𝐝)-Nₑ)/length(𝐝)
        return accuracy # return the accuracy for this realization
    else
        return Int.(𝐲) # return the errors over the instances to plot the confusion matrix
    end
end

## generate dummy data
𝐗₁ = [σₓ*randn(10)'; σₓ*randn(10)']
𝐗₂ = [σₓ*randn(10)'.+1; σₓ*randn(10)']
𝐗₃ = [σₓ*randn(10)'; σₓ*randn(10)'.+1]
𝐗₄ = [σₓ*randn(10)'.+1; σₓ*randn(10)'.+1]

𝐗 = [fill(-1,N)'; [𝐗₁ 𝐗₂ 𝐗₃ 𝐗₄]]
𝐝 = [zeros(30);ones(10)]

## init
accₜₛₜ = fill(NaN, Nᵣ) # vector of accuracies for test dataset (to compute the final statistics)
figs_surface = Array{Plots.Plot{Plots.GRBackend},1}[]
figs_training_accuracy = Array{Plots.Plot{Plots.GRBackend},1}[]
for nᵣ ∈ 1:Nᵣ
    # initialize
    global 𝐰 = randn(Nₐ+1)
    accₜᵣₙ = fill(NaN, Nₑ) # vector of accuracies for train dataset (to see its evolution during training phase)

    # prepare the data!
    global  𝐗, 𝐝
    𝐗, 𝐝 = shuffle_dataset(𝐗, 𝐝)
    # hould-out
    global 𝐗ₜᵣₙ = 𝐗[:,1:(N*Nₜᵣₙ)÷100]
    global 𝐝ₜᵣₙ = 𝐝[1:(N*Nₜᵣₙ)÷100]
    global 𝐗ₜₛₜ = 𝐗[:,length(𝐝ₜᵣₙ)+1:end]
    global 𝐝ₜₛₜ = 𝐝[length(𝐝ₜᵣₙ)+1:end]

    # train!
    for nₑ ∈ 1:Nₑ
        𝐰, accₜᵣₙ[nₑ] = train(𝐗ₜᵣₙ, 𝐝ₜᵣₙ, 𝐰)
        𝐗ₜᵣₙ, 𝐝ₜᵣₙ = shuffle_dataset(𝐗ₜᵣₙ, 𝐝ₜᵣₙ)
    end
    # test!
    accₜₛₜ[nᵣ] = test(𝐗ₜₛₜ, 𝐝ₜₛₜ, 𝐰) # accuracy for this realization

    # make plots!
    # accuracy training dataset x Epochs
    local fig = plot(accₜᵣₙ, label="", xlabel=L"Epochs", ylabel="Accuracy", linewidth=2)
    push!(figs_training_accuracy, [fig])

    # decision surface
    φ = u₍ₙ₎ -> u₍ₙ₎≥0 ? 1 : 0 # activation function of the single-unit perceptron
    x₁_range = floor(minimum(𝐗[2,:])):.1:ceil(maximum(𝐗[2,:]))
    x₂_range = floor(minimum(𝐗[3,:])):.1:ceil(maximum(𝐗[3,:]))
    y(x₁, x₂) = φ(dot([-1, x₁, x₂], 𝐰))
    fig = surface(x₁_range, x₂_range, y, camera=(60,40,0), xlabel = L"x_1", ylabel = L"x_2", zlabel="decision surface")
    push!(figs_surface, [fig])

    # train and desired label 
    scatter!(𝐗ₜᵣₙ[2,𝐝ₜᵣₙ.==1], 𝐗ₜᵣₙ[3,𝐝ₜᵣₙ.==1], ones(length(filter(x->x==1, 𝐝ₜᵣₙ))), markershape = :hexagon, markersize = 4, markeralpha = 0.6, markercolor = :green, markerstrokewidth = 3, markerstrokealpha = 0.2, markerstrokecolor = :black, label = "desired class train set")
    
    # test and desired label 
    scatter!(𝐗ₜₛₜ[2,𝐝ₜₛₜ.==1], 𝐗ₜₛₜ[3,𝐝ₜₛₜ.==1], ones(length(filter(x->x==1, 𝐝ₜₛₜ))), markershape = :cross, markersize = 4, markeralpha = 0.6, markercolor = :green, markerstrokewidth = 3, markerstrokealpha = 0.2, markerstrokecolor = :black, label = "desired class test set")

    # train and not desired label 
    scatter!(𝐗ₜᵣₙ[2,𝐝ₜᵣₙ.==0], 𝐗ₜᵣₙ[3,𝐝ₜᵣₙ.==0], zeros(length(filter(x->x==0, 𝐝ₜᵣₙ))), markershape = :hexagon, markersize = 4, markeralpha = 0.6, markercolor = :red, markerstrokewidth = 3, markerstrokealpha = 0.2, markerstrokecolor = :black, label = "not desired class train set")

    # test and not desired label 
    scatter!(𝐗ₜₛₜ[2,𝐝ₜₛₜ.==0], 𝐗ₜₛₜ[3,𝐝ₜₛₜ.==0], zeros(length(filter(x->x==0, 𝐝ₜₛₜ))), markershape = :cross, markersize = 4, markeralpha = 0.6, markercolor = :red, markerstrokewidth = 3, markerstrokealpha = 0.2, markerstrokecolor = :black, label = "not desired class test set")
    title!("Decision surface for the desired class")
end

# analyze the accuracy statistics of each independent realization
āc̄c̄ = Σ(accₜₛₜ)/Nᵣ # Mean
𝔼acc² = Σ(accₜₛₜ.^2)/Nᵣ
σacc = sqrt.(𝔼acc² .- āc̄c̄.^2) # standard deviation

println("Mean accuracy: $(āc̄c̄)")
println("Standard deviation: $(σacc)")

# find closest surface
i = 1
accₜₛₜ_closest_to_accuracy = accₜₛₜ[1]
for nᵣ ∈ 2:Nᵣ
    if accₜₛₜ[nᵣ] < accₜₛₜ_closest_to_accuracy
        global accₜₛₜ_closest_to_accuracy = accₜₛₜ[nᵣ]
        global i = nᵣ
    end
end

# plot the training set accuracy by epoch for the realization whose test dataset accuracy is closest to the mean accuracy
display(figs_training_accuracy[i][1])
savefig(figs_training_accuracy[i][1], "trab1 (single-unit perceptron)/figs/training dataset accuracy for realization $(i) (closest to the mean acc).png")
# plot surface decision for  the realization whose test dataset accuracy is closest to the mean accuracy
display(figs_surface[i][1])
savefig(figs_surface[i][1], "trab1 (single-unit perceptron)/figs/decision-surface-for-dummy-data.png")