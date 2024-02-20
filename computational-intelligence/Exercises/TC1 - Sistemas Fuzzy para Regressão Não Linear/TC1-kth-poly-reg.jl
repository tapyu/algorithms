using FileIO, Plots, LinearAlgebra, Statistics
Σ=sum

## Input analisys and delimiters

𝐱, 𝐲 = FileIO.load("TC1data.jld2", "x", "y") # 𝐱 -> Inputs; 𝐲 -> Outputs

all_K = 5:7 # range of K values
𝐫 = rand(length(all_K)) # vector with all coefficient of determination
𝛒 = rand(length(all_K)) # vector with all Pearson correlation

for (i,K) ∈ enumerate(all_K)
    # the kth order plynomial regressors
    𝐇 = vcat(map(xₙ -> xₙ.^(0:K)', 𝐱)...) # observation matrix
    𝐇⁺ = pinv(𝐇) # the pseudoinverse (not the same Matlab's garbage pinv() function)
    𝛉 = 𝐇⁺*𝐲 # estimated coefficients
    𝐲̂ = 𝐇*𝛉 # regressor output
    𝛜 = 𝐲 - 𝐲̂ # residues

    # residues statistics
    𝛜̄ = Σ(𝛜)/length(𝛜) # must be approximetly zero
    𝔼𝛜² = Σ(𝛜.^2)/length(𝛜) # second moment
    σ̂²ₑ = 𝔼𝛜² - 𝛜̄^2 # σ̂²ₑ≈𝔼𝛜² (variance≈power)

    # coefficient of determination
    𝐲̄ = Σ(𝐲)/length(𝐲)
    R² = 1 - (Σ(𝛜.^2)/Σ((𝐲.-𝐲̄).^2))
    𝐫[i] = R²

    # Pearson correlation between 𝐲 and 𝐲̂
    𝛒[i] = cor(𝐲, 𝐲̂)

    # plot the results
    p = scatter(𝐱, 𝐲,
        markershape = :hexagon,
        markersize = 4,
        markeralpha = 0.6,
        markercolor = :green,
        markerstrokewidth = 3,
        markerstrokealpha = 0.2,
        markerstrokecolor = :black,
        xlabel = "Inputs",
        ylabel = "Outputs",
        label = "Data")
    plot!(𝐱, 𝐲̂, linewidth=2, color=:red, label="$(K)th order polynomial regressor")
    savefig(p, "figs/kth-poly-reg/$(K)th-order.png")
end

println(𝐫)
println(𝛒)