################################################################################
# Master's Thesis - Spatial Epidemiology of Absenteeism 
# Shoo the Flu Evaluation
# 2012-2017 Spatial Epidemiology Analysis
# Data Management file for raw dataset import, cleaning, and export
################################################################################
source(here::here("Flu-Absenteeism", "Master's Thesis - Spatial Epidemiology of Influenza", "0 - Config.R"))

################################################################################
# Import absentee data, add a column & downsample
################################################################################

absentee_all = fread(file = raw_data_path) %>%
  mutate(program = case_when(schoolyr %in% pre_program_schoolyrs ~ 0,
                             schoolyr %in% program_schoolyrs ~ 1)) %>% 
  mutate(period = case_when(schoolyr %in% pre_program_schoolyrs ~ 0, 
                            schoolyr %in% weak_vaccine_schoolyrs ~ 1,
                            schoolyr %in% strong_vaccine_schoolyrs ~ 2))
absentee_all_downsample = down_sample(data = absentee_all)

################################################################################
# Clean and limit absentee data to what is relevant to analysis
################################################################################

absentee_flu = absentee_all %>% filter(fluseasCDPH == 1)
absentee_flu_downsample = absentee_all_downsample %>% filter(fluseasCDPH == 1)

absentee_peakwk = absentee_all %>% filter(peakwk == 1)
absentee_peakwk_downsample = absentee_all_downsample %>% filter(peakwk == 1)

school_names = list(
  OUSD_school_names = absentee_all %>% 
  filter(dist.n == 1) %>% 
  pull(school) %>% 
  unique %>% 
  sort,
  
  WCCSD_school_names = absentee_all %>%
  filter(dist.n == 0) %>% 
  pull(school) %>% 
  unique %>% 
  sort
)

################################################################################
# Export several versions of absentee data
################################################################################

write_csv(x = absentee_all_downsample, path = raw_data_path_downsample)

write_csv(x = absentee_flu, path = flu_path)
write_csv(x = absentee_flu_downsample, path = flu_path_downsample)

write_csv(x = absentee_peakwk, path = peakwk_path)
write_csv(x = absentee_peakwk_downsample, path = peakwk_path_downsample)

write_rds(x = school_names, path = school_names_path)
