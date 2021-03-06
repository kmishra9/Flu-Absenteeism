##############################################
# PH242C - Longitudinal Data - Final Project 
# Shoo the Flu Evaluation
# 2016-2017 Peakmonths Longitudinal Analysis
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

source(here("Flu-Absenteeism", "PH242C - Final Project", "0 - Utils.R"))
