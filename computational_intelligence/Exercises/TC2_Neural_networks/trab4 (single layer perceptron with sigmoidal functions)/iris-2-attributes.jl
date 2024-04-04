using FileIO, JLD2, Random, LinearAlgebra, Plots, LaTeXStrings
Σ=sum

## algorithm parameters hyperparameters
Nᵣ = 20 # number of realizations
Nₐ = 2 # number of Attributes, that is, input vector size at each instance. They are petal length, petal width
N = 150 # number of instances(samples)
Nₜᵣₙ = 80 # % percentage of instances for the train dataset
Nₜₛₜ = 20 # % percentage of instances for the test dataset
c = 3 # number of perceptrons (neurons) of the single layer
Nₑ = 100 # number of epochs
α = 0.01 # learning step

## load the data
𝐗, labels = FileIO.load("Datasets/Iris [uci]/iris.jld2", "𝐗", "𝐝") # 𝐗 ➡ [attributes X instances]
𝐗 = [fill(-1, size(𝐗,2))'; 𝐗[3:4,:]] # add the -1 input (bias)
𝐃 = rand(c,0)
for label ∈ labels
    global 𝐃 = [𝐃 one_hot_encoding(label)]
end

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

function one_hot_encoding(label)
    return ["setosa", "virginica", "versicolor"].==label
end

## init
for nᵣ ∈ 1:Nᵣ
    # initialize!
    𝐖₍ₙ₎ = rand(c, Nₐ+1) # [𝐰₁ᵀ; 𝐰₂ᵀ; ...; 𝐰ᵀ_c]

    # prepare the data!
    global 𝐗, 𝐃 = shuffle_dataset(𝐗, 𝐃)
    # hould-out
    global 𝐗ₜᵣₙ = 𝐗[:,1:(N*Nₜᵣₙ)÷100]
    global 𝐃ₜᵣₙ = 𝐃[:,1:(N*Nₜᵣₙ)÷100]
    global 𝐗ₜₛₜ = 𝐗[:,size(𝐃ₜᵣₙ, 2)+1:end]
    global 𝐃ₜₛₜ = 𝐃[:,size(𝐃ₜᵣₙ, 2)+1:end]

    # train!
    for nₑ ∈ 1:Nₑ # for each epoch
        𝐖₍ₙ₎, _ = train(𝐗ₜᵣₙ, 𝐃ₜᵣₙ, 𝐖₍ₙ₎)
        𝐗ₜᵣₙ, 𝐃ₜᵣₙ = shuffle_dataset(𝐗ₜᵣₙ, 𝐃ₜᵣₙ)
    end

    # decision surface (for the 1th realization only)
    if nᵣ == 1
        ## predictors of each class (basically it is what is done on test(), but only with the attributes as inputs)
        #setosa
        y_setosa = function predict_setosa(x₃, x₄)
            φ = u₍ₙ₎ -> 1/(1+ℯ^(-u₍ₙ₎)) # logistic function
            𝐱₍ₙ₎ = [-1, x₃, x₄]
            𝛍₍ₙ₎ = 𝐖₍ₙ₎*𝐱₍ₙ₎ # induced local field
            𝐲₍ₙ₎ = map(φ, 𝛍₍ₙ₎) # perceptron output (a vector) at instant n
            if 𝐲₍ₙ₎[1] == maximum(𝐲₍ₙ₎)
                return 1
            else
                return 0
            end
        end
        # virginica
        y_virginica = function predict_virginica(x₃, x₄)
            φ = u₍ₙ₎ -> 1/(1+ℯ^(-u₍ₙ₎)) # logistic function
            𝐱₍ₙ₎ = [-1, x₃, x₄]
            𝛍₍ₙ₎ = 𝐖₍ₙ₎*𝐱₍ₙ₎ # induced local field
            𝐲₍ₙ₎ = map(φ, 𝛍₍ₙ₎) # perceptron output (a vector) at instant n
            if 𝐲₍ₙ₎[2] == maximum(𝐲₍ₙ₎)
                return 1
            else
                return 0
            end
        end
        # versicolor
        y_versicolor = function predict_versicolor(x₃, x₄)
            φ = u₍ₙ₎ -> 1/(1+ℯ^(-u₍ₙ₎)) # logistic function
            𝐱₍ₙ₎ = [-1, x₃, x₄]
            𝛍₍ₙ₎ = 𝐖₍ₙ₎*𝐱₍ₙ₎ # induced local field
            𝐲₍ₙ₎ = map(φ, 𝛍₍ₙ₎) # perceptron output (a vector) at instant n
            if 𝐲₍ₙ₎[3] == maximum(𝐲₍ₙ₎)
                return 1
            else
                return 0
            end
        end

        # plot the surface for each class
        x₃_range = floor(minimum(𝐗[2,:])):.1:ceil(maximum(𝐗[2,:]))
        x₄_range = floor(minimum(𝐗[3,:])):.1:ceil(maximum(𝐗[3,:]))
        for (i, (y, desired_label, camera_pos)) ∈ enumerate(zip((y_setosa, y_virginica, y_versicolor), ("setosa", "virginica", "versicolor"), ((60,40,0), (60,40,0), (160,40,0))))
            p = surface(x₃_range, x₄_range, y, camera=camera_pos, xlabel = "petal length", ylabel = "petal width", zlabel="decision surface")
    
            # scatter plot for the petal length and petal length width for the setosa class
            # train and desired label 
            scatter!(𝐗ₜᵣₙ[2,𝐃ₜᵣₙ[i,:].==1], 𝐗ₜᵣₙ[3,𝐃ₜᵣₙ[i,:].==1], ones(length(filter(x->x==1, 𝐃ₜᵣₙ[i,:]))), markershape = :hexagon, markersize = 4, markeralpha = 0.6, markercolor = :green, markerstrokewidth = 3, markerstrokealpha = 0.2, markerstrokecolor = :black, xlabel = "petal\nlength", ylabel = "petal width", label = "$(desired_label) train set")
            
            # test and desired label 
            scatter!(𝐗ₜₛₜ[2,𝐃ₜₛₜ[i,:].==1], 𝐗ₜₛₜ[3,𝐃ₜₛₜ[i,:].==1], ones(length(filter(x->x==1, 𝐃ₜₛₜ[i,:]))), markershape = :cross, markersize = 4, markeralpha = 0.6, markercolor = :green, markerstrokewidth = 3, markerstrokealpha = 0.2, markerstrokecolor = :black, xlabel = "petal\nlength", ylabel = "petal width", label = "$(desired_label) test set")
    
            # train and not desired label 
            scatter!(𝐗ₜᵣₙ[2,𝐃ₜᵣₙ[i,:].==0], 𝐗ₜᵣₙ[3,𝐃ₜᵣₙ[i,:].==0], zeros(length(filter(x->x==0, 𝐃ₜᵣₙ[i,:]))), markershape = :hexagon, markersize = 4, markeralpha = 0.6, markercolor = :red, markerstrokewidth = 3, markerstrokealpha = 0.2, markerstrokecolor = :black, xlabel = "petal\nlength", ylabel = "petal width", label = "not $(desired_label) train set")
    
            # test and not desired label 
            scatter!(𝐗ₜₛₜ[2,𝐃ₜₛₜ[i,:].==0], 𝐗ₜₛₜ[3,𝐃ₜₛₜ[i,:].==0], zeros(length(filter(x->x==0, 𝐃ₜₛₜ[i,:]))), markershape = :cross, markersize = 4, markeralpha = 0.6, markercolor = :red, markerstrokewidth = 3, markerstrokealpha = 0.2, markerstrokecolor = :black, xlabel = "petal\nlength", ylabel = "petal width", label = "not $(desired_label) test set")
            
            title!("Decision surface for the class $(desired_label)")
            display(p)
            savefig(p,"trab4 (single layer perceptron with sigmoidal functions)/figs/decision-surface-for-$(desired_label).png")
        end

    end
end