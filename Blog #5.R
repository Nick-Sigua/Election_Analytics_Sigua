### October 9th, 2020
### Alexander Sigua
### R code for Blog Post #5

## install packages
library(tidyverse)
library(ggplot2)
library(geofacet) 

## set working directory
setwd("~/Downloads")

## Loading and cleaning up-to-date poll averages
library(tidyverse)
poll_2020_url <- "https://projects.fivethirtyeight.com/2020-general-data/presidential_poll_averages_2020.csv"
poll_2020_df <- read_csv(poll_2020_url)
elxnday_2020 <- as.Date("11/3/2020", "%m/%d/%Y")
dnc_2020 <- as.Date("8/20/2020", "%m/%d/%Y")
rnc_2020 <- as.Date("8/27/2020", "%m/%d/%Y")
colnames(poll_2020_df) <- c("year","state","poll_date","candidate_name","avg_support","avg_support_adj")
poll_2020_df <- poll_2020_df %>%
  mutate(party = case_when(candidate_name == "Donald Trump" ~ "republican",
                           candidate_name == "Joseph R. Biden Jr." ~ "democrat"),
         poll_date = as.Date(poll_date, "%m/%d/%Y"),
         days_left = round(difftime(elxnday_2020, poll_date, unit="days")),
         weeks_left = round(difftime(elxnday_2020, poll_date, unit="weeks")),
         before_convention = case_when(poll_date < dnc_2020 & party == "democrat" ~ TRUE,
                                       poll_date < rnc_2020 & party == "republican" ~ TRUE,
                                       TRUE ~ FALSE)) %>%
  filter(!is.na(party)) %>%
  filter(!state == "National")  %>%
  filter(days_left == 27)
 
# read data sets
pvstate_df    <- read_csv("popvote_bystate_1948-2016.csv")
economy_df    <- read_csv("econ.csv")
pollstate_df  <- read_csv("pollavg_bystate_1968-2016.csv")

# merging data sets and filtering polls to 5 weeks before election
poll_pvstate_df <- pvstate_df %>%
  inner_join(
    pollstate_df %>% 
      filter(weeks_left == 5)
      # group_by(state, year) %>%
      # top_n(1, poll_date)
  )
poll_pvstate_df$D_pv <- (poll_pvstate_df$D / poll_pvstate_df$total)*100
poll_pvstate_df$R_pv <- (poll_pvstate_df$R / poll_pvstate_df$total)*100
poll_pvstate_df$state <- state.abb[match(poll_pvstate_df$state, state.name)]

# read VEP data set and merging other data sets
vep_df <- read_csv("vep_1980-2016.csv")
poll_pvstate_vep_df <- pvstate_df %>%
  mutate(D_pv = D/total) %>%
  inner_join(pollstate_df %>% filter(weeks_left == 5)) %>%
  left_join(vep_df)

############### Simulation of election results in 2020 #################

state_glm_forecast <- list()
state_glm_forecast_outputs <- data.frame()
poll_pvstate_vep_df$state_abb <- state.abb[match(poll_pvstate_vep_df$state, state.name)]
for (s in unique(poll_pvstate_vep_df$state_abb)) {
  
  state_glm_forecast[[s]]$dat_D <- poll_pvstate_vep_df %>%  ###### VEP DATA DEM
    filter(state_abb == s, party == "democrat")
  
  state_glm_forecast[[s]]$mod_D <- glm(cbind(D, VEP - D) ~ avg_poll,  ######glm fit
                                       state_glm_forecast[[s]]$dat_D,
                                       family = quasibinomial(link="logit"))

  state_glm_forecast[[s]]$dat_R <- poll_pvstate_vep_df %>% ###### VEP DATA REP
    filter(state_abb == s, party == "republican")  
  
  state_glm_forecast[[s]]$mod_R <- glm(cbind(R, VEP - R) ~ avg_poll, ######glm fit
                                       state_glm_forecast[[s]]$dat_R,
                                       family = quasibinomial(link="logit"))
  
  # draw probabilities based on avg support for both candidates in 2020
  if (nrow(state_glm_forecast[[s]]$dat_R) > 2) {     
      Dpred_voteprob <- predict(state_glm_forecast[[s]]$mod_D, 
                               newdata=data.frame(avg_poll=51.5), se=F, type="response") 
      Rpred_voteprob <- predict(state_glm_forecast[[s]]$mod_R, 
                               newdata=data.frame(avg_poll=42.4), se=F, type="response")
      
  # data frame containing simulated distribution of election results in 2020
      state_glm_forecast_outputs <- 
        bind_rows(
        state_glm_forecast_outputs,
        cbind.data.frame(state = s,  
        sim.D = rbinom(n = 10000, size = state_glm_forecast[[s]]$dat_D$VEP[1], prob = Dpred_voteprob),
        sim.R = rbinom(n = 10000, size = state_glm_forecast[[s]]$dat_R$VEP[1], prob = Rpred_voteprob))
      )
    }
  }

