## Optimization theory

This directory contains:
- [`./tip8300_nonlinear_opt_sist/`](./tip8300_nonlinear_opt_sist): Computational homeworks from my PhD. course "TIP8300 - Otimização não-linear de sistemas", taught by Yuri Carvalho Barbosa Silva and Tarcisio Ferreira Maciel at UFC.
- [`./additional-exercises/`](./ee364a_additional_exercises) is a git submodule for the a [repository][20] from Stanford University containing a huge set of exercises. Some of them have computational part, and the repo contain the code solution (in `matlab`, `R`, `julia`, and `python`).
- [Optimization theory cheat sheet](./opt_cheatsheet) - A cheat sheet of the main concepts about optmization theory. This optimization was initially created during the course taught by Yuri Carvalho Barbosa Silva and Tarcísio Ferreira Maciel. However, the cheat sheet is mainly linked to the core conceps in the main theoretical references.

## Theoretical references
- Main:
    - [EE364A - Convex Optimization I][30] and [EE364B - Convex Optimization II][25] courses taught by Stephen Boyd, Stanford University.
        - **Course**: [Stanford Engineering Everywhere - EE364A - Convex Optimization I][22].
        - **Book**: [Boyd, S. and Vandenberghe, L., 2004. Convex optimization. Cambridge university press][23]
        - [EE364A Lecture slides (updated summer 2023)][27]: Newest version of the slides.
        - [EE364A Original lecture slides][28]: First version of the slides.
        - [EE364A Additional lecture slides][29]. You can also find a few slides from EE364B, which is used as additional content in EE364A.
        - [CVX* tutorial slides][29]
        - [Additional exercises][21]: Data files in Python, Julia, and Matlab for Stanford EE364A, Convex Optimization, that do not appear in the book Convex Optimization (see [`./additional-exercises/`](./additional-exercises)).
        - [EE364A Lecture slides][31].
- Others:
    - [Dattorro, J., 2010. Convex optimization & Euclidean distance geometry.][24]


## Technical references

1. CVX-derived packages (a CVX package uses many solvers)
    1. [CVX (Matlab, the main)][8]
        1. [CVX Users’ Guide][12]
    2. [CVXR (R)][9]
    3. [CVXPY (Python)][10]
    4. [Convex.jl (Julia)][11]
2. Solvers (used by the CVX packages)
    1. [GLPK (GNU Linear Programming Kit)][1]
    2. [ADMM - Alternating Direction Method of Multipliers][2]
    3. [MOSEK (commercial solver)][3]
    4. [ECOS - Embedded Conic Solver][4]
    5. [SCS - Splitting Conic Solver][5]
    6. [Gurobi (commercial solver)][6]
    7. [Mosek ApS (proprietary)][7]

## Extra references

3. [`ncvx`][18]: A `python` package for modeling and solving problems with convex objectives and decision variables from a nonconvex set (from the Stanford University Convex Optimization Group, cvxgrp).
4. [Optimization Problem Types][16]
5. [JuMP.jl][21]: Modeling language for Mathematical Optimization (linear, mixed-integer, conic, semidefinite, nonlinear). 
6. [What is DCP(disciplined convex programming)][13]
7. [Auxiliary variables and extended formulation][14]
8. [DCP Analyzer][15]
9. A short [`cvxpy` course][19] from the Stanford University Convex Optimization Group (cvxgrp). It contains a lot of computational exercises

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
[18]: https://github.com/cvxgrp/ncvx
[19]: https://github.com/cvxgrp/cvx_short_course/
[20]: https://github.com/cvxgrp/cvxbook_additional_exercises/
[21]: https://github.com/jump-dev/JuMP.jl
[22]: https://see.stanford.edu/Course/EE364A
[23]: https://web.stanford.edu/~boyd/cvxbook/bv_cvxbook.pdf
[24]: https://www.convexoptimization.com/TOOLS/0976401304_v2011.04.25.pdf
[25]: https://web.stanford.edu/class/ee364b
[26]: https://web.stanford.edu/~boyd/cvxbook/
[27]: https://web.stanford.edu/~boyd/cvxbook/bv_cvxslides.pdf
[28]: https://web.stanford.edu/~boyd/cvxbook/bv_cvxslides_original.pdf
[29]: https://web.stanford.edu/class/ee364a/lectures.html
[30]: https://web.stanford.edu/class/ee364a
[31]: https://web.stanford.edu/class/ee364b/lectures.html
