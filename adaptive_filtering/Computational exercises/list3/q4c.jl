using LinearAlgebra, DSP, Plots, LaTeXStrings
Σ = sum

N = 200 # number of samples
𝐚 = randn(N) # a(n) ~ N(0, 1)
σ² = 1 # variance of a
𝐝 = 𝐚 # d(n) = a(n)
𝐡 = [1, 1.6] # channel filter coefficients
μ = .1 # step learning

𝐑 = [3.56 1.6
1.6 3.56]
𝐩 = [1.6, 0]
𝐰ₒ = inv(𝐑)*𝐩 # Wiener solution
J(w₀, w₁) = σ² - 2𝐩⋅[w₀; w₁] + [w₀; w₁]' * 𝐑 * [w₀; w₁] # cost-function

# channel output
𝐱 = rand(N)
for n ∈ 2:N
    𝐚₍ₙ₎ = [𝐚[n], 𝐚[n-1]] # input vector at the instant n
    𝐱[n] = 𝐡 ⋅ 𝐚₍ₙ₎ # x(n)
end

# steepest descent
𝐰₍ₙ₎ = zeros(2) # initial guess of the coefficient vector
𝐖 = rand(2, N) # save the coefficient vector evolution
𝐖[:,1] = 𝐰₍ₙ₎ # save initial position
𝐲 = rand(N) # output signal
𝔼e² = zeros(N) # error signal
for n ∈ 2:N
    𝐱₍ₙ₎ = [𝐱[n], 𝐱[n-1]] # input vector at the instant n
    𝐲[n] = 𝐰₍ₙ₎ ⋅ 𝐱₍ₙ₎ # y(n)
    𝐠₍ₙ₎ = -2𝐩 + 2𝐑*𝐰₍ₙ₎ # deterministic gradient
    global 𝐰₍ₙ₎ -= μ*𝐠₍ₙ₎
    global 𝐖[:,n] = 𝐰₍ₙ₎
    global 𝔼e²[n] = ((n-2)*𝔼e²[n-1] + (𝐝[n] - 𝐲[n])^2)/(n-1)
end
p1 = plot([𝐲 𝐝], title="Steepest descent "*L"(\mathbf{w}(n) = \mathbf{w}(n) - \mu \mathbf{g}(n))", label=[L"y(n)" L"d(n)"], legend=:bottomleft)
e1 = plot(𝔼e², title="MSE of the Steepest descent", label=L"\mathbb{E}[e^2(n)]")
fig = contour(-.5:.05:1.5, -1.5:.05:1.5, J) # add the cost function contour to the last plot
scatter!([𝐰ₒ[1]], [𝐰ₒ[2]], markershape= :circle, color= :red, markersize = 6, label = "Wiener solution", title="Steepest descent coefficients over the contours") # ! make plots the scatter on the same axis
plot!(𝐖[1,:], 𝐖[2,:], xlabel=L"w_1", ylabel=L"w_2", label="", markershape=:xcross, color=:blue)
savefig(fig, "list3/figs/q4c_steepest_descent.png")

# Newton's algorithm
𝐰₍ₙ₎ = zeros(2) # initial guess of the coefficient vector
𝐖 = rand(2, N) # save the coefficient vector evolution
𝐖[:,1] = 𝐰₍ₙ₎ # save initial position
𝐲 = rand(N) # output signal
𝔼e² = zeros(N) # error signal
𝐇 = 2𝐑 # the Hessian
for n ∈ 2:N
    𝐱₍ₙ₎ = [𝐱[n], 𝐱[n-1]] # input vector at the instant n
    𝐲[n] = 𝐰₍ₙ₎ ⋅ 𝐱₍ₙ₎ # y(n)
    𝐠₍ₙ₎ = -2𝐩 + 2𝐑*𝐰₍ₙ₎ # deterministic gradient
    Δ𝐰₍ₙ₊₁₎ = -inv(𝐇)*𝐠₍ₙ₎
    global 𝐰₍ₙ₎ += Δ𝐰₍ₙ₊₁₎
    global 𝐖[:,n] = 𝐰₍ₙ₎
    global 𝔼e²[n] = ((n-2)*𝔼e²[n-1] + (𝐝[n] - 𝐲[n])^2)/(n-1)
end
p2 = plot([𝐲 𝐝], title="Newton's algorithm "*L"(\mathbf{w}(n) = \mathbf{w}(n) - \mu \mathbf{H}^{-1}\mathbf{g}(n))" , label=[L"y(n)" L"d(n)"], legend=:bottomleft)
e2 = plot(𝔼e², title="MSE of the Newton's algorithm", label=L"\mathbb{E}[e^2(n)]")
fig = contour(-.5:.05:1.5, -1.5:.05:1.5, J) # add the cost function contour to the last plot
scatter!([𝐰ₒ[1]], [𝐰ₒ[2]], markershape= :circle, color= :red, markersize = 6, label = "Wiener solution", title="Newton's algorithm coefficients over the contours") # ! make plots the scatter on the same axis
plot!(𝐖[1,:], 𝐖[2,:], xlabel=L"w_1", ylabel=L"w_2", label="", markershape=:xcross, color=:blue)
savefig(fig, "list3/figs/q4c_newton_algorithm.png")

