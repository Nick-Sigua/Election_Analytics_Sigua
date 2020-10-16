### October 16th, 2020
### Alexander Sigua
### R code for Blog Post #6

## install packages
library(tidyverse)
library(ggplot2)

#set directory
setwd("~/Downloads")

## read csv data
turnout_df <- read_csv("turnout_1980-2016.csv")
popvote_df <- read_csv("popvote_1948-2016.csv")
poll_df    <- read_csv("pollavg_1968-2016.csv")

# join popvote and poll data
dat <- popvote_df %>% 
  full_join(poll_df %>% 
              filter(weeks_left == 6) %>% 
              group_by(year,party) %>% 
              summarise(avg_support=mean(avg_support))) 

# restrict dat to 1980 and above
data = dat[dat$year >= 1980,]

## United States turnout data
turnout_US = turnout_df[turnout_df$state == "United States",]

# presidential election-year turnout
turnout_US_presidential = 
  turnout_US[turnout_US$year == 1980 | turnout_US$year == 1984 | 
  turnout_US$year == 1988 | turnout_US$year == 1992 | turnout_US$year == 1996 |
    turnout_US$year == 2000 | turnout_US$year == 2004 | turnout_US$year == 2008 |
    turnout_US$year == 2012 | turnout_US$year == 2016,]

# creating a new column for percentage of turnout in numeric form
turnout_US_presidential$turnout_pctg = c(58,61.6,60.1,54.2,51.7,58.1,	
                                         52.8,55.2,54.2,59.2)

# midterm-election year turnout
turnout_US_midterm = 
  turnout_US[turnout_US$year == 1982 | turnout_US$year == 1986 | 
               turnout_US$year == 1990 | turnout_US$year == 1994 | turnout_US$year == 1998 |
               turnout_US$year == 2002 | turnout_US$year == 2006 | turnout_US$year == 2010 |
               turnout_US$year == 2014,]

# creating a new column for percentage of turnout in numeric form
turnout_US_midterm$turnout_pctg = c(36,41,40.4,39.5,38.1,41.1,38.4,38.1,42.1)

# my personal theme 
my_theme <- theme_bw() + 
  theme(panel.border = element_blank(),
        plot.title   = element_text(size = 15, hjust = 0.5), 
        axis.line    = element_line(colour = "black"),
        panel.grid.minor = element_blank(),
        panel.grid.major = 
        element_line(size = 0.2, linetype = 'solid', colour = "grey"))


##################### Trends in Turnout Rate #########################

## turnout trends for presidential election year
ggplot(data = turnout_US_presidential, aes(x = year, y = turnout_pctg)) +
  geom_point()+
  geom_line()+
  xlab("Year") + 
  ylab("Turnout (%)") +
  ggtitle("") + 
  scale_x_continuous(breaks = seq(from = 1980, to = 2016, by = 4)) +
  my_theme

## turnout trends for midterm election year
ggplot(data = turnout_US_midterm, aes(x = year, y = turnout_pctg)) +
  geom_point()+
  geom_line()+
  xlab("Year") + 
  ylab("Turnout (%)") +
  ggtitle("") + 
  scale_x_continuous(breaks = seq(from = 1982, to = 2014, by = 4)) +
  my_theme


################## Poll and Turnout Model for Dem Candidates 1980-2016 ###############

# restrict data with popvote and poll for only democrat candidates
data_dem = data[data$party == "democrat",]

# merge turnout data with data_dem
data_dem_turnout <- data_dem %>%
  left_join(turnout_US_presidential)

# poll and turnout model for democrats (model 1)
mod_turnout_dem <- lm(pv ~ turnout_pctg + avg_support , data = data_dem_turnout)

# r squared: 0.5599613
summary(mod_turnout_dem)$r.squared

# the mean squared error : 2.580458
mse <- mean((mod_turnout_dem$model$pv - mod_turnout_dem$fitted.values)^2)
sqrt(mse)

## cross-validation (1000 runs)
outsamp_errors1 <- sapply(1:1000, function(i){
  years_outsamp <- sample(data_dem_turnout$year, 4)
  outsamp_mod1 <- lm(pv ~ turnout_pctg + avg_support,
                    data_dem_turnout[!(data_dem_turnout$year %in% years_outsamp),])
  outsamp_pred1 <- predict(outsamp_mod1,
                          newdata = data_dem_turnout[data_dem_turnout$year %in% years_outsamp,])
  outsamp_true1 <- data_dem_turnout$pv2p[data_dem_turnout$year %in% years_outsamp]
  mean(outsamp_pred1 - outsamp_true1)
})

#mean out of sample error: 3.273713
mean(abs(outsamp_errors1))

################## Poll and Turnout Model for Rep Candidates 1980-2016 ###############

# restrict data with popvote and poll for only republican candidates
data_rep = data[data$party == "republican",]

# merge turnout data to data_rep
data_rep_turnout <- data_rep %>%
  left_join(turnout_US_presidential)

# poll and turnout model for republicans (model 1)
mod_turnout_rep <- lm(pv ~ turnout_pctg + avg_support , data = data_rep_turnout)

