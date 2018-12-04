##############################################
# PH242C - Longitudinal Data - Final Project 
# Shoo the Flu Evaluation
# 2016-2017 Peakmonths Longitudinal Analysis
# Longitudinal Analysis 1 - EDA with Plotting
##############################################

#################################################################################
# Setup and Import data for analysis
#################################################################################

source(here::here("Flu-Absenteeism", "PH242C - Final Project", "0 - Config.R"))

absentee_1617_limited_weekly_rates = fread(file = paste0(long_peak_weekly_rates_prefix, ".csv")) %>% as.tibble()

#################################################################################
# Run visualizations
#################################################################################

# Plot 1 
ggplot(data=absentee_1617_limited_weekly_rates, mapping=aes(x=shifted_week, y=weekly_absence_rate, group=school_ID, color=as.factor(intervention))) + 
  geom_line()

ggsave(filename=here("Flu-Absenteeism", "PH242C - Final Project", "2a-P1-LineSchoolGroupedPlot.png"))

# Plot 2
ggplot(data=absentee_1617_limited_weekly_rates, mapping=aes(x=shifted_week, y=weekly_absence_rate, group=school_ID, color=as.factor(intervention))) + 
  geom_smooth(se = FALSE)

ggsave(filename=here("Flu-Absenteeism", "PH242C - Final Project", "2a-P2-SmoothSchoolGroupedPlot.png"))

# Plot 3
ggplot(data=absentee_1617_limited_weekly_rates, mapping=aes(x=shifted_week, y=weekly_absence_rate, group=intervention, color=as.factor(intervention))) + 
  geom_smooth(se = FALSE)

ggsave(filename=here("Flu-Absenteeism", "PH242C - Final Project", "2a-P3-SmoothQuadraticInterventionGroupedPlot.png"))

# Plot 4
ggplot(data=absentee_1617_limited_weekly_rates, mapping=aes(x=shifted_week, y=weekly_absence_rate, group=intervention, color=as.factor(intervention))) + 
  geom_smooth(se = FALSE, method="lm")

ggsave(filename=here("Flu-Absenteeism", "PH242C - Final Project", "2a-P4-SmoothLinearInterventionGroupedPlot.png"))

# Plot 5
ggplot(data=absentee_1617_limited_weekly_rates) + 
  geom_histogram(mapping=aes(x=weekly_absence_rate))

ggsave(filename=here("Flu-Absenteeism", "PH242C - Final Project", "2a-P5-HistAbsenceRatePlot.png"))
