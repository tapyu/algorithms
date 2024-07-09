#!/usr/bin/zsh

for urldirectory filename urlfile in {\
'Ch05_duality','Section 5.2.4: Solves a simple QCQP.m','qcqp.m',\
'Ch05_duality','Section 5.2.5: Mixed strategies for matrix games.m','matrix_games.m',\
'Ch05_duality','Section 5.2.5: Mixed strategies for matrix games (LP formulation).m','matrix_games_LP.m',\
'Ch05_duality','Examples 5.6,5.8: An l_p norm approximation problem.m','norm_approx.m',\
'Ch05_duality','Exercise 5.19c: Markovitz portfolio optimization with diversification constraint.m','ex_5_19.m',\
'Ch05_duality','Exercise 5.1d: Sensitivity analysis for a simple QCQP.m','ex_5_1.m',\
'Ch05_duality','Exercise 5.33: Parametrized l1-norm approximation.m','ex_5_33.m',\
'Ch05_duality','Exercise 5.39: SDP relaxations of the two-way partitioning problem.m','ex_5_39.m'}; do
  wget -O $filename http://cvxr.com/cvx/examples/cvxbook/$urldirectory/$urlfile
  # echo $filename http://cvxr.com/cvx/examples/cvxbook/$urldirectory/$urlfile
done
