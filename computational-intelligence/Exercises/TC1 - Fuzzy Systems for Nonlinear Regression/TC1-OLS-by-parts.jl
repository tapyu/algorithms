using FileIO, Plots
Σ=sum

## Input analisys and delimiters

𝐱, 𝐲 = FileIO.load("TC1data.jld2", "x", "y") # 𝐱 -> Inputs; 𝐲 -> Outputs

all_delimiters = Dict(3=>[1, 68, 110, 180, 250], 4=>[1, 68, 110, 145, 180, 250], 5=>[1, 68, 110, 130, 145, 180, 250])

## SISO (single input, single output) Ordinary Least-Squares (OLS)
function siso_ols_algorithm(𝐱,𝐲)
    # 𝐲̂ = â𝐱+b̂
    x̄, ȳ = Σ(𝐱)/length(𝐱), Σ(𝐲)/length(𝐲)
    𝔼𝐱𝐲, 𝔼𝐱² = Σ(𝐱.*𝐲)/length(𝐱), Σ(𝐱.^2)/length(𝐱)
    σ̂ₓy = 𝔼𝐱𝐲 - x̄*ȳ
    σ²ₓ = 𝔼𝐱² - x̄^2
    â = σ̂ₓy/σ²ₓ
    b̂ = ȳ - â*x̄
    return â, b̂
end

## begin LS by parts
𝐑 = Matrix{Float64}(undef, 0,maximum(keys(all_delimiters))+1+2) # variable that gather all values the coefficient of determination for each part (plus their statistics)
for (I, delimiters) ∈ all_delimiters
    𝐫 = rand(I+1) # vector of the coefficient of determination (R²) for each part
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
        plot!(delimiters[2:end-1], linewidth = 2, seriestype = :vline, label = "Delimiters", color= :blue)
        savefig(p, "figs/scatterplot_with_delimiter_$(I)I.png")

    for i ∈ 2:length(delimiters)
        𝐱ᵢ, 𝐲ᵢ = 𝐱[delimiters[i-1]:delimiters[i]], 𝐲[delimiters[i-1]:delimiters[i]]

        â, b̂ = siso_ols_algorithm(𝐱ᵢ, 𝐲ᵢ) # get the coefficients
        𝐲̂ᵢ = â*𝐱ᵢ .+ b̂
        𝛜ᵢ = 𝐲ᵢ - 𝐲̂ᵢ # residues

        # coefficient of determination
        𝐲̄ᵢ = Σ(𝐲ᵢ)/length(𝐲ᵢ)
        R² = 1 - (Σ(𝛜ᵢ.^2)/Σ((𝐲ᵢ.-𝐲̄ᵢ).^2))
        𝐫[i-1] = R²
        if i==length(delimiters)
            𝐫̄ = Σ(𝐫)/length(𝐫) # mean
            𝔼𝐫² = Σ(𝐫.^2)/length(𝐫) # second moment
            σ²ᵣ = 𝔼𝐫² - 𝐫̄^2 # variance
            global 𝐑 = [𝐑; [𝐫' zeros(1, maximum(keys(all_delimiters))+1-length(𝐫)) 𝐫̄ σ²ᵣ]]
        end

        # residues statistics
        𝛜̄ᵢ = Σ(𝛜ᵢ)/length(𝛜ᵢ) # must be approximetly zero
        𝔼𝛜² = Σ(𝛜ᵢ.^2)/length(𝛜ᵢ) # second moment
        σ̂²ₑ = 𝔼𝛜² - 𝛜̄ᵢ^2 # σ̂²ₑ≈𝔼𝛜² (variance≈power)

        # plot of the curve of the linear regressors
        if i == length(delimiters)
            plot!(p, [delimiters[i-1], delimiters[i]], [â*delimiters[i-1]+b̂, â*delimiters[i] + b̂], label="Linear Curves", color=:red, linewidth = 3)
            savefig(p, "figs/OLS_by_$(I+1)parts.png")
        else
            plot!(p, [delimiters[i-1], delimiters[i]], [â*delimiters[i-1]+b̂, â*delimiters[i] + b̂], label="", color=:red, linewidth = 3)
        end

        # histogram of the residues along with the Gaussian distribution
        𝐝ᵢ = 𝛜ᵢ/√σ̂²ₑ # normalized residues
        h = histogram(𝐝ᵢ, label="Distribution of the residues", normalize= :pdf, bins=range(-3, stop = 3, length = 8))
        x = range(-3,3,length=50)
        gaussian = exp.(-(x.^2)./(2*1))./√(2*π*1) # Gaussian Probability Density Function (PDF)
        plot!(h, x, gaussian, label="~N(0, 1)", linewidth=2)
        savefig(h, "figs/residues_PDF_I$(I)i$(i-1).png")
    end
end

FileIO.save("R2_LS_by_parts.jld2", "R", 𝐑)