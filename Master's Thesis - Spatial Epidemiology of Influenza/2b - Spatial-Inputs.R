################################################################################
# Master's Thesis - Spatial Epidemiology of Absenteeism 
# Shoo the Flu Evaluation
# 2012-2017 Spatial Epidemiology Analysis
# Input management file for merging statistical inputs with spatial data
################################################################################
source(here::here("Flu-Absenteeism", "Master's Thesis - Spatial Epidemiology of Influenza", "0 - Config.R"))

################################################################################
# Import shape data and statistical inputs 
################################################################################

OUSD_study_school_shapes_longlat  = read_csv(file = OUSD_study_school_shapes_longlat_path)
WCCSD_study_school_shapes_longlat = read_csv(file = WCCSD_study_school_shapes_longlat_path)

input_1 = read_csv(file = input_1_path)
input_2 = read_csv(file = input_2_path)
input_3 = read_csv(file = input_3_path)
input_4 = read_csv(file = input_4_path)
input_5 = read_csv(file = input_5_path)
input_6 = read_csv(file = input_6_path)
input_7 = read_csv(file = input_7_path)
input_8 = read_csv(file = input_8_path)
input_9 = read_csv(file = input_9_path)

################################################################################
# Merge Datasets - Unique Key: (absentee_school_name, dist.n)
################################################################################

study_school_shapes_longlat = rbind(OUSD_study_school_shapes_longlat, WCCSD_study_school_shapes_longlat)

input_1_longlat = input_1 %>% left_join(study_school_shapes_longlat, by=c("school" = "absentee_alias", "dist.n"))
input_2_longlat = input_2 %>% left_join(study_school_shapes_longlat, by=c("school" = "absentee_alias", "dist.n"))
input_3_longlat = input_3 %>% left_join(study_school_shapes_longlat, by=c("school" = "absentee_alias", "dist.n"))
input_4_longlat = input_4 %>% left_join(study_school_shapes_longlat, by=c("school" = "absentee_alias", "dist.n"))
input_5_longlat = input_5 %>% left_join(study_school_shapes_longlat, by=c("school" = "absentee_alias", "dist.n"))
input_6_longlat = input_6 %>% left_join(study_school_shapes_longlat, by=c("school" = "absentee_alias", "dist.n"))
input_7_longlat = input_7 %>% left_join(study_school_shapes_longlat, by=c("school" = "absentee_alias", "dist.n"))
input_8_longlat = input_8 %>% left_join(study_school_shapes_longlat, by=c("school" = "absentee_alias", "dist.n"))
input_9_longlat = input_9 %>% left_join(study_school_shapes_longlat, by=c("school" = "absentee_alias", "dist.n"))

################################################################################
# Export several versions of aggregated spatial input data
################################################################################

write_csv(x = input_1_longlat, path = spatial_input_1_path)
write_csv(x = input_2_longlat, path = spatial_input_2_path)
write_csv(x = input_3_longlat, path = spatial_input_3_path)
write_csv(x = input_4_longlat, path = spatial_input_4_path)
write_csv(x = input_5_longlat, path = spatial_input_5_path)
write_csv(x = input_6_longlat, path = spatial_input_6_path)
write_csv(x = input_7_longlat, path = spatial_input_7_path)
write_csv(x = input_8_longlat, path = spatial_input_8_path)
write_csv(x = input_9_longlat, path = spatial_input_9_path)

