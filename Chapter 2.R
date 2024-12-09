# 2.2 The very basics----

a <- 1
b <- 1
c <- 1

a # see the stored values
print(a)

ls() # list objects in the workspace

(-b + sqrt(b^2 - 4*a*c) ) / ( 2*a )

log(a)

help("log") # 2 ways of learning about a function
?log

args(log) # learn about a function arguments

log(base = 2, x = 8) # if we specify the arguments, their order does not matter
log(8,2)

# 2.4 Data Types----

a <- 2
class(a) # determine the object type

library(dslabs)
data(murders)

class(murders)

str(murders) # find out more about the object structure

head(murders) # will show the first six lines of the object


