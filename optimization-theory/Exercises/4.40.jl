using Convex, SCS

𝐱 = Variable(2)

f0 = square(𝐱[1]) # objective function
constraints = [
    𝐱[1] ≤ -1,
    square(𝐱[1]) + square(𝐱[2]) ≤ 2
]
problem = minimize(f0, constraints)
solve!(problem, SCS.Optimizer; silent_solver = true)

println(round(problem.optval, digits = 2))
# println(round.(evaluate(𝐱), digits = 2))
# println(evaluate(x[1]))
𝐱