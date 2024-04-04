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
F = 𝐲̂ᵢ -> Σ(abs.(𝐲̂-𝐲̂ᵢ)) # alternative cost function
cₚ = cg = .1 # accelerator coefficients
k = 6 # order of the polynomial regression
Nᵢ = 100 # number of iterations

# initialize!
𝐱ᵤ = [79.3, 3.5, -0.20, 0.005, -3e-5, 1.35e-7, -1.78e-10] # upper bound
𝐱ₗ = [79.1, 3.4, -0.25, 0.003, -4e-5, 1.33e-7, -1.80e-10] # lower bound
𝐗 = hcat([[rand(Uniform(a,b)) for (a, b) ∈ zip(𝐱ₗ, 𝐱ᵤ)] for _ in 1:I]...) # matrix of all solutions [k+1 position of the ith particle X I particles]
𝐕 = hcat([[rand(Uniform(a,b)) for (a, b) ∈ zip(-abs.(𝐱ᵤ-𝐱ₗ), abs.(𝐱ᵤ-𝐱ₗ))] for _ in 1:I]...) # their velocities
𝐏 = rand(k+1, I) # their positions for their best solutions
𝐠 = rand(k+1) # the position for the best global solution
𝐣ₚ = fill(Inf, I) # cost function of the best solution for each particle
Jg = Inf # cost function of the global solution
𝐣g = fill(NaN, Nᵢ)
M = 3 # number of realizations

# initialize the best individual and global best cost function
for i ∈ 1:I
    𝐲̂ᵢ = map(x₍ₙ₎ -> Σ(𝐗[:,i] ⊙ x₍ₙ₎.^(0:k)), 𝐱)
    J(𝐲̂ᵢ)<𝐣ₚ[i] && (𝐣ₚ[i]=J(𝐲̂ᵢ); 𝐏[:,i]=𝐗[:,i]) # update position of the individual best solution
    J(𝐲̂ᵢ)<Jg && (global Jg=J(𝐲̂ᵢ); global 𝐠=𝐗[:,i]) # update position of global best solution
end

for i ∈ 1:I
    𝐲̂ᵢ = map(x₍ₙ₎ -> Σ(𝐗[:,i] ⊙ x₍ₙ₎.^(0:k)), 𝐱)
    J(𝐲̂ᵢ)<𝐣ₚ[i] && (𝐣ₚ[i]=J(𝐲̂ᵢ); 𝐏[:,i]=𝐗[:,i]) # update position of the individual best solution
    J(𝐲̂ᵢ)<Jg && (global Jg=J(𝐲̂ᵢ); global 𝐠=𝐗[:,i]) # update position of glob
end

for m in 1:M
    for (nᵢ, w) ∈ enumerate(range(.9,.4, length=Nᵢ)) # inertia parameter
        for i ∈ 1:I
            𝐫ₚ, 𝐫g = (rand(k+1) for _ ∈ 1:2)
            𝐕[:,i] = w*𝐕[:,i] + cₚ*𝐫ₚ⊙(𝐏[:,i] - 𝐗[:,i]) + cg*𝐫g⊙(𝐠 - 𝐗[:,i]) # update velocity
            𝐕[:,i] = [max(min(vₘₐₓ, v), vₘᵢₙ) for (vₘᵢₙ, v, vₘₐₓ) ∈ zip(-abs.(𝐱ᵤ-𝐱ₗ), 𝐕[:,i], abs.(𝐱ᵤ-𝐱ₗ))] # restrict it to the space search
    
            𝐗[:,i] += 𝐕[:,i]
            𝐲̂ᵢ = map(x₍ₙ₎ -> Σ(𝐗[:,i] ⊙ x₍ₙ₎.^(0:k)), 𝐱)
            # update position of the individual best solution
            if J(𝐲̂ᵢ)<𝐣ₚ[i]
                𝐣ₚ[i]=J(𝐲̂ᵢ)
                𝐏[:,i]=𝐗[:,i]
            end
            
            # update position of global best solution
            if J(𝐲̂ᵢ)<Jg
                global Jg=J(𝐲̂ᵢ)
                global 𝐠=𝐗[:,i]
                global 𝐣g[nᵢ]=J(𝐲̂ᵢ)
            end
        end
    end
    
    𝐲̂ₒ = map(x₍ₙ₎ -> Σ(𝐠 ⊙ x₍ₙ₎.^(0:k)), 𝐱) # heuristic solution
    
    fig = plot([𝐲̂ 𝐲̂ₒ], label=["Least Square Polynomial solution" "Heuristic solution"], linewidth=3)
    scatter!(𝐱, 𝐲, label="Dataset")
    savefig(fig, "./TC3 - Methaeuristic/figs/methaeuristic_regression_result$(m).png")
    
    display(fig)
end