using Random, Plots, LaTeXStrings, LinearAlgebra
Σ=sum

## algorithm hyperparameters
N = 50
Nₜᵣₙ = 80 # % percentage of instances for the train dataset
Nₜₛₜ = 20 # % percentage of instances for the test dataset
Nₐ₁ = 1 # number of number of attributes for the first function (without bias)
Nₐ₂ = 2 # number of number of attributes for the first function (without bias)
Nᵣ = 20 # number of realizations
Nₑ = 100 # number of epochs
α = 0.002 # learning step
μₙ, σ²ₙ = 0, 10 # Gaussian parameters

## useful functions
function shuffle_dataset(𝐗, 𝐝)
    shuffle_indices = Random.shuffle(1:size(𝐗,2))
    return 𝐗[:, shuffle_indices], 𝐝[shuffle_indices]
end

function train(𝐗ₜᵣₙ, 𝐝ₜᵣₙ, 𝐰)
    𝐞ₜᵣₙ = rand(length(𝐝ₜᵣₙ)) # vector of errors
    for (n, (𝐱₍ₙ₎, d₍ₙ₎)) ∈ enumerate(zip(eachcol(𝐗ₜᵣₙ), 𝐝ₜᵣₙ))
        μₙ = dot(𝐱₍ₙ₎,𝐰) # inner product
        y₍ₙ₎ = μₙ # ADALINE's activation function
        e₍ₙ₎ = d₍ₙ₎ - y₍ₙ₎
        𝐰 += α*e₍ₙ₎*𝐱₍ₙ₎
        𝐞ₜᵣₙ[n] = e₍ₙ₎
    end
    𝔼𝐞ₜᵣₙ² = Σ(𝐞ₜᵣₙ.^2)/length(𝐞ₜᵣₙ)  # MSE (Mean squared error), that is, the the estimative of second moment of the error signal for this epoch
    return 𝐰, 𝔼𝐞ₜᵣₙ²
end

function test(𝐗ₜₛₜ, 𝐝ₜₛₜ, 𝐰)
    𝐞ₜₛₜ = rand(length(𝐝ₜₛₜ)) # vector of errors
    for (n, (𝐱₍ₙ₎, d₍ₙ₎)) ∈ enumerate(zip(eachcol(𝐗ₜₛₜ), 𝐝ₜₛₜ))
        μₙ = 𝐱₍ₙ₎⋅𝐰 # inner product
        y₍ₙ₎ = μₙ # ADALINE's activation function
        𝐞ₜₛₜ[n] = d₍ₙ₎ - y₍ₙ₎
    end
    𝔼𝐞ₜₛₜ² = Σ(𝐞ₜₛₜ.^2)/length(𝐞ₜₛₜ) # MSE (Mean squared error), that is, the the estimative of second moment of the error signal for this epoch
    return 𝔼𝐞ₜₛₜ² # MSE
end

## generate dummy data
f₁(x) = 5x .+ 8 # two attributes (Nₐ = 2), they are a = 5, b = 8
f₂(x₁, x₂) =5x₁ .+ 3x₂ .+ 6 # three attributes (Nₐ = 3), they are a = 2, b = 3, c = 6