# Least-Mean Squares (LMS) algorithm
μ = .015 # step learning
global 𝐰₍ₙ₎ = zeros(2) # initial guess of the coefficient vector
𝐖 = rand(2, N) # save the coefficient vector evolution
𝐖[:,1] = 𝐰₍ₙ₎ # save initial position
𝐲 = rand(N) # output signal
𝔼e² = zeros(N) # error signal
for n ∈ 2:N
    𝐱₍ₙ₎ = [𝐱[n], 𝐱[n-1]] # input vector at the instant n
    𝐲[n] = 𝐰₍ₙ₎ ⋅ 𝐱₍ₙ₎ # y(n)
    e₍ₙ₎ = 𝐝[n] - 𝐲[n]
    𝐠̂₍ₙ₎ = -2e₍ₙ₎*𝐱₍ₙ₎ # stochastic gradient
    global 𝐰₍ₙ₎ -= μ*𝐠̂₍ₙ₎
    global 𝐖[:,n] = 𝐰₍ₙ₎
    global 𝔼e²[n] = ((n-2)*𝔼e²[n-1] + e₍ₙ₎^2)/(n-1)
end
p3 = plot([𝐲 𝐝], title="LMS algorithm "*L"(\mathbf{w}(n) = \mathbf{w}(n) + 2\mu e(n)\mathbf{x}(n))", label=[L"y(n)" L"d(n)"], legend=:bottomleft)
e3 = plot(𝔼e², title="MSE of the LMS algorithm", label=L"\mathbb{E}[e^2(n)]")
fig = contour(-.5:.05:1, -1.5:.05:1, J) # add the cost function contour to the last plot
scatter!([𝐰ₒ[1]], [𝐰ₒ[2]], markershape= :circle, color= :red, markersize = 6, label = "Wiener solution", title="LMS algorithm coefficients over the contours") # ! make plots the scatter on the same axis
plot!(𝐖[1,:], 𝐖[2,:], xlabel=L"w_1", ylabel=L"w_2", label="", markershape=:xcross, color=:blue)
savefig(fig, "list3/figs/q4c_lms_algorithm.png")

# normalized LMS algorithm
μ = .5 # step learning
𝐰₍ₙ₎ = zeros(2) # initial guess of the coefficient vector
𝐖 = rand(2, N) # save the coefficient vector evolution
𝐖[:,1] = 𝐰₍ₙ₎ # save initial position
γ = 20 # Normalized LMS hyperparameter
𝐲 = rand(N) # output signal
𝔼e² = zeros(N) # error signal
for n ∈ 2:N
    𝐱₍ₙ₎ = [𝐱[n], 𝐱[n-1]] # input vector at the instant n
    𝐲[n] = 𝐰₍ₙ₎ ⋅ 𝐱₍ₙ₎ # y(n)
    e₍ₙ₎ = 𝐝[n] - 𝐲[n]
    𝐠̂₍ₙ₎ = -2e₍ₙ₎*𝐱₍ₙ₎ # stochastic gradient
    global 𝐰₍ₙ₎ -= μ*𝐠̂₍ₙ₎/(𝐱₍ₙ₎⋅𝐱₍ₙ₎ + γ)
    global 𝐖[:,n] = 𝐰₍ₙ₎
    global 𝔼e²[n] = ((n-2)*𝔼e²[n-1] + e₍ₙ₎^2)/(n-1)
end
p4 = plot([𝐲 𝐝], title="Normalized LMS algorithm "*L"\left(\mathbf{w}(n) = \mathbf{w}(n) + \frac{2\mu e(n)\mathbf{x}(n)}{\mathbf{x}^\mathrm{T}(n)\mathbf{x}(n) + \gamma}\right)", label=[L"y(n)" L"d(n)"], legend=:bottomleft)
e4 = plot(𝔼e², title="MSE of the normalized LMS algorithm", label=L"\mathbb{E}[e^2(n)]")
fig = contour(-.5:.05:1.5, -1.5:.05:1.5, J) # add the cost function contour to the last plot
scatter!([𝐰ₒ[1]], [𝐰ₒ[2]], markershape= :circle, color= :red, markersize = 6, label = "Wiener solution", title="Normalized LMS algorithm coefficients over the contours") # ! make plots the scatter on the same axis
plot!(𝐖[1,:], 𝐖[2,:], xlabel=L"w_1", ylabel=L"w_2", label="", markershape=:xcross, color=:blue)
savefig(fig, "list3/figs/q4c_normalized_lms_algorithm.png")

# final plots
fig = plot(p1, p2, p3, p4, layout=(4,1), size=(1200,800))
savefig(fig, "list3/figs/q4_all_filter_output.png")

fig = plot(e1, e2, e3, e4, layout=(4,1), size=(1200,800))
savefig(fig, "list3/figs/q4-error-evolution.png")