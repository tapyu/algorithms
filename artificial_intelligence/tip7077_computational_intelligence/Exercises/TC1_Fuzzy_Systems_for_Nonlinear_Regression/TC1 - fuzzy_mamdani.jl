using FileIO, Plots, LinearAlgebra, Statistics, LaTeXStrings
include("fuzzification_mamdani.jl")
include("inference_mamdani.jl")
Σ=sum

## Input and outputs
𝐱, 𝐲 = FileIO.load("TC1data.jld2", "x", "y") # 𝐱 -> Inputs; 𝐲 -> Outputs

# Mamdani fuzzy infer system
𝐲̂ = rand(length(𝐲))
for (K, 𝐲_range_max, labels) ∈ zip((2,3), (190,150), (["LOW fuzzy set "*L"(A_1)" "MEDIUM fuzzy set"*L"(A_2)" "HIGH fuzzy set"*L"(A_3)"], ["LOW fuzzy set "*L"(A_1)" "HIGH fuzzy set"*L"(A_2)"]))
    𝐲_range = range(0, 𝐲_range_max, length(𝐲)) # Universo de discurso (?) da variavel de saida
    all_μx_A = hcat(map(input_fuzzification, range(minimum(𝐱), maximum(𝐱), length(𝐱)), fill(K, length(𝐱)))...)' # input fuzzification (all domain, all fuzzy set)
    for (k, μx_A_k) ∈ enumerate(eachcol(all_μx_A)) # for each set
        all_μx_A[:,k]/=maximum(μx_A_k) # normalize it to unity
    end
    local fig = plot(all_μx_A, label=labels, xlabel=L"x\_n", ylabel=L"\mu_A(x_n)")
    savefig(fig, "figs/mamdani_fuzzy/fuzzification-for-$(K)sets.png")

    all_μy_B = hcat(map(output_fuzzification, 𝐲_range, fill(K, length(𝐲)))...)' # output fuzzification (all domain, all fuzzy set)
    all_μy_B/=maximum(all_μy_B) # normalize it to unity

    for (n, μx_A) ∈ enumerate(eachrow(all_μx_A)) # for each input sample (already fuzzified)
        𝐲̂[n] = inference(μx_A, all_μy_B, K, 𝐲_range) # compute ŷₙ
    end
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
plot!(𝐱, 𝐲̂, linewidth=2, label=L"\hat{y}_n")
savefig(fig, "figs/mamdani_fuzzy/fuzzy_prediction.png")

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