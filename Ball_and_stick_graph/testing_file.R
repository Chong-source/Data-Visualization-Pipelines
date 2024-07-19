#Testing functions and pipe lines
add_two_vectors <- function(x, y){
  x+y
}
a = c(1, 2, 3)
b = c(1, 2, 3)

multiply_two_vectors <- function(x, y){
  x * y
}

minus_vector_by_1 <- function(x){
  x - 1
}

#Note: Basically the pipe line will 
c <- add_two_vectors(a, b) %>%
  multiply_two_vectors(y=c(2)) %>%
  minus_vector_by_1

