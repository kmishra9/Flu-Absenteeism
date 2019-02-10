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

input_1_longlat = read_csv(file = spatial_input_1_path)
input_2_longlat = read_csv(file = spatial_input_2_path)
input_3_longlat = read_csv(file = spatial_input_3_path)
input_4_longlat = read_csv(file = spatial_input_4_path)
input_5_longlat = read_csv(file = spatial_input_5_path)

################################################################################
# Static Maps per Spatial Input, Faceted by School Year
################################################################################

theme_update(
  plot.title = element_text(hjust = 0.5),
  legend.key.width = unit(3, "cm"),
  plot.margin = unit(c(5, 0, 0, 1), "points")
)

# Input 1
qmplot(
  x = long,
  y = lat,
  fill = absence_rate_all,
  group = group,
  facets = . ~ schoolyr,
  data = input_1_longlat,
  maptype = "toner-lite",
  geom = "polygon",
  legend = "bottom"
) + 
  scale_fill_distiller(palette='Spectral') +
  labs(title = "Mean All-Cause Absence Rate by School during Flu Season", fill="")

ggsave(filename=paste0(project_dir, "2c-P1-FluAbsenceRate-all.png"))

qmplot(
  x = long,
  y = lat,
  fill = absence_rate_ill,
  group = group,
  facets = . ~ schoolyr,
  data = input_1_longlat,
  maptype = "toner-lite",
  geom = "polygon",
  legend = "bottom"
) + 
  scale_fill_distiller(palette='Spectral') +
  labs(title = "Mean Illness-Specific Absence Rate by School during Flu Season", fill="")
  

ggsave(filename=paste0(project_dir, "2c-P1-FluAbsenceRate-ill.png"))

# Input 2
qmplot(
  x = long,
  y = lat,
  fill = absence_rate_all,
  group = group,
  facets = . ~ schoolyr,
  data = input_2_longlat,
  maptype = "toner-lite",
  geom = "polygon",
  legend = "bottom"
) + 
  scale_fill_distiller(palette='Spectral') +
  labs(title = "Mean All-Cause Absence Rate by School during the Peak Week of Flu Season", fill="")

ggsave(filename=paste0(project_dir, "2c-P1-PeakwkAbsenceRate-all.png"))

qmplot(
  x = long,
  y = lat,
  fill = absence_rate_ill,
  group = group,
  facets = . ~ schoolyr,
  data = input_2_longlat,
  maptype = "toner-lite",
  geom = "polygon",
  legend = "bottom"
) + 
  scale_fill_distiller(palette='Spectral') +
  labs(title = "Mean Illness-Specific Absence Rate by School during the Peak Week of Flu Season", fill="")

ggsave(filename=paste0(project_dir, "2c-P1-PeakwkAbsenceRate-ill.png"))

# Input 3
qmplot(
  x = long,
  y = lat,
  fill = did_absence_rate_all,
  group = group,
  facets = . ~ schoolyr,
  data = input_3_longlat,
  maptype = "toner-lite",
  geom = "polygon",
  legend = "bottom"
) + 
  scale_fill_distiller(palette='Spectral') +
  labs(title = "Mean Difference-in-Difference All-Cause Absence Rate by School during Flu Season", fill="")

ggsave(filename=paste0(project_dir, "2c-P1-FluAbsenceRate-DID-all.png"))

qmplot(
  x = long,
  y = lat,
  fill = did_absence_rate_ill,
  group = group,
  facets = . ~ schoolyr,
  data = input_3_longlat,
  maptype = "toner-lite",
  geom = "polygon",
  legend = "bottom"
) + 
  scale_fill_distiller(palette='Spectral') +
  labs(title = "Mean Difference-in-Difference Illness-Specific Absence Rate by School during Flu Season", fill="")

ggsave(filename=paste0(project_dir, "2c-P1-FluAbsenceRate-DID-ill.png"))

# Input 4
qmplot(
  x = long,
  y = lat,
  fill = did_absence_rate_all,
  group = group,
  facets = . ~ schoolyr,
  data = input_4_longlat,
  maptype = "toner-lite",
  geom = "polygon",
  legend = "bottom"
) + 
  scale_fill_distiller(palette='Spectral') +
  labs(title = "Mean Difference-in-Difference All-Cause Absence Rate by School during the Peak Week of Flu Season", fill="")

ggsave(filename=paste0(project_dir, "2c-P1-PeakwkAbsenceRate-DID-all.png"))

qmplot(
  x = long,
  y = lat,
  fill = did_absence_rate_ill,
  group = group,
  facets = . ~ schoolyr,
  data = input_4_longlat,
  maptype = "toner-lite",
  geom = "polygon",
  legend = "bottom"
) + 
  scale_fill_distiller(palette='Spectral') +
  labs(title = "Mean Difference-in-Difference Illness-Specific Absence Rate by School during the Peak Week of Flu Season", fill="")

ggsave(filename=paste0(project_dir, "2c-P1-PeakwkAbsenceRate-DID-ill.png"))

# Input 5
qmplot(
  x = long,
  y = lat,
  fill = vaccination_coverage,
  group = group,
  facets = . ~ schoolyr,
  data = input_5_longlat,
  maptype = "toner-lite",
  geom = "polygon",
  legend = "bottom"
) + 
  scale_fill_distiller(palette='Spectral') +
  labs(title = "Mean Vaccination Coverage by School in each year", fill="")

ggsave(filename=paste0(project_dir, "2c-P2-VaccinationCoverage.png"))


################################################################################
# Exploratory Leaflet App
################################################################################


