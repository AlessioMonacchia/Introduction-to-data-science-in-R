# CHAPTER 8 - VISUALIZING DATA DISTRIBUTIONS----
# 8.9 The Standard Units----
z <- scale(x) # obtain the corresponding standard units
mean(abs(z) < 2) # how many values are within 2 sd from the average

# 8.10 Quantile-Quantile Plots----
pnorm(-1.96) # calculates the proportion of values lower than x in the normal distribution. Result is 0.025
qnorm(0.975) # calculates the variable value for which 97.5% of the values are smaller
qnorm(0.975, mean = 5, sd = 2) # theorethical quantiles for a normal distribution with mean 5 and sd 2. The value of x corresponding to the top 97.5% in a distribution with that mean and sd

p <- seq(0.05, 0.95, 0.05) # vector of proportions

sample_quantiles <- quantile(x, p)
theoretical_quantiles <- qnorm(p, mean = mean(x), sd = sd(x))
qplot(theoretical_ quantiles, sample_quantiles) + geom_abline()

sample_quantiles <- quantile(z, p)
theoretical_quantiles <- qnorm(p)
qplot(theoretical_quantiles, sample_quantiles) + geom_abline()

library(ggplot2)
heights %>% filter(sex == "Male") %>%
  ggplot(aes(sample = scale(height))) +
  geom_qq() + # ggplot version of quantile-quantile plot
  geom_abline()

# 8.16 ggplot2 Geometries----
library(dslabs)
library(tidyverse)
data(murders)

murders %>% ggplot(aes(region)) +
  geom_bar() # creates a barplot

tab <- murders %>%
  count(region) %>%
  mutate(proportion = n/sum(n))
tab

tab %>% ggplot(aes(region, proportion)) + 
  geom_bar(stat = "identity") # here we want the barplot but showing the proportions instead, we need to provide the x and y variable in aes and use the identity option.

data(heights)

heights %>%
  filter(sex == "Female") %>%
  ggplot(aes(height)) +
  geom_histogram(binwidth = 1) # creating a histogram

heights %>%
  filter(sex == "Female") %>%
  ggplot(aes(height)) +
  geom_histogram(binwidth = 1, fill = "blue", col = "black") +
  xlab("Male heights in inches") +
  ggtitle("Histograms")

heights %>%
  filter(sex == "Female") %>%
  ggplot(aes(height)) +
  geom_density() # creating a density plot

heights %>%
  filter(sex == "Female") 
  ggplot(aes(height)) +
  geom_density(fill="blue")

heights %>%
  filter(sex == "Female") %>%
  ggplot(aes(height)) +
  geom_density(fill="blue", adjust = 2) # modifies smoothness, here we set the bandwith to be twice as big

heights %>%
  ggplot(aes(sex, height)) +
  geom_boxplot() # here we create a boxplot

heights %>% filter(sex == "Male") %>%
  ggplot(aes(sample = height)) +
  geom_qq() # here we make a qqplot

params <- heights %>% filter(sex=="Male") %>%
  summarize(mean = mean(height), sd = sd(height)) # calculate mean and sd for male heights

heights %>% filter(sex == "Male") %>% # here we use dparams argument to change the normal distribution to which the data is compared. We compare it to a normal distribution with same
  # mean and average as the sample data
  ggplot(aes(sample = height)) +
  geom_qq(dparams = params) +
  geom_abline()

heights %>%
  filter(sex == "Male") %>%
  ggplot(aes(sample = scale(height))) + # here we scale the data first, is the alternative to changing the normal distribution parameters
  geom_qq() +
  geom_abline()

x <- expand.grid(x = 1:12, y = 1:10) %>%
  mutate(z = 1:120) # we create a dataframe with x and y and then we associate a value to each combination of x and y values

x %>% ggplot(aes(x, y, fill = z)) +
  geom_raster() + # here we create a raster image
  scale_fill_gradientn(colors = terrain.colors(10)) # here we change the color scale

x <- heights %>%
  filter(sex == "Male") %>%
  pull(height)

qplot(x) # creates a quick histogram

qplot(sample = scale(x)) + geom_abline() # makes a qqplot with line. Requires the sample argument.

heights %>% qplot(sex, height, data = .) #

heights %>% qplot(sex, height, data = ., geom = "boxplot") # we can specify a geometry

qplot(x, geom = "density") # we can also generate a density plot by specifying it into the geom argument

qplot(x, bins = 15, color = I("black"), xlab = "Population") # improving the plot look. "I" is used to tell qplot to not convert its content into a factor as it would normally try to do.

