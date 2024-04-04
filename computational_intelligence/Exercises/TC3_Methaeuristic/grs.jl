using FileIO, Plots, LinearAlgebra, Statistics, Distributions
Σ=sum
⊙ = .* # Hadamard

𝐱, 𝐲 = FileIO.load("TC1 - Sistemas Fuzzy para Regressão Não Linear/TC1data.jld2", "x", "y") # 𝐱 -> Inputs; 𝐲 -> Outputs

# the kth order plynomial regressors
𝐇 = vcat(map(xₙ -> xₙ.^(0:6)', 𝐱)...) # observation matrix
𝐇⁺ = pinv(𝐇) # the pseudoinverse (not the same Matlab's garbage pinv() function)
𝛉ₒ = 𝐇⁺*𝐲 # estimated coefficients (optimum values)
𝐲̂ = 𝐇*𝛉ₒ # regressor output

I = 30 # number of particles
J = 𝐲̂ᵢ -> Σ((𝐲̂-𝐲̂ᵢ).^2) # cost function
cₚ = cg = .1 # accelerator coefficients
k = 6 # order of the polynomial regression
Nᵢ = 10_000 # number of iterations

# initialize!
𝐱ᵤ = [79.3, 3.5, -0.20, 0.005, -3e-5, 1.35e-7, -1.78e-10] # upper bound
𝐱ₗ = [79.1, 3.4, -0.25, 0.003, -4e-5, 1.33e-7, -1.80e-10] # lower bound
𝐱ₒ = [rand(Uniform(a,b)) for (a, b) ∈ zip(𝐱ₗ, 𝐱ᵤ)] # initialize the best solution with the bound
𝐲̂ₒ = map(x₍ₙ₎ -> Σ(𝐱ₒ ⊙ x₍ₙ₎.^(0:k)), 𝐱) # output value of the best function
Jₒ = J(𝐲̂ₒ) # best cost function
M = 3 # number of realizations

for m ∈ 1:M
    for _ ∈ 1:Nᵢ
        𝐱c = [rand(Uniform(a,b)) for (a, b) ∈ zip(𝐱ₗ, 𝐱ᵤ)] # candidate solution
        𝐲̂c = map(x₍ₙ₎ -> Σ(𝐱c ⊙ x₍ₙ₎.^(0:k)), 𝐱) # output value of the best function
        if J(𝐲̂c) < Jₒ
            # println("pass here!")
            global 𝐱ₒ = 𝐱c
            global Jₒ = J(𝐲̂c)
        end
    end
    𝐲̂ₒ = map(x₍ₙ₎ -> Σ(𝐱ₒ ⊙ x₍ₙ₎.^(0:k)), 𝐱) # heuristic solution
    
    fig = plot([𝐲̂ 𝐲̂ₒ], label=["Least Square Polynomial solution" "Heuristic solution"], linewidth=3)
    scatter!(𝐱, 𝐲, label="Dataset")
    savefig(fig, "./TC3 - Methaeuristic/figs/grs_regression_result$(m).png")
end