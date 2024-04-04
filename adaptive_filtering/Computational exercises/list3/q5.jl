using LinearAlgebra, Plots, LaTeXStrings, DSP

Nₛ = 1000 # number of samples
N = 13 # 13 tapped delay plus the bias
𝐱 = 2√(3)rand(Nₛ).-√(3) # ~ U(-√(3), √(3)) -> σₓ² = 1
μₘₐₓ = 1/N
𝐑 = I(N) # correlation matrix of x(n) -> is I since it is a white process
σₙ² = 1e-3 # measurement variance
𝔼e²ₘᵢₙ = σₙ² # minimum MSE (only achievable by the steepest descent method, using the deterministic gradient)

# system output
𝐝ʼ = [0; rand(Nₛ-1)] # initial stage
for n ∈ N:Nₛ
    𝐝ʼ[n] = 𝐝ʼ[n-1] + 𝐱[n] - 𝐱[n-12]
end

# reference signal (system output + noise)
𝐧 = √(σₙ²)randn(Nₛ) # ~ N(0, σₙ²)
𝐝 = 𝐝ʼ + 𝐧

plots_lms = Array{Plots.Plot{Plots.GRBackend}, 1}(undef,4) # or Vector{Plots.GRBackend}(undef,4)
plots_mse = Array{Plots.Plot{Plots.GRBackend}, 1}(undef,4) # or Vector{Plots.GRBackend}(undef,4)
for (j, i) ∈ enumerate((1, 2, 10, 50))
    μ = μₘₐₓ/i # step learning
    # the LMS algorithm
    global 𝐰₍ₙ₎ = rand(N) # initial coefficient vector
    𝔼e² = zeros(Nₛ) # MSE (mean-squared error) signal
    𝐲 = [fill(NaN, N); rand(Nₛ-N)] # adaptive filter output
    for n ∈ N:Nₛ
        𝐱₍ₙ₎ = 𝐱[n:-1:n-12] # input signal
        𝐲[n] = 𝐱₍ₙ₎ ⋅ 𝐰₍ₙ₎ # adaptive filter output
        e₍ₙ₎ = 𝐝[n] - 𝐲[n] # signal error
        𝔼e²[n] = ((n-N)*𝔼e²[n-1] + e₍ₙ₎^2)/(n-N+1) # estimate the the MSE recursively
        𝐰₍ₙ₎ += 2μ*e₍ₙ₎*𝐱₍ₙ₎
    end
    plots_lms[j] = plot([𝐝 𝐲], label=[L"d(n)" L"y(n)"*" for "*L"\mu=\mu_{max}"*(i!=1 ? "/$(i)" : "")], xlabel="n", legend=:topleft)
    plots_mse[j] = plot(𝔼e², label=L"e^2(n)"*" for "*L"\mu=\mu_{max}"*(i!=1 ? "/$(i)" : ""), xlabel="n", legend=:bottomright)

    𝔼e²ₑₓc = 𝔼e²[end] - 𝔼e²ₘᵢₙ

    # println("Excess MSE = $(𝔼e²ₑₓc) for μ = μₘₐₓ/$(i) (practical result)")
    # println("Excess MSE = $(μ*σₙ²*tr(𝐑)/(1 - μ*tr(𝐑))) for μ = μₘₐₓ/$(i) (theoretical result)")

    println("Misadjustment M = $(𝔼e²ₑₓc/𝔼e²ₘᵢₙ) for μ = μₘₐₓ/$(i) (practical result)")
    println("Misadjustment M = $(μ*tr(𝐑)/(1 - μ*tr(𝐑))) for μ = μₘₐₓ/$(i) (theoretical result)")
end

# save LMS fig convergence
fig = plot(plots_lms..., layout=(4,1), size=(1200,800), title=["System identification output for differents learning steps" "" "" ""]) # plots_lms... -> dereferencing
savefig(fig, "list3/figs/q5_lms_algorithm.png")

# save MSE
fig = plot(plots_mse..., layout=(4,1), size=(1200,800)) # plots_ems... -> dereferencing
savefig(fig, "list3/figs/q5_mse_algorithm.png")

H = DSP.PolynomialRatio([1; fill(0,11); -1], [1, -1]) # transfer function of H(ℯ^(jω)) vs. Ĥ(ℯ^(jω))
H₍w₎, w = DSP.freqresp(H)
fig = plot(w, abs.(H₍w₎), label=L"\mid H(e^{jw})\mid", linewidth=2)
Ĥ = DSP.PolynomialRatio(𝐰₍ₙ₎, [1])
Ĥ₍w₎, w = DSP.freqresp(Ĥ)
plot!(w, abs.(Ĥ₍w₎), xlabel="Digital frequency "*L"w"*" (radians/sample)", label=L"\mid\hat{H}(e^{jw})\mid", xticks = ([0, π/2, π], ["0", "π/2", "π"]), linewidth=2)
savefig(fig, "list3/figs/transfer_function.png")