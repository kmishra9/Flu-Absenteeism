################################################################################
# Master's Thesis - Spatial Epidemiology of Absenteeism 
# Shoo the Flu Evaluation
# 2012-2017 Spatial Epidemiology Analysis
# Cluster analysis file for generating numerical measures of clustering for Objective 3: 
# Objective 3: To find and characterize global and local clustering in absenteeism and vaccination coverage following the introduction of SLIV and understand how clusters of high/low vaccination coverage are correlated with clusters of high/low absenteeism
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
# Moran's I - Per Year
################################################################################

################################################################################
# Geary's C - Per Year
################################################################################
