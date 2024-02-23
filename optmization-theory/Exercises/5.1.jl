using Convex, SCS

# data parameters
Q = [1 -1/2; -1/2 2];
f = [-1, 0];
A = [1 2; 1 -4; 5 76];
b = [-2, -3, 1];


# item 1 (a)
x = Variable(2);
constraints = A*x <= b;
p = minimize(quadform(x,Q)+f'*x, constraints);
solve!(p, SCS.Optimizer);
lambda = constraints.dual;
p_star = p.optval;
println(lambda);
println(p_star);
println(x.value);
println(A*x.value - b);
println(2*Q*x.value + f + A'*lambda);


# item (b)
arr_i = [0 -1 1];
delta = 0.1;
pa_table = zeros(9, 4);
count = 1;
for i in arr_i
for j in arr_i
p_pred = p_star - dot(lambda[1:2], [i;j])*delta;
x = Variable(2);
p = minimize(quadform(x,Q)+f'*x, A*x <= b+[1;j;0]*delta);
solve!(p, SCS.Optimizer);
p_exact = p.optval;
pa_table[count, :] = [i*delta j*delta p_pred p_exact];
global count += 1;
end
end