################################################################################
# Master's Thesis - Spatial Epidemiology of Absenteeism 
# Shoo the Flu Evaluation
# 2012-2017 Spatial Epidemiology Analysis
# Data Management file for raw dataset import, cleaning, and export
################################################################################
source(here::here("Flu-Absenteeism", "Master's Thesis - Spatial Epidemiology of Influenza", "0 - Config.R"))

################################################################################
# Import data & downsample
################################################################################

absentee_all = fread(file = raw_data_path) %>% as.tibble()
absentee_all_downsample = down_sample(data = absentee_all)

################################################################################
# Clean and limit data to what is relevant to analysis
################################################################################

absentee_flu = absentee_all %>% filter(fluseasCDPH == 1)
absentee_flu_downsample = absentee_all_downsample %>% filter(fluseasCDPH == 1)

absentee_peakwk = absentee_all %>% filter(peakwk == 1)
absentee_peakwk_downsample = absentee_all_downsample %>% filter(peakwk == 1)

################################################################################
# Export several versions of data
################################################################################

write_csv(x = absentee_all_downsample, path = raw_data_path_downsample)

write_csv(x = absentee_flu, path = flu_path)
write_csv(x = absentee_flu_downsample, path = flu_path_downsample)

write_csv(x = absentee_peakwk, path = peakwk_path)
write_csv(x = absentee_peakwk_downsample, path = peakwk_path_downsample)

