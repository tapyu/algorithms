# homework 01 - 1a

# runtime generation ---------------------------------------------------------
max_=100
for (n in xdata <- c(2, 4, 8, 16, 32)){
# matrices
A = matrix(complex(length.out=n^2, real=x<-runif(n^2,max=max_), imaginary=x), nrow=n, ncol=n)
B = matrix(complex(length.out=n^2, real=x<-runif(n^2,max=max_), imaginary=x), nrow=n, ncol=n)

# method 1
start_time = Sys.time()
solve(kronecker(A,B))
end_time = Sys.time()
delta_t_met1 = tryCatch(append(delta_t_met1, end_time - start_time), error=function(c) end_time - start_time)

# method 2
start_time = Sys.time()
kronecker(solve(A), solve(B))
end_time = Sys.time()
delta_t_met2 = tryCatch(append(delta_t_met2, end_time - start_time), error=function(c) end_time - start_time)
}



# plotting ----------------------------------------------------------------

# type	description
# p	    pointsn
# l	    lines
# o	    overplotted points and lines
# b, c	points (empty if "c") joined by lines
# s, S	stair steps
# h	    histogram-like vertical lines
# n	    does not produce any points or lines
library(latex2exp)
library(extrafont)
font_install("fontscm")
loadfonts()
# plot(xdata, delta_t_met1, xlab="N", ylab="Time (seconds)", col="blue", pch="x", type="o", lty="dashed", lwd = 2, main="Runtime for the Kronecker Product computation")
# lines(xdata, delta_t_met2, col="red", pch="o", type="o", lty="dashed", lwd = 2)
# legend(0 , 110, legend=c(TeX("$(A\\oplus B)^{-1}$"), TeX("$A^{-1}\\oplus B^{-1}")), col=c("blue","red"), pch=c("x","o"), lty=c("dashed", "dashed"))

pdf(file="./Pictures/R/test.pdf", height=5, width=7)
plot(xdata, delta_t_met1, log="y", xlab="N", ylab="Time (seconds)", family="CM Roman", col="blue", pch="x", type="o", lty="dashed", lwd = 2, main="Runtime for the Kronecker Product computation")
# lines(xdata, delta_t_met2, col="red", pch="o", type="o", lty="dashed", lwd = 2)
legend(0 , 110, legend=c(TeX("$(A\\oplus B)^{-1}$"), TeX("$A^{-1}\\oplus B^{-1}")), col=c("blue","red"), pch=c("x","o"), lty=c("dashed", "dashed"))

