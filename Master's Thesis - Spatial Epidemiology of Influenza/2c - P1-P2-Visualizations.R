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

input_1_longlat = read_csv(path = spatial_input_1_path)
input_2_longlat = read_csv(path = spatial_input_2_path)
input_3_longlat = read_csv(path = spatial_input_3_path)
input_4_longlat = read_csv(path = spatial_input_4_path)
input_5_longlat = read_csv(path = spatial_input_5_path)

################################################################################
# Static Maps per Spatial Input, Faceted by School Year
################################################################################

# Input 1
qmplot(
  x = long,
  y = lat,
  fill = absence_rate_all,
  group = group,
  facets = . ~ schoolyr,
  data = input_1_longlat,
  maptype = "toner-lite",
  geom = "polygon"
)

ggsave(filename=paste0(project_dir, "2c-P1-FluAbsenceRate.png"))

# Input 2
qmplot(
  x = long,
  y = lat,
  fill = absence_rate_all,
  group = group,
  facets = . ~ schoolyr,
  data = input_2_longlat,
  maptype = "toner-lite",
  geom = "polygon"
)

ggsave(filename=paste0(project_dir, "2c-P1-PeakwkAbsenceRate.png"))

# Input 3
qmplot(
  x = long,
  y = lat,
  fill = did_absence_rate_all,
  group = group,
  facets = . ~ schoolyr,
  data = input_3_longlat,
  maptype = "toner-lite",
  geom = "polygon"
)

ggsave(filename=paste0(project_dir, "2c-P1-FluAbsenceRate_DID.png"))

# Input 4
qmplot(
  x = long,
  y = lat,
  fill = did_absence_rate_all,
  group = group,
  facets = . ~ schoolyr,
  data = input_4_longlat,
  maptype = "toner-lite",
  geom = "polygon"
)

ggsave(filename=paste0(project_dir, "2c-P1-PeakwkAbsenceRate_DID.png"))

# Input 5
qmplot(
  x = long,
  y = lat,
  fill = vaccination_coverage,
  group = group,
  facets = . ~ schoolyr,
  data = input_5_longlat,
  maptype = "toner-lite",
  geom = "polygon"
)

ggsave(filename=paste0(project_dir, "2c-P2-VaccinationCoverage.png"))


################################################################################
# Exploratory Leaflet App
################################################################################

# Options - District, 
# 

