#### PROGRAMMING BASICS ####
# 3.1 Conditional Expressions ----

a <- 0

if(a!=0){
  print(1/a)
} else {
  print("No reciprocal for 0.")
}

library(dslabs)
data(murders)

murder_rate <- murders$total / murders$population * 100000
ind <- which.min(murder_rate)

if(murder_rate[ind] < 0.25) {
  print(murders$state[ind])
} else {
  print("No state has a murder rate that low")
}

a <- 0
ifelse(a > 0, 1/a, NA) # first argument is the condition, second is the return when condition is T, third the opposite. Ifelse works on vectors

a <- c(0, 1, 2, -4, 5)
result <- ifelse(a > 0, 1/a, NA) # here ifelse will check for every single value inside the vector a. It will return a vector
result

data(na_example)
no_nas <- ifelse(is.na(na_example), 0, na_example) # ifelse used to replace NAs with 0
sum(is.na(no_nas)) # check the number of NA values, it will return 0

z <- c(T, T, F)
any(z) # check if there is at least one T value in the vector of logicals
all(z) # check if there are only T values in the vector of logicals

# 3.2 Defining Functions ----
avg <- function(x) {
  s <- sum(x)
  n <- length(x)
  s/n
}

x <- 1:100
identical(mean(x), avg(x)) # checks identity between two elements, in this case between the return values of two functions

my_function <- function(VARIABLE_NAME) { # scheme of a function
  perform operations on VARIABLE_NAME and calculate VALUE
  VALUE
}

avg <- function(x, arithmetic = T) { # function that computes arithmetic or geometric average depending on user input
  n <- lenght(x)
  ifelse(arithmetic, sum(x)/n, prod(x)^(1/n))
}

# 3.4 For Loops ----
for (i in 1:5) {
  print(i)
}

compute_s_n <- function(n) {
  x <- 1:n
  sum(x)
}

m <- 25
s_n <- vector(length = m) # create an empty vector
for (n in 1:m) {
  s_n[n] <- compute_s_n(n)
}

n <- 1:m
plot(n, s_n)


# 3.5 Vectorization and Functionals ----
x <- 1:10
sqrt(x) # vectorization, preferred to for loops
y <- 1:10
x*y

x <- 1:10
sapply(x, sqrt) # functionals, apply a function over a list or vector

n <- 1:25
s_n <- sapply(n, compute_s_n)

# Other functionals: apply, lapply, tapply, mapply, vapply, replicate.