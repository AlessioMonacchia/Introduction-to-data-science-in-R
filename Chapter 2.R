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

names(murders) # access variable names

class(murders$region) # factors are useful for storing categorical data

levels(murders$region) # returns the levels of the factor variable

region <- murders$region
value <- murders$total
region <- reorder(region, value, FUN = sum) # reorder the region levels according to their sum of murders
levels(region)

str(murders)
a <- murders$abb
b <- murders["abb"]
a == b

mat <- matrix(1:12, 4, 3)
mat
mat[2,3]
mat[2,]
mat[,3]
mat[,2:3]
as.data.frame(mat)

murders[25,1] # access row 25 column 1 position

# 2.6 Vectors ----
codes <- c(380, 124, 818)
codes
country <- c("italy", "canada", "egypt")
codes <- c(italy = 380, canada = 124, egypt = 818) # Using quotes for the vector names would yield the same result
codes
class(codes) # it is still a numeric vector, but now it also contains names
names(codes)

codes <- c(380, 124, 818)
country <- c("italy", "canada", "egypt")
names(codes) <- country # another way to assign names
codes

seq(1, 10) # creates a vector
seq(1, 10, 2) # third argument is by
class(1:10) # integer
class(seq(1, 10, 2)) # numeric

codes[2]
codes[c(1,3)]
codes["canada"]
codes[c("italy","egypt")]

# 2.9 Sorting----
sort(murders$total) # sorts vector in ascending order

x <- c(31, 4, 15, 92, 65)
sort(x) # 4, 15, 31, 65, 92
order(x) # 2, 3, 1, 5, 4; returns the ordered indexes of the vectors elements

index <- order(x)
x[index] # 4, 15, 31, 65, 92; same output as sort()

murders$state[1:6]
murders$abb[1:6]

ind <- order(murders$total)
murders$abb[ind] # returns the abbreviations ordered according to the number of murders

max(murders$total) # finds the largest value

i_max <- which.max(murders$total) # gets the index of the largest value
murders$state[i_max] # returns the state that corresponds to the highest murder index

min(murders$total)
i_min <- which.min(murders$total)
murders$state[i_min]

rank(x) # returns a rank of the input vector

comparison_table <- tibble(original = x, sort = sort(x), order = order(x), rank = rank(x))

# 2.11 Vector Arithmetics ----
inches <- c(69, 62, 66, 70, 70, 73, 67, 73, 67, 70)
inches*2.54
inches-69

murders_rate <- murders$total / murders$population * 100000

murders$abb[order(murders_rate)] # return abbreviations ordered according to the murder rate

# 2.13 Indexing ----
ind <- murders_rate < 0.71
ind <- murders_rate <= 0.71

murders$state[ind] # here we are indexing using a logical vector

sum(ind) # sums the number of Ts

west <- murders$region == "West" # returns a logical vector
# west <- murders$region["West"] returns the levels
safe <- murders_rate <= 1

ind <- west & safe # returns logical vector indicating where both west and safe are true
murders$state[ind]

ind <- which(murders$state == "California") # return vector of indices satisfying the boolean
murders_rate[ind]

ind <- match(c("New York", "Florida", "Texas"), murders$state) # same as above both for finding several values
murders_rate[ind]

c("Boston", "Dakota", "Washington") %in% murders$state # returns logical vector, are those values present in murders$state?

which(murders$state%in%c("New York", "Florida", "Texas")) # which(%in%) returns same as match()

# 2.15 Basic Plots----
x <- murders$population / 10^6
y <- murders$total
plot(x, y)

with(murders, plot(population, total)) # adds column names as axis names

x <- with(murders, total/population*100000)
hist(x)

murders$rate <- with(murders, total/population*100000)
boxplot(rate~region, data=murders) # rate goes to the y, region goes to the x

x <- matrix(1:120, 12, 10)
image(x) # displays the values using colors
