### September 25th, 2020
### Alexander Sigua
### R code for Blog Post #3 ("The Polls in Popular Vote Predictions")

## install oackages
library(tidyverse)
library(ggplot2)
library(readxl)

## set working directory
setwd("~/Downloads")

#read data sets
polls.2016 <- read_csv("polls_2016.csv")
polls.2020 <- read_csv("polls_2020-2.csv")
popvote_df <- read_csv("popvote_1948-2016.csv")
economy_df <- read_csv("econ.csv")
poll_df    <- read_csv("pollavg_1968-2016.csv")

# merge popular vote, avg support and economic variable data sets 
# filtered for second-quarter data (6 weeks till election)
dat <- popvote_df %>% 
  full_join(poll_df %>% 
              filter(weeks_left == 6) %>% 
              group_by(year,party) %>% 
              summarise(avg_support=mean(avg_support))) %>% 
  left_join(economy_df %>% 
              filter(quarter == 2))

#relationship between incumbent party pop vote share and
#avg support 6 weeks till election
dat %>%
  filter(incumbent_party == "TRUE") %>%
  ggplot(aes(x=avg_support, y=pv,
             label=year)) + 
  geom_text(hjust = 0, nudge_x = 0.05, nudge_y = 1.5, size = 3.5) +
  geom_hline(yintercept=50, lty=2) +
  geom_vline(xintercept=50, lty=2) + # median
  ggtitle("") +
  scale_x_continuous(limit = c(30, 65))+
  xlab( "Average poll support") +
  ylab("Incumbent party's national popular vote share") +
  theme_bw()

#relationship between challenger party pop vote share and 
#avg support 6 weeks till election
dat %>%
  filter(incumbent_party == "FALSE") %>%
  ggplot(aes(x=avg_support, y=pv,
             label=year)) + 
  geom_text(hjust = 0, nudge_x = 0.05, nudge_y = 1.5, size = 3.5) +
  geom_hline(yintercept=50, lty=2) +
  geom_vline(xintercept=50, lty=2) + # median
  ggtitle("") +
  scale_x_continuous(limit = c(30, 65))+
  xlab( "Average poll support") +
  ylab("Challenger party's national popular vote share") +
  theme_bw()


################################################

#Poll Quality Histograms

#national polls for 2016
national.polls.2016 <-  
  polls.2016 %>%
  filter(state == "U.S.")

#national polls for 2020
national.polls.2020 <-
  polls.2020 %>%
  filter(is.na(state))

#Poll Grades for 2016, omitting NA's
poll.grades.2016 = na.omit(national.polls.2016$grade)
poll.grades.2016

#Poll Grades for 2020, omitting NA's
poll.grades.2020 = na.omit(national.polls.2020$fte_grade)
poll.grades.2020

#histogram for 2016 poll grades
ggplot(data.frame(poll.grades.2016), 
       aes(x=poll.grades.2016)) +
  geom_bar() + 
  xlab( "2016 Poll Grades") +
  ylab("Count") 

#histogram for 2020 poll grades
ggplot(data.frame(poll.grades.2020), 
       aes(x=poll.grades.2020)) +
  geom_bar()+
  xlab( "2020 Poll Grades") +
  ylab("Count") 

##############################################

#Constructing a prediction model based on weighting higher quality polls
#Model 1

#First Component: Weighted Average Support

#A+ grade national polls
national.polls.2016.Aplus <-
  national.polls.2016 %>%
  filter(grade == "A+")

#Incumbent party candidate's average support from A+ grade polls
Aplus.polls.2016.clinton =  mean(national.polls.2016.Aplus$rawpoll_clinton)

#Challenger party candidate's average support from A+ grade polls
Aplus.polls.2016.trump =  mean(national.polls.2016.Aplus$rawpoll_trump)


#A grade national polls
national.polls.2016.A <-
    national.polls.2016 %>%
    filter(grade == "A")

#Incumbent party candidate's average support from A grade polls
A.polls.2016.clinton = mean(national.polls.2016.A$rawpoll_clinton)

#Challenger party candidate's average support from A grade polls
A.polls.2016.trump =  mean(national.polls.2016.A$rawpoll_trump)


#A- grade national polls
national.polls.2016.Aminus <-
  national.polls.2016 %>%
  filter(grade == "A-")

#Incumbent party candidate's average support from A- grade polls
Aminus.polls.2016.clinton = mean(national.polls.2016.Aminus$rawpoll_clinton)

#Challenger party candidate's average support from A- grade polls
Aminus.polls.2016.trump =  mean(national.polls.2016.Aminus$rawpoll_trump)

#Weights for each of the "A" graded polling averages
Aplus = 0.75
A = 0.2
Aminus = 0.05

#Weighted average support for the incumbent party candidate 2016
polls.weighted.2016.clinton = ((Aplus*Aplus.polls.2016.clinton) +
      (A*A.polls.2016.clinton) + (Aminus*Aminus.polls.2016.clinton) )                         
