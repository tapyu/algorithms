using FileIO, Plots, Statistics, LaTeXStrings
include("fuzzification_takagi_sugeno.jl")
include("inference_takagi_sugeno.jl")
Σ=sum

## Input and outputs
𝐱, 𝐲 = FileIO.load("TC1data.jld2", "x", "y") # 𝐱 -> Inputs; 𝐲 -> Outputs

# Takagi-Sugeno fuzzy inference system (FIS)
𝐲̂ = rand(length(𝐲)) # predicted values
K = 4 # number of sets

all_μx_A = hcat(map(input_fuzzification, range(minimum(𝐱), maximum(𝐱), length(𝐱)))...)' # input fuzzification (all domain, all fuzzy set)

for (k, μx_A_k) ∈ enumerate(eachcol(all_μx_A)) # normalize it to unity
    all_μx_A[:,k]/=maximum(μx_A_k)
end

fig = plot(all_μx_A, label=["VERY LOW "*L"\left(\mu_{A_1}^{(i)}(x_n)\right)" "LOW "*L"\left(\mu_{A_2}^{(i)}(x_n)\right)" "MEDIUM "*L"\left(\mu_{A_3}^{(i)}(x_n)\right)" "HIGH "*L"\left(\mu_{A_4}^{(i)}(x_n)\right)"], xlabel=L"x_n", ylabel=L"\mu_A(x_n)", legend=:bottomright)

savefig(fig, "figs/takagi_sugeno/fuzzyset_takagi_sugeno.png")

all_f = [100, 40, 150, 8] # [f₁(xₙ) f₂(xₙ) ... f₄(xₙ)]

for (n, μx_A) ∈ enumerate(eachrow(all_μx_A))
    𝐲̂[n] = inference(μx_A, all_f)
end


# plot the result
fig = scatter(𝐱, 𝐲,
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
plot!(𝐱, 𝐲̂, linewidth=3, label=L"\hat{y}_n")
savefig(fig, "figs/takagi_sugeno/fuzzy_prediction.png")
display(fig)

𝛜 = 𝐲 - 𝐲̂ # residues

# residues statistics
𝛜̄ = Σ(𝛜)/length(𝛜) # must be approximately zero
𝔼𝛜² = Σ(𝛜.^2)/length(𝛜) # second moment (mean squared error, MSE)
σ̂²ₑ = 𝔼𝛜² - 𝛜̄^2 # σ̂²ₑ≈𝔼𝛜² (variance≈power)

# coefficient of determination
𝐲̄ = Σ(𝐲)/length(𝐲)
R² = 1 - (Σ(𝛜.^2)/Σ((𝐲.-𝐲̄).^2))

# Pearson correlation between 𝐲 and 𝐲̂
ρ = cor(𝐲, 𝐲̂)

println("mean squared error, MSE: $(𝔼𝛜²)")
println("Coefficient of determination: $(R²)")
println("Pearson correlation: $(ρ)")