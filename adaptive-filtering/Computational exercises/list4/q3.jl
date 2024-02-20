using LinearAlgebra, DSP, Plots, LaTeXStrings
Σ = sum

N = 200 # number of samples
𝐚 = randn(N) # a(n) ~ N(0, 1)
σ² = 1 # variance of a
𝐝 = 𝐚 # d(n) = a(n)
𝐡 = [1, 1.6] # channel filter coefficients
λ = 0.99
δ = 5
𝐲 = fill(NaN, 10)
𝐒d = δ*I(2)

𝐑 = [3.56 1.6
1.6 3.56]
𝐩ₓd = [1.6, 0]
𝐰ₒ = inv(𝐑)*𝐩ₓd # Wiener solution
J(w₀, w₁) = σ² - 2𝐩ₓd⋅[w₀; w₁] + [w₀; w₁]' * 𝐑 * [w₀; w₁] # cost-function

# channel output
𝐱 = rand(N)
for n ∈ 2:N
    𝐚₍ₙ₎ = [𝐚[n], 𝐚[n-1]] # input vector at the instant n
    𝐱[n] = 𝐡 ⋅ 𝐚₍ₙ₎ # x(n)
end

# RLS
𝐰₍ₙ₎ = zeros(2) # initial guess of the coefficient vector
𝐩 = zeros(2)
𝐖 = rand(2, N) # save the coefficient vector evolution
𝐖[:,1] = 𝐰₍ₙ₎ # save initial position
𝐲 = rand(N) # output signal
𝔼e² = zeros(N) # error signal
for n ∈ 2:N
    𝐱₍ₙ₎ = [𝐱[n], 𝐱[n-1]] # input vector at the instant n
    global 𝐒d = (𝐒d - (𝐒d*𝐱₍ₙ₎*𝐱₍ₙ₎'*𝐒d)/(λ + 𝐱₍ₙ₎'*𝐒d*𝐱₍ₙ₎))/λ
    global 𝐩 = λ*𝐩 + 𝐝[n]'*𝐱₍ₙ₎
    global 𝐰₍ₙ₎ = 𝐒d*𝐩
    global 𝐖[:,n] = 𝐰₍ₙ₎
    global 𝔼e²[n] = ((n-2)*𝔼e²[n-1] + (𝐝[n] - 𝐲[n])^2)/(n-1)
    𝐲[n] = 𝐰₍ₙ₎ ⋅ 𝐱₍ₙ₎ # y(n)
end
p4 = plot([𝐲 𝐝], title="RLS algorithm ", label=[L"y(n)" L"d(n)"], legend=:bottomleft)
savefig(p4, "list4/figs/q2_rls_algorithm_output.png")

fig = contour(-.5:.05:1.5, -1.5:.05:1.5, J) # add the cost function contour to the last plot
scatter!([𝐰ₒ[1]], [𝐰ₒ[2]], markershape= :circle, color= :red, markersize = 6, label = "Wiener solution", title="RLS algorithm coefficients over the contours") # ! make plots the scatter on the same axis
plot!(𝐖[1,:], 𝐖[2,:], xlabel=L"w_1", ylabel=L"w_2", label="", markershape=:xcross, color=:blue)
savefig(fig, "list4/figs/q2_contour.png")

e4 = plot(𝔼e², title="MSE of the RLS algorithm", label=L"\mathbb{E}[e^2(n)]")
savefig(e4, "list4/figs/q2_rls_algorithm_error.png")