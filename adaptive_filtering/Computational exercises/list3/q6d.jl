using LinearAlgebra, DSP, Plots, LaTeXStrings
include("q6d_hard_decisors.jl")
Σ = sum

# system parameters
Nₒ = 3 # channel order
δ = 15 # desired signal delay
Nₜᵣₙ = 500 # number of samples for the training phase
μ = 0.4
γ = 10 # Normalized LMS hyperparameter
M = 16

### TRAIN ###
𝐬 = rand([1+im, 1-im, -1+im, -1-im], Nₜᵣₙ+Nₒ+δ) # constellation for 4-QAM
Eₐᵥg = Σ(abs2.(𝐬))/Nₜᵣₙ # average symbol energy -> 𝔼[‖𝐬‖²]

# channel
𝐱 = Vector{ComplexF64}(undef, Nₜᵣₙ+Nₒ+δ)
for n ∈ 1+Nₒ:Nₜᵣₙ+Nₒ+δ
    𝐱[n] = 0.5𝐬[n] + 1.2𝐬[n-1] + 1.5𝐬[n-2] - 𝐬[n-3]
end
# cut off the noncomputed part
𝐱 = 𝐱[1+Nₒ:end]
𝐬 = 𝐬[1+Nₒ:end]

# noise
# σ²ₙ = Eₐᵥg*1e-3 # SNR = 30 dB = 10 log(Eₐᵥg/σ²ₙ)
# 𝐯 = √(σ²ₙ)*randn(Nₜᵣₙ+δ)
# 𝐱 += 𝐯

# equalizer (normalized LMS)
𝐰₍ₙ₎ = zeros(M) # filter coefficients (initializing)
𝐞 = Vector{ComplexF64}(undef, Nₜᵣₙ)
for n ∈ 1+δ:Nₜᵣₙ+δ
    𝐱₍ₙ₎ = 𝐱[n:-1:n-δ] # input vector at the instant n -> [x[n], x[n-1], x[n-2], ..., x[n-15]]
    y₍ₙ₎ = 𝐰₍ₙ₎ ⋅ 𝐱₍ₙ₎ # y(n)
    d₍ₙ₎ = 𝐬[n-δ] # d(n) = s[n-δ]
    e₍ₙ₎ = d₍ₙ₎ - y₍ₙ₎
    𝐞[n-δ] = e₍ₙ₎
    𝐠̂₍ₙ₎ = -2e₍ₙ₎'*𝐱₍ₙ₎ # stochastic gradient
    global 𝐰₍ₙ₎ -= μ*𝐠̂₍ₙ₎/(𝐱₍ₙ₎⋅𝐱₍ₙ₎ + γ)
end

## DECISION-DIRECTED MODE ###
N = 100_000 # number of symbols for the decision-directed mode
SNR_min, SNR_max = 0, 30
# plots_SER = Vector{Plots.Plot{Plots.GRBackend}}(undef,4) # a list of output plots
figs = plot() # an empty plot

for (j, (M, hard_decisor)) ∈ enumerate(zip((4, 16, 64, 256), (hard_decisor_4qam, hard_decisor_16qam, hard_decisor_64qam, hard_decisor_256qam)))
    all_SER = Vector{Float64}(undef, SNR_max-SNR_min+1)
    for (i, SNR_dB) ∈ enumerate(SNR_min:SNR_max)
        local 𝐬 = rand([i[1]+i[2]*im for i ∈ Iterators.product(-(√(M)-1):2:√(M)-1, -(√(M)-1):2:√(M)-1)], N+Nₒ+δ) # symbol sequence for M-QAM constellation
        local Eₐᵥg = Σ(abs2.(𝐬))/N # average symbol energy -> 𝔼[‖𝐬‖²]

        # channel
        local 𝐱 = Vector{ComplexF64}(undef, N+Nₒ+δ)
        for n ∈ 1+Nₒ:N+Nₒ+δ
            𝐱[n] = 0.5𝐬[n] + 1.2𝐬[n-1] + 1.5𝐬[n-2] - 𝐬[n-3]
        end
        # cut off the noncomputed part
        𝐱 = 𝐱[1+Nₒ:end]
        𝐬 = 𝐬[1+Nₒ:end]

        # noise
        local σ²ₙ = (10^(-SNR_dB/10))*Eₐᵥg # SNR = SNR_dB dB = 10 log(Eₐᵥg/σ²ₙ) -> σ²ₙ = (10^(-SNR_dB/10))/ Eₐᵥg
        local 𝐯 = √(σ²ₙ)*randn(ComplexF64, N+δ) # ~ N(0, σ²ₙ)
        𝐱 += 𝐯

        𝐲 = Vector{ComplexF64}(undef, N+δ) # output signal
        # equalizer filter
        for n ∈ 1+δ:N+δ
            𝐱₍ₙ₎ = 𝐱[n:-1:n-δ] # input vector at the instant n -> [x[n], x[n-1], x[n-2], ..., x[n-15]]
            y₍ₙ₎ = 𝐰₍ₙ₎ ⋅ 𝐱₍ₙ₎ # y(n)
            # decisor
            𝐲[n] = hard_decisor(real(y₍ₙ₎)) + hard_decisor(imag(y₍ₙ₎))*im
        end

        # ignoring the noncomputed part
        𝐲 = 𝐲[1+δ:end]
        𝐱 = 𝐱[1+δ:end]
        𝐬 = 𝐬[1:end-δ]

        # compute the SER (Symbol Error Rate)
        all_SER[i] = Σ(𝐲 .!= 𝐬)/length(𝐲)
    end
    global fig = plot!(SNR_min:SNR_max, 10log10.(all_SER), label="$(M)-QAM", linewidth=2, linestyle=:dashdot, markershape=:xcross, legend=:bottomleft)
end

title!("Symbol Error Rate")
ylabel!("SER (dB)")
xlabel!("SNR (dB)")
savefig(fig, "list3/figs/q6d_ser_by_snr.png")