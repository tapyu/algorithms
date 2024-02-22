## Optimization theory

This directory contains:
- The homework from my PhD. course "Otimização não-linear de sistemas", taught by Yuri Carvalho Barbosa Silva and Tarcisio Ferreira Maciel at UFC.
- All the computation homework descriptions are in the Jupyter Notebooks files (`OtimizacaoRelaxacaoQuadratica.ipynb` and `lamps.ipynb`).
- The computational homework is basically to solve optimization problems by using optimization packages.
- The slides is the same as the Stephen Boyd slides, which can be found in Google Drive in the path `Mathematics - Optmization theory/Stephen Boyd - slides`
- `additional-exercises/` is a git submodule for the a [repository][20] from Stanford University containing a huge set of exercises. Some of them have computational part, and the repo contain the code solution (in `matlab`, `R`, `julia`, and `python`).

## Important links

1. [Optimization cheatsheet][17]

1. Solvers (used by the CVX packages)
    1. [GLPK (GNU Linear Programming Kit)][1]
    1. [ADMM - Alternating Direction Method of Multipliers][2]
    1. [MOSEK (commercial solver)][3]
    1. [ECOS - Embedded Conic Solver][4]
    1. [SCS - Splitting Conic Solver][5]
    1. [Gurobi (commercial solver)][6]
    1. [Mosek ApS (proprietary)][7]

1. CVX-derived packages (a CVX package uses many solvers)
    1. [CVX (Matlab, the main)][8]
        1. [CVX Users’ Guide][12]
    1. [CVXR (R)][9]
    1. [CVXPY (Python)][10]
    1. [Convex.jl (Julia)][11]
  
1. [`ncvx`][18]: A `python` package for modeling and solving problems with convex objectives and decision variables from a nonconvex set (from the Stanford University Convex Optimization Group, cvxgrp).

1. [Optimization Problem Types][16]

1. [What is DCP(disciplined convex programming)][13]

1. [Auxiliary variables and extended formulation][14]

1. [DCP Analyzer][15]

1. A short [`cvxpy` course][19] from the Stanford University Convex Optimization Group (cvxgrp). It contains a lot of computational exercises

[1]: https://www.gnu.org/software/glpk/
[2]: https://stanford.edu/~boyd/admm.html
[3]: https://en.wikipedia.org/wiki/MOSEK
[4]: https://github.com/embotech/ecos
[5]: https://www.cvxgrp.org/scs/
[6]: https://www.gurobi.com/
[7]: https://www.mosek.com/
[8]: http://cvxr.com/
[9]: https://cran.r-project.org/web/packages/CVXR/vignettes/cvxr_intro.html#:~:text=CVXR%20is%20an%20R%20package,form%20required%20by%20most%20solvers.
[10]: https://www.cvxpy.org/
[11]: https://jump.dev/Convex.jl/stable/
[12]: http://cvxr.com/cvx/doc/index.html
[13]: http://cvxr.com/cvx/doc/intro.html#what-is-disciplined-convex-programming
[14]: https://jump.dev/Convex.jl/stable/#Extended-formulations-and-the-DCP-ruleset
[15]: https://dcp.stanford.edu/analyzer
[16]: https://neos-guide.org/guide/types/
[17]: https://tapyu.github.io/notes/posts/opt_cheatsheet/index.html
[18]: https://github.com/cvxgrp/ncvx
[19]: https://github.com/cvxgrp/cvx_short_course/
[20]: https://github.com/cvxgrp/cvxbook_additional_exercises/
