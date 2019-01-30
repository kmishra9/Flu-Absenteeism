################################################################################
# Master's Thesis - Spatial Epidemiology of Absenteeism 
# Shoo the Flu Evaluation
# 2012-2017 Spatial Epidemiology Analysis
# Map management file for creating visualizations for Objectives 1 & 2: 
# Objective 1: To examine the pre-program and post-program spatial distribution of illness-specific and all-cause absenteeism following the introduction of SLIV
# Objective 2: To examine the spatial distribution of vaccination coverage following the introduction of SLIV
################################################################################
source(here::here("Flu-Absenteeism", "Master's Thesis - Spatial Epidemiology of Influenza", "0 - Config.R"))

################################################################################
# Import spatial inputs 
################################################################################


################################################################################
# Static Maps per Spatial Input & School Year
################################################################################

inputs = list(input_1_longlat, input_2_longlat, input_3_longlat, input_4_longlat)

qmplot(
  x = long,
  y = lat,
  fill = absence_rate_ill,
  group = group,
  data = input_1_longlat %>% filter(schoolyr == "2016-17"),
  maptype = "toner-lite",
  geom = "polygon"
)


################################################################################
# Exploratory Leaflet App
################################################################################

# Options - District, 
# 

