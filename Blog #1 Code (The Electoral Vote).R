# September 12th, 2020
# Alexander Sigua
# R code for Blog Post #1 ("The Electoral Vote")

## install packages
library(tidyverse)
library(ggplot2)
library(usmap)
library(readxl)

#set directory
setwd("~/Downloads")

## read popular vote csv
popvote_df <- read_csv("popvote_1948-2016.csv")

## read electoral vote share data via excel file
## electoral vote share data in excel file was calculated personally
Electoral_Test <- read_excel("Electoral Test.xlsx")

# mutation to numbered rows; in order to accurately merge electoral excel data 
# by row number 
row = 1:nrow(popvote_df)
popvote_mutate <- mutate(popvote_df, row)

#left join electoral vote share data
popvote_and_electoral_df <- popvote_mutate %>% 
left_join(Electoral_Test, by = "row")

# my personal ggplot theme: formatted legend, removed minor grid lines, 
# adjusted x asix title angles
my_theme <- theme_bw() + 
  theme(panel.border = element_blank(),
        plot.title   = element_text(size = 15, hjust = 0.5), 
        axis.text.x  = element_text(angle = 90, hjust = 1),
        axis.text    = element_text(size = 10),
        strip.text   = element_text(size = 10),
        axis.line    = element_line(colour = "black"),
        legend.position = "right",
        legend.background = element_rect(colour= "grey"),
        legend.title = element_text(size = 1),
        legend.text = element_text(size = 10),
        panel.grid.minor = element_blank(),
        panel.grid.major = 
        element_line(size = 0.2, linetype = 'solid', colour = "grey"))

# Electoral Vote Share ggplot
ggplot(popvote_and_electoral_df, aes(x = year, y = Ev2p, colour = party)) +
  geom_line(stat = "identity") +
  scale_color_manual(values = c("blue", "red"), name = "") +
  xlab("") + 
  ylab("Percentage of Electoral Vote") +
  ggtitle("Presidential Electoral Vote Share (1948-2016)") + 
  scale_x_continuous(breaks = seq(from = 1948, to = 2016, by = 4)) +
  my_theme

# Popular Vote Share ggplot
ggplot(popvote_and_electoral_df, aes(x = year, y = pv2p, colour = party)) +
  geom_line(stat = "identity") +
  scale_color_manual(values = c("blue", "red"), name = "") +
  xlab("") + 
  ylab("Percentage of Popular Vote") +
  ggtitle("Presidential Popular Vote Share (1948-2016)") + 
  scale_x_continuous(breaks = seq(from = 1948, to = 2016, by = 4)) +
  my_theme


# read state popular data
pvstate_df <- read_csv("popvote_bystate_1948-2016.csv")
pvstate_df$full <- pvstate_df$state

## 2000 win-margins map; variable creation
pv_margins_map_2000 <- pvstate_df %>%
  filter(year == 2000) %>%
  mutate(win_margin = (R_pv2p-D_pv2p))

# 2000 win-margins map; map display
plot_usmap(data = pv_margins_map_2000, regions = "states", labels= TRUE, values = "win_margin") +
  scale_fill_gradient2(
    high = "red", 
    mid = "white",
    low = "blue", 
    breaks = c(-50,-25,0,25,50), 
    limits = c(-50,50),
    name = "win margin"
  ) + 
  theme(legend.position = "bottom") +
  labs(title = "US Win Margins Map 2000") + 
  theme(plot.title = element_text(size = 15, hjust = 0.5))
  theme_void()
  
# swing states as defined by states with less than 2 percent popular vote win margins
swing.states.2000 = pv_margins_map_2000[pv_margins_map_2000$win_margin <= 2 & 
pv_margins_map_2000$win_margin >= -2,]
swing.states.2000

#total democrat popular votes in swing states (2000)
democrat.swing.voters.2000 = sum(swing.states.2000$D)
democrat.swing.voters.2000

#total republican popular votes in swing states (2000)
republican.swing.voters.2000 = sum(swing.states.2000$R)
republican.swing.voters.2000

#total two party votes in swing states (2000)
total.swing.voters.2000 = democrat.swing.voters.2000 + republican.swing.voters.2000
total.swing.voters.2000

#democrat two-party popular vote share of swing voters (2000)
democrat.swing.voters.2000/total.swing.voters.2000

#republican two-party popular vote share of swing voters (2000)
republican.swing.voters.2000/total.swing.voters.2000

## Electoral votes in swing states, for presidential election 2000
# Florida: 25 electoral votes
# New Mexico: 5 electoral votes
# Oregon: 7 electoral votes
# New Hampshire: 4 electoral votes
# Iowa: 7 electoral votes
# Wisconsin: 11 electoral votes 

#total electoral votes from swing states
25+5+7+4+7+11

#republican electoral votes from swing states
25+4

#republican electoral vote share from swing states
29/59

#democrat electoral votes from swing states
5+7+7+11

#democrat electoral vote share from swing states 
30/59


## 2016 win-margins map; variable creation
pv_margins_map_2016 <- pvstate_df %>%
    filter(year == 2016) %>%
    mutate(win_margin = (R_pv2p-D_pv2p))
  
## 2016 win-margins map; map display
plot_usmap(data = pv_margins_map_2016, regions = "states", labels= TRUE, values = "win_margin") +
    scale_fill_gradient2(
      high = "red", 
      mid = "white",
      low = "blue", 
      breaks = c(-50,-25,0,25,50), 
      limits = c(-50,52),
      name = "win margin"
    ) + 
    theme(legend.position = "bottom") +
    labs(title = "US Win Margins Map 2016") + 
    theme(plot.title = element_text(size = 15, hjust = 0.5))
    theme_void()
  
# swing states as defined by states with less than 2 percent popular vote win margins
swing.states.2016 = pv_margins_map_2016[pv_margins_map_2016$win_margin <= 2 & 
  pv_margins_map_2016$win_margin >= -2,]
swing.states.2016

#total democrat popular votes in swing states (2016)
democrat.swing.voters.2016 = sum(swing.states.2016$D)
democrat.swing.voters.2016

#total republican popular votes in swing states (2016)
republican.swing.voters.2016 = sum(swing.states.2016$R)
republican.swing.voters.2016

#total two party votes in swing states (2016)
total.swing.voters.2016 = democrat.swing.voters.2016 + republican.swing.voters.2016
total.swing.voters.2016

#democrat two-party popular vote share of swing voters (2016)
democrat.swing.voters.2016/total.swing.voters.2016

#republican two-party popular vote share of swing voters (2016)
republican.swing.voters.2016/total.swing.voters.2016

## Electoral votes in swing states, for presidential election 2016
# Florida: 29 electoral votes
# Michigan: 16 electoral votes
# Minnesota: 10 electoral votes
# New Hampshire: 4 electoral votes
# Pennsylvania: 20 electoral votes
# Wisconsin: 10 electoral votes 

#total electoral votes from swing states
29+16+10+4+20+10

#republican electoral votes from swing states
29+16+20+10

#republican electoral vote share from swing states
75/89

#democrat electoral votes from swing states
10+4

#democrat electoral vote share from swing states 
14/89


  
  
