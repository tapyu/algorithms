using Convex, SCS, Plots, LaTeXStrings

N = 30 # N in the set {0, 1, ..., N}
n = 3 # order of the linear dynamical system
x_des = [7, 2, -6] # constraint -> 𝐱(N) == x_des
# model parameters
𝐀 = [-1 .4 .8; 1 0 0; 0 1 0]
𝐛 = [1, 0, 0.3]

𝐗 = Variable(n, N+1) # [𝐱(0) 𝐱(1) ... 𝐱(N)]
𝐮 = Variable(1, N) # [u(0) u(1) ... u(N-1)]
f0 = sum(max(abs(𝐮), 2abs(𝐮)-1)) # objective function
constraints = [
    𝐗[:,2:N+1] == 𝐀*𝐗[:,1:N]+𝐛*𝐮, # recursive equation
    𝐗[:,1] == zeros(n), # initial condition
    𝐗[:,N+1] == x_des, # final condition
]
problem = minimize(f0, constraints)
solve!(problem, SCS.Optimizer; silent_solver = true)

fig = plot(vec(𝐮.value), xlabel=L"k", title=L"u(k)", seriestype=:sticks, markershape=:circle, label="")
savefig(fig, "figs/4.17.png")