polls.weighted.2016.clinton

#Weighted average support for the challenger party candidate 2016
polls.weighted.2016.trump = ((Aplus*Aplus.polls.2016.trump) +
           (A*A.polls.2016.trump) + (Aminus*Aminus.polls.2016.trump) )                         
polls.weighted.2016.trump


#Second Component: 2nd Quarter GDP


#second quarter GDP data
dat_econ <- unique(dat[!is.na(dat$GDP_growth_qt),])
dat_econ_inc <- dat_econ[dat_econ$incumbent_party,]
dat_econ_chl <- dat_econ[!dat_econ$incumbent_party,]

#out-of-sample 2016 prediction from 2nd quarter GDP model
mod_econ_inc_ <- lm(pv ~ GDP_growth_qt, data = dat_econ_inc[dat_econ_inc$year != 2016,])
mod_econ_chl_ <- lm(pv ~ GDP_growth_qt, data = dat_econ_chl[dat_econ_chl$year != 2016,])
pred_econ_inc <- predict(mod_econ_inc_, dat_econ_inc[dat_econ_inc$year == 2016,])
pred_econ_chl <- predict(mod_econ_chl_, dat_econ_chl[dat_econ_chl$year == 2016,])


#Model 1: First and Second Components Weighted Equally


#Equal weights for the weighted average support and 2nd quarter GDP predictions
W1 = 0.5
W2 = 0.5

#Model 1 prediction for 2016 incumbent party candidate
pred_inc = ((W1*polls.weighted.2016.clinton) + (W2*pred_econ_inc ))
pred_inc

#Model 1 prediction for 2016 challenger party candidate
pred_chl = ((W1*polls.weighted.2016.trump) + (W2*pred_econ_chl ))
pred_chl

# true values for incumbent and challenger vote shares in 2016
true_inc <- unique(dat$pv[dat$year == 2016 & dat$incumbent_party])
true_chl <- unique(dat$pv[dat$year == 2016 & !dat$incumbent_party])

#prediction error for incumbent party candidate 
prediction.error.1.inc = pred_inc - true_inc
prediction.error.1.inc 

#prediction error for challenger party candidate
prediction.error.1.chl = pred_chl - true_chl
prediction.error.1.chl

#total error
new.model.error1 = abs(prediction.error.1.inc ) + abs(prediction.error.1.chl)
new.model.error1


#######################################################################

#Model 2: fundamentals-only model

#second-quarter GDP data and model
dat_econ <- unique(dat[!is.na(dat$GDP_growth_qt),])
dat_econ_inc <- dat_econ[dat_econ$incumbent_party,]
dat_econ_chl <- dat_econ[!dat_econ$incumbent_party,]
mod_econ_inc <- lm(pv ~ GDP_growth_qt, data = dat_econ_inc)
mod_econ_chl <- lm(pv ~ GDP_growth_qt, data = dat_econ_chl)

#Model 2 out-of-sample prediction for 2016
mod_econ_inc_ <- lm(pv ~ GDP_growth_qt, data = dat_econ_inc[dat_econ_inc$year != 2016,])
mod_econ_chl_ <- lm(pv ~ GDP_growth_qt, data = dat_econ_chl[dat_econ_chl$year != 2016,])
pred_econ_inc <- predict(mod_econ_inc_, dat_econ_inc[dat_econ_inc$year == 2016,])
pred_econ_chl <- predict(mod_econ_chl_, dat_econ_chl[dat_econ_chl$year == 2016,])

#Model 2 prediction for 2016 incumbent party candidate
pred_econ_inc 

#Model 2 prediction for 2016 challenger party candidate
pred_econ_chl 

#prediction error for incumbent party candidate 
prediction.error.2.inc = pred_econ_inc - true_inc
prediction.error.2.inc 

#prediction error for challenger party candidate 
prediction.error.2.chl = pred_econ_chl - true_chl
prediction.error.2.chl

#total error
new.model.error2 = abs(prediction.error.2.inc ) + abs(prediction.error.2.chl)
new.model.error2

###############################################

#Model 3: adjusted polls-only model

#avg support data and model
dat_poll <- dat[!is.na(dat$avg_support),]
dat_poll_inc <- dat_poll[dat_poll$incumbent_party,]
dat_poll_chl <- dat_poll[!dat_poll$incumbent_party,]
mod_poll_inc <- lm(pv ~ avg_support, data = dat_poll_inc)
mod_poll_chl <- lm(pv ~ avg_support, data = dat_poll_chl)

#Model 3 out-of-sample prediction for 2016
mod_poll_inc_ <- lm(pv ~ avg_support, data = dat_poll_inc[dat_poll_inc$year != 2016,])
mod_poll_chl_ <- lm(pv ~ avg_support, data = dat_poll_chl[dat_poll_chl$year != 2016,])
pred_poll_inc <- predict(mod_poll_inc_, dat_poll_inc[dat_poll_inc$year == 2016,])
pred_poll_chl <- predict(mod_poll_chl_, dat_poll_chl[dat_poll_chl$year == 2016,])

