library(rTensor)

r <- 2
i <- 2
max_ <- 100

A = matrix(complex(length.out=i*r, real=x<-runif(i*r,max=max_), imaginary=x), nrow=i, ncol=r)
B = matrix(complex(length.out=i*r, real=x<-runif(i*r,max=max_), imaginary=x), nrow=i, ncol=r)
X = khatri_rao(A,B)

# dim(X)
