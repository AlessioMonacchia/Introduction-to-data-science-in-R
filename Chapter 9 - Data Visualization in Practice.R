# CHAPTER 9 - DATA VISUALIZATION IN PRACTICE----
# 9.1 Case Study----
library(tidyverse)
library(dslabs)
data(gapminder)
gapminder %>% as_tibble()

gapminder %>%
  filter(year == 2015 & country %in% c("Sri Lanka", "Turkey")) %>%
  select(country, infant_mortality)

# 9.2 Scatterplots----
filter(gapminder, year == 1962) %>%
  ggplot(aes(fertility, life_expectancy, color = continent)) +
  geom_point(size = 3)

# 9.3 Faceting----
filter(gapminder, year %in% c(1962, 2012)) %>%
  ggplot(aes(fertility, life_expectancy, color = continent)) +
  geom_point(size=3) +
  facet_grid(continent~year) # facet_grid separates the plots according to the combination of variables placed as arguments. We will have one plot per each combination of year and continent.

filter(gapminder, year %in% c(1962, 2012)) %>%
  ggplot(aes(fertility, life_expectancy, color = continent)) +
  geom_point(size = 3) +
  facet_grid(.~year) # the dot tells facet_grid we are not using the first argument, so it should split the plots just by the second argument (year)

years <- c(1962, 1980, 1990, 2000, 2012)
continents <- c("Europe", "Asia")
gapminder %>%
  filter(year %in% years & continent %in% continents) %>%
  ggplot(aes(fertility, life_expectancy, color=continent)) +
  geom_point(size=3) +
  facet_wrap(~year) # facet_wrap permits permits us to automatically place plots in multiple rows and columns. Facet_grid would have placed all the plots in the same row.

filter(gapminder, year %in% c(1962, 2012)) %>%
  ggplot(aes(fertility, life_expectancy, col=continent)) +
  geom_point(size = 3) +
  facet_wrap(. ~ year, scales = "free") # parameter scales = "free" automatically adjust the axis scale according to plotted data (not great for comparing multiple plots).

# 9.4 Time Series Plots----
gapminder %>%
  filter(country == "United States") %>%
  ggplot(aes(year, fertility)) +
  geom_point()

gapminder %>%
  filter(country == "United States") %>%
  ggplot(aes(year, fertility)) +
  geom_line() # here we create a curve by joining the points with lines by geom_line()


countries <- c("South Korea", "Germany")

gapminder %>%
  filter(country %in% countries & !is.na(fertility)) %>%
  ggplot(aes(year, fertility, color=country)) +
  geom_line()


labels <- data.frame(country = countries, x = c(1975, 1965), y = c(60, 72))

gapminder %>%
  filter(country %in% countries) %>%
  ggplot(aes(year, life_expectancy, col = country)) +
  geom_line() +
  geom_text(data = labels, aes(x, y, label = country), size = 5) + # with this trick we assigns labels to the curves. Labels are preferred to legends in time series.
  theme(legend.position = "none")

# 9.5 Data Transformations----
gapminder <- gapminder %>% mutate(dollars_per_day = gdp/population/365)

past_year <- 1970
gapminder %>%
  filter(year == past_year & !is.na(gdp)) %>%
  ggplot(aes(dollars_per_day)) +
  geom_histogram(binwidth =1, color = "black")

gapminder %>%
  filter(year == past_year & !is.na(gdp)) %>%
  ggplot(aes(log2(dollars_per_day))) + # same distribution but applying a log2 transformation which turns doubling of values into increase of 1. Approach of scaling the data.
  geom_histogram(binwidth=1, col="black")


filter(gapminder, year == past_year) %>%
  summarize(min = min(population), max = max(population))

gapminder %>%
  filter(year == past_year) %>%
  ggplot(aes(log10(population))) + # here we use a log10 given the data range
  geom_histogram(binwidth = 0.5, color = "black")

gapminder %>%
  filter(year == past_year & !is.na(gdp)) %>%
  ggplot(aes(dollars_per_day)) +
  geom_histogram(binwidth=1, color="black") +
  scale_x_continuous(trans = "log2") # this graph performs a log2 transformation but leaves the original x values on the x axis. This is the approach to scale the axis.

# 9.7 Comparing Multiple Distributions with Boxplots and Ridge Plots----
gapminder %>%
  filter(year == past_year & !is.na(gdp)) %>%
  mutate(region = reorder(region, dollars_per_day, FUN = median)) %>%
  ggplot(aes(dollars_per_day, region)) +
  geom_point() +
  scale_x_continuous(trans = "log2")


gapminder <- gapminder %>%
  mutate(group = case_when(
    region %in% c("Western Europe", "Northern Europe", "Southern Europe", "Northern America", "Australia and New Zealand") ~ "West",
    region %in% c("Eastern Asia", "South-Eastern Asia") ~ "East Asia",
    region %in% c("Caribbean", "Central America", "South America", "Latin America") ~ "Latin America",
    continent == "Africa" &
      region != "Northern Africa" ~ "Sub-Saharian",
    TRUE ~ "Others"
  ))

gapminder <- gapminder %>%
  mutate(group = factor(group, levels = c("Others", "Latin America", "East Asia", "Sub-Saharian", "West")))

