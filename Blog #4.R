### October 3, 2020
### Alexander Sigua
### R code for Blog Post #4 

## install packages
library(tidyverse)
library(ggplot2)

## set working directory
setwd("~/Downloads")

#read data sets
popvote_df    <- read_csv("popvote_1948-2016.csv")
economy_df    <- read_csv("econ.csv")
approval_df   <- read_csv("approval_gallup_1941-2020.csv")
poll_df       <- read_csv("pollavg_1968-2016.csv")

### Incumbency Status vs. Two-Party Popular Vote Share

# Historic pv2p share for incumbent candidates only
incumbent_pv2p = popvote_df$pv2p[popvote_df$incumbent == TRUE]
summary(incumbent_pv2p)

# Historic pv2p share for non-incumbent candidates only
non_incumbent_pv2p = popvote_df$pv2p[popvote_df$incumbent == FALSE]
summary(non_incumbent_pv2p)

# boxplots for two-party popular vote percentages, separated by incumbency status
boxplot(incumbent_pv2p, non_incumbent_pv2p,
        horizontal=FALSE,
        names=c("Incumbents","Non-Incumbents"),
        col=c("dodgerblue","dodgerblue4"),
        ylab="Two-Party Popular Vote (%)",
        main=""
        )

####################### Time For Change Model ########################

# time-for-change data set, comprised of second-quarter GDP, 
# approval ratings, incumbency status and popular vote data sets
# filtered for only incumbent party candidates
tfc_df <- popvote_df %>%
  filter(incumbent_party) %>%
  select(year, candidate, party, pv, pv2p, incumbent) %>%
  inner_join(
    approval_df %>% 
      group_by(year, president) %>% 
      slice(1) %>% 
      mutate(net_approve=approve-disapprove) %>%
      select(year, incumbent_pres=president, net_approve, poll_enddate),
    by="year"
  ) %>%
  inner_join(
    economy_df %>%
      filter(quarter == 2) %>%
      select(GDP_growth_qt, year),
    by="year"
  )

# time for change model 
tfc_model <- lm(pv2p ~ net_approve + GDP_growth_qt + incumbent, data= tfc_df)
summary(tfc_model)

###### In-Sample Fit

#r-squared value: 0.6847874
summary(tfc_model)$r.squared

# the mean squared error: 2.874799
mse <- mean((tfc_model$fitted.values - tfc_model$model$pv2p)^2)
sqrt(mse)

###### Out-Of-Sample Error

#leaving one out validation: -2.856384
outsamp_mod  <- lm(pv2p ~ net_approve + GDP_growth_qt + incumbent,
                   tfc_df[tfc_df$year != 2016,])
outsamp_pred <- predict(outsamp_mod, tfc_df[tfc_df$year == 2016,])
outsamp_true <- tfc_df$pv2p[tfc_df$year == 2016] 
outsamp_pred - outsamp_true


#cross validation: 1.45034
outsamp_errors <- sapply(1:1000, function(i){
  years_outsamp <- sample(tfc_df$year, 8)
  outsamp_mod <- lm(pv2p ~ net_approve + GDP_growth_qt + incumbent,
                    tfc_df[!(tfc_df$year %in% years_outsamp),])
  outsamp_pred <- predict(outsamp_mod,
                          newdata = tfc_df[tfc_df$year %in% years_outsamp,])
  outsamp_true <- tfc_df$pv2p[tfc_df$year %in% years_outsamp]
  mean(outsamp_pred - outsamp_true)
})

#mean out of sample error
mean(abs(outsamp_errors))

####################### Week 3 Model ###############################

# joining poll data to existing time for change data set
new_dat <- tfc_df  %>% 
  left_join(poll_df %>% 
              filter(weeks_left == 6) %>% 
              group_by(year,party) %>% 
              summarise(avg_support=mean(avg_support)))

#avg support data and model
dat_poll <- new_dat[!is.na(new_dat$avg_support),]
poll_model <- lm(pv2p ~ avg_support, data = dat_poll)
summary(poll_model)

###### In-Sample Fit

#r-squared value: 0.720662
summary(poll_model)$r.squared

# the mean squared error: 2.500999
mse2 <- mean((poll_model$fitted.values - poll_model$model$pv2p)^2)
sqrt(mse2)

###### Out-Of-Sample Error

#leaving one out validation: -0.9078538 
outsamp_mod2  <- lm(pv2p ~ avg_support,
                   dat_poll[dat_poll$year != 2016,])
outsamp_pred2 <- predict(outsamp_mod2, dat_poll[dat_poll$year == 2016,])
outsamp_true2 <- dat_poll$pv2p[dat_poll$year == 2016] 
outsamp_pred2 - outsamp_true2

#cross validation: 1.559656
outsamp_errors2 <- sapply(1:1000, function(i){
  years_outsamp2 <- sample(dat_poll$year, 8)
  outsamp_mod2 <- lm(pv2p ~ avg_support,
                    dat_poll[!(dat_poll$year %in% years_outsamp2),])
  outsamp_pred2 <- predict(outsamp_mod2,
                          newdata = dat_poll[dat_poll$year %in% years_outsamp2,])
  outsamp_true2 <- dat_poll$pv2p[dat_poll$year %in% years_outsamp2]
  mean(outsamp_pred2 - outsamp_true2)
})

#mean out of sample error
mean(abs(outsamp_errors2))

######################### Model Predictions ##########################

######### Time-For-Change Model ############

#2020 second quarter GDP data
GDP_SecondQuarter_2020 <- economy_df %>%
  subset(year == 2020 & quarter == 2) %>%
  select(GDP_growth_qt)

#most recent approval ratings in 2020
net_approval_2020 = 41-56

#data set for 2020
dat_2020 <- data.frame(net_approve = net_approval_2020, 
            GDP_growth_qt = GDP_SecondQuarter_2020, incumbent = TRUE)

# TFC model 2020 prediction for Trump
prediction_2020 = predict(tfc_model, newdata = dat_2020)
prediction_2020

#prediction interval
predict(tfc_model, newdata = dat_2020, interval="prediction")

############# Week 3 Model #################

#recent average support data for Trump in 2020 (fivethirtyeight)
poll_2020_inc <- data.frame(avg_support = 42.9)

# week 3 model 2020 prediction for Trump
poll_prediction_2020 = predict(poll_model, newdata = poll_2020_inc)
poll_prediction_2020

#prediction interval
predict(poll_model, newdata = poll_2020_inc, interval="prediction")






