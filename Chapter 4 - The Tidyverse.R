# CHAPTER 4 - THE TIDYVERSE ----
# 4.1 Tidy Data ----
library(tidyverse)
# tidy data: each row represents on observation and each column the different variables for each observation
murders # is an example of tidy data

co2 # is an example of non tidy data
CO2 # instead is!

# 4.3 Manipulating Data Frames (dplyr) ----
murders <- mutate(murders, rate = total / population *100000) # adds a column, the second argument defines new column name and content

filter(murders, rate <= 0.71) # returns the rows of the dataframe that satisfy the second argument

new_table <- select(murders, state, region, rate) # subsets variables of a dataframe
filter(new_table, rate <= 0.71)

# 4.5 The Pipe %>% ----
murders %>% select(state, region, rate) %>% filter(rate <= 0.71)

mutate(murders, rate = total / population * 100000,
       rank = rank(-rate)) %>%
  select(state, rate, rank)

# 4.7 Summarizing Data ----
library(dslabs)
data(heights)

s <- heights %>%
  filter(sex == "Female") %>%
  summarize(average = mean(height), standard_deviation = sd(height)) # we create an object containing the mean and sd

heights %>%
  filter(sex == "Female") %>%
  summarize(median = median(height), minimum = min(height),
            maximum = max(height))

heights %>% # does not work, with summarize we can only call functions that returns a single value
  filter(sex == "Female") %>%
  summarize(range = quantile(height, c(0, 0.5, 1)))

murders <- murders %>% mutate(rate = total / population *100000)

summarize(murders, mean(rate))

us_murder_rate <- murders %>%
  summarize(rate = sum(total) / sum(population) * 100000)
us_murder_rate

us_murder_rate %>% pull(rate) # pull allows to access stored data when using pipes

us_murder_rate <- murders %>%
  summarize(rate = sum(total) / sum(population) * 100000) %>%
  pull(rate)

heights %>% group_by(sex) # groups data into variable levels. It returns a grouped data frame, recognized by dplyr functions.

heights %>%
  group_by(sex) %>%
  summarize(average = mean(height), standard_deviation = sd(height)) # will return summary for height conditional on sex
  
murders %>%
  group_by(region) %>%
  summarize(median_rate = median(rate))

murders %>%
  arrange(population) %>% # arrange orders the df rows according to one variable values ascending order
  head()

murders %>%
  arrange(desc(rate))

murders %>%
  arrange(region, rate) %>% # adding a second column means rows are arranged according to the first variable, within the first variable values, 
  # these are arranged according to the second variable values (nested sorting)
  head()

murders %>% top_n(5, rate) # top_n will show the first n rows filtered according to one variable values (kind of ordered)


# 4.10 Tibbles ----
murders %>% group_by(region) %>% class() # we notice there is tbl
# tbl stands for tibble, a new version of dataframe, preferred within the Tidyverse environment

class(as_tibble(murders)[,4]) # returns a df, not a vector

class(as_tibble(murders)$population) # $ to get a vector out of a tibble column

tibble(id = c(1, 2, 3), func = c(mean, median, sd)) # tibble can include complex objects like functions

# group_by returns a grouped tibble, whose advantage is that stores information of which rows are in which groups

grades <- tibble(names = c("John", "Juan", "Jean", "Yao"),
                 exam_1 = c(95, 80, 90, 85),
                 exam_2 = c(90, 85, 85, 90))

as_tibble(grades) # to convert dataframe to a tibble


# 4.11 Dot Operator ----
rates <- filter(murders, region == "South") %>%
  mutate(rate = total / population * 10^5) %>%
  .$rate # dot operator, allows to access only the rate column, which gets assigned to the rates object 
median(rates)

# 4.12 Do ----
my_summary <- function(dat) {
  x <- quantile(dat$height, c(0, 0.5, 1))
  tibble(min=x[1], median=x[2], max=x[3])
}

heights %>%
  group_by(sex) %>%
  my_summary # we notice the function returns the quantiles but not for each sex as we want

# To correctly interpret the grouped tibble, we need the do
heights %>%
  group_by(sex) %>%
  do(my_summary(.)) # we need to include the dot operator as symbol for the tibble we are processing

# 4.13 The Purrr Package----
compute_s_n <- function(n){
  x <- 1:n
  sum(x)
}

n <- 1:25

library(purrr)

s_n <- map(n, compute_s_n) # similar to apply functions, but always returns a list
class(s_n)

s_n <- map_dbl(n, compute_s_n) # version of map that returns a numerical vector
class(s_n)

compute_s_n <- function(n){
  x <- 1:n
  tibble(sum = sum(x)) # we need to enforce the creation of a tibble to use the next function
}
s_n <- map_df(n, compute_s_n) # version of map that returns a data frame
class(s_n)

# 4.14 Tidyverse Conditionals ----
x <- c(-2, -1, 0, 1, 2)
case_when(x < 0 ~ "Negative", x > 0 ~ "Positive", TRUE ~ "Zero") # similar to ifelse but can output any number of values, not just
# T or F

murders %>% # we use case_when to define categorical variables based on existing variables.
  mutate(group = case_when(
    abb %in% c("ME", "NH", "VT", "MA", "RI", "CT") ~ "New England",
    abb %in% c("WA", "OR", "CA") ~ "West Coast",
    region == "South" ~ "South",
    TRUE ~ "Other")) %>%
  group_by(group) %>%
  summarize(rate = sum(total) / sum(population) * 10^5)

between(x, a, b) # check if a value falls inside an interval