# adding Biden win margins column to state_glm_forecast_output data frame
state_glm_forecast_outputs$win.margins <- 
  ((state_glm_forecast_outputs$sim.D - state_glm_forecast_outputs$sim.R)/(state_glm_forecast_outputs$sim.D + state_glm_forecast_outputs$sim.R))*100 

# Map of United States, with predicted win margins for Joe Biden in each state where data is availible
ggplot(state_glm_forecast_outputs, aes(x=win.margins)) + 
  geom_histogram() +
  facet_geo(~ state, scales = "free_x" ) +
  xlab("Biden's Win Margin") +
  ylab("Frequency") +
  theme_bw()

######################### Battleground States 2020 ###########################

####### Florida 

# VEP data for Florida, 2016
VEP_FL_2020 <- as.integer(vep_df$VEP[vep_df$state == "Florida" & vep_df$year == 2016])

# party-specific VEP data for Florida
FL_R <- poll_pvstate_vep_df %>% filter(state=="Florida", party=="republican")
FL_D <- poll_pvstate_vep_df %>% filter(state=="Florida", party=="democrat")

## Fit D and R models for Florida 
FL_R_glm <- glm(cbind(R, VEP-R) ~ avg_poll, FL_R, family = quasibinomial)
FL_D_glm <- glm(cbind(D, VEP-D) ~ avg_poll, FL_D, family = quasibinomial)

## Get predicted draw probabilities for D and R
prob_Rvote_FL_2020 <- predict(FL_R_glm, newdata = data.frame(avg_poll=44.71), type="response")[[1]]
prob_Dvote_FL_2020 <- predict(FL_D_glm, newdata = data.frame(avg_poll=48.78), type="response")[[1]]

## Get predicted distribution of draws from the population
sim_Rvotes_FL_2020 <- rbinom(n = 10000, size = VEP_FL_2020, prob = prob_Rvote_FL_2020)
sim_Dvotes_FL_2020 <- rbinom(n = 10000, size = VEP_FL_2020, prob = prob_Dvote_FL_2020)

## Simulating a distribution of election results: Biden win margin
sim_elxns_FL_2020 <- ((sim_Dvotes_FL_2020-sim_Rvotes_FL_2020)/(sim_Dvotes_FL_2020+sim_Rvotes_FL_2020))*100
hist(sim_elxns_FL_2020, xlab="predicted draws of Biden win margin (% pts)\nfrom 10,000 binomial process simulations", xlim=c(2, 7))

####### Ohio

# VEP data for Ohio, 2016
VEP_OH_2020 <- as.integer(vep_df$VEP[vep_df$state == "Ohio" & vep_df$year == 2016])

# party-specific VEP data for Ohio
OH_R <- poll_pvstate_vep_df %>% filter(state=="Ohio", party=="republican")
OH_D <- poll_pvstate_vep_df %>% filter(state=="Ohio", party=="democrat")

## Fit D and R models for Ohio
OH_R_glm <- glm(cbind(R, VEP-R) ~ avg_poll, OH_R, family = quasibinomial)
OH_D_glm <- glm(cbind(D, VEP-D) ~ avg_poll, OH_D, family = quasibinomial)

## Get predicted draw probabilities for D and R
prob_Rvote_OH_2020 <- predict(OH_R_glm, newdata = data.frame(avg_poll=46.66), type="response")[[1]]
prob_Dvote_OH_2020 <- predict(OH_D_glm, newdata = data.frame(avg_poll=46.8), type="response")[[1]]

## Get predicted distribution of draws from the population
sim_Rvotes_OH_2020 <- rbinom(n = 10000, size = VEP_OH_2020, prob = prob_Rvote_OH_2020)
sim_Dvotes_OH_2020 <- rbinom(n = 10000, size = VEP_OH_2020, prob = prob_Dvote_OH_2020)

## Simulating a distribution of election results: Biden win margin
sim_elxns_OH_2020 <- ((sim_Dvotes_OH_2020-sim_Rvotes_OH_2020)/(sim_Dvotes_OH_2020+sim_Rvotes_OH_2020))*100
hist(sim_elxns_OH_2020, xlab="predicted draws of Biden win margin (% pts)\nfrom 10,000 binomial process simulations", xlim=c(-5, 2))

###### Georgia 

# VEP data for Georgia, 2016
VEP_GA_2020 <- as.integer(vep_df$VEP[vep_df$state == "Georgia" & vep_df$year == 2016])

# party-specific VEP data for Georgia
GA_R <- poll_pvstate_vep_df %>% filter(state=="Georgia", party=="republican")
GA_D <- poll_pvstate_vep_df %>% filter(state=="Georgia", party=="democrat")

## Fit D and R models for Georgia
GA_R_glm <- glm(cbind(R, VEP-R) ~ avg_poll, GA_R, family = quasibinomial)
GA_D_glm <- glm(cbind(D, VEP-D) ~ avg_poll, GA_D, family = quasibinomial)

