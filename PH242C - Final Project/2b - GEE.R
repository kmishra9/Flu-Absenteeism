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

#################################################################################
# Conduct unadjusted and adjusted analyses
#################################################################################

gee_fit_unadj = gee(
  formula = weekly_absence_rate ~ shifted_week + intervention + shifted_week * intervention,
  id = school_ID,
  data = absentee_1617_limited_weekly_rates,
  family = "gaussian",
  corstr = "exchangeable",
  Mv = 1
)

gee_fit_adj = gee(
  formula = weekly_absence_rate ~ shifted_week + intervention + per.freelunch + shifted_week * intervention,
  id = school_ID,
  data = absentee_1617_limited_weekly_rates,
  family = "gaussian",
  corstr = "exchangeable",
  Mv = 1
)

#################################################################################
# Using only weeks 1-4, where the absence rates peak (trying to remove some noise because we're working with a inherently limited linear model)

absentee_1617_limited_weekly_rates_w5max = absentee_1617_limited_weekly_rates %>% filter(shifted_week <= 5)

gee_fit_unadj_w5max = gee(
  formula = weekly_absence_rate ~ shifted_week + intervention + shifted_week * intervention,
  id = school_ID,
  data = absentee_1617_limited_weekly_rates_w5max,
  family = "gaussian",
  corstr = "exchangeable",
  Mv = 1
)

gee_fit_adj_w5max = gee(
  formula = weekly_absence_rate ~ shifted_week + intervention + per.freelunch + shifted_week * intervention,
  id = school_ID,
  data = absentee_1617_limited_weekly_rates_w5max,
  family = "gaussian",
  corstr = "exchangeable",
  Mv = 1
)

#################################################################################
# Conducting all analyses with an AR-M(1) correlation structure

gee_fit_unadj = gee(
  formula = weekly_absence_rate ~ shifted_week + intervention + shifted_week * intervention,
  id = school_ID,
  data = absentee_1617_limited_weekly_rates,
  family = "gaussian",
  corstr = "AR-M",
  Mv = 1
)

gee_fit_adj = gee(
  formula = weekly_absence_rate ~ shifted_week + intervention + per.freelunch + shifted_week * intervention,
  id = school_ID,
  data = absentee_1617_limited_weekly_rates,
  family = "gaussian",
  corstr = "AR-M",
  Mv = 1
)

gee_fit_unadj_w5max_ = gee(
  formula = weekly_absence_rate ~ shifted_week + intervention + shifted_week * intervention,
  id = school_ID,
  data = absentee_1617_limited_weekly_rates_w5max,
  family = "gaussian",
  corstr = "AR-M",
  Mv = 1
)

gee_fit_adj_w5max = gee(
  formula = weekly_absence_rate ~ shifted_week + intervention + per.freelunch + shifted_week * intervention,
  id = school_ID,
  data = absentee_1617_limited_weekly_rates_w5max,
  family = "gaussian",
  corstr = "AR-M",
  Mv = 1
)


#################################################################################
# Save fit coefficients
#################################################################################

write_rds(x = gee_fit_unadj %>% summary %>% coef, path = here("Flu-Absenteeism", "PH242C - Final Project", "2b-F1-GEE-unadj.RDS"))      # F1 stands for Fit 1
write_rds(x = gee_fit_adj   %>% summary %>% coef, path = here("Flu-Absenteeism", "PH242C - Final Project", "2b-F2-GEE-adj.RDS"))

write_rds(x = gee_fit_unadj_w5max %>% summary %>% coef, path = here("Flu-Absenteeism", "PH242C - Final Project", "2b-F3-GEE-w5max-unadj.RDS"))
write_rds(x = gee_fit_adj_w5max   %>% summary %>% coef, path = here("Flu-Absenteeism", "PH242C - Final Project", "2b-F4-GEE-w5max-adj.RDS"))
