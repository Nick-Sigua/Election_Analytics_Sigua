### September 18th, 2020
### Alexander Sigua
### R code for Blog Post #2 ("The Economy in Popular Vote Predictions")

## install packages
library(tidyverse)
library(ggplot2)

## set working directory
setwd("~/Downloads")

# read data sets 
economy_df <- read_csv("econ.csv") 
popvote_df <- read_csv("popvote_1948-2016.csv") 

# merge popular vote and economic variable data sets 
# combined data set displays second quarter election-year economic data and  
# incumbent candidates' popular vote share from 1948-2016
dat <- popvote_df %>% 
  filter(incumbent_party == TRUE) %>%
  select(year, winner, pv2p) %>%
  left_join(economy_df %>% filter(quarter == 2))

# scatter plots matrices for relationship between vote share and economic variables 

#Popular vote share vs. GDP, Inflation and RDI
pairs(~pv2p+GDP+inflation+RDI,data=dat,
      lower.panel = NULL,
      main="Vote Share vs. GDP, Inflation, and RDI")

#Popular vote share vs. Quarterly GDP growth and Yearly GDP growth
pairs(~pv2p+GDP_growth_qt+GDP_growth_yr,data=dat,
      lower.panel = NULL,
      main="Vote Share vs. GDP Quarter and Yearly Growth")

#Popular vote share vs. RDI growth and Unemployment
pairs(~pv2p+RDI_growth+unemployment,data=dat,
      lower.panel = NULL,
      main="Vote Share vs RDI Growth and Unemployment")

#Popular vote share vs. Stock open, Stock close, and Stock volume
pairs(~pv2p+stock_open+stock_close+stock_volume,data=dat,
      lower.panel = NULL,
      main="Vote Share vs Stock Open, Close, and Volume")


#MODEL 1
# r squared: 0.3261369, MSE: 4.203311,
# leave one out validation: -0.8487183 
# cross validation: 1.81753
# prediction: 21.25928

### Linear Regression Model for Quarterly GDP Growth
lm_econ <- lm(pv2p ~ GDP_growth_qt, data = dat)
summary(lm_econ)

###Evaluating Model Fit

# R squared value
summary(lm_econ)$r.squared

# the mean squared error 
mse <- mean((lm_econ$model$pv2p - lm_econ$fitted.values)^2)
sqrt(mse)

## leave-one-out validation
outsamp_mod  <- lm(pv2p ~ GDP_growth_qt, dat[dat$year != 2016,])
outsamp_pred <- predict(outsamp_mod, dat[dat$year == 2016,])
outsamp_true <- dat$pv2p[dat$year == 2016] 
outsamp_pred - outsamp_true

## cross-validation (1000 runs)
outsamp_errors <- sapply(1:1000, function(i){
  years_outsamp <- sample(dat$year, 8)
  outsamp_mod <- lm(pv2p ~ GDP_growth_qt,
                    dat[!(dat$year %in% years_outsamp),])
  outsamp_pred <- predict(outsamp_mod,
                  newdata = dat[dat$year %in% years_outsamp,])
  outsamp_true <- dat$pv2p[dat$year %in% years_outsamp]
  mean(outsamp_pred - outsamp_true)
})

#mean out of sample error 
mean(abs(outsamp_errors))

### Prediction for 2020
GDP_new <- economy_df %>%
    subset(year == 2020 & quarter == 2) %>%
    select(GDP_growth_qt)

prediciton_2020 = predict(lm_econ, GDP_new)
prediciton_2020

# prediction interval
predict(lm_econ, GDP_new, interval="prediction")

##################################################

# Model 2: GDP_growth_yr
#r squared: 0.2961565, MSE:  4.295797 
# leave one out validation: -2.739504
# cross validation: 1.839578
# prediction: 34.21037

### Linear Regression Model for Yearly GDP Growth
lm_econ2 <- lm(pv2p ~ GDP_growth_yr, data = dat)
summary(lm_econ2)

