## install via `install.packages("name")`
library(tidyverse)
library(ggplot2)
library(usmap)

setwd("~/Downloads")

## read
popvote_df <- read_csv("popvote_1948-2016.csv")


## read excel file
Electoral_Test <- read_excel("Electoral Test.xlsx")

view(Electoral_Test)


# mutation
row = 1:nrow(popvote_df)
popvote_mutate <- mutate(popvote_df, row)

view(popvote_mutate)

#left join
popvote_and_electoral_df <- popvote_mutate %>% 
  left_join(Electoral_Test, by = "row")

view(popvote_and_electoral_df)


#make wider, maybe change background, make grid lines darker, 
#if possible make election year grids darkets and thicker


# Electoral Vote Share 
my_pretty_theme <- theme_bw() + 
  theme(panel.border = element_blank(),
        plot.title   = element_text(size = 15, hjust = 0.5), 
        axis.text.x  = element_text(angle = 45, hjust = 1),
        axis.text    = element_text(size = 12),
        strip.text   = element_text(size = 18),
        axis.line    = element_line(colour = "black"),
        legend.position = "top",
        legend.text = element_text(size = 12))

ggplot(popvote_and_electoral_df, aes(x = year, y = Ev2p, colour = party)) +
  geom_line(stat = "identity") +
  scale_color_manual(values = c("blue", "red"), name = "") +
  xlab("") + ## no need to label an obvious axis
  ylab("electoral vote %") +
  ggtitle("Presidential Electoral Vote Share (1948-2016)") + 
  scale_x_continuous(breaks = seq(from = 1948, to = 2016, by = 4)) +
  my_pretty_theme



# Popular Vote Share 
my_pretty_theme <- theme_bw() + 
  theme(panel.border = element_blank(),
        plot.title   = element_text(size = 15, hjust = 0.5), 
        axis.text.x  = element_text(angle = 45, hjust = 1),
        axis.text    = element_text(size = 12),
        strip.text   = element_text(size = 18),
        axis.line    = element_line(colour = "black"),
        legend.position = "top",
        legend.text = element_text(size = 12))

ggplot(popvote_and_electoral_df, aes(x = year, y = pv2p, colour = party)) +
  geom_line(stat = "identity") +
  scale_color_manual(values = c("blue", "red"), name = "") +
  xlab("") + ## no need to label an obvious axis
  ylab("popular vote %") +
  ggtitle("Presidential Popular Vote Share (1948-2016)") + 
  scale_x_continuous(breaks = seq(from = 1948, to = 2016, by = 4)) +
  my_pretty_theme
