using ImplicitEquations, Plots, LaTeXStrings
f(x,y) = x * y
g(x,y) = x
h(x,y) = y
fig = plot((f ≫ 1) & (g ≫ 0) & (h ≫ 0), fc=:blues, widen=false, xlabel=L"x", ylabel=L"y") # \leqq[tab]
savefig(fig, "figs/2.8d.png")