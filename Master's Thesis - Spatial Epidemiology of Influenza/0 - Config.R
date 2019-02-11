################################################################################
# Master's Thesis - Spatial Epidemiology of Absenteeism 
# Shoo the Flu Evaluation
# 2012-2017 Spatial Epidemiology Analysis
# Configuration file for setup and filepath specification
################################################################################

# Load libraries
library(tidyverse)
library(data.table)
library(broom)

library(ggplot2)
library(ggmap)
library(sp)
library(spdep)
#library(sf)
library(rgdal)
library(maptools)

library(here)
library(assertthat)
library(kableExtra)


# File paths
data_dir = here("..", "Individual Projects - Data", "Flu-Absenteeism/")
project_dir = here("Flu-Absenteeism", "Master's Thesis - Spatial Epidemiology of Influenza/")

# Absentee Data Paths
raw_data_path = paste0(data_dir, "absentee_all.csv")
raw_data_path_downsample = paste0(data_dir, "absentee_all_downsample.csv")
school_names_path = paste0(data_dir, "school_names.RDS")

flu_path = paste0(data_dir, "absentee_flu.csv")
flu_path_downsample = paste0(data_dir, "absentee_flu_downsample.csv")

peakwk_path = paste0(data_dir, "absentee_peakwk.csv")
peakwk_path_downsample = paste0(data_dir, "absentee_peakwk_downsample.csv")

# Vaccination Coverage Data Paths
vaccination_coverage_path = paste0(data_dir, "vaccination_coverage.RDS")

# Spatial Data Paths
school_shapes_dir = paste0(data_dir, "SABS_1516/")
school_shapes_layer = "SABS_1516"

OUSD_study_school_shapes_path = paste0(project_dir, "1b-OUSD-study-school-shapes.RDS")
WCCSD_study_school_shapes_path = paste0(project_dir, "1b-WCCSD-study-school-shapes.RDS")
OUSD_study_school_shapes_longlat_path = paste0(project_dir, "1b-OUSD-study-school-shapes-longlat.csv")
WCCSD_study_school_shapes_longlat_path = paste0(project_dir, "1b-WCCSD-study-school-shapes-longlat.csv")

# Statistical Input Paths
input_1_path = paste0(project_dir, "2a-I1-FluAbsenceRate.csv")
input_2_path = paste0(project_dir, "2a-I2-PeakwkAbsenceRate.csv")
input_3_path = paste0(project_dir, "2a-I3-FluAbsenceRate_DID.csv")
input_4_path = paste0(project_dir, "2a-I4-PeakwkAbsenceRate_DID.csv")
input_5_path = paste0(project_dir, "2a-I5-VaccinationCoverage.csv")
input_6_path = paste0(project_dir, "2a-I6-FluAbsenceRate_PrePost.csv")
input_7_path = paste0(project_dir, "2a-I7-PeakwkAbsenceRate_PrePost.csv")
input_8_path = paste0(project_dir, "2a-I8-FluAbsenceRate_PreWeakStrong.csv")
input_9_path = paste0(project_dir, "2a-I9-PeakwkAbsenceRate_PreWeakStrong.csv")

# Spatial Input Paths
spatial_input_1_path = paste0(project_dir, "2b-I1-Spatial-FluAbsenceRate.csv")
spatial_input_2_path = paste0(project_dir, "2b-I2-Spatial-PeakwkAbsenceRate.csv")
spatial_input_3_path = paste0(project_dir, "2b-I3-Spatial-FluAbsenceRate_DID.csv")
spatial_input_4_path = paste0(project_dir, "2b-I4-Spatial-PeakwkAbsenceRate_DID.csv")
spatial_input_5_path = paste0(project_dir, "2b-I5-Spatial-VaccinationCoverage.csv")
spatial_input_6_path = paste0(project_dir, "2b-I6-Spatial-FluAbsenceRate_PrePost.csv")
spatial_input_7_path = paste0(project_dir, "2b-I7-Spatial-PeakwkAbsenceRate_PrePost.csv")
spatial_input_8_path = paste0(project_dir, "2b-I8-Spatial-FluAbsenceRate_PreWeakStrong.csv")
spatial_input_9_path = paste0(project_dir, "2b-I9-Spatial-PeakwkAbsenceRate_PreWeakStrong.csv")

# Global variables
pre_program_schoolyrs = list("2011-12","2012-13", "2013-14")
program_schoolyrs = list("2014-15", "2015-16", "2016-17", "2017-18")
weak_vaccine_schoolyrs = list("2014-15", "2015-16")
strong_vaccine_schoolyrs = list("2016-17", "2017-18")

# Other scripts
source(here("Flu-Absenteeism", "Master's Thesis - Spatial Epidemiology of Influenza", "0 - Utils.R"))
