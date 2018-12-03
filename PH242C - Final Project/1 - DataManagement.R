##############################################
# PH242C - Longitudinal Data - Final Project 
# Shoo the Flu Evaluation
# 2016-2017 Peakmonths Longitudinal Analysis
# Data Management file for raw dataset import, cleaning, and export
##############################################
source(here::here("Flu-Absenteeism", "PH242C - Final Project", "0 - Config.R"))

# Read in data and create a downsample
absentee_all = fread(file = raw_data_path) %>% as.tibble()
absentee_all_downsample = down_sample(data = absentee_all)

# Adjust our data to only include the peakmonths for all schools during the 2016-2017 flu season (as defined by the CDPH)
peakmonths = list(11, 12, 1)

absentee_1617_peakmonths = absentee_all %>%
  filter(schoolyr == "2016-17", fluseasCDPH==1, (month %in% peakmonths))

absentee_1617_peakmonths_downsample = absentee_all_downsample %>%
  filter(schoolyr == "2016-17", fluseasCDPH==1, (month %in% peakmonths))

# Only keep a limited set of relevant variables
absentee_1617_peakmonths_limited = absentee_1617_peakmonths %>%
  select("dist", "dist.n", "school","enrolled",            # School Information, including a treatment indicator and the # of students to standardize absence rates by
         "yr", "month", "week", "date",                    # Longitudinal markers
         "absent_all", "absent_ill",                       # Indicators of absence, the measured outcome
         "per.freelunch")                                  # A limited set of covariates to adjust for (estimating median income)

absentee_1617_peakmonths_limited_downsample = absentee_1617_peakmonths_downsample %>%
  select("dist", "dist.n", "school","enrolled",            # School Information, including a treatment indicator and the # of students to standardize absence rates by
         "yr", "month", "week", "date",                    # Longitudinal markers
         "absent_all", "absent_ill",                       # Indicators of absence, the measured outcome
         "per.freelunch")                                  # A limited set of covariates to adjust for (estimating median income)

############################
# Save data in several forms
############################
write_rds(x = absentee_all, path = raw_data_path_RDS)

write_csv(x = absentee_all_downsample, path = raw_data_path_downsample)
write_rds(x = absentee_all_downsample, path = raw_data_path_RDS_downsample)

write_csv(x = absentee_1617_peakmonths, path = paste0(analysis_data_prefix, ".csv"))
write_rds(x = absentee_1617_peakmonths, path = paste0(analysis_data_prefix, ".RDS"))

write_csv(x = absentee_1617_peakmonths_downsample, path = paste0(analysis_data_prefix, "_downsample", ".csv"))
write_rds(x = absentee_1617_peakmonths_downsample, path = paste0(analysis_data_prefix, "_downsample", ".RDS"))

write_csv(x = absentee_1617_peakmonths_limited, path = paste0(analysis_data_prefix, "_limited.csv"))
write_rds(x = absentee_1617_peakmonths_limited, path = paste0(analysis_data_prefix, "_limited.RDS"))

write_csv(x = absentee_1617_peakmonths_limited_downsample, path = paste0(analysis_data_prefix, "_limited_downsample", ".csv"))
write_rds(x = absentee_1617_peakmonths_limited_downsample, path = paste0(analysis_data_prefix, "_limited_downsample", ".RDS"))
