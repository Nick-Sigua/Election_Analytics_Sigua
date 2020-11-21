### November 21, 2020
### Post Election Reflection
### Alexander Sigua

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
state_results_2020 <- read_excel("stateresults_2020.xlsx")

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

################ Adding pv2p and win margins columns 

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


############################# Actual 2020 State Results ###########################

# add state abbreviations to state column in state_results_2020 data set
state_results_2020$state <- state.abb[match(state_results_2020$state, state.name)]

# join state results data to state glm forecasts 
state_forecasts_results <- state_glm_forecast_outputs %>% 
  left_join(state_results_2020, by = "state")

# adding DC row to state_forecasts_results 
state_forecasts_results <- state_forecasts_results %>% add_row(state = "DC", pv_D = 69.93275, pv_R = 20.38461, 
pv2p_D = 77.43002,  pv2p_R = 22.56998, win.margins = 54.86, D_pv2p_frac = 0.9441612355, R_pv2p_frac= 0.05583876449)

#adding pv2p columns for actual results (pv2p_frac times 100)
#pvp2 column actual for dems
state_forecasts_results$pv2p_D_actual <- 
(state_forecasts_results$D_pv2p_frac)*100

#pvp2 column actual for reps
state_forecasts_results$pv2p_R_actual <- 
  (state_forecasts_results$R_pv2p_frac)*100

# histogram of distribution for Trump's pv2p error (predicted - actual)
error_R = state_forecasts_results$pv2p_R - state_forecasts_results$pv2p_R_actual
hist(error_R, main="",
        xlab="Predicted pv2p - Actual pv2p for Trump (%)")

# RMSE for pv2p (predicted - actual)
mse <- mean((state_forecasts_results$pv2p_R - state_forecasts_results$pv2p_R_actual)^2)
sqrt(mse)

# adding pv2p_R absolute error column 
state_forecasts_results$pv2p_R_error <- 
  abs(state_forecasts_results$pv2p_R - state_forecasts_results$pv2p_R_actual)

# pv2p_R absolute error map 
plot_usmap(data = state_forecasts_results, regions = "states", labels= TRUE, values = "pv2p_R_error") +
  scale_fill_gradient(
    high = "red", 
    low = "white", 
    breaks = c(0,8,16), 
    limits = c(0,16),
    name = "pv2p_R absolute error (%)"
  ) + 
  theme(legend.position = "bottom") +
  labs(title = "") + 
  theme(plot.title = element_text(size = 15, hjust = 0.5))
theme_void()

# states with top 10 largest absolute errors (predicted - actual)
largest_state_errors = state_forecasts_results[state_forecasts_results$pv2p_R_error >= 6.9,]

# barplot of states with top 10 largest absolute errors (predicted - actual)
df = largest_state_errors[order(largest_state_errors$pv2p_R_error, decreasing = TRUE),]
barplot(df$pv2p_R_error, main= "", xlab = "State", ylab = "Absolute Predicted pv2p Error Margin (%)",
        names.arg=df$state)

# adding absolute win margins column
state_forecasts_results$win_margins_actual <-
  abs(state_forecasts_results$pv2p_R_actual- state_forecasts_results$pv2p_D_actual)

# states with top 10 largest absolute win margins  
largest_state_margins = state_forecasts_results[state_forecasts_results$win_margins_actual >= 30.5,]

# barplot of states with top 10 largest absolute win margins  
df2 = largest_state_margins[order(largest_state_margins$win_margins_actual, decreasing = TRUE),]
barplot(df2$win_margins_actual, main= "", xlab = "State", ylab = "Absolute Win Margins (%)",
        names.arg=df2$state)

# RMSE for states with top 10 win margins (blowout states)
mse3 <- mean((largest_state_margins$pv2p_R - largest_state_margins$pv2p_R_actual)^2)
sqrt(mse3)








