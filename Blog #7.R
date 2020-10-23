### October 22th, 2020
### Alexander Sigua
### R code for Blog Post #7

## install packages
library(tidyverse)
library(ggplot2)
library(readxl)

#set directory
setwd("~/Downloads")

## read csv data
nationnal_covid_df <- read_csv("national-history.csv")
avg_support_df <- read_excel("avg_support.xlsx")

#my theme
my_theme <- theme_bw() + 
  theme(panel.border = element_blank(),
        plot.title   = element_text(size = 15, hjust = 0.5), 
        axis.line    = element_line(colour = "black"),
        panel.grid.minor = element_blank(),
        panel.grid.major = 
        element_line(size = 0.2, linetype = 'solid', colour = "grey"))

################### Trends of Covid Variables by Date #########################

# Covid death increases by day
ggplot(data = nationnal_covid_df, aes(x = date, y = deathIncrease)) +
  geom_point()+
  geom_line()+
  xlab("Date") + 
  ylab("Death Increase") +
  ggtitle("") + 
  my_theme

# Covid positive case increases by day
ggplot(data = nationnal_covid_df, aes(x = date, y = positiveIncrease)) +
  geom_point()+
  geom_line()+
  xlab("Date") + 
  ylab("Positive Case Increase") +
  ggtitle("") + 
  my_theme

# Covid test results increase by day
ggplot(data = nationnal_covid_df, aes(x = date, y = totalTestResultsIncrease)) +
  geom_point()+
  geom_line()+
  xlab("Date") + 
  ylab("Test Results Increase") +
  ggtitle("") + 
  my_theme

####### Relationship between Covid Variables and Candidates' Average Support #######

#combine data of candidates' average support and covid variables data 
df= nationnal_covid_df %>% inner_join(avg_support_df,by="date")

############### Death increase and average support ################

#scatterplot of death increase and average support for Biden
ggplot(data = df, aes(x = deathIncrease, y = avg_support_Biden)) +
  geom_point()+
  geom_line()+
  xlab("Death Increase") + 
  ylab("Average Support for Biden") +
  ggtitle("") + 
  my_theme

#scatterplot of death increase and average support for Trump
ggplot(data = df, aes(x = deathIncrease, y = avg_support_Trump)) +
  geom_point()+
  geom_line()+
  xlab("Death Increase") + 
  ylab("Average Support for Trump") +
  ggtitle("") + 
  my_theme

# linear regression model for death increase and average support for Biden
model_deathrate_biden <- 
  lm(avg_support_Biden ~ deathIncrease, data = df)

# r-squared: 0.4886008
summary(model_deathrate_biden)$r.squared

# linear regression model for death increase and average support for Trump
model_deathrate_trump <- 
  lm(avg_support_Trump ~ deathIncrease, data = df)

# r-squared: 0.1384364
summary(model_deathrate_trump)$r.squared

############# Positive case increase and average support ################

#scatterplot of positive case increase and average support for Biden
ggplot(data = df, aes(x = positiveIncrease, y = avg_support_Biden)) +
  geom_point()+
  geom_line()+
  xlab("Positive Case Increase") + 
  ylab("Average Support for Biden") +
  ggtitle("") + 
  my_theme

#scatterplot of positive case increase and average support for Trump
ggplot(data = df, aes(x = positiveIncrease, y = avg_support_Trump)) +
  geom_point()+
  geom_line()+
  xlab("Positive Case Increase") + 
  ylab("Average Support for Trump") +
  ggtitle("") + 
  my_theme

# linear regression model for positive case increase and average support for Biden
model_positive_biden <- 
  lm(avg_support_Biden ~ positiveIncrease, data = df)

# r-squared: 0.0175652
summary(model_positive_biden)$r.squared

# linear regression model for positive case increase and average support for Trump
model_positive_trump <- 
  lm(avg_support_Trump ~ positiveIncrease, data = df)

# r-squared: 0.6074377
summary(model_positive_trump)$r.squared

############# Test results increase and average support ###############

#scatterplot of test results increase and average support for Biden
ggplot(data = df, aes(x = totalTestResultsIncrease, y = avg_support_Biden)) +
  geom_point()+
  geom_line()+
  xlab("Test Results Increase") + 
  ylab("Average Support for Biden") +
  ggtitle("") + 
  my_theme

#scatterplot of test results increase and average support for Trump
ggplot(data = df, aes(x = totalTestResultsIncrease, y = avg_support_Trump)) +
  geom_point()+
  geom_line()+
  xlab("Test Results Increase") + 
  ylab("Average Support for Trump") +
  ggtitle("") + 
  my_theme

# linear regression model for test results increase and average support for Biden
model_test_biden <- 
  lm(avg_support_Biden ~ totalTestResultsIncrease, data = df)

# r-squared: 0.01485442
summary(model_test_biden)$r.squared

# linear regression model for test results increase and average support for Trump
model_test_trump <- 
  lm(avg_support_Trump ~ totalTestResultsIncrease, data = df)

# r-squared: 0.4610032
summary(model_test_trump)$r.squared




