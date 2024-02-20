function grid_search_cross_validation(𝐗, 𝐃, K, hyperparameters, valuation_method="accuracy")
    # 𝐗 ➡ the dataset without the test instances [attributes X instances]
    # K ➡ number of folds
    # hyperparameters ➡ vector of vector of all hyperparameters
    # valuation_method ➡ accuracy: classification problem, get the highest; RMSE: regression problem, get the lowest

    𝐗, 𝐃 = shuffle_dataset(𝐗, 𝐃) # shuffle dataset
    Nₐ = ndims(𝐗)==1 ? 1 : size(𝐗,1) # number of attributes
    m₂ = ndims(𝐃)==1 ? 1 : size(𝐃, 1) # number of neurons on the output layer = output vector size
    ndims(𝐗)>1 && (𝐗 = [fill(-1, size(𝐗,2))'; 𝐗]) # add the -1 input (bias) if the input is a vector

    𝓧 = reshape(𝐗, Nₐ, :, K) # split the dataset into K folds
    𝓓 = reshape(𝐃, m₂, :, K)

    μ_best = 0 # mean accuracy of the best set of hyperparameters (begin as Inf)
    best_set_of_hyperparameter=[hyperparameter[1] for hyperparameter ∈ hyperparameters]
    for set_of_hyperparameter ∈ Iterators.product(hyperparameters...)
        m₁ = set_of_hyperparameter[1] # number of neurons of the hidden layer (hyperparameter)
        φ = set_of_hyperparameter[2][1] # activation function
        φʼ = set_of_hyperparameter[2][2] # derivative of the activation function

        𝐞 = rand(K) # the accuracy for each fold
        for k ∈ 1:K
            global μ_best
            𝔚 = OrderedDict(1 => rand(m₁, Nₐ+1), 2 => rand(m₂, m₁+1)) # 1 => first layer (hidden layer) 2 => second layer (output layer)
            𝐗ᵥₐₗ = 𝓧[:,:,1:end.!=k] # validation dataset
            𝐗ᵥₐₗ = reshape(𝐗ᵥₐₗ, size(𝐗ᵥₐₗ, 1), :)
            𝐃ᵥₐₗ = 𝓓[:, :, 1:end.!=k]
            𝐃ᵥₐₗ = reshape(𝐃ᵥₐₗ, size(𝐃ᵥₐₗ, 1), :)
            
            𝐗ₜₛₜ = 𝓧[:,:,k] # test dataset
            𝐃ₜₛₜ = 𝓓[:,:,k]

            for _ ∈ 1:Nₑ
                𝐗ᵥₐₗ, 𝐃ᵥₐₗ = shuffle_dataset(𝐗ᵥₐₗ, 𝐃ᵥₐₗ) # shuffle dataset
                𝔚, _ = train(𝐗ᵥₐₗ, 𝐃ᵥₐₗ, 𝔚, φ, φʼ)
            end
            𝐞[k] = test(𝐗ₜₛₜ, 𝐃ₜₛₜ, 𝔚, φ)
        end

        μ_set = sum(𝐞)/length(𝐞) # mean accuracy for this set of hyperparameters

        if valuation_method=="accuracy"
            if μ_set > μ_best
                μ_best = μ_set
                best_set_of_hyperparameter = set_of_hyperparameter
            end
        else
            if μ_set < μ_best
                μ_best = μ_set
                best_set_of_hyperparameter = set_of_hyperparameter
            end
        end

    end

    return best_set_of_hyperparameter 
end