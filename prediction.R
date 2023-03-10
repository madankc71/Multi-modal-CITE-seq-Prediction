
#Load necessary packages and set options for displaying code.

library(Matrix)
test_rna <- as.matrix(read.csv("Data/machine-learning-challenge-2-prediction/test_set_rna.csv", row.names = 1))
train_rna <- as.matrix(read.csv("Data/machine-learning-challenge-2-prediction/training_set_rna.csv", row.names = 1))
train_adt <- as.matrix(read.csv("Data/machine-learning-challenge-2-prediction/training_set_adt.csv", row.names = 1))



#Transpose the training RNA and ADT matrices and store as A and y.

A <- t(train_rna)
y <- t(train_adt)

#Define a normalization function to scale data to a range of 0 to 1.

normalize_func <- function(data) {
  min_val <- min(data)
  max_val <- max(data)
  
  range_val <- max_val - min_val
  
  normalized_data <- (data - min_val) / range_val
  
  return (normalized_data)
}

Apply the normalization function to the input data.
test_rna <- normalize_func(test_rna)
train_rna <- normalize_func(train_rna)
train_adt <- normalize_func(train_adt)



#Calculate the cross-product of the training RNA data matrix and store in matrix A, and the cross-product of the training RNA data matrix and training ADT data matrix and store in matrix B.
a <- crossprod(A)
B <- crossprod(A, y)
```


#Define a function called "parallel_multivariate" to perform parallel multivariate regression on the data using Gauss-Seidel method, which takes in matrices A and B as input, along with the maximum number of iterations and a tolerance cutoff value for convergence. The function returns the ADT matrix X.
parallel_multivariate <- function(a, B, max_iter = 9300, tol_cutoff = 1e-9){
  x <- matrix(0, nrow(a), ncol(B))
  
  for(i in 1:ncol(B) ) {
    b <- B[,i]
    
    x_col <- rep(0, length(b))
    
    for(iter in 1:max_iter) {
      
      tol <- 0
      
      for(j in 1:length(b)) {
        bj <- b[j]
        ajj <- a[j, j]
        z <- bj / ajj
        x_col[j] <- x_col[j] + z
        b <- b - z * a[, j]
        tol <- tol + abs(z / x_col[j])
      }
      if(iter %% 100 == 0) cat(" iter: ", iter, ", tol: ", tol, "\n") 
      if(tol < tol_cutoff) break
    }
    x[,i] <- x_col 
    
  }
  return(x)
}


#Apply the "parallel_multivariate" function to A and B, and store the resulting ADT matrix X in x.
x <- parallel_multivariate(a,B)

#Predict the ADT values for the test RNA data by multiplying the transposed test RNA data matrix with the X matrix, and store the resulting ADT predictions in output
test_adt <- t(test_rna) %*% x
output <- t(test_adt)


#Write the output in tall format with two columns ID and Expected
sample_submission <- reshape2::melt(output)

sample_submission <- data.frame(
  "ID" = paste0("ID_", 1:nrow(sample_submission)), 
  "Expected" = sample_submission$value)
head(sample_submission)


#Saving the output(test_adt) as csv file.
write.csv(sample_submission, "my_submission-gd9300.csv", row.names = FALSE)
