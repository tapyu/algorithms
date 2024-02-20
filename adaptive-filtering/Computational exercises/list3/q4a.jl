using DSP, Plots, LinearAlgebra, LaTeXStrings
include("zplane.jl")

N = 50 # number of samples
𝐡 = [1, 1.6] # filter coefficients

𝐚 = randn(N) # a(n)
# Output filter - both are equivalent
# H = PolynomialRatio(𝐡, [1])
# 𝐱 = filt(H, 𝐚)
𝐱 = [NaN; rand(N-1)] # x(n)
for n ∈ 2:N
    𝐱[n] = 𝐡[1]𝐚[n] + 𝐡[2]𝐚[n-1] # channel output
end

# equalizer (Wiener filter)
𝐑 = [3.56 1.6
      1.6 3.56]
𝐩 = [1, 0]
𝐰ₒ = inv(𝐑)*𝐩 # Wiener solution
𝐲 = [NaN; rand(N-1)] # x(n)
for n ∈ 2:N
    𝐲[n] = 𝐰ₒ[1]𝐱[n] + 𝐰ₒ[2]𝐱[n-1] # channel output
end

# plot([𝐚 𝐱 𝐲], label=[L"d(n)=a(n)" L"x(n)" L"y(n)=\hat{a}(n)"])
fig = plot(PolynomialRatio(𝐰ₒ, [1]))
savefig(fig, "figs/q4a_wiener_filter.png")