# homework 01 - 1b)
# runtime generation ---------------------------------------------------------
max_=100
n = 2
rm()
A = matrix(complex(length.out=n^2, real=x<-runif(n^2,max=max_), imaginary=x), nrow=n, ncol=n)
# k=2
# method 1
start_time = Sys.time()
result = solve(kronecker(A,A))
end_time = Sys.time()
delta_t_met1 = end_time - start_time
# method 2
start_time = Sys.time()
result = kronecker(solve(A), solve(A))
end_time = Sys.time()
delta_t_met2 = end_time - start_time

for (k in xdata <- c(4, 6, 8, 10)){
  # method 1
  start_time = Sys.time()
  result = kronecker(A,A)
  for (i in 1:k-2){
    result = kronecker(result, A)
  }
  solve(result)
  end_time = Sys.time()
  delta_t_met1 = append(delta_t_met1, end_time - start_time)
  
  # method 2
  start_time = Sys.time()
  result = kronecker(solve(A), solve(A))
  for (i in 1:k-2){
    result = kronecker(result, solve(A))
  }
  end_time = Sys.time()
  delta_t_met2 = append(delta_t_met2, end_time - start_time)
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
library("latex2exp")
plot(c(2, xdata), delta_t_met1, xlab="N", ylab="Time (seconds)", col="blue", pch="x", type="o", lty="dashed", lwd = 2, main="Runtime for the Kronecker Product computation")
lines(c(2, xdata), delta_t_met2, col="red", pch="o", type="o", lty="dashed", lwd = 2)
legend(2 , 132, legend=c(TeX("$(\\oplus_{i=1}^{k} A_{2x2}^{(i)})^{-1}$"), TeX("\\oplus_{i=1}^{k} (A_{2x2}^{(i)})^{-1}")), col=c("blue","red"), pch=c("x","o"), lty=c("dashed", "dashed"))

plot(c(2, xdata), delta_t_met1, log="y", xlab="N", ylab="Time (seconds)", col="blue", pch="x", type="o", lty="dashed", lwd = 2, main="Runtime for the Kronecker Product computation", ylim=c(min(delta_t_met2),max(delta_t_met1)))
lines(c(2, xdata), delta_t_met2, col="red", pch="o", type="o", lty="dashed", lwd = 2)
legend(2 , 150, legend=c(TeX("$(\\oplus_{i=1}^{k} A_{2x2}^{(i)})^{-1}$"), TeX("\\oplus_{i=1}^{k} (A_{2x2}^{(i)})^{-1}")), col=c("blue","red"), pch=c("x","o"), lty=c("dashed", "dashed"))