# r squared: 0.8194145
summary(mod_turnout_rep)$r.squared

# the mean squared error : 2.47421
mse3 <- mean((mod_turnout_rep$model$pv - mod_turnout_rep$fitted.values)^2)
sqrt(mse3)

## cross-validation (1000 runs)
outsamp_errors3 <- sapply(1:1000, function(i){
  years_outsamp <- sample(data_rep_turnout$year, 4)
  outsamp_mod3 <- lm(pv ~ turnout_pctg + avg_support,
                     data_rep_turnout[!(data_rep_turnout$year %in% years_outsamp),])
  outsamp_pred3 <- predict(outsamp_mod3,
                           newdata = data_rep_turnout[data_rep_turnout$year %in% years_outsamp,])
  outsamp_true3 <- data_rep_turnout$pv2p[data_rep_turnout$year %in% years_outsamp]
  mean(outsamp_pred3 - outsamp_true3)
})

#mean out of sample error:  2.847064
mean(abs(outsamp_errors3))

##################### Poll Only Model for Dem Candidates 1980-2016 ###################

# poll only model for democrats (model 2)
mod_poll_dem <- lm(pv ~ avg_support , data = data_dem_turnout)

# r squared: 0.4701869
summary(mod_poll_dem)$r.squared

# the mean squared error: 2.831474
mse2 <- mean((mod_poll_dem$model$pv - mod_poll_dem$fitted.values)^2)
sqrt(mse2)

## cross-validation (1000 runs)
outsamp_errors2 <- sapply(1:1000, function(i){
  years_outsamp <- sample(data_dem_turnout$year, 4)
  outsamp_mod2 <- lm(pv ~ avg_support,
                    data_dem_turnout[!(data_dem_turnout$year %in% years_outsamp),])
  outsamp_pred2 <- predict(outsamp_mod2,
                          newdata = data_dem_turnout[data_dem_turnout$year %in% years_outsamp,])
  outsamp_true2 <- data_dem_turnout$pv2p[data_dem_turnout$year %in% years_outsamp]
  mean(outsamp_pred2 - outsamp_true2)
})

#mean out of sample error: 2.725257
mean(abs(outsamp_errors2))

################## Polls Only Model for Rep Candidates 1980-2016 ###############

# poll only model for republicans (model 2)
mod_poll_rep <- lm(pv ~ avg_support , data = data_rep_turnout)

# r squared: 0.7114566
summary(mod_poll_rep)$r.squared

# the mean squared error: 3.127524
mse4 <- mean((mod_poll_rep$model$pv - mod_poll_rep$fitted.values)^2)
sqrt(mse4)

## cross-validation (1000 runs)
outsamp_errors4 <- sapply(1:1000, function(i){
  years_outsamp <- sample(data_rep_turnout$year, 4)
  outsamp_mod4 <- lm(pv ~ avg_support,
                    data_rep_turnout[!(data_rep_turnout$year %in% years_outsamp),])
  outsamp_pred4 <- predict(outsamp_mod4,
                          newdata = data_rep_turnout[data_rep_turnout$year %in% years_outsamp,])
  outsamp_true4 <- data_rep_turnout$pv2p[data_rep_turnout$year %in% years_outsamp]
  mean(outsamp_pred4 - outsamp_true4)
})

#mean out of sample error:  3.180844
mean(abs(outsamp_errors4))

############################ Predictions for 2020 ##################################

# 2020 data assuming business as usual - turnout does not vary much from last year
dat_2020_dem <- data.frame(avg_support = 52.2, turnout_pctg = 59.2)
dat_2020_rep <- data.frame(avg_support = 42, turnout_pctg = 59.2)

#Democrat party candidate predictions 2020: 52.02561 
dem_prediction = predict(mod_turnout_dem, newdata = dat_2020_dem)
dem_prediction

#Republican party candidate predictions 2020: 43.70903
rep_prediction = predict(mod_turnout_rep, newdata = dat_2020_rep)
rep_prediction

# if covid has a big impact, my assumption of historic low turnout
dat_2020_dem2 <- data.frame(avg_support = 52.2, turnout_pctg = 51)
dat_2020_rep2 <- data.frame(avg_support = 42, turnout_pctg = 51)

#Democrat party candidate predictions 2020: 48.97718 
dem_prediction = predict(mod_turnout_dem, newdata = dat_2020_dem2)
dem_prediction

#Republican party candidate predictions 2020: 48.74555 
rep_prediction = predict(mod_turnout_rep, newdata = dat_2020_rep2)
rep_prediction

# if turnout is greater than last cycle
dat_2020_dem3 <- data.frame(avg_support = 52.2, turnout_pctg = 61)
dat_2020_rep3 <- data.frame(avg_support = 42, turnout_pctg = 61)

#Democrat party candidate predictions 2020: 52.69477 
dem_prediction = predict(mod_turnout_dem, newdata = dat_2020_dem3)
dem_prediction

#Republican party candidate predictions 2020: 42.60345
rep_prediction = predict(mod_turnout_rep, newdata = dat_2020_rep3)
rep_prediction




