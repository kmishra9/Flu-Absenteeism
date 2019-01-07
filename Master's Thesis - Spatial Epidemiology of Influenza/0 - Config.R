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

flu_path = paste0(data_dir, "absentee_flu.csv")
flu_path_downsample = paste0(data_dir, "absentee_flu_downsample.csv")

peakwk_path = paste0(data_dir, "absentee_peakwk.csv")
peakwk_path_downsample = paste0(data_dir, "absentee_peakwk_downsample.csv")

vaccination_coverage_path = paste0(data_dir, "vaccination_coverage.RDS")

source(here("Flu-Absenteeism", "Master's Thesis - Spatial Epidemiology of Influenza", "0 - Utils.R"))
