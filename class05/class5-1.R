#Class 5 ggPlot learning, always remember to library(ggplot2) first. 
library(ggplot2)
# Open ggplot(cars) and add aes
ggplot(cars) +
  aes(x=speed, y=dist)
## we need to add one of ggplot’s geometric layers (or geoms) to define how we want to visualize our dataset. 
## We can use geom_line(), geom_col(), etc
ggplot(cars) +
  aes(x=speed, y=dist) +
  geom_point()

## let's make it smooth. What is smooth? Aids the eye in seeing patterns in the presence of overplotting. 
ggplot(cars) +
  aes(x=speed, y=dist) +
  geom_point() +
  geom_smooth()

## add labs() function and changing the plot look to “black & white” theme by adding the theme_bw() function:
ggplot(cars) + 
  aes(x=speed, y=dist) +
  geom_point() +
  labs(title="Speed and Stopping Distances of Cars",
       x="Speed (MPH)", 
       y="Stopping Distance (ft)",
       subtitle = "Your informative subtitle text here",
       caption="Dataset: 'cars'") +
  geom_smooth(method="lm", se=FALSE) +
  theme_bw()

##Adding more plot aesthetics through aes()
##Adjust the point size of a scatter plot using the size parameter.
##Change the point color of a scatter plot using the color parameter. 
##Set a parameter alpha to change the transparency of all points.

#another exercise
url <- "https://bioboot.github.io/bimm143_S20/class-material/up_down_expression.txt"
genes <- read.delim(url)
head(genes)

nrow(genes)
colnames(genes)
ncol(genes)
## table the state in the genes database
table(genes$State)

## the round( ,2 ) here means 2 digital after the decimal point
round( table(genes$State)/nrow(genes) * 100, 2 )

## make a basic plot first
ggplot(genes) + 
  aes(x=Condition1, y=Condition2) +
  geom_point()

## name this p, and add color for the dots according to the State
p <- ggplot(genes) + 
  aes(x=Condition1, y=Condition2, col=State) +
  geom_point()
p

##change color for the dots manually
p + scale_colour_manual( values=c("blue","gray","red") )

## add labels and change color of theme
p + scale_colour_manual(values=c("blue","gray","red")) +
  labs(title="Gene Expresion Changes Upon Drug Treatment",
       x="Control (no drug) ",
       y="Drug Treatment") + theme_bw()

# what is more??
library(gapminder)
# only want 2007?
library(dplyr)
gapminder_2007 <- gapminder %>% filter(year==2007)

#Let’s consider the gapminder_2007 dataset which contains the variables GDP per capita gdpPercap and life expectancy lifeExp for 142 countries in the year 2007
ggplot(gapminder_2007) +
  aes(x=gdpPercap, y=lifeExp) +
  geom_point()

#on the top of each other? no worries!  One useful approach here is to add an alpha=0.4 argument to your geom_point() call to make the points slightly transparent. This will help us see things a little more clearly later on.
ggplot(gapminder_2007) +
  aes(x=gdpPercap, y=lifeExp) +
  geom_point(alpha=0.5)

# add the population pop (in millions) through the point size argument to aes() we can obtain a much richer plot that now includes 4 different variables from the data set
ggplot(gapminder_2007) +
  aes(x=gdpPercap, y=lifeExp, color=continent, size=pop) +
  geom_point(alpha=0.5)

# we also can color the dots by the numeric variable population pop
ggplot(gapminder_2007) + 
  aes(x = gdpPercap, y = lifeExp, color = pop) +
  geom_point(alpha=0.8)

#I do not like using color to indicate the population in this case. let me change back to using the size function
ggplot(gapminder_2007) + 
  aes(x = gdpPercap, y = lifeExp, size = pop) +
  geom_point(alpha=0.5)

# This is not really reflecting the real size. let us use scale_size_area() function
ggplot(gapminder_2007) + 
  geom_point(aes(x = gdpPercap, y = lifeExp,
                 size = pop), alpha=0.5) + 
  scale_size_area(max_size = 10)

# let me make one for 1957
gapminder_1957 <- gapminder %>% filter(year==1957)
ggplot(gapminder_1957) + 
  geom_point(aes(x = gdpPercap, y = lifeExp,color=continent,
                 size = pop), alpha=0.7) + 
  scale_size_area(max_size = 10)

gapminder_top5 <- gapminder %>% filter(year==2007)
ggplot(gapminder_2007) +
  geom_point(aes(x = gdpPercap, y = lifeExp,color=continent,
                 size = pop), alpha=0.7) + 
  scale_size_area(max_size = 10)

# How to put them together??  multi-panel plots in R using facet_wrap()
gapminder_1957 <- gapminder %>% filter(year==1957 | year==2007)

ggplot(gapminder_1957) + 
  geom_point(aes(x = gdpPercap, y = lifeExp, color=continent,
                 size = pop), alpha=0.7) + 
  scale_size_area(max_size = 10) +
  facet_wrap(~year)

# ADVANCE!!
# set a CRAN mirror
local({r <- getOption("repos")
r["CRAN"] <- "http://my.local.cran"
options(repos=r)})

install.packages("gifski") 
install.packages("gganimate")

library(ggplot2)
library(gapminder)
library(gganimate)

# Setup nice regular ggplot of the gapminder data
ggplot(gapminder, aes(gdpPercap, lifeExp, size = pop, colour = country)) +
  geom_point(alpha = 0.7, show.legend = FALSE) +
  scale_colour_manual(values = country_colors) +
  scale_size(range = c(2, 12)) +
  scale_x_log10() +
  # Facet by continent
  facet_wrap(~continent) +
  # Here comes the gganimate specific bits
  labs(title = 'Year: {frame_time}', x = 'GDP per capita', y = 'life expectancy') +
  transition_time(year) +
  shadow_wake(wake_length = 0.1, alpha = FALSE)