p <- gapminder %>%
  filter(year == past_year & !is.na(gdp)) %>%
  ggplot(aes(group, dollars_per_day)) +
  geom_boxplot() +
  scale_y_continuous(trans = "log2") +
  xlab("") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) # angle = 90 sets the x axis labels vertical, otherwise they would not have fit

p

p + geom_point(alpha = 0.25) # we add the data points with some transparency


library(ggridges)
p <- gapminder %>%
  filter(year == past_year & !is.na(dollars_per_day)) %>%
  ggplot(aes(dollars_per_day, group)) +
  scale_x_continuous(trans = "log2")
p + geom_density_ridges() # creates a ridge plot, useful for seeing multi-modality when comparing multiple distributions

p + geom_density_ridges(jittered_points = TRUE) # adds data points

p + geom_density_ridges(jittered_points = TRUE,
                        position = position_points_jitter(height=0),
                        point_shape = '|', point_size = 3,
                        point_alpha = 1, alpha = 0.7) # translates data points in the x axis, creating a so called rug representation

present_year<- 2010
years <- c(past_year, present_year)
gapminder %>%
  filter(year %in% years & !is.na(gdp)) %>%
  mutate(west = ifelse(group == "West", "West", "Developing")) %>%
  ggplot(aes(dollars_per_day)) +
  geom_histogram(binwidth = 1, color = "black") +
  scale_x_continuous(trans = "log2") +
  facet_grid(year ~ west)

country_list_1 <- gapminder %>%
  filter(year == past_year & !is.na(gdp)) %>%
  pull(country)
country_list_2 <- gapminder %>%
  filter(year == present_year & !is.na(gdp)) %>%
  pull(country)

country_list <- intersect(country_list_1, country_list_2) # allows to create a vector containing only the common values between two objects

gapminder %>% # we remake the same plot as before but only including the common countries
  filter(year %in% years & country %in% country_list & !is.na(gdp)) %>%
  mutate(west = ifelse(group == "West", "West", "Developing")) %>%
  ggplot(aes(dollars_per_day)) +
  geom_histogram(binwidth = 1, color = "black") +
  scale_x_continuous(trans = "log2") +
  facet_grid(year ~ west)

gapminder %>%
  filter(year %in% years & country %in% country_list) %>%
  ggplot(aes(group, dollars_per_day)) +
  geom_boxplot() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  scale_y_continuous(trans = "log2") +
  xlab("") +
  facet_grid(. ~ year)


gapminder %>%
  filter(year %in% years & country %in% country_list) %>%
  mutate(year = factor(year)) %>%
  ggplot(aes(group, dollars_per_day, fill = year)) + # if we give a factor as fill, ggplot will automatically plot the factors levels separately, useful for graphical comparison.
  geom_boxplot() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  scale_y_continuous(trans = "log2") +
  xlab("")


gapminder %>%
  filter(year %in% years & country %in% country_list) %>%
  ggplot(aes(dollars_per_day)) +
  geom_density(fill = 'grey') + # density plot for the dollars per day variable
  scale_x_continuous(trans = 'log2') +
  facet_grid(. ~ year) # 2 graphs, one per each year considered


gapminder %>%
  filter(year %in% years & country %in% country_list) %>%
  mutate(group = ifelse(group == "West", "West", "Developing")) %>% # split the data into developing and west
  ggplot(aes(dollars_per_day, fill = group)) + # fill by west and developing
  scale_x_continuous(trans = 'log2') +
  geom_density(alpha = 0.2) +
  facet_grid(year ~ .) # this time we still divide the plots by year, but we place them vertically and not horizontally

p <- gapminder %>%
  filter(year %in% years & country %in% country_list) %>%
  mutate(group = ifelse(group == "West", "West", "Developing")) %>%
  ggplot(aes(dollars_per_day, after_stat(count), fill = group)) +  # the after_stat(count) parameters returns the absolute counts rather than the relative counts per group.
  # this is useful for highlighting the different sizes of the groups (e.g. group one has 20 elements, group two has 80 elements)
  scale_x_continuous(trans = "log2", limit = c(0.125, 300))

p + geom_density(alpha = 0.2) +
  facet_grid(year ~ .)

p + geom_density(alpha = 0.2, bw = 0.75) + # bw parameter makes the curves smoother
  facet_grid(year ~ .)

library(ggridges)
gapminder %>% # with this ridge plot we see which subgroups are most shifting the major west vs developing distributions
  filter(year %in% years & !is.na(dollars_per_day)) %>%
  ggplot(aes(dollars_per_day, group)) +
  scale_x_continuous(trans = 'log2') +
  geom_density_ridges() +
  facet_grid(. ~ year)

gapminder %>% # same graph and intent of before but this time we overlap the curves. 
  filter(year %in% years, country %in% country_list) %>%
  group_by(year) %>% # ensures the weights are computed separately for each year, reflecting the distribution of population within that year
  mutate(weight = population / sum(population)*2) %>% # adds a weight column that normalizes the population data
  ungroup() %>% # resets the grouping to avoid unintended grouping effects during plotting
  ggplot(aes(dollars_per_day, fill = group, weight = weight)) + # add the weight factor into the aesthetics
  scale_x_continuous(trans = 'log2', limit = c(0.125, 300)) +
  geom_density(alpha = 0.2, bw = 0.75, position = 'stack') +
  facet_grid(year ~ .)