# CHAPTER 7 - GGPLOT2 ----
# 7.2 ggplot objects ----
library(dslabs)
data("murders")

library(ggplot2)
ggplot(data = murders)
murders %>% ggplot()

p <- ggplot(data = murders)
class(p)
print(p)

# 7.3 & 7.4 Geometries and Aesthetic Mappings ----
murders %>% ggplot() +
  geom_point(aes(x = population/10^6, y = total)) # geom_ describes the plot geometry (type), aesthetic mappings describe how properties of the data connect with features of the plot

p <- ggplot(data = murders)
p + geom_point(aes(population/10^6, total))

# 7.5 Layers
p + geom_point(aes(population/10^6, total)) + 
  geom_text(aes(population/10^6, total, label = abb)) # to add labels to each point

p + geom_point(aes(population/10^6, total), size = 3) + # size allows to change the point's size 
  geom_text(aes(population/10^6, total, label = abb)) 

p + geom_point(aes(population/10^6, total), size = 3) + 
  geom_text(aes(population/10^6, total, label = abb), nudge_x = 1.5) # nudge_x argument moves the text slighlty to the right or the left of the point, to make the label more visible

# 7.6 Global vs local aesthetic mapping----
p <- murders %>% ggplot(aes(population/10^6, total, label = abb)) # when we define the aesthetics within ggplot main function, we do not need to repeat the definition in other plot layers
p + geom_point(size = 3) +
  geom_text(nudge_x = 1.5)

p + geom_point(size = 3) +
  geom_text(aes(x = 10, y = 800, label = "Hello there!")) # note that local aesthetic definitions will override the global ones

# 7.7 Scales ----
p + geom_point(size = 3) +
  geom_text(nudge_x = 0.05) +
  scale_x_continuous(trans = "log10") +
  scale_y_continuous(trans = "log10") # transform the axis scale

p + geom_point(size = 3) +
  geom_text(nudge_x = 0.05) +
  scale_x_log10() +
  scale_y_log10() # transform the axis scale in log10

# 7.8 Labels and Titles----
p + geom_point(size = 3) +
  geom_text(nudge_x = 0.05) +
  scale_x_log10() +
  scale_y_log10() +
  xlab("Populations in millions (log scale)") + # add axis names
  ylab("Total number of murders (log scale)") +
  ggtitle("US Gun Murders in 2010") # add title

# 7.9 Categories as colors----
p <- murders %>% ggplot(aes(population/10^6, total, label = abb)) +
  geom_text(nudge_x = 0.05) +
  scale_x_log10() +
  scale_y_log10() +
  xlab("Populations in millions (log scale)") + 
  ylab("Total number of murders (log scale)") +
  ggtitle("US Gun Murders in 2010") 

p + geom_point(size = 3, color = "blue") # change the points' color

p + geom_point(aes(col=region), size = 3) # if we want to color by a variable, we need to include it within aes() as it is not global but specific to each observation 
# note that in this case ggplot2 automatically adds a legend


# 7.10 Annotations, Shapes and Adjustments----
r<- murders %>%
  summarize(rate = sum(total) / sum(population) * 10^6) %>%
  pull(rate)

p + geom_point(aes(col=region), size = 3) +
  geom_abline(intercept = log10(r)) # adds the average line, a and b, namely intercept and slope, are asked. Default are 1 for slope and 0 for the intercept. Here we supply the intercept.

p <- p + geom_abline(intercept = log10(r), lty = 2, color = "darkgrey") + # we adjust the color and the type of line (2 is dashed)
  geom_point(aes(col=region), size = 3)
  
p <- p + scale_color_discrete(name = "Region") # with this function and its name argument we modify the legend name


# 7.11 Add on packages ----
library(ggthemes)

p + theme_economist()
p + theme_dark()
p + theme_fivethirtyeight()

library(ggrepel)

r <- murders %>%
  summarize(rate = sum(total) / sum(population) * 10^6) %>%
  pull(rate)

murders %>% ggplot(aes(population/10^6, total, label = abb)) +
  geom_abline(intercept = log10(r), lty = 2, color = "darkgrey") +
  geom_point(aes(col=region), size = 3) +
  geom_text_repel() + # from ggrepel, makes sure there is no text/label overfitting
  scale_x_log10() +
  scale_y_log10() +
  xlab("Populations in millions (log scale") +
  ylab("Total number of murders (log scale") +
  ggtitle("US gun murders in 2010") +
  scale_color_discrete(name = "Region") +
  theme_economist()

# 7.13 Quick plots with qplot----
data(murders)
x <- log10(murders$population)
y <- murders$total

qplot(x, y) # allows to generate ggplot style plots in a quicker, but less flexible way

# 7.14 Grid of Plots ----
library(gridExtra)
p1 <- qplot(x)
p2 <- qplot(x, y)
grid.arrange(p1, p2, ncol=2)

