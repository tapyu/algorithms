#!/usr/bin/zsh

for urldirectory filename urlfile in {\
'Ch07_statistical_estim','Section 7.1.1: Counting problems with Poisson distribution.m','counting_problem_poisson.m',\
'Ch07_statistical_estim','Section 7.1.1: Covariance estimation for Gaussian variables.m','ML_covariance_est.m',\
'Ch07_statistical_estim','Section 7.4.3: Probability bounds example with Voronoi diagram.m','probbounds.m',\
'Ch07_statistical_estim','Section 7.5.2: Experiment design.m','expdesign.m',\
'Ch07_statistical_estim','Figure 7.1: Logistic regression.m','logistics.m',\
'Ch07_statistical_estim','Figure 7.1: Logistic regression (GP version).m','logistics_gp.m',\
'Ch07_statistical_estim','Example 7.2: Maximum entropy distribution.m','maxent.m',\
'Ch07_statistical_estim','Example 7.4: Binary hypothesis testing.m','detector2.m'}; do
  wget -O $filename http://cvxr.com/cvx/examples/cvxbook/$urldirectory/$urlfile
  # echo $filename http://cvxr.com/cvx/examples/cvxbook/$urldirectory/$urlfile
done
