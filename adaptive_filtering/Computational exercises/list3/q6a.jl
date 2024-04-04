using LinearAlgebra, DSP, Plots, LaTeXStrings
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
σ²ₙ = Eₐᵥg*1e-3 # SNR = 30 dB = 10 log(Eₐᵥg/σ²ₙ)
𝐯 = √(σ²ₙ)*randn(Nₜᵣₙ+δ)
𝐱 += 𝐯

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
N = 5_000 # number of samples for the decision-directed mode
𝐬 = rand([i[1]+i[2]*im for i in Iterators.product(-3:2:3, -3:2:3)], N+Nₒ+δ) # constellation for 16-QAM
Eₐᵥg = Σ(abs2.(𝐬))/N # average symbol energy -> 𝔼[‖𝐬‖²]

# channel
𝐱 = Vector{ComplexF64}(undef, N+Nₒ+δ)
for n ∈ 1+Nₒ:N+Nₒ+δ
    𝐱[n] = 0.5𝐬[n] + 1.2𝐬[n-1] + 1.5𝐬[n-2] - 𝐬[n-3]
end
# cut off the noncomputed part
𝐱 = 𝐱[1+Nₒ:end]
𝐬 = 𝐬[1+Nₒ:end]

# noise
σ²ₙ = Eₐᵥg*1e-3 # SNR = 30 dB = 10 log(Eₐᵥg/σ²ₙ)
𝐯 = √(σ²ₙ)*randn(ComplexF64, N+δ)
𝐱 += 𝐯

# equalizer in decision-directed mode
function hard_decisor16qam(x)
    if x > 2
        return 3
    elseif x > 0
        return 1
    elseif x > -2
        return -1
    else
        return -3
    end
end

𝐲 = Vector{ComplexF64}(undef, N+δ) # output signal
for n ∈ 1+δ:N+δ
    𝐱₍ₙ₎ = 𝐱[n:-1:n-δ] # input vector at the instant n -> [x[n], x[n-1], x[n-2], ..., x[n-15]]
    y₍ₙ₎ = 𝐰₍ₙ₎ ⋅ 𝐱₍ₙ₎ # y(n)
    # decisor
    𝐲[n] = hard_decisor16qam(real(y₍ₙ₎)) + hard_decisor16qam(imag(y₍ₙ₎))*im
end

# ignoring the noncomputed part
𝐲 = 𝐲[1+δ:end]
𝐱 = 𝐱[1+δ:end]
𝐬 = 𝐬[1:end-δ]

# save signal output
p = [plot([real(𝐲[end-50:end]) real(𝐬[end-50:end]) real(𝐱[end-50:end])], line=:stem, markershape=[:star5 :utriangle :circle], title="Real part", label=[L"\hat{s}(n)" L"s(n)" L"x(n)"], ylims=(-1.5,1.5)) plot([imag(𝐲[end-50:end]) imag(𝐬[end-50:end]) imag(𝐱[end-50:end])], line=:stem, title="Imaginary part", markershape=[:star5 :utriangle :circle], label=[L"\hat{s}(n)" L"s(n)" L"x(n)"], ylims=(-1.5,1.5))]
fig = plot(p..., size=(900,600), layout=(2,1))
savefig(fig, "list3/figs/q6a_output.png")

# save error output
fig = plot(abs2.(𝐞), title="Signal error in training phase for $(Nₜᵣₙ) samples", label=L"\mid e(n)\mid^2", xlabel="n")
savefig(fig, "list3/figs/q6a_error.png")