### October 31th, 2020
### Alexander Sigua
### R code for Final Election Prediction

## install packages
library(tidyverse)
library(ggplot2)
library(readxl)
library(usmap)

## set working directory
setwd("~/Downloads")

#read data sets
popvote_df <- read_csv("popvote_1948-2016.csv")
poll_df    <- read_csv("pollavg_1968-2016.csv")
polls2020    <- read_excel("polls2020.xlsx")
electoral_votes_2020 <- read_excel("electoral_votes.xlsx")

# merge popular vote and avg support data sets
# filtered for 6 weeks till election
dat <- popvote_df %>% 
  full_join(poll_df %>% 
              filter(weeks_left == 6) %>% 
              group_by(year,party) %>% 
              summarise(avg_support=mean(avg_support))) 

# restrict dat to 1968 and above
data = dat[dat$year >= 1968,]

# filter popular vote and average support data for democrats 
data_democrat = data  %>%  filter(party == "democrat")

# filter popular vote and average support data for republicans
data_republican = data  %>%  filter(party == "republican")


############## Average Support Model for Each Party ################

# avg support model (democrats)
poll_model_dem <- lm(pv ~ avg_support, data = data_democrat)
summary(poll_model_dem)

# avg support model (republicans)
poll_model_rep <- lm(pv ~ avg_support, data = data_republican)
summary(poll_model_rep)

###################### Model Validation #######################

####### Democrat Model

# avg support model (democrats)
poll_model_dem <- lm(pv ~ avg_support, data = data_democrat)
summary(poll_model_dem)

# R squared value
summary(poll_model_dem)$r.squared

# the mean squared error 
mse <- mean((poll_model_dem$model$pv - poll_model_dem$fitted.values)^2)
sqrt(mse)

# leave one out validation
outsamp_mod  <- lm(pv ~ avg_support, data_democrat[data_democrat$year != 2016,])
outsamp_pred <- predict(outsamp_mod, data_democrat[data_democrat$year == 2016,])
outsamp_true <- data_democrat$pv[data_democrat$year == 2016] 
outsamp_pred - outsamp_true

#cross validation
outsamp_errors <- sapply(1:1000, function(i){
  years_outsamp <- sample(data_democrat$year, 8)
  outsamp_mod <- lm(pv ~ avg_support,
                    data_democrat[!(data_democrat$year %in% years_outsamp),])
  outsamp_pred <- predict(outsamp_mod,
                          newdata = data_democrat[data_democrat$year %in% years_outsamp,])
  outsamp_true <- data_democrat$pv[data_democrat$year %in% years_outsamp]
  mean(outsamp_pred - outsamp_true)
})

#mean out of sample error
mean(abs(outsamp_errors))

###### Republican Model

# avg support model (republicans)
poll_model_rep <- lm(pv ~ avg_support, data = data_republican)
summary(poll_model_rep)

# R squared value
summary(poll_model_rep)$r.squared

# the mean squared error 
mse2 <- mean((poll_model_rep$model$pv - poll_model_rep$fitted.values)^2)
sqrt(mse2)

# leave one out validation
outsamp_mod2  <- lm(pv ~ avg_support, data_republican[data_republican$year != 2016,])
outsamp_pred2 <- predict(outsamp_mod2, data_republican[data_republican$year == 2016,])
outsamp_true2 <- data_republican$pv[data_republican$year == 2016] 
outsamp_pred2 - outsamp_true2

#cross validation
outsamp_errors2 <- sapply(1:1000, function(i){
  years_outsamp2 <- sample(data_republican$year, 8)
  outsamp_mod2 <- lm(pv ~ avg_support,
                     data_republican[!(data_republican$year %in% years_outsamp2),])
  outsamp_pred2 <- predict(outsamp_mod2,
                           newdata = data_republican[data_republican$year %in% years_outsamp2,])
  outsamp_true2 <- data_republican$pv[data_republican$year %in% years_outsamp2]
  mean(outsamp_pred2 - outsamp_true2)
})

#mean out of sample error
mean(abs(outsamp_errors2))

####################### National Election Predictions #########################

#current avg support data for Biden and Trump (RCP)
data_2020_dem <- data.frame(avg_support = 50.8)
data_2020_rep <- data.frame(avg_support = 43)

#democrat party candidate predictions 2020
dem_prediction = predict(poll_model_dem, newdata = data_2020_dem)
dem_prediction

#republican party candidate predictions 2020
rep_prediction = predict(poll_model_rep, newdata = data_2020_rep)
rep_prediction

#pv2p 
national_D_pv2p = dem_prediction/(dem_prediction+rep_prediction) *100
national_R_pv2p = rep_prediction/(dem_prediction+rep_prediction) *100
national_D_pv2p
national_R_pv2p

# prediction interval for democrat party prediction
predict(poll_model_dem, newdata = data_2020_dem, interval="prediction")

# prediction interval for republican party prediction
predict(poll_model_rep, newdata = data_2020_rep, interval="prediction")