## Get predicted draw probabilities for D and R
prob_Rvote_GA_2020 <- predict(GA_R_glm, newdata = data.frame(avg_poll=46.63), type="response")[[1]]
prob_Dvote_GA_2020 <- predict(GA_D_glm, newdata = data.frame(avg_poll=47.0), type="response")[[1]]

## Get predicted distribution of draws from the population
sim_Rvotes_GA_2020 <- rbinom(n = 10000, size = VEP_GA_2020, prob = prob_Rvote_GA_2020)
sim_Dvotes_GA_2020 <- rbinom(n = 10000, size = VEP_GA_2020, prob = prob_Dvote_GA_2020)

## Simulating a distribution of election results: Biden win margin
sim_elxns_GA_2020 <- ((sim_Dvotes_GA_2020-sim_Rvotes_GA_2020)/(sim_Dvotes_GA_2020+sim_Rvotes_GA_2020))*100
hist(sim_elxns_GA_2020, xlab="predicted draws of Biden win margin (% pts)\nfrom 10,000 binomial process simulations", xlim=c(-2, 8))

####### North Carolina 

# VEP data for North Carolina, 2016
VEP_NC_2020 <- as.integer(vep_df$VEP[vep_df$state == "North Carolina" & vep_df$year == 2016])

# party-specific VEP data for North Carolina
NC_R <- poll_pvstate_vep_df %>% filter(state=="North Carolina", party=="republican")
NC_D <- poll_pvstate_vep_df %>% filter(state=="North Carolina", party=="democrat")

## Fit D and R models for North Carolina
NC_R_glm <- glm(cbind(R, VEP-R) ~ avg_poll, NC_R, family = quasibinomial)
NC_D_glm <- glm(cbind(D, VEP-D) ~ avg_poll, NC_D, family = quasibinomial)

## Get predicted draw probabilities for D and R
prob_Rvote_NC_2020 <- predict(NC_R_glm, newdata = data.frame(avg_poll=46.47), type="response")[[1]]
prob_Dvote_NC_2020 <- predict(NC_D_glm, newdata = data.frame(avg_poll=48.35), type="response")[[1]]

## Get predicted distribution of draws from the population
sim_Rvotes_NC_2020 <- rbinom(n = 10000, size = VEP_NC_2020, prob = prob_Rvote_NC_2020)
sim_Dvotes_NC_2020 <- rbinom(n = 10000, size = VEP_NC_2020, prob = prob_Dvote_NC_2020)

## Simulating a distribution of election results: Biden win margin
sim_elxns_NC_2020 <- ((sim_Dvotes_NC_2020-sim_Rvotes_NC_2020)/(sim_Dvotes_NC_2020+sim_Rvotes_NC_2020))*100
hist(sim_elxns_NC_2020, xlab="predicted draws of Biden win margin (% pts)\nfrom 10,000 binomial process simulations", xlim=c(0, 6))

#####IOWA

# VEP data for Iowa, 2016
VEP_IA_2020 <- as.integer(vep_df$VEP[vep_df$state == "Iowa" & vep_df$year == 2016])

# party-specific VEP data for Iowa
IA_R <- poll_pvstate_vep_df %>% filter(state=="Iowa", party=="republican")
IA_D <- poll_pvstate_vep_df %>% filter(state=="Iowa", party=="democrat")

## Fit D and R models for Iowa
IA_R_glm <- glm(cbind(R, VEP-R) ~ avg_poll, IA_R, family = quasibinomial)
IA_D_glm <- glm(cbind(D, VEP-D) ~ avg_poll, IA_D, family = quasibinomial)

## Get predicted draw probabilities for D and R
prob_Rvote_IA_2020 <- predict(IA_R_glm, newdata = data.frame(avg_poll=46.73), type="response")[[1]]
prob_Dvote_IA_2020 <- predict(IA_D_glm, newdata = data.frame(avg_poll=47.13), type="response")[[1]]

## Get predicted distribution of draws from the population
sim_Rvotes_IA_2020 <- rbinom(n = 10000, size = VEP_IA_2020, prob = prob_Rvote_IA_2020)
sim_Dvotes_IA_2020 <- rbinom(n = 10000, size = VEP_IA_2020, prob = prob_Dvote_IA_2020)

## Simulating a distribution of election results: Biden win margin
sim_elxns_IA_2020 <- ((sim_Dvotes_IA_2020-sim_Rvotes_IA_2020)/(sim_Dvotes_IA_2020+sim_Rvotes_IA_2020))*100
hist(sim_elxns_IA_2020, xlab="predicted draws of Biden win margin (% pts)\nfrom 10,000 binomial process simulations", xlim=c(-25, 0))

############# Electoral Votes ###############

# Total electoral votes in battleground states
29+19+16+15+6

# Biden's projected electoral votes in battleground states 
29+16+15
