import JuMP, CDDLib, Polyhedra, Plots
m = JuMP.Model()
JuMP.@variable(m, 0 ≤ x[1:2] ≤ 3) # it is not possible to define opened intervals, the values 3 was arbitrary
JuMP.@constraint(m, x[1] ≤ x[2])
poly = Polyhedra.polyhedron(m, CDDLib.Library(:exact))
Plots.plot(poly)