###### Democratic Candidate 2020 Predicted Vote Share
data %>%
  filter(party == "democrat") %>%
  ggplot(aes(x=avg_support, y=pv,
             label=year)) + 
  geom_point()+
  geom_point(x = 50.8, y= dem_prediction, color = "blue")+
  annotate("text", x = 50.8+1, y = dem_prediction+0.5,
           size = 3.5,label = "2020")+
  geom_text(hjust = 0, nudge_x = 0.05, nudge_y = 0.5, size = 3.5) +
  geom_hline(yintercept=50, lty=2) +
  geom_vline(xintercept=50, lty=2) + # median
  ggtitle("") +
  scale_x_continuous(limit = c(30, 65))+
  xlab( "Average poll support") +
  ylab("Democratic party candidate's national popular vote share") +
  theme_bw()

###### Average Support Model Prediction (republican)
data %>%
  filter(party == "republican") %>%
  ggplot(aes(x=avg_support, y=pv,
             label=year)) + 
  geom_point()+
  geom_point(x = 43, y= rep_prediction, color = "blue")+
  annotate("text", x = 43+1, y = rep_prediction+0.5,
           size = 3.5,label = "2020")+
  geom_text(hjust = 0, nudge_x = 0.05, nudge_y = 0.5, size = 3.5) +
  geom_hline(yintercept=50, lty=2) +
  geom_vline(xintercept=50, lty=2) + # median
  ggtitle("") +
  scale_x_continuous(limit = c(30, 65))+
  xlab( "Average poll support") +
  ylab("Republican party candidate's national popular vote share") +
  theme_bw()

############## State Level Predictions based on Average Support Model ##################

state_glm_forecast <- list()
state_glm_forecast_outputs <- data.frame()
polls2020$state_abb <- state.abb[match(polls2020$state, state.name)]

for (s in unique(polls2020$state_abb)) {
  
  state_glm_forecast[[s]]$data_D <- polls2020 %>%  ###### AVG SUPPORT DATA DEM
    filter(state_abb == s, party == "democrat")
  
  state_glm_forecast[[s]]$data_R <- polls2020 %>% ###### AVG SUPPORT DATA REP
    filter(state_abb == s, party == "republican")  
  
state_glm_forecast_outputs <- 
  bind_rows(
      state_glm_forecast_outputs,
      cbind.data.frame(state = s,  
      pv_D = predict(poll_model_dem, 
                      newdata=state_glm_forecast[[s]]$data_D),
      pv_R = predict(poll_model_rep, 
                      newdata=state_glm_forecast[[s]]$data_R)
    )
)
}

################ Adding pv2p and winn margins columns 

## adding pv2p columns to state_glm_forecast_output data frame
# democrat pv2p column
state_glm_forecast_outputs$pv2p_D <- 
  ((state_glm_forecast_outputs$pv_D)/(state_glm_forecast_outputs$pv_D + state_glm_forecast_outputs$pv_R))*100

# republican pv2p column 
state_glm_forecast_outputs$pv2p_R <- 
  ((state_glm_forecast_outputs$pv_R)/(state_glm_forecast_outputs$pv_D + state_glm_forecast_outputs$pv_R))*100

# adding Biden win margins column to state_glm_forecast_output data frame
state_glm_forecast_outputs$win.margins <- 
  ((state_glm_forecast_outputs$pv2p_D - state_glm_forecast_outputs$pv2p_R)/(state_glm_forecast_outputs$pv2p_D + state_glm_forecast_outputs$pv2p_R))*100


############################ Win Margins Map 2020 ##############################

# win margins map based on predicted Biden pv2p win margin relative to Trump in each state
plot_usmap(data = state_glm_forecast_outputs, regions = "states", labels= TRUE, values = "win.margins") +
  scale_fill_gradient2(
    high = "blue", 
    mid = "white",
    low = "red", 
    breaks = c(-40,-20,0,20,40), 
    limits = c(-40,40),
    name = "win margin %"
  ) + 
  theme(legend.position = "bottom") +
  labs(title = "") + 
  theme(plot.title = element_text(size = 15, hjust = 0.5))
theme_void()

######################## Electoral Votes in 2020 ######################

# add state abbreviations to state column
electoral_votes_2020$state <- state.abb[match(electoral_votes_2020$state, state.name)]

# join electoral votes data to state glm pv2p forecasts 
state_forecasts_electoral <- state_glm_forecast_outputs %>% 
  left_join(electoral_votes_2020, by = "state")

# Biden Electoral Votes
biden_state_win = state_forecasts_electoral[state_forecasts_electoral$win.margins > 0,]
sum(biden_state_win$electoral_votes) + 3 # adding 3 from D.C votes 

# Trump Electoral Votes 
trump_state_win = state_forecasts_electoral[state_forecasts_electoral$win.margins < 0,]
sum(trump_state_win$electoral_votes)

# Washington D.C

#current avg support data in D.C
dat_2020_dem_DC <- data.frame(avg_support = 88)
dat_2020_rep_DC <- data.frame(avg_support = 10)

#democratic party candidate predictions 2020
dem_prediction_DC = predict(poll_model_dem, newdata = dat_2020_dem_DC)
dem_prediction_DC

#republican party candidate predictions 2020
rep_prediction_DC = predict(poll_model_rep, newdata = dat_2020_rep_DC)
rep_prediction_DC

state_DC_D_pv2p = dem_prediction_DC/(dem_prediction+rep_prediction) *100
state_DC_R_pv2p = rep_prediction_DC/(dem_prediction+rep_prediction) *100
state_DC_D_pv2p
state_DC_R_pv2p