###Evaluating Model Fit

# R squared value
summary(lm_econ2)$r.squared

# the mean squared error 
mse <- mean((lm_econ2$model$pv2p - lm_econ2$fitted.values)^2)
sqrt(mse)

# leave one out validation
outsamp_mod  <- lm(pv2p ~ GDP_growth_yr, dat[dat$year != 2016,])
outsamp_pred <- predict(outsamp_mod, dat[dat$year == 2016,])
outsamp_true <- dat$pv2p[dat$year == 2016] 
outsamp_pred - outsamp_true

#cross validation
outsamp_errors2 <- sapply(1:1000, function(i){
  years_outsamp <- sample(dat$year, 8)
  outsamp_mod <- lm(pv2p ~ GDP_growth_yr,
                    dat[!(dat$year %in% years_outsamp),])
  outsamp_pred <- predict(outsamp_mod,
                          newdata = dat[dat$year %in% years_outsamp,])
  outsamp_true <- dat$pv2p[dat$year %in% years_outsamp]
  mean(outsamp_pred - outsamp_true)
})

#mean out of sample error
mean(abs(outsamp_errors2))

### Prediction for 2020
GDP_new2 <- economy_df %>%
  subset(year == 2020 & quarter == 2) %>%
  select(GDP_growth_yr)

predict(lm_econ2, GDP_new2)

##################################################

# Model 3: GDP
#r squared: 0.03929979, MSE: 5.018797, 
# leave one out validation: -1.369452
# cross validation: 2.019815
# prediction: 50.22322

### Linear Regression Model for GDP
lm_econ3 <- lm(pv2p ~ GDP, data = dat)
summary(lm_econ3)

###Evaluating Model Fit

# R squared value
summary(lm_econ3)$r.squared

# the mean squared error 
mse <- mean((lm_econ3$model$pv2p - lm_econ3$fitted.values)^2)
sqrt(mse)

# leave one out validation
outsamp_mod  <- lm(pv2p ~ GDP, dat[dat$year != 2016,])
outsamp_pred <- predict(outsamp_mod, dat[dat$year == 2016,])
outsamp_true <- dat$pv2p[dat$year == 2016] 
outsamp_pred - outsamp_true

#cross validation
outsamp_errors3 <- sapply(1:1000, function(i){
  years_outsamp <- sample(dat$year, 8)
  outsamp_mod <- lm(pv2p ~ GDP,
                    dat[!(dat$year %in% years_outsamp),])
  outsamp_pred <- predict(outsamp_mod,
                          newdata = dat[dat$year %in% years_outsamp,])
  outsamp_true <- dat$pv2p[dat$year %in% years_outsamp]
  mean(outsamp_pred - outsamp_true)
})

#mean out of sample error
mean(abs(outsamp_errors3))

### Prediction for 2020
GDP_new3 <- economy_df %>%
  subset(year == 2020 & quarter == 2) %>%
  select(GDP)

predict(lm_econ3, GDP_new3)

##################################################

# Model 4: RDI
#r squared: 0.08013714, MSE: 4.861243, 
# leave one out validation: -2.332925
# cross validation: N/A
# prediction: 48.31594 

### Linear Regression Model for RDI
lm_econ4 <- lm(pv2p ~ RDI, data = dat)
summary(lm_econ4)

###Evaluating Model Fit

# R squared value
summary(lm_econ4)$r.squared

# the mean squared error 
mse <- mean((lm_econ4$model$pv2p - lm_econ4$fitted.values)^2)
sqrt(mse)

# leave one out validation
outsamp_mod  <- lm(pv2p ~ RDI, dat[dat$year != 2016,])
outsamp_pred <- predict(outsamp_mod, dat[dat$year == 2016,])
outsamp_true <- dat$pv2p[dat$year == 2016] 
outsamp_pred - outsamp_true

