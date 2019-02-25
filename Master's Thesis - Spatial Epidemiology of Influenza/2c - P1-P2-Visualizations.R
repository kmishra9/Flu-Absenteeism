################################################################################
# Master's Thesis - Spatial Epidemiology of Absenteeism 
# Shoo the Flu Evaluation
# 2011-2018 Spatial Epidemiology Analysis
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
input_6_longlat = read_csv(file = spatial_input_6_path)
input_7_longlat = read_csv(file = spatial_input_7_path)
input_8_longlat = read_csv(file = spatial_input_8_path)
input_9_longlat = read_csv(file = spatial_input_9_path)


################################################################################
# Static Maps per Spatial Input, Faceted by School Year
################################################################################

theme_update(
  plot.title = element_text(hjust = 0.5),
  legend.key.width = unit(1.5, "cm")
)

################################################################################
# Input 1
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
  

ggsave(filename=paste0(project_dir, "2c-P1-Appendix-1-FluAbsenceRate-ill.png"))

################################################################################
# Input 2
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
  labs(title = "Mean Illness-Specific Absence Rate by School during the Peak Week of Flu Season", fill="") +
  theme(plot.title = element_text(size=10))

ggsave(filename=paste0(project_dir, "2c-P1-Appendix-2-PeakwkAbsenceRate-ill.png"))

################################################################################
# Input 3
qmplot(
  x = long,
  y = lat,
  fill = did_absence_rate_ill,
  group = group,
  facets = . ~ schoolyr,
  data = input_3_longlat %>% filter(schoolyr == "2016-17"),
  maptype = "toner-lite",
  geom = "polygon",
  legend = "bottom"
) + 
  scale_fill_distiller(palette='Spectral') +
  labs(title = "Figure 1: Mean Difference-in-Difference Illness-Specific\n Absence Rate by School during Flu Season", fill="") +
  theme(plot.title = element_text(size=10))

ggsave(filename=paste0(project_dir, "2c-P1-Figure-1-FluAbsenceRate-DID-ill.png"))

# All Facets
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
  labs(title = "Mean Difference-in-Difference Illness-Specific\n Absence Rate by School during Flu Season", fill="")

ggsave(filename=paste0(project_dir, "2c-P1-Appendix-3-FluAbsenceRate-DID-ill.png"))

################################################################################
# Input 4
qmplot(
  x = long,
  y = lat,
  fill = did_absence_rate_ill,
  group = group,
  facets = . ~ schoolyr,
  data = input_4_longlat %>% filter(schoolyr == "2016-17"),
  maptype = "toner-lite",
  geom = "polygon",
  legend = "bottom"
) + 
  scale_fill_distiller(palette='Spectral') +
  labs(title = "Figure 2: Mean Difference-in-Difference Illness-Specific\n Absence Rate by School during the Peak Week of Flu Season", fill="") +
  theme(plot.title = element_text(size=10))

ggsave(filename=paste0(project_dir, "2c-P1-Figure-2-PeakwkAbsenceRate-DID-ill.png"))

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
  labs(title = "Mean Difference-in-Difference Illness-Specific Absence\nRate by School during the Peak Week of Flu Season", fill="")

ggsave(filename=paste0(project_dir, "2c-P1-Appendix-4-PeakwkAbsenceRate-DID-ill.png"))

################################################################################
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
  scale_fill_distiller(palette='Spectral', direction=1) +
  labs(title = "Figure 8: Mean Vaccination Coverage by School in each year", fill="") 

ggsave(filename=paste0(project_dir, "2c-P2-Figure-8-VaccinationCoverage.png"))

################################################################################
# Input 6
input_6_longlat = input_6_longlat %>% mutate(program = as.factor(program))
levels(input_6_longlat$program) = c("Pre-Program", "Intervention Period")

qmplot(
  x = long,
  y = lat,
  fill = absence_rate_ill,
  group = group,
  facets = . ~ program,
  data = input_6_longlat,
  maptype = "toner-lite",
  geom = "polygon",
  legend = "bottom"
) + 
  scale_fill_distiller(palette='Spectral') +
  labs(title = "Figure 3: Mean Illness-Specific Absence Rate by School during Flu Season", fill="") +
  theme(plot.title = element_text(size=10))

ggsave(filename=paste0(project_dir, "2c-P1-Figure-3-FluAbsenceRate-ill_PrePost.png"))

################################################################################
# Input 7
input_7_longlat = input_7_longlat %>% mutate(program = as.factor(program))
levels(input_7_longlat$program) = c("Pre-Program", "Intervention Period")

qmplot(
  x = long,
  y = lat,
  fill = absence_rate_ill,
  group = group,
  facets = . ~ program,
  data = input_7_longlat,
  maptype = "toner-lite",
  geom = "polygon",
  legend = "bottom"
) + 
  scale_fill_distiller(palette='Spectral') +
  labs(title = "Figure 5: Mean Illness-Specific Absence Rate by School during the Peak Week of Flu Season", fill="") +
  theme(plot.title = element_text(size=10))

ggsave(filename=paste0(project_dir, "2c-P1-Figure-5-PeakwkAbsenceRate-ill_PrePost.png"))

################################################################################
# Input 8
input_8_longlat = input_8_longlat %>% mutate(period = as.factor(period))
levels(input_8_longlat$period) = c("Pre-Program", "Primary STF Vaccine Type: LAIV", "Primary STF Vaccine Type: IIV")

qmplot(
  x = long,
  y = lat,
  fill = absence_rate_ill,
  group = group,
  facets = . ~ period,
  data = input_8_longlat,
  maptype = "toner-lite",
  geom = "polygon",
  legend = "bottom"
) + 
  scale_fill_distiller(palette='Spectral') +
  labs(title = "Figure 4: Mean Illness-Specific Absence Rate by School during Flu Season", fill="") +
  theme(plot.title = element_text(size=12))

ggsave(filename=paste0(project_dir, "2c-P1-Figure-4-FluAbsenceRate-ill_PreLaivIiv.png"))

################################################################################
# Input 9
input_9_longlat = input_9_longlat %>% mutate(period = as.factor(period))
levels(input_9_longlat$period) = c("Pre-Program", "Primary STF Vaccine Type: LAIV", "Primary STF Vaccine Type: IIV")

qmplot(
  x = long,
  y = lat,
  fill = absence_rate_ill,
  group = group,
  facets = . ~ period,
  data = input_9_longlat,
  maptype = "toner-lite",
  geom = "polygon",
  legend = "bottom"
) + 
  scale_fill_distiller(palette='Spectral') +
  labs(title = "Figure 6: Mean Illness-Specific Absence Rate by School during the Peak Week of Flu Season", fill="") +
  theme(plot.title = element_text(size=10))

ggsave(filename=paste0(project_dir, "2c-P1-Figure-6-PeakwkAbsenceRate-ill_PreLaivIiv.png"))
