#!/usr/bin/zsh

for filename in {figure_11_4.m,figure_11_6.m,figure_11_7.m,figure_11_15.m,figure_11_17.m,figure_11_19.m,figure_11_21.m,figure_11_22.m}; do
  wget https://stanford.edu/~boyd/cvxbook/cvxbook_examples/chap11/$filename
done