#cross validation
outsamp_errors4 <- sapply(1:1000, function(i){
  years_outsamp <- sample(dat$year, 8)
  outsamp_mod <- lm(pv2p ~ RDI,
                    dat[!(dat$year %in% years_outsamp),])
  outsamp_pred <- predict(outsamp_mod,
                          newdata = dat[dat$year %in% years_outsamp,])
  outsamp_true <- dat$pv2p[dat$year %in% years_outsamp]
  mean(outsamp_pred - outsamp_true)
})

#mean out of sample error
mean(abs(outsamp_errors4))

### Prediction for 2020
GDP_new4 <- economy_df %>%
  subset(year == 2020 & quarter == 2) %>%
  select(RDI)

predict(lm_econ4, GDP_new4)

##################################################

# Model 5: RDI_growth
#r squared: 0.2576564, MSE: 4.367051
# leave one out validation: -3.191615
# cross validation: N/A
# prediction: 80.33064 

### Linear Regression Model for RDI Growth
lm_econ5 <- lm(pv2p ~ RDI_growth, data = dat)
summary(lm_econ5)

###Evaluating Model Fit

# R squared value
summary(lm_econ5)$r.squared

# the mean squared error 
mse <- mean((lm_econ5$model$pv2p - lm_econ5$fitted.values)^2)
sqrt(mse)

# leave one out validation
outsamp_mod  <- lm(pv2p ~ RDI_growth, dat[dat$year != 2016,])
outsamp_pred <- predict(outsamp_mod, dat[dat$year == 2016,])
outsamp_true <- dat$pv2p[dat$year == 2016] 
outsamp_pred - outsamp_true

#cross validation
outsamp_errors5 <- sapply(1:1000, function(i){
  years_outsamp <- sample(dat$year, 8)
  outsamp_mod <- lm(pv2p ~ RDI_growth,
                    dat[!(dat$year %in% years_outsamp),])
  outsamp_pred <- predict(outsamp_mod,
                          newdata = dat[dat$year %in% years_outsamp,])
  outsamp_true <- dat$pv2p[dat$year %in% years_outsamp]
  mean(outsamp_pred - outsamp_true)
})

#mean out of sample error
mean(abs(outsamp_errors5))

### Prediction for 2020
GDP_new5 <- economy_df %>%
  subset(year == 2020 & quarter == 2) %>%
  select(RDI_growth)

predict(lm_econ5, GDP_new5)

##################################################

# Model 6: Inflation
#r squared: 0.04921914, MSE: 4.99282
# leave one out validation: -1.500741
# cross validation: 2.040818
# prediction: 49.75127 

### Linear Regression Model for Inflation
lm_econ6 <- lm(pv2p ~ inflation, data = dat)
summary(lm_econ6)

###Evaluating Model Fit

# R squared value
summary(lm_econ6)$r.squared

# the mean squared error 
mse <- mean((lm_econ6$model$pv2p - lm_econ6$fitted.values)^2)
sqrt(mse)

# leave one out validation
outsamp_mod  <- lm(pv2p ~ inflation, dat[dat$year != 2016,])
outsamp_pred <- predict(outsamp_mod, dat[dat$year == 2016,])
outsamp_true <- dat$pv2p[dat$year == 2016] 
outsamp_pred - outsamp_true

#cross validation
outsamp_errors6 <- sapply(1:1000, function(i){
  years_outsamp <- sample(dat$year, 8)
  outsamp_mod <- lm(pv2p ~ inflation,
                    dat[!(dat$year %in% years_outsamp),])
  outsamp_pred <- predict(outsamp_mod,
                          newdata = dat[dat$year %in% years_outsamp,])
  outsamp_true <- dat$pv2p[dat$year %in% years_outsamp]
  mean(outsamp_pred - outsamp_true)
})

#mean out of sample error
mean(abs(outsamp_errors6))

