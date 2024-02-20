using FileIO, JLD2, Random, LinearAlgebra, Plots, LaTeXStrings
Σ=sum

## load the data
𝐗, labels = FileIO.load("Datasets/Iris [uci]/iris.jld2", "𝐗", "𝐝") # 𝐗 ➡ [attributes X instances]
# PS choose only one!!!
# uncomment ↓ if you want to train for all attributes
𝐗 = [fill(-1, size(𝐗,2))'; 𝐗] # add the -1 input (bias)
# uncomment ↓ if you want to train for petal length and width (to plot the decision surface)
# 𝐗 = [fill(-1, size(𝐗,2))'; 𝐗[3:4,:]] # add the -1 input (bias)

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

## algorithm parameters hyperparameters
Nᵣ = 20 # number of realizations
Nₐ = size(𝐗, 1) # =5 (including bias) number of Attributes, that is, input vector size at each intance. They mean: sepal length, sepal width, petal length, petal width
N = size(𝐗, 2) # =150 number of instances(samples)
Nₜᵣₙ = 80 # % percentage of instances for the train dataset
Nₜₛₜ = 20 # % percentage of instances for the test dataset
Nₑ = 100 # number of epochs
α = 0.01 # learning step

## init
all_āc̄c̄, all_σacc, all_𝐰ₒₚₜ = rand(3), rand(3), rand(Nₐ,3)
for (i, desired_label) ∈ enumerate(("setosa", "virginica", "versicolor"))
    local 𝐝 = labels.==desired_label # d₍ₙ₎ ∈ {0,1}
    local accₜₛₜ = fill(NaN, Nᵣ) # vector of accuracies for test dataset (to compute the final statistics)
    for nᵣ ∈ 1:Nᵣ # for each realization
        # initializing!
        accₜᵣₙ = fill(NaN, Nₑ) # vector of accuracies for train dataset (to see its evolution during training phase)
        global 𝐰 = ones(Nₐ) # initialize a new McCulloch-Pitts neuron (a new set of parameters)
        global 𝐗 # ?

        # prepare the data!
        𝐗, 𝐝 = shuffle_dataset(𝐗, 𝐝)
        # hould-out
        global 𝐗ₜᵣₙ = 𝐗[:,1:(N*Nₜᵣₙ)÷100]
        global 𝐝ₜᵣₙ = 𝐝[1:(N*Nₜᵣₙ)÷100]
        global 𝐗ₜₛₜ = 𝐗[:,length(𝐝ₜᵣₙ)+1:end]
        global 𝐝ₜₛₜ = 𝐝[length(𝐝ₜᵣₙ)+1:end]

        # train!
        for nₑ ∈ 1:Nₑ # for each epoch
            𝐰, accₜᵣₙ[nₑ] = train(𝐗ₜᵣₙ, 𝐝ₜᵣₙ, 𝐰)
            𝐗ₜᵣₙ, 𝐝ₜᵣₙ = shuffle_dataset(𝐗ₜᵣₙ, 𝐝ₜᵣₙ)
        end
        # test!
        accₜₛₜ[nᵣ] = test(𝐗ₜₛₜ, 𝐝ₜₛₜ, 𝐰)
        
        # make plots!
        if nᵣ == 1
            all_𝐰ₒₚₜ[:,i] = 𝐰 # save the optimum value reached during the 1th realization for setosa, versicolor, and virginica
            # if all attributes was taken into account, compute the accuracyxepochs for all classes
            if length(𝐰) != 3
                local p = plot(accₜᵣₙ, label="", xlabel=L"Epochs", ylabel="Accuracy", linewidth=2, title="Training accuracy for $(desired_label) class by epochs")
                display(p)
                savefig(p, "trab1 (single-unit perceptron)/figs/accuracy-by-epochs-for-$(desired_label).png")
                # for the setosa class, compute the confusion matrix
                if desired_label == "setosa"
                    𝐂 = zeros(2,2) # confusion matrix
                    𝐲ₜₛₜ = test(𝐗ₜₛₜ, 𝐝ₜₛₜ, 𝐰, true)
                    for n ∈ 1:length(𝐲ₜₛₜ)
                        # predicted x true label
                        𝐂[𝐲ₜₛₜ[n]+1, 𝐝ₜₛₜ[n]+1] += 1
                    end
                    h = heatmap(𝐂, xlabel="Predicted labels", ylabel="True labels", xticks=(1:2, ("setosa", "not setosa")), yticks=(1:2, ("setosa", "not setosa")), title="Confusion matrix for the setosa class")
                    savefig(h, "trab1 (single-unit perceptron)/figs/setosa-confusion-matrix.png")
                    display(h) # TODO: put the number onto each confusion square
                end
            end
            # decision surface
            if length(𝐰) == 3 # plot the surface only if the learning procedure was taken with only two attributes, the petal length and petal width (equals to 3 because the bias)
                φ = u₍ₙ₎ -> u₍ₙ₎≥0 ? 1 : 0 # activation function of the single-unit perceptron
                x₃_range = floor(minimum(𝐗[2,:])):.1:ceil(maximum(𝐗[2,:]))
                x₄_range = floor(minimum(𝐗[3,:])):.1:ceil(maximum(𝐗[3,:]))
                y(x₃, x₄) = φ(dot([-1, x₃, x₄], 𝐰))
                p = surface(x₃_range, x₄_range, y, camera=(60,40,0), xlabel = "petal length", ylabel = "petal width", zlabel="decision surface")

                # scatter plot for the petal length and petal length width for the setosa class
                # train and desired label 
                scatter!(𝐗ₜᵣₙ[2,𝐝ₜᵣₙ.==1], 𝐗ₜᵣₙ[3,𝐝ₜᵣₙ.==1], ones(length(filter(x->x==1, 𝐝ₜᵣₙ))),
                        markershape = :hexagon,
                        markersize = 4,
                        markeralpha = 0.6,
                        markercolor = :green,
                        markerstrokewidth = 3,
                        markerstrokealpha = 0.2,
                        markerstrokecolor = :black,
                        xlabel = "petal\nlength",
                        ylabel = "petal width",
                        camera = (60,40,0),
                        label = "$(desired_label) train set")
                
                # test and desired label 
                scatter!(𝐗ₜₛₜ[2,𝐝ₜₛₜ.==1], 𝐗ₜₛₜ[3,𝐝ₜₛₜ.==1], ones(length(filter(x->x==1, 𝐝ₜₛₜ))),
                        markershape = :cross,
                        markersize = 4,
                        markeralpha = 0.6,
                        markercolor = :green,
                        markerstrokewidth = 3,
                        markerstrokealpha = 0.2,
                        markerstrokecolor = :black,
                        xlabel = "petal\nlength",
                        ylabel = "petal width",
                        camera = (60,40,0),
                        label = "$(desired_label) test set")

                # train and not desired label 
                scatter!(𝐗ₜᵣₙ[2,𝐝ₜᵣₙ.==0], 𝐗ₜᵣₙ[3,𝐝ₜᵣₙ.==0], zeros(length(filter(x->x==0, 𝐝ₜᵣₙ))),
                        markershape = :hexagon,
                        markersize = 4,
                        markeralpha = 0.6,
                        markercolor = :red,
                        markerstrokewidth = 3,
                        markerstrokealpha = 0.2,
                        markerstrokecolor = :black,
                        xlabel = "petal\nlength",
                        ylabel = "petal width",
                        camera = (60,40,0),
                        label = "not $(desired_label) train set")

                # test and not desired label 
                scatter!(𝐗ₜₛₜ[2,𝐝ₜₛₜ.==0], 𝐗ₜₛₜ[3,𝐝ₜₛₜ.==0], zeros(length(filter(x->x==0, 𝐝ₜₛₜ))),
                        markershape = :cross,
                        markersize = 4,
                        markeralpha = 0.6,
                        markercolor = :red,
                        markerstrokewidth = 3,
                        markerstrokealpha = 0.2,
                        markerstrokecolor = :black,
                        xlabel = "petal\nlength",
                        ylabel = "petal width",
                        camera = (60,40,0),
                        label = "not $(desired_label) test set")
                
                title!("Decision surface for the class $(desired_label)")
                display(p)
                savefig(p,"trab1 (single-unit perceptron)/figs/decision-surface-for-$(desired_label).png")
            end
        end
    end
    # analyze the accuracy statistics of each independent realization
    local āc̄c̄ = Σ(accₜₛₜ)/Nᵣ # Mean
    local 𝔼acc² = Σ(accₜₛₜ.^2)/Nᵣ
    local σacc = sqrt.(𝔼acc² .- āc̄c̄.^2) # standard deviation
    
    # save the performance
    all_āc̄c̄[i] = āc̄c̄
    all_σacc[i] = σacc
    println("Mean accuracy for $(desired_label): $(āc̄c̄)")
    println("Standard deviation for $(desired_label): $(σacc)")
end