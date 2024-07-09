#!/usr/bin/zsh

for urldirectory filename urlfile in {\
'Ch06_approx_fitting','Section 6.1.2: Residual minimization with deadzone penalty.m','deadzone.m',\
'Ch06_approx_fitting','Figure 6.15: A comparison of stochastic and worst-case robust approximation.m','fig6_15.m',\
'Ch06_approx_fitting','Figure 6.19: Polynomial fitting.m','fig6_19.m',\
'Ch06_approx_fitting','Figure 6.24: Fitting a convex function to given data.m','convex_interpolation.m',\
'Ch06_approx_fitting','Figure 6.2: Penalty function approximation.m','penalty_comp_cvx.m',\
'Ch06_approx_fitting','Figure 6.9: An optimal tradeoff curve.m','fig6_9.m',\
'Ch06_approx_fitting','Figures 6.11-6.14: Total variation reconstruction.m','tv_cvx.m',\
'Ch06_approx_fitting','Figures 6.21-6.23: Basis pursuit using Gabor functions.m','basispursuit.m',\
'Ch06_approx_fitting','Figures 6.8-6.10: Quadratic smoothing.m','smoothrec_cvx.m'}; do
  wget -O $filename http://cvxr.com/cvx/examples/cvxbook/$urldirectory/$urlfile
  # echo $filename http://cvxr.com/cvx/examples/cvxbook/$urldirectory/$urlfile
done
