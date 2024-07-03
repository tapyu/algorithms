using ImplicitEquations, Plots, LaTeXStrings
f(x,y,z) = x + y + z
fig = plot(f ≪ 1, fc=:blues, widen=false, xlabel=L"x", ylabel=L"y", zlabel=L"z") # \leqq[tab]
savefig(fig, "figs/2.15.png")