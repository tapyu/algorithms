#!/usr/bin/zsh

for urldirectory filename urlfile in {\
'Ch04_cvx_opt_probs','Section 4.3.1: Compute and display the Chebyshev center of a 2D polyhedron.m','chebyshev_center_2D.m',\
'Ch04_cvx_opt_probs','Section 4.3.1- Compute the Chebyshev center of a polyhedron.m.m','chebyshev_center.m',\
'Ch04_cvx_opt_probs','Section 4.5.4- Design of a cantilever beam- recursive formulation (GP).m','cantilever_beam_rec.m',\
'Ch04_cvx_opt_probs','Section 4.5.4- Frobenius norm diagonal scaling (GP).m','frob_norm_diag_scaling.m',\
'Ch04_cvx_opt_probs','Section 4.5.4- Minimum spectral radius via Peron-Frobenius theory (GP).m','min_spec_rad_ppl_dynamics.m',\
'Ch04_cvx_opt_probs','Section 4.6.3- Find the fastest mixing Markov chain on a graph.m','fastest_mixing_MC.m',\
'Ch04_cvx_opt_probs','Exercise 4.27- Matrix fractional minimization using second-order cone programming.m','ex_4_27.m',\
'Ch04_cvx_opt_probs','Exercise 4.31- Design of a cantilever beam (GP).m','cantilever_beam.m',\
'Ch04_cvx_opt_probs','Exercise 4.38(b)- Linear matrix inequalities with one variable.m','ex_4_38.m',\
'Ch04_cvx_opt_probs','Exercise 4.3- Solve a simple QP with inequality constraints.m','ex_4_3.m',\
'Ch04_cvx_opt_probs','Exercise 4.47- Maximum determinant PSD matrix completion.m','max_det_psd_completion.m',\
'Ch04_cvx_opt_probs','Exercise 4.57- Capacity of a communication channel.m','channel_capacity.m',\
'Ch04_cvx_opt_probs','Exercise 4.5- Show the equivalence of 3 convex problem formations.m','ex_4_5.m',\
'Ch04_cvx_opt_probs','Exercise 4.60- Log-optimal investment strategy.m','logopt_investment.m',\
'Ch04_cvx_opt_probs','Utility- Plots a cantilever beam as a 3D figure.m','cantilever_beam_plot.m'}; do
  wget -O $filename http://cvxr.com/cvx/examples/cvxbook/$urldirectory/$urlfile
  # echo $filename http://cvxr.com/cvx/examples/cvxbook/$urldirectory/$urlfile
done
