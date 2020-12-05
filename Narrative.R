### December 4th, 2020
### Alexander Sigua
### R code for Test Narratives Blog

## install packages
library(tidyverse)
library(ggplot2)
library(readxl)
library(quanteda) 

## set working directory here
setwd("~/Downloads")

## read data
nationnal_covid_df <- read_csv("covid-data.csv") # csv from Covid tracking project data
avg_support_df <- read_excel("average_support_Trump.xlsx") #created an Excel using RCP data

#my theme
my_theme <- theme_bw() + 
  theme(panel.border = element_blank(),
        plot.title   = element_text(size = 15, hjust = 0.5), 
        axis.line    = element_line(colour = "black"),
        panel.grid.minor = element_blank(),
        panel.grid.major = 
          element_line(size = 0.2, linetype = 'solid', colour = "grey"))

#combine data of candidates' average support and covid variables data 
df= nationnal_covid_df %>% inner_join(avg_support_df, by="date") 

################### Testable Implication #1: Correlation ####################

#scatterplot of positive case increase and average support for Trump
ggplot(data = df, aes(x = positiveIncrease, y = average_support_Trump)) +
  geom_point()+
  geom_smooth(method = "lm", col = "red") +
  #geom_line()+
  xlab("Daily Increase in Positive Covid-19 Cases") + 
  ylab("Average Support for Trump") +
  ggtitle("") + 
  my_theme

# linear regression model for positive case increase and average support for Trump
model_case_increase_trump <- 
  lm(average_support_Trump ~ positiveIncrease, data = df)

# r-squared: 0.3142299
summary(model_case_increase_trump)$r.squared

############## Testable Implication #2: Keyness Plots ####################

# filter data for start of pandemic to election day, similar to my previous analysis
speech_df <- read_csv("campaignspeech_2019-2020.csv")  %>%
  filter(approx_date > "2020-03-01" & approx_date < "2020-11-04")

## pre-process: make a `quanteda` corpus from dataframe
speech_corpus <- corpus(speech_df, text_field = "text", docid_field = "url") 

## pre-process: tokenize, clean, select n-grams
speech_toks <- tokens(speech_corpus, 
                      remove_punct = TRUE,
                      remove_symbols = TRUE,
                      remove_numbers = TRUE,
                      remove_url = TRUE) %>% 
  tokens_tolower() %>%
  tokens_remove(pattern=c("joe","biden","donald","trump","president","kamala",
  "harris", "white", "house", "america", "american", "united", "states", "vice", "john", "obama")) %>%
  tokens_remove(pattern=stopwords("en")) %>%
  tokens_ngrams(n=2)

## pre-process: make doc-freq matrix
speech_dfm <- dfm(speech_toks, groups = "candidate")

# Word "keyness" for Biden
biden_keyness <- textstat_keyness(speech_dfm, target = "Joe Biden")
textplot_keyness(biden_keyness)


############# Frequency table for Covid-19 related words

## pre-process: make a `quanteda` corpus from dataframe for Trump and Biden
trump_speech_corpus <- corpus(speech_df %>% filter(candidate == "Donald Trump"),
                              text_field = "text",
                              docid_field = "url")
biden_speech_corpus <- corpus(speech_df %>% filter(candidate == "Joe Biden"),
                              text_field = "text",
                              docid_field = "url")

## pre-process: tokenize, clean, select n-grams for Trump and Biden
trump_speech_toks <- tokens(trump_speech_corpus,
                     remove_punct = TRUE,
                     remove_symbols = TRUE,
                     remove_numbers = TRUE,
                     remove_url = TRUE) %>%
  tokens_tolower() %>%
  tokens_remove(pattern=c("joe","biden","donald","trump","president","kamala","harris", "white", "house", "america", "american", "united", "states")) %>%
  tokens_remove(pattern=stopwords("en")) %>%
  tokens_ngrams(n=2)

biden_speech_toks <- tokens(biden_speech_corpus,
                     remove_punct = TRUE,
                     remove_symbols = TRUE,
                     remove_numbers = TRUE,
                     remove_url = TRUE) %>%
  tokens_tolower() %>%
  tokens_remove(pattern=c("joe","biden","donald","trump","president","kamala","harris", "white", "house", "america", "american", "united", "states")) %>%
  tokens_remove(pattern=stopwords("en")) %>%
  # tokens_select(min_nchar=3) %>%
  tokens_ngrams(n=2)

# Make doc-freq matrices
trump_speech_dfm <- dfm(trump_speech_toks, groups = "approx_date")
biden_speech_dfm <- dfm(biden_speech_toks, groups = "approx_date")

##### word-frequency matrix variables for Trump and Biden
trump_tstat_freq <- textstat_frequency(trump_speech_dfm)
biden_tstat_freq <- textstat_frequency(biden_speech_dfm)

# string of covid-related phrases 
covid_phrases <- c("sick_leave", "testing_tracing", "frontline_workers", "protective_equipment",
              "wearing_mask", " healthcare_workers", "healthcare_workers", "middle_pandemic", 
              " wear_mask", "health_crisis ", " health_insurance", "essential_workers", 
              "social_distancing", "public_health", "preexisting_conditions", "affordable care")

#join Trump and Biden frequency matrix variables, filtered for covid-related phrases
speech_freqs <- full_join(biden_tstat_freq, trump_tstat_freq, by = c("feature")) %>%
  filter(feature %in% covid_phrases)

# remove rank and docfreq columns from word-frequency matrix, and rename Trump and Biden frequency columns
speech_freqs_output <- data.frame(speech_freqs) %>%
  rename(freq_Trump = frequency.y,
         freq_Biden = frequency.x) %>%
  select(-rank.x, -rank.y,  -docfreq.x, -docfreq.y, -group.x, -group.y) 

# word-frequency matrix for Trump and Biden, focused on covid-related phrases 
head(speech_freqs_output)