𝐧 = √σ²ₙ*randn(N) .+ μₙ # ~ N(μₙ, σ²ₙ)
𝐝₁ = f₁(range(-10,10,N)) + 𝐧 # dummy desired dataset for function 1
𝐝₂ = f₂(range(-10,10,N), range(-10,10,N)) + 𝐧 # dummy desired dataset for function 2
𝐗₁ = [fill(-1,N)'; range(-10,10,N)'] # dummy input dataset
𝐗₂ = [fill(-1,N)'; range(-10,10,N)'; range(-10,10,N)'] # dummy input dataset

## init
𝐰₁ₒₚₜ, 𝐰₂ₒₚₜ = rand(Nₐ₁+1), rand(Nₐ₂+1) # two attributes: bias + x₍ₙ₎

MSE₁ₜₛₜ = rand(Nᵣ)
MSE₂ₜₛₜ = rand(Nᵣ)
for nᵣ ∈ 1:Nᵣ
    # initialize!
    𝐰₁, 𝐰₂ = rand(Nₐ₁+1), rand(Nₐ₂+1) # two attributes bias + x₍ₙ₎
    MSE₁ₜᵣₙ = zeros(Nₑ) # vector that stores the error train dataset for each epoch (to see its evolution)
    MES₂ₜᵣₙ = zeros(Nₑ)

    # prepare the data!
    global 𝐗₁ # ?
    global 𝐝₁ # ?
    global 𝐗₂ # ?
    global 𝐝₂ # ?
    𝐗₁, 𝐝₁ = shuffle_dataset(𝐗₁, 𝐝₁)
    𝐗₂, 𝐝₂ = shuffle_dataset(𝐗₂, 𝐝₂)
    # hould-out
    global 𝐗₁ₜᵣₙ = 𝐗₁[:,1:(N*Nₜᵣₙ)÷100] # for (𝐗₁, 𝐝₁)
    global 𝐝₁ₜᵣₙ = 𝐝₁[1:(N*Nₜᵣₙ)÷100]
    global 𝐗₁ₜₛₜ = 𝐗₁[:,length(𝐝₁ₜᵣₙ)+1:end]
    global 𝐝₁ₜₛₜ = 𝐝₁[length(𝐝₁ₜᵣₙ)+1:end]

    global 𝐗₂ₜᵣₙ = 𝐗₂[:,1:(N*Nₜᵣₙ)÷100] # for (𝐗₂, 𝐝₂)
    global 𝐝₂ₜᵣₙ = 𝐝₂[1:(N*Nₜᵣₙ)÷100]
    global 𝐗₂ₜₛₜ = 𝐗₂[:,length(𝐝₂ₜᵣₙ)+1:end]
    global 𝐝₂ₜₛₜ = 𝐝₂[length(𝐝₂ₜᵣₙ)+1:end]

    # train!
    for nₑ ∈ 1:Nₑ
        𝐰₁, MSE₁ₜᵣₙ[nₑ] = train(𝐗₁ₜᵣₙ, 𝐝₁ₜᵣₙ, 𝐰₁)
        𝐰₂, MES₂ₜᵣₙ[nₑ] = train(𝐗₂ₜᵣₙ, 𝐝₂ₜᵣₙ, 𝐰₂)
        𝐗₁ₜᵣₙ, 𝐝₁ₜᵣₙ = shuffle_dataset(𝐗₁ₜᵣₙ, 𝐝₁ₜᵣₙ)
        𝐗₂ₜᵣₙ, 𝐝₂ₜᵣₙ = shuffle_dataset(𝐗₂ₜᵣₙ, 𝐝₂ₜᵣₙ)
    end
    # test!
    MSE₁ₜₛₜ[nᵣ] = test(𝐗₁ₜₛₜ, 𝐝₁ₜₛₜ, 𝐰₁)
    MSE₂ₜₛₜ[nᵣ] = test(𝐗₂ₜₛₜ, 𝐝₂ₜₛₜ, 𝐰₂)

    # make plots!
    if nᵣ == 1
        global 𝐰₁ₒₚₜ = 𝐰₁ # save the optimum value reached during the 1th realization f₁(⋅)
        global 𝐰₂ₒₚₜ = 𝐰₂ # save the optimum value reached during the 1th realization f₂(⋅)

        local fig = plot(MSE₁ₜᵣₙ, label="", xlabel=L"Epochs", ylabel=L"MSE_{1}", linewidth=2, title="Training MSE for"*L"f_1(x_n)=ax+b"*" class by epochs\n(1th realization)", ylims=(0, 5))
        display(fig)
        savefig(fig, "trab2 (ADALINE)/figs/MES-by-epochs-for-f1.png")
        fig = plot(10*log10.(MES₂ₜᵣₙ), label="", xlabel=L"Epochs", ylabel=L"MSE_{2}"*" in (dB)", linewidth=2, title="Training MSE for "*L"f_2(x_1,x_2)=ax_1(n)+bx_2(n)+c"*" class by epochs\n(1th realization)", ylims=(0, 40))
        savefig(fig, "trab2 (ADALINE)/figs/MES-by-epochs-for-f2.png")
        display(fig)
    end
end

RMSE₁ₜₛₜ = sqrt.(MSE₁ₜₛₜ)
M̄S̄Ē₁, R̄M̄S̄Ē₁ = Σ(MSE₁ₜₛₜ)/length(MSE₁ₜₛₜ), Σ(RMSE₁ₜₛₜ)/length(RMSE₁ₜₛₜ) # mean of the MSE and RMSE of the all realizations
𝔼MSE₁², 𝔼RMSE₁² = Σ(MSE₁ₜₛₜ.^2)/length(MSE₁ₜₛₜ), Σ(RMSE₁ₜₛₜ.^2)/length(RMSE₁ₜₛₜ) # second moment of the MSE and RMSE of the all realizations
σ₁ₘₛₑ, σ₁ᵣₘₛₑ = √(𝔼MSE₁² - M̄S̄Ē₁^2), √(𝔼RMSE₁² - R̄M̄S̄Ē₁^2) # standard deviation of the MSE of the all realizations

RMSE₂ₜₛₜ = sqrt.(MSE₂ₜₛₜ)
M̄S̄Ē₂, R̄M̄S̄Ē₂ = Σ(MSE₂ₜₛₜ)/length(MSE₂ₜₛₜ), Σ(RMSE₂ₜₛₜ)/length(RMSE₂ₜₛₜ) # mean of the MSE and RMSE of the all realizations
𝔼MSE₂², 𝔼RMSE₂² = Σ(MSE₂ₜₛₜ.^2)/length(MSE₂ₜₛₜ), Σ(RMSE₂ₜₛₜ.^2)/length(RMSE₂ₜₛₜ) # second moment of the MSE and RMSE of the all realizations
σ₂ₘₛₑ, σ₂ᵣₘₛₑ = √(𝔼MSE₂² - M̄S̄Ē₂^2), √(𝔼RMSE₂² - R̄M̄S̄Ē₂^2) # standard deviation of the MSE of the all realizations

println("MSE, RMSE mean for f₁(⋅): $(M̄S̄Ē₁), $(R̄M̄S̄Ē₁)")
println("MSE, RMSE standard deviation for f₁(⋅): $(σ₁ₘₛₑ), $(σ₁ᵣₘₛₑ)")
println("MSE, RMSE mean for f₂(⋅): $(M̄S̄Ē₂), $(R̄M̄S̄Ē₂)")
println("MSE, RMSE standard deviation for f₂(⋅): $(σ₂ₘₛₑ), $(σ₂ᵣₘₛₑ)")

## predict!
𝐝₁ = f₁(range(-10,10,N)) + 𝐧 # dummy desired dataset for function 1
𝐝₂ = f₂(range(-10,10,N), range(-10,10,N)) + 𝐧 # dummy desired dataset for function 2

𝐲₁ = [fill(-1, N) range(-10,10,N)]*𝐰₁ₒₚₜ
𝐲₂ = [fill(-1, N) range(-10,10,N) range(-10,10,N)]*𝐰₂ₒₚₜ

fig = plot(range(-10,10,N), [𝐝₁ 𝐲₁], label=["Input signal" "Predicted signal"], ylabel=L"f_1(x)", xlabel=L"x", linewidth=2, title="Predicted signal for"*L"f_1(x)")
display(fig)
savefig(fig, "trab2 (ADALINE)/figs/predict-f1.png")

fig = plot3d(range(-10,10,N), range(-10,10,N), 𝐝₂, label="Input signal", linewidth=2, title="Predicted signal for "*L"f_2(x)", xlabel=L"x_1", ylabel=L"x_2", zlabel=L"f_2(x_1,x_2)")
plot3d!(range(-10,10,N), range(-10,10,N), 𝐲₂, label="Predicted signal", linewidth=2)
display(fig)
savefig(fig, "trab2 (ADALINE)/figs/predict-f2.png")