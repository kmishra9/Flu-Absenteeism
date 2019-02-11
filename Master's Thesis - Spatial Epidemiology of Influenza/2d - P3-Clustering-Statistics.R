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
input_6_longlat = read_csv(file = spatial_input_6_path)
input_7_longlat = read_csv(file = spatial_input_7_path)
input_8_longlat = read_csv(file = spatial_input_8_path)
input_9_longlat = read_csv(file = spatial_input_9_path)

OUSD_study_school_shapes = read_rds(path = OUSD_study_school_shapes_path)
WCCSD_study_school_shapes = read_rds(path = WCCSD_study_school_shapes_path)

################################################################################
# Prep shape files for Moran's I clustering 
################################################################################

OUSD_neighbors = poly2nb(pl = OUSD_study_school_shapes, queen = TRUE)
WCCSD_neighbors = poly2nb(pl = WCCSD_study_school_shapes, queen = TRUE)

OUSD_list_weights = nb2listw(neighbours = OUSD_neighbors, style = "W", zero.policy = FALSE)
WCCSD_list_weights = nb2listw(neighbours = WCCSD_neighbors, style = "W", zero.policy = FALSE)

################################################################################
# Moran's I - Per Year
################################################################################

################################################################################
# Geary's C - Per Year
################################################################################
