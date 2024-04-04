using LinearAlgebra, Plots

λ = 0.98
δ = 100

𝐲 = fill(NaN, 10)
𝐒d = δ*I(3)
𝐩 = zeros(3)

for n ∈ 3:10
    𝐱₍ₙ₎ = cos.(π*(n:-1:n-2)/3)
    d₍ₙ₎ = cos(π*(n+1)/3) # d(n) = x[n+1]

    global 𝐒d = (𝐒d - (𝐒d*𝐱₍ₙ₎*𝐱₍ₙ₎'*𝐒d)/(λ + 𝐱₍ₙ₎'*𝐒d*𝐱₍ₙ₎))/λ
    global 𝐩 = λ*𝐩 + d₍ₙ₎'*𝐱₍ₙ₎
    𝐰₍ₙ₎ = 𝐒d*𝐩
    y₍ₙ₎ = 𝐰₍ₙ₎ ⋅ 𝐱₍ₙ₎ # y(n)
    𝐲[n] = y₍ₙ₎
end

fig = plot([cos.(π*(1:10)/3) 𝐲], markershape=:xcross, linewidth=2, markersize=5, markerstrokewidths=4, label=["x(n)" "y(n)"], xlabel="n")

savefig(fig, "list4/figs/q1.png")