#Model 3 prediction for 2016 incumbent party candidate
pred_poll_inc

#Model 3 prediction for 2016 challenger party candidate
pred_poll_chl

#prediction error for incumbent party candidate
prediction.error.3.inc = pred_poll_inc - true_inc
prediction.error.3.inc 

#prediction error for challenger party candidate
prediction.error.3.chl = pred_poll_chl - true_chl
prediction.error.3.chl

#total error
new.model.error3 = abs(prediction.error.3.inc  ) + abs(prediction.error.3.chl)
new.model.error3

###########################################

#Model 4: adjusted polls + fundamentals model

#avg support and second quarter GDP data plus model
dat_plus <- dat[!is.na(dat$avg_support) & !is.na(dat$GDP_growth_qt),]
dat_plus_inc <- dat_plus[dat_plus$incumbent_party,]
dat_plus_chl <- dat_plus[!dat_plus$incumbent_party,]
mod_plus_inc <- lm(pv ~ avg_support + GDP_growth_qt, data = dat_plus_inc)
mod_plus_chl <- lm(pv ~ avg_support + GDP_growth_qt, data = dat_plus_chl)

#Model 4 out-of-sample prediction for 2016
mod_plus_inc_ <- lm(pv ~ GDP_growth_qt + avg_support, data = dat_plus_inc[dat_poll_inc$year != 2016,])
mod_plus_chl_ <- lm(pv ~ GDP_growth_qt + avg_support, data = dat_plus_chl[dat_poll_chl$year != 2016,])
pred_plus_inc <- predict(mod_plus_inc_, dat_plus_inc[dat_plus_inc$year == 2016,])
pred_plus_chl <- predict(mod_plus_chl_, dat_plus_chl[dat_plus_chl$year == 2016,])

#Model 4 prediction for 2016 incumbent party candidate
pred_plus_inc

#Model 4 prediction for 2016 challenger party candidate
pred_plus_chl

#prediction error for incumbent party candidate
prediction.error.4.inc = pred_plus_inc - true_inc
prediction.error.4.inc 

#prediction error for challenger party candidate
prediction.error.4.chl = pred_plus_chl - true_chl
prediction.error.4.chl

#total error
new.model.error4 = abs(prediction.error.4.inc  ) + abs(prediction.error.4.chl)
new.model.error4

##################################

#Model 3 is the model we will use for predictions

#current avg support data 
dat_2020_inc <- data.frame(avg_support = 43.6)
dat_2020_chl <- data.frame(avg_support = 50.4)

#incumbent party candidate predictions 2020
inc_prediction = predict(mod_poll_inc, newdata = dat_2020_inc)
inc_prediction

#challenger party candidate predictions 2020
chl_prediction = predict(mod_poll_chl, newdata = dat_2020_chl)
chl_prediction

# prediction interval for incumbent party prediction
predict(mod_poll_inc, newdata = dat_2020_inc, interval="prediction")

# prediction interval for challenger party prediction
predict(mod_poll_chl, newdata = dat_2020_chl, interval="prediction")

#average poll support vs. incumbent popular vote share and 2020 prediction
dat %>%
  filter(incumbent_party == "TRUE") %>%
  ggplot(aes(x=avg_support, y=pv,
             label=year)) + 
  geom_point()+
  geom_point(x = 43.6, y= inc_prediction, color = "blue")+
  annotate("text", x = 43.6+2, y = inc_prediction+1,
           size = 3.5,label = "2020")+
  geom_text(hjust = 0, nudge_x = 0.05, nudge_y = 1, size = 3.5) +
  geom_hline(yintercept=50, lty=2) +
  geom_vline(xintercept=50, lty=2) + # median
  ggtitle("") +
  scale_x_continuous(limit = c(30, 65))+
  xlab( "Average poll support") +
  ylab("Incumbent party's national popular vote share") +
  theme_bw()

#average poll support vs. challenger popular vote share and 2020 prediction
dat %>%
  filter(incumbent_party == "FALSE") %>%
  ggplot(aes(x=avg_support, y=pv,
             label=year)) + 
  geom_point()+
  geom_point(x = 50.4, y= chl_prediction, color = "blue")+
  annotate("text", x = 50.4 +2, y = chl_prediction+1,
           size = 3.5,label = "2020")+
  geom_text(hjust = 0, nudge_x = 0.05, nudge_y = 1, size = 3.5) +
  geom_hline(yintercept=50, lty=2) +
  geom_vline(xintercept=50, lty=2) + # median
  ggtitle("") +
  scale_x_continuous(limit = c(30, 65))+
  xlab( "Average poll support") +
  ylab("Challenger party's national popular vote share") +
  theme_bw()