### Prediction for 2020
GDP_new6 <- economy_df %>%
  subset(year == 2020 & quarter == 2) %>%
  select(inflation)

predict(lm_econ6, GDP_new6)

##################################################

# Model 7: Unemployment 
#r squared: 4.516349e-05, MSE: 5.120306
# leave one out validation: 0.8873312
# cross validation: 2.251268
# prediction: 52.17693 

### Linear Regression Model for Unemployment
lm_econ7 <- lm(pv2p ~ unemployment, data = dat)
summary(lm_econ7)

###Evaluating Model Fit

# R squared value
summary(lm_econ7)$r.squared

# the mean squared error 
mse <- mean((lm_econ7$model$pv2p - lm_econ7$fitted.values)^2)
sqrt(mse)

# leave one out validation
outsamp_mod  <- lm(pv2p ~ unemployment, dat[dat$year != 2016,])
outsamp_pred <- predict(outsamp_mod, dat[dat$year == 2016,])
outsamp_true <- dat$pv2p[dat$year == 2016] 
outsamp_pred - outsamp_true

#cross validation
outsamp_errors7 <- sapply(1:1000, function(i){
  years_outsamp <- sample(dat$year, 8)
  outsamp_mod <- lm(pv2p ~ unemployment,
                    dat[!(dat$year %in% years_outsamp),])
  outsamp_pred <- predict(outsamp_mod,
                          newdata = dat[dat$year %in% years_outsamp,])
  outsamp_true <- dat$pv2p[dat$year %in% years_outsamp]
  mean(outsamp_pred - outsamp_true)
})

#mean out of sample error
mean(abs(outsamp_errors7))

### Prediction for 2020
GDP_new7 <- economy_df %>%
  subset(year == 2020 & quarter == 2) %>%
  select(unemployment)

predict(lm_econ7, GDP_new7)

##################################################

# Model 8: Stock Open
#r squared: 0.03966285, MSE: 5.017849
# leave one out validation: -2.706793
# cross validation: 2.104414
# prediction: 48.32853

### Linear Regression Model for Stock Open
lm_econ8 <- lm(pv2p ~ stock_open, data = dat)
summary(lm_econ8)

###Evaluating Model Fit

# R squared value
summary(lm_econ8)$r.squared

# the mean squared error 
mse <- mean((lm_econ8$model$pv2p - lm_econ8$fitted.values)^2)
sqrt(mse)

# leave one out validation
outsamp_mod  <- lm(pv2p ~ stock_open, dat[dat$year != 2016,])
outsamp_pred <- predict(outsamp_mod, dat[dat$year == 2016,])
outsamp_true <- dat$pv2p[dat$year == 2016] 
outsamp_pred - outsamp_true

#cross validation
outsamp_errors8 <- sapply(1:1000, function(i){
  years_outsamp <- sample(dat$year, 8)
  outsamp_mod <- lm(pv2p ~ stock_open,
                    dat[!(dat$year %in% years_outsamp),])
  outsamp_pred <- predict(outsamp_mod,
                          newdata = dat[dat$year %in% years_outsamp,])
  outsamp_true <- dat$pv2p[dat$year %in% years_outsamp]
  mean(outsamp_pred - outsamp_true)
})

#mean out of sample error
mean(abs(outsamp_errors8))

### Prediction for 2020
GDP_new8 <- economy_df %>%
  subset(year == 2020 & quarter == 2) %>%
  select(stock_open)

predict(lm_econ8, GDP_new8)

##################################################

# Model 9: Stock Close
#r squared: 0.03935155, MSE: 5.018662
# leave one out validation: -2.775858
# cross validation: 1.967143
# prediction: 47.98323

### Linear Regression Model for Stock Close
lm_econ9 <- lm(pv2p ~ stock_close, data = dat)
summary(lm_econ9)

###Evaluating Model Fit

# R squared value
summary(lm_econ9)$r.squared

