# CHAPTER 11- ROBUST SUMMARIES----
# 11.1 Outliers----
library(tidyverse)
library(dslabs)
data("outlier_example")
str(outlier_example)

mean(outlier_example)
sd(outlier_example) # note a standard deviation (range of which contains 95% of values) bigger than the mean

boxplot(outlier_example) # note one observation completely out of scale

median(outlier_example) # median is more resistant to outliers

IQR(outlier_example) # also the IQR is resistant to outliers

q3 <- qnorm(0.75) # calculates the 75th percentile
q1 <- qnorm(0.25)
iqr <- q3-q1
r <- c(q1 - 1.5*iqr, q3 +1.5*iqr) # this is the formula used by default to calculate whiskers in R boxplots

max_height <- quantile(outlier_example, 0.75) + 3*IQR(outlier_example)
max_height

x <- outlier_example[outlier_example < max_height]
qqnorm(x) # quantile quantile plot excluding the outlier height shows the data is normally distributed
qqline(x)


mad(outlier_example) # calculates the MAD (Median Absolute Deviation), a more robust way of computing the standard deviation in the presence of outliers


# 11.7 Case Study----
library(dslabs)
data("reported_heights")

reported_heights <- reported_heights %>%
  mutate(original_heights = height, height = as.numeric(height)) # we get NAs

reported_heights %>% filter(is.na(height)) %>% head() # we check the reasons of the NAs

reported_heights <- filter(reported_heights, !is.na(height)) # we remove the NAs entries

reported_heights %>%
  group_by(sex) %>%
  summarize(average = mean(height), sd = sd(height),
            median= median(height), MAD = mad(height)) # we notice that mean and median, and sd and MAD, differ. This suggests outliers

boxplot(height ~ sex, data = reported_heights, main = "Boxplot of Heights by Sex") # we visualize the outliers

reported_heights %>% arrange(desc(height)) %>% top_n(10, height) # to print out the 10 highest values in descending order

whisker <- 3*IQR(reported_heights$height)
max_height <- quantile(reported_heights$height, .75) + whisker
min_height <- quantile(reported_heights$height, .25) - whisker
reported_heights %>%
  filter(!between(height, min_height, max_height)) %>%
  select(original_heights) %>%
  head(n=10) %>% pull(original_heights) # review the nonsensical data considered far out for Tukey standards

