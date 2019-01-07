##############################################
# Master's Thesis - Spatial Epidemiology of Absenteeism 
# Shoo the Flu Evaluation
# 2012-2017 Spatial Epidemiology Analysis
# Configuration file for setup and filepath specification
##############################################

# Load libraries
library(tidyverse)
library(here)
library(data.table)
library(ggplot2)
library(assertthat)
library(gee)
library(lme4)
library(lmtest)
library(kableExtra)

data_dir = here("..", "Individual Projects - Data", "Flu-Absenteeism/")

raw_data_path = paste0(data_dir, "absentee_all.csv")
raw_data_path_downsample = paste0(data_dir, "absentee_all_downsample.csv")

raw_data_path_RDS = paste0(data_dir, "absentee_all.RDS")
raw_data_path_RDS_downsample = paste0(data_dir, "absentee_all_downsample.RDS")

peakmonths_data_prefix = paste0(data_dir, "absentee_1617_peakmonths")

long_peak_weekly_rates_prefix = paste0(data_dir, "absentee_1617_peak_weekly_rates")

source(here("Flu-Absenteeism", "Master's Thesis - Spatial Epidemiology of Influenza", "0 - Utils.R"))
