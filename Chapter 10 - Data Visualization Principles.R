# CHAPTER 10 - DATA VISUALIZATION PRINCIPLES

library(tidyverse)
library(dslabs)
library(gridExtra)

data(murders)
murders %>% # barplot of murder rate per state in ascending order on the y axis
  mutate(murder_rate = total / population /100000) %>%
  mutate(state = reorder(state, murder_rate)) %>%
  ggplot(aes(state, murder_rate)) +
  geom_bar(stat = "identity") +
  coord_flip() + # flips x and y axis. Same result is achieved by inverting x and y arguments in ggplot aesthetics
  theme(axis.text.y = element_text(size = 6)) +
  xlab("")

# 10.5 Show the Data----
heights %>%
  ggplot(aes(sex, height)) +
  geom_point()

heights %>%
  ggplot(aes(sex, height)) +
  geom_jitter(width = 0.1, alpha = 0.2) # jitter includes horizontal random distribution of points, alpha adjusts transparency according to points density. Overall, they improve
# scatterplots interpretation

# 10.6 Ease Comparisons----
heights %>% # vertical alignment of barplots to visually locate distributions' differences
  ggplot(aes(height, after_stat(density))) + # the after_stat(density) parameter makes R calculate the relative frequency of each height range (bin) to then plot it in the y axis.
  geom_histogram(binwidth = 1, color = "black") +
  facet_grid(sex~.)

heights %>% # in case of comparing with boxplots, we align the graphs horizontally
  ggplot(aes(sex, height)) +
  geom_boxplot(coef = 3) +
  geom_jitter(width = 0.1, alpha = 0.2) +
  ylab("Height in inches")


# 10.8 Plots for Two Variables----
west <- c("Western Europe", "Northern Europe", "Southern Europe", "Northern America", "Auatralia and New Zealand")

dat <- gapminder %>%
  filter(year %in% c(2010, 2015) & region %in% west & !is.na(life_expectancy) & population > 10^7)

dat %>% # creating a slope chart, useful for comparing linear changes of various actors (here the life expectancy change of various countries between 2010 and 2015)
  mutate(location = ifelse(year == 2010, 1, 2),
         location = ifelse(year == 2015 & country %in% c("United States", "Portugal"),
                           location + 0.22, location),
         hjust = ifelse(year == 2010, 1, 0)) %>%
  mutate(year = as.factor(year)) %>%
  ggplot(aes(year, life_expectancy, group = country)) +
  geom_line(aes(color = country), show.legend = F) +
  geom_text(aes(x = location, label = country, hjust = hjust),
            show.legend = F) +
  xlab("") + ylab("Life Expectancy")

library(ggrepel)
dat %>% # here we create a Bland-Altman plot = shows the difference vs the average. It is a valid alternative to the slope chart seen above.
  mutate(year = paste0("life_expectancy_", year)) %>%
  select(country, year, life_expectancy) %>%
  spread(year, life_expectancy) %>%
  mutate(average = (life_expectancy_2015 + life_expectancy_2010) / 2,
         difference = life_expectancy_2015 - life_expectancy_2010) %>%
  ggplot(aes(average, difference, label = country)) +
  geom_point() +
  geom_text_repel() +
  geom_abline(lty = 2) +
  xlab("Average of 2010 and 2015") +
  ylab("Difference between 2015 and 2010")

# 10.9 Encoding a Third Variable----
library(RColorBrewer)
display.brewer.all(type = "seq") # sequential colors offered by the RColorBrewer package
display.brewer.all(type = "div") # divergent colors offered by the RColorBrewer package (highlights distance of values from a center value)

# 10.14 Case Study: Vaccines and Infectuous Diseases----
the_disease <- "Measles"
dat <- us_contagious_diseases %>%
  filter(!state%in%c("Hawai", "Alaska") & disease == the_disease) %>%
  mutate(rate = count / population * 10000 *52 / weeks_reporting) %>%
  mutate(state = reorder(state, rate))

dat %>% filter(state == "California" & !is.na(rate)) %>%
  ggplot(aes(year, rate)) +
  geom_line() +
  ylab("Caese per 10,000") +
  geom_vline(xintercept = 1963, col = "blue")

dat %>% # This plot shows three variables making using of the color brewer pallette to portray the third variable.  
  ggplot(aes(year, state, fill = rate)) +
  geom_tile(color = "grey50") + # adds rectangular tiles (cells) for each combination of year and state, adds a grey boundary around each tile
  scale_x_continuous(expand=c(0,0)) + # removes padding (whitespace) around the x-axis
  scale_fill_gradientn(colors = brewer.pal(9, "Reds"), trans = "sqrt") +
  # customizes the color scale for the fill aesthetic (rate)
  geom_vline(xintercept = 1963, col = "blue") + # draws the vertical blue line at the wanted intercept
  theme_minimal() + # sets a clean and minimalistic plot theme by removing unnecessary elements
  theme(panel.grid = element_blank(), # removes gridline from the plot panel,  
        legend.position = "bottom", # moves the legend,
        text = element_text(size = 8)) + # reduces the font size for text elements
  ggtitle(the_disease) +
  ylab("") + xlab("")


avg <- us_contagious_diseases %>%
  filter(disease==the_disease) %>%
  group_by(year) %>%
  summarize(us_rate = sum(count, na.rm = T) / sum(population, na.rm = T) * 10000)

dat %>% # using position and lenght instead of colors to display the 3 variables
  filter(!is.na(rate)) %>%
  ggplot() +
  geom_line(aes(year, rate, group = state), color = 'grey50', show.legend = F, alpha = 0.2, size = 1) +
  # group = state ensures that each state is represented by a line
  geom_line(mapping = aes(year, us_rate), data = avg, size = 1) + # adds a line made with value of another data frame (avg)
  scale_y_continuous(trans = 'sqrt', breaks = c(5, 25, 125, 300)) + # breaks sets tick marks on the y axis
  ggtitle("Cases per 10,000 by state") +
  xlab("") + ylab("") +
  geom_text(data = data.frame(x = 1955, y = 50), # data.frame defines the coordinates where to place the text
            mapping = aes(x, y, label = "Us average"), # the mapping places the text on the specified coordinates
            color = 'black') +
  geom_vline(xintercept = 1963, col = 'blue') # adds a vertical blue line the a intercept