##############################################
# PH242C - Longitudinal Data - Final Project 
# Shoo the Flu Evaluation
# 2016-2017 Peakmonths Longitudinal Analysis
# Longitudinal Analysis 2 - GEE
##############################################

#################################################################################
# Setup and Import data for analysis
#################################################################################

source(here::here("Flu-Absenteeism", "PH242C - Final Project", "0 - Config.R"))

absentee_1617_limited_weekly_rates = fread(file = paste0(long_peak_weekly_rates_prefix, ".csv")) %>% as.tibble()

 
