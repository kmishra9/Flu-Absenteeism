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
  geom_line() +
  ggtitle(label = "Longitudinal Absence Rates by School during 2016-17 peak influenza season") +
  xlab("School Week during Flu Season") + 
  ylab("Absence Rate (Absences per student-school-week)") + 
  scale_color_discrete(name=NULL, labels=c("Control", "Intervention")) +
  theme(legend.justification = c(1,1), legend.position = c(1,1))

ggsave(filename=here("Flu-Absenteeism", "PH242C - Final Project", "2a-P1-LineSchoolGroupedPlot.png"))

# Plot 2
ggplot(data=absentee_1617_limited_weekly_rates, mapping=aes(x=shifted_week, y=weekly_absence_rate, group=school_ID, color=as.factor(intervention))) + 
  geom_smooth(se = FALSE) +
  ggtitle(label = "Longitudinal Absence Rates by School during 2016-17 peak influenza season") +
  xlab("School Week during Flu Season") + 
  ylab("Absence Rate (Absences per student-school-week)") + 
  scale_color_discrete(name=NULL, labels=c("Control", "Intervention")) +
  theme(legend.justification = c(1,1), legend.position = c(1,1))

ggsave(filename=here("Flu-Absenteeism", "PH242C - Final Project", "2a-P2-SmoothSchoolGroupedPlot.png"))

# Plot 3
ggplot(data=absentee_1617_limited_weekly_rates, mapping=aes(x=shifted_week, y=weekly_absence_rate, group=intervention, color=as.factor(intervention))) + 
  geom_smooth(se = FALSE) + 
  ggtitle(label = "Longitudinal Absence Rates by School District during 2016-17 peak influenza season") +
  xlab("School Week during Flu Season") + 
  ylab("Absence Rate (Absences per student-school-week)") + 
  scale_color_discrete(name=NULL, labels=c("Control", "Intervention")) +
  theme(legend.justification = c(1,1), legend.position = c(1,1))

ggsave(filename=here("Flu-Absenteeism", "PH242C - Final Project", "2a-P3-SmoothQuadraticInterventionGroupedPlot.png"))

# Plot 4
ggplot(data=absentee_1617_limited_weekly_rates, mapping=aes(x=shifted_week, y=weekly_absence_rate, group=intervention, color=as.factor(intervention))) + 
  geom_smooth(se = FALSE, method="lm") + 
  ggtitle(label = "Linear Fit of Longitudinal Absence Rates by School during 2016-17 peak influenza season") +
  xlab("School Week during Flu Season") + 
  ylab("Absence Rate (Absences per student-school-week)") + 
  scale_color_discrete(name=NULL, labels=c("Control", "Intervention")) +
  theme(legend.justification = c(1,1), legend.position = c(1,1))

ggsave(filename=here("Flu-Absenteeism", "PH242C - Final Project", "2a-P4-SmoothLinearInterventionGroupedPlot.png"))

# Plot 5
ggplot(data=absentee_1617_limited_weekly_rates) + 
  geom_histogram(mapping=aes(x=weekly_absence_rate), color="black") +
  ggtitle(label = "Distribution of weekly absence rates during 2016-17 peak influenza season") +
  xlab("Absence Rate (Absences per student-school-week)") +
  ylab("Count") 
  
ggsave(filename=here("Flu-Absenteeism", "PH242C - Final Project", "2a-P5-HistAbsenceRatePlot.png"))

# Distribution has mean=0.2340408, SD=0.1128782

# Plot 6
ggplot(data=absentee_1617_limited_weekly_rates, mapping=aes(x=weekly_absence_rate, fill=as.factor(intervention))) + 
  geom_histogram(color="black") +
  facet_grid(~ intervention) + 
  ggtitle(label = "Distribution of weekly absence rates by school district during 2016-17 peak influenza season") +
  xlab("Absence Rate (Absences per student-school-week)") +
  ylab("Count") +
  scale_fill_discrete(name=NULL, labels=c("Control", "Intervention")) +
  theme(legend.justification = c(1,1), legend.position = c(1,1),
        strip.text.x = element_blank())

ggsave(filename=here("Flu-Absenteeism", "PH242C - Final Project", "2a-P6-HistFacetAbsenceRatePlot.png"))

# Intervention distribution has mean=0.2211697, SD=0.1125307
# Control distribution has mean=0.2522119, SD=0.1110833


# Need to present a side-by-side with "weight" of a school-district
