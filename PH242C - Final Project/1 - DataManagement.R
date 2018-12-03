##############################################
# PH242C - Longitudinal Data - Final Project 
# Shoo the Flu Evaluation
# 2016-2017 Peakmonths Longitudinal Analysis
# Data Management file for raw dataset import, cleaning, and export
##############################################
source(here::here("Flu-Absenteeism", "PH242C - Final Project", "0 - Config.R"))

#################################################################################
# Import data & downsample
#################################################################################

absentee_all = fread(file = raw_data_path) %>% as.tibble()
absentee_all_downsample = down_sample(data = absentee_all)

#################################################################################
# Clean and limit data to what is relevant to analysis
#################################################################################

# Adjust our data to only include the peakmonths for all schools during the 2016-2017 flu season (as defined by the CDPH)
peakmonths = list(11, 12, 1)

absentee_1617_peakmonths = absentee_all %>%
  filter(schoolyr == "2016-17", fluseasCDPH==1, (month %in% peakmonths))

absentee_1617_peakmonths_downsample = absentee_all_downsample %>%
  filter(schoolyr == "2016-17", fluseasCDPH==1, (month %in% peakmonths))

#################################################################################
# Only keep a limited set of relevant variables and add a unique ID for each cluster (district-school pairing)
absentee_1617_peakmonths_limited = absentee_1617_peakmonths %>%
  select("dist", "dist.n", "school","enrolled",            # School Information, including a treatment indicator and the # of students to standardize absence rates by
         "yr", "month", "week", "date",                    # Longitudinal markers
         "absent_all",                                     # Indicators of absence, the measured outcome
         "per.freelunch") %>%                              # A limited set of covariates to adjust for (estimating median income)
  rename("intervention"=dist.n) %>% 
  mutate(school_ID = as.numeric(interaction(dist, school, drop=TRUE)))

absentee_1617_peakmonths_limited_downsample = absentee_1617_peakmonths_downsample %>%
  select("dist", "dist.n", "school","enrolled",            # School Information, including a treatment indicator and the # of students to standardize absence rates by
         "yr", "month", "week", "date",                    # Longitudinal markers
         "absent_all",                                     # Indicators of absence, the measured outcome
         "per.freelunch") %>%                              # A limited set of covariates to adjust for (estimating median income)
  rename("intervention"=dist.n) %>% 
  mutate(school_ID = as.numeric(interaction(dist, school, drop=TRUE)))

#################################################################################
# Organize into long, weekly absence rate data, standardized by enrollment and recalibrate week column
week_map = list(
  "49" = 1,
  "50" = 2,
  "51" = 3,
  "2" = 4,
  "3" = 5,
  "4" = 6,
  "5" = 7
)
assert_that((
  week_map %>% names %>% sort ==
    absentee_1617_peakmonths_limited %>% pull(week) %>% unique %>% as.character %>% sort
) %>%
  all
)

absentee_1617_limited_weekly_rates = absentee_1617_peakmonths_limited %>%
  group_by(school_ID, week) %>%
  summarize(weekly_absence_rate = sum(school_ID) / mean(enrolled)) %>%
  mutate(shifted_week = week_map[week %>% as.character()] %>% unlist)

absentee_1617_limited_weekly_rates_downsample = absentee_1617_peakmonths_limited_downsample %>%
  group_by(school_ID, week) %>%
  summarize(weekly_absence_rate = sum(school_ID) / mean(enrolled)) %>%
  mutate(shifted_week = week_map[week %>% as.character()] %>% unlist)

#################################################################################
# Merge back original dataset variables and covariates, reduced to the weekly level
absentee_1617_limited_weekly_rates  = absentee_1617_limited_weekly_rates %>%
  left_join(
    y = absentee_1617_peakmonths_limited %>%
      select(-absent_all, -date) %>%
      distinct,
    by = c("school_ID", "week")
  ) %>% 
  arrange(school_ID, shifted_week)

absentee_1617_limited_weekly_rates_downsample  = absentee_1617_limited_weekly_rates_downsample %>%
  left_join(
    y = absentee_1617_peakmonths_limited %>%
      select(-absent_all, -date) %>%
      distinct,
    by = c("school_ID", "week")
  ) %>% 
  arrange(school_ID, shifted_week)

#################################################################################
# Export several versions of data
#################################################################################

write_rds(x = absentee_all, path = raw_data_path_RDS)

write_csv(x = absentee_all_downsample, path = raw_data_path_downsample)
write_csv(x = absentee_1617_peakmonths, path = paste0(peakmonths_data_prefix, ".csv"))
write_csv(x = absentee_1617_peakmonths_downsample, path = paste0(peakmonths_data_prefix, "_downsample", ".csv"))
write_csv(x = absentee_1617_peakmonths_limited, path = paste0(peakmonths_data_prefix, "_limited.csv"))
write_csv(x = absentee_1617_peakmonths_limited_downsample, path = paste0(peakmonths_data_prefix, "_limited_downsample", ".csv"))

write_csv(x = absentee_1617_limited_weekly_rates, path = paste0(long_peak_weekly_rates_prefix, ".csv"))
write_csv(x = absentee_1617_limited_weekly_rates, path = paste0(long_peak_weekly_rates_prefix, "_downsample.csv"))
