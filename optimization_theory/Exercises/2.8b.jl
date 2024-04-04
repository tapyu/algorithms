import JuMP, CDDLib, Polyhedra, Plots
using LaTeXStrings
m = JuMP.Model()
JuMP.@variable(m, 0 ≤ x[1:2] ≤ 3) # it is not possible to define opened intervals, the values 3 was arbitrary
JuMP.@constraint(m, x[2] ≤ x[1])
poly = Polyhedra.polyhedron(m, CDDLib.Library(:exact))
fig = Plots.plot(poly, xlabel=L"x", ylabel=L"y")
Plots.savefig(fig, "figs/2.8b.png")