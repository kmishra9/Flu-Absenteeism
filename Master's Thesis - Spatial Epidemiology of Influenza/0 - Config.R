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
library(sf)
library(rgdal)
library(maptools)

library(here)
library(assertthat)
library(kableExtra)


# File paths
data_dir = here("..", "Individual Projects - Data", "Flu-Absenteeism/")
project_dir = here("Flu-Absenteeism", "Master's Thesis - Spatial Epidemiology of Influenza/")

raw_data_path = paste0(data_dir, "absentee_all.csv")
raw_data_path_downsample = paste0(data_dir, "absentee_all_downsample.csv")

flu_path = paste0(data_dir, "absentee_flu.csv")
flu_path_downsample = paste0(data_dir, "absentee_flu_downsample.csv")

peakwk_path = paste0(data_dir, "absentee_peakwk.csv")
peakwk_path_downsample = paste0(data_dir, "absentee_peakwk_downsample.csv")

vaccination_coverage_path = paste0(data_dir, "vaccination_coverage.RDS")

school_names_path = paste0(data_dir, "school_names.RDS")

school_shapes_dir = paste0(data_dir, "SABS_1516/")
school_shapes_layer = "SABS_1516"

# Global variables
pre_program_schoolyrs = list("2011-12","2012-13", "2013-14")
program_schoolyrs = list("2014-15", "2015-16", "2016-17")

# Other scripts
source(here("Flu-Absenteeism", "Master's Thesis - Spatial Epidemiology of Influenza", "0 - Utils.R"))