# the mean squared error 
mse <- mean((lm_econ9$model$pv2p - lm_econ9$fitted.values)^2)
sqrt(mse)

# leave one out validation
outsamp_mod  <- lm(pv2p ~ stock_close, dat[dat$year != 2016,])
outsamp_pred <- predict(outsamp_mod, dat[dat$year == 2016,])
outsamp_true <- dat$pv2p[dat$year == 2016] 
outsamp_pred - outsamp_true

#cross validation
outsamp_errors9 <- sapply(1:1000, function(i){
  years_outsamp <- sample(dat$year, 8)
  outsamp_mod <- lm(pv2p ~ stock_close,
                    dat[!(dat$year %in% years_outsamp),])
  outsamp_pred <- predict(outsamp_mod,
                          newdata = dat[dat$year %in% years_outsamp,])
  outsamp_true <- dat$pv2p[dat$year %in% years_outsamp]
  mean(outsamp_pred - outsamp_true)
})

#mean out of sample error
mean(abs(outsamp_errors9))

### Prediction for 2020
GDP_new9 <- economy_df %>%
  subset(year == 2020 & quarter == 2) %>%
  select(stock_close)

predict(lm_econ9, GDP_new9)

##################################################

# Model 10: Stock Volume
#r squared: 0.04940569, MSE: 4.99233
# leave one out validation: -2.242903 
# cross validation: 2.265194
# prediction: 48.18031

### Linear Regression Model for Stock Volume
lm_econ10 <- lm(pv2p ~ stock_volume, data = dat)
summary(lm_econ10)

###Evaluating Model Fit

# R squared value
summary(lm_econ10)$r.squared

# the mean squared error 
mse <- mean((lm_econ10$model$pv2p - lm_econ10$fitted.values)^2)
sqrt(mse)

# leave one out validation
outsamp_mod  <- lm(pv2p ~ stock_volume, dat[dat$year != 2016,])
outsamp_pred <- predict(outsamp_mod, dat[dat$year == 2016,])
outsamp_true <- dat$pv2p[dat$year == 2016] 
outsamp_pred - outsamp_true

#cross validation
outsamp_errors10 <- sapply(1:1000, function(i){
  years_outsamp <- sample(dat$year, 8)
  outsamp_mod <- lm(pv2p ~ stock_volume,
                    dat[!(dat$year %in% years_outsamp),])
  outsamp_pred <- predict(outsamp_mod,
                          newdata = dat[dat$year %in% years_outsamp,])
  outsamp_true <- dat$pv2p[dat$year %in% years_outsamp]
  mean(outsamp_pred - outsamp_true)
})

#mean out of sample error
mean(abs(outsamp_errors10))

### Prediction for 2020
GDP_new10 <- economy_df %>%
  subset(year == 2020 & quarter == 2) %>%
  select(stock_volume)

############################################################

# Scatter plot of second quarter GDP growth vs popular vote share (1948-2016) 
# Prediction for 2020 denoted as blue dot
dat %>%
  ggplot(aes(x=GDP_growth_qt, y=pv2p,
             label=year)) + 
  geom_point()+
  geom_point(x = GDP_new$GDP_growth_qt, y= prediciton_2020, color = "blue")+
  annotate("text", x = GDP_new$GDP_growth_qt+2, y = prediciton_2020+1.5,
           size = 3.5,label = "2020 prediction")+
  geom_text(hjust = 0, nudge_x = 0.05, nudge_y = 1.5, size = 3.5) +
  geom_hline(yintercept=50, lty=2) +
  geom_vline(xintercept=0.01, lty=2) + # median
  ggtitle("Second quarter GDP growth vs. popular vote share") +
  scale_x_continuous(limit = c(-10, 4))+
  scale_y_continuous(limit = c(20, 65))+
  xlab( "Second quarter GDP growth") +
  ylab("Incumbent party's national popular vote share") +
  theme_bw()





