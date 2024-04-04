require( tikzDevice )
require(Matrix)
require(corpcor)

tikz(paste(getwd(), '/latex/myPlot.tex', sep=""))

i_set <- c(2,4)
r_set <- 2^(1:floor(log(256,2)))

delta_time_X = matrix(0, nrow = length(r_set), ncol = length(i_set))
delta_time_AB = matrix(0, nrow = length(r_set), ncol = length(i_set))

for (i in i_set){
  for (r in r_set){
    # matrices
    A = matrix(complex(length.out=i*r, real=x<-runif(i*r,max=max_), imaginary=x), nrow=i, ncol=r)
    B = matrix(complex(length.out=i*r, real=x<-runif(i*r,max=max_), imaginary=x), nrow=i, ncol=r)
    
    X = KhatriRao(A,B)
    
    start_time = Sys.time()
    pseudoinverse(X)
    end_time = Sys.time()
    delta_time_X[match(r, r_set), match(i, i_set)] = end_time - start_time
    print(i)
    print(r)
    
    start_time = Sys.time()
    pseudoinverse(KhatriRao(A,B))
    end_time = Sys.time()
    delta_time_AB[match(r, r_set), match(i, i_set)] = end_time - start_time
    
  }
}

plot( 1, 1, main = '$\\int e^{xy}$' )

dev.off()