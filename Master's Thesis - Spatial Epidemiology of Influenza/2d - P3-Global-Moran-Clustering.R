################################################################################
# Master's Thesis - Spatial Epidemiology of Absenteeism 
# Shoo the Flu Evaluation
# 2011-2018 Spatial Epidemiology Analysis
# Cluster analysis file for generating numerical measures of clustering for Objective 3: 
# Objective 3: To find and characterize global and local clustering in absenteeism and vaccination coverage following the introduction of SLIV and understand how clusters of high/low vaccination coverage are correlated with clusters of high/low absenteeism
################################################################################
source(here::here("Flu-Absenteeism", "Master's Thesis - Spatial Epidemiology of Influenza", "0 - Config.R"))

################################################################################
# Import statistical inputs & clustering-prepped shapefiles
################################################################################

input_1 = read_csv(file = input_1_path)
input_2 = read_csv(file = input_2_path)
input_3 = read_csv(file = input_3_path)
input_4 = read_csv(file = input_4_path)
input_5 = read_csv(file = input_5_path)
input_6 = read_csv(file = input_6_path)
input_7 = read_csv(file = input_7_path)
input_8 = read_csv(file = input_8_path)
input_9 = read_csv(file = input_9_path)

OUSD_study_school_shapes = read_rds(path = OUSD_study_school_shapes_path)
WCCSD_study_school_shapes = read_rds(path = WCCSD_study_school_shapes_path)
all_study_school_shapes = raster::union(OUSD_study_school_shapes, WCCSD_study_school_shapes)

################################################################################
# Global Moran's I - Per Year, Program Period (Pre/Post), Vaccine Effectiveness Period (Pre/Weak/Strong)
################################################################################

calculate_Morans = function(input_shape_file, grouping_column, clustering_column, queen = TRUE, style = "W", zero.policy = FALSE, randomisation = TRUE, mc = FALSE, nsim = 9999) {
  # @Description: "Facet_wrap" for calculating Moran's I on every unique element in grouping_column
  # @Arg: input_shape_file: an SPDF that countains a grouping_colum
  # @Arg: grouping_column: a string column name of a column on which input_shape_file should be separated on and Moran's I calculated on each unique group
  # @Arg: clustering_column: a string column name containing values for which clustering should be determined with Moran's I
  # @Arg: queen: a boolean argument passed to poly2nb determining neighbor type
  # @Arg: style: a character argument passed to nb2listw determining style
  # @Arg: zero.policy: a boolean argument passed to nb2listw and moran.mc determining whether polygons without neighbors should error (zero.policy = FALSE) or continue quietly while setting lagging variables to 0 (zero.policy = TRUE)
  # @Arg: randomisation: a boolean argument determining whether Moran's I is computed under randomisation or normality (assumption of variance) - only applicable if mc=FALSE
  # @Arg: mc: a boolean argument determining how Moran's I is computed -- using a standard test under variance assumptions or with a Monte Carlo simulation
  # @Arg: nsim: the number of times to sample for a bootstrap permutation test for Moran's I - only applicaplbe if mc=TRUE
  # @Return: a named list where names correspond to unique elements in grouping_column and values are the result of running moran.mc on the input shape file faceted by elements of grouping_column
  assert_that(!is.null(input_shape_file[[grouping_column]]) & !is.null(input_shape_file[[clustering_column]]))
  
  morans_by_group = list()
  
  # Partition by unique values in grouping_column, find neighbors, and calculate Moran's I on clustering column
  for (unique_grouping_value in as.factor(sort(unique(input_shape_file[[grouping_column]])))) {
    select_on_unique_grouping_value = input_shape_file[[grouping_column]] == unique_grouping_value
    subsetted_input_shape_file = input_shape_file[select_on_unique_grouping_value,]
    
    neighbors = poly2nb(pl = subsetted_input_shape_file, queen = queen)
    list_weights = nb2listw(neighbours = neighbors, style = "W", zero.policy = zero.policy)
    
    if (mc) {
      morans_by_group[[unique_grouping_value]] = moran.mc(x = subsetted_input_shape_file[[clustering_column]], listw = list_weights, nsim = nsim, na.action = na.omit, zero.policy = zero.policy)  
    } else {
      morans_by_group[[unique_grouping_value]] = moran.test(x = subsetted_input_shape_file[[clustering_column]], listw = list_weights, na.action = na.omit, zero.policy = zero.policy, randomisation = randomisation)
    }
  }
  
  return(morans_by_group)
}

# Input 1 (year)
input_1_shapes = sp::merge(
  x = all_study_school_shapes,
  y = input_1,
  by.x = c("absentee_alias", "dist.n"),
  by.y = c("school", "dist.n"),
  duplicateGeoms = TRUE
)

input_1_moran_all = calculate_Morans(input_shape_file = input_1_shapes, grouping_column = "schoolyr", clustering_column = "absence_rate_all")
input_1_moran_ill = calculate_Morans(input_shape_file = input_1_shapes, grouping_column = "schoolyr", clustering_column = "absence_rate_ill")

# Input 2 (year)
input_2_shapes = sp::merge(
  x = all_study_school_shapes,
  y = input_2,
  by.x = c("absentee_alias", "dist.n"),
  by.y = c("school", "dist.n"),
  duplicateGeoms = TRUE
)

input_2_moran_all = calculate_Morans(input_shape_file = input_2_shapes, grouping_column = "schoolyr", clustering_column = "absence_rate_all")
input_2_moran_ill = calculate_Morans(input_shape_file = input_2_shapes, grouping_column = "schoolyr", clustering_column = "absence_rate_ill")

# Input 3 (year)
input_3_shapes = sp::merge(
  x = all_study_school_shapes,
  y = input_3,
  by.x = c("absentee_alias", "dist.n"),
  by.y = c("school", "dist.n"),
  duplicateGeoms = TRUE
)

input_3_moran_all = calculate_Morans(input_shape_file = input_3_shapes, grouping_column = "schoolyr", clustering_column = "did_absence_rate_all")
input_3_moran_ill = calculate_Morans(input_shape_file = input_3_shapes, grouping_column = "schoolyr", clustering_column = "did_absence_rate_ill")

# Input 4 (year)
input_4_shapes = sp::merge(
  x = all_study_school_shapes,
  y = input_4,
  by.x = c("absentee_alias", "dist.n"),
  by.y = c("school", "dist.n"),
  duplicateGeoms = TRUE
)

input_4_moran_all = calculate_Morans(input_shape_file = input_4_shapes, grouping_column = "schoolyr", clustering_column = "did_absence_rate_all")
input_4_moran_ill = calculate_Morans(input_shape_file = input_4_shapes, grouping_column = "schoolyr", clustering_column = "did_absence_rate_ill")

# Input 5 (year)
input_5_shapes = sp::merge(
  x = all_study_school_shapes,
  y = input_5,
  by.x = c("absentee_alias", "dist.n"),
  by.y = c("school", "dist.n"),
  duplicateGeoms = TRUE
)

input_5_shapes@data = input_5_shapes@data %>% na.omit()

input_5_moran_all = calculate_Morans(input_shape_file = input_5_shapes, grouping_column = "schoolyr", clustering_column = "vaccination_coverage", zero.policy = TRUE)
input_5_moran_ill = calculate_Morans(input_shape_file = input_5_shapes, grouping_column = "schoolyr", clustering_column = "vaccination_coverage", zero.policy = TRUE)

# Input 6 (program - PrePost intervention)
input_6_shapes = sp::merge(
  x = all_study_school_shapes,
  y = input_6,
  by.x = c("absentee_alias", "dist.n"),
  by.y = c("school", "dist.n"),
  duplicateGeoms = TRUE
)

input_6_moran_all = calculate_Morans(input_shape_file = input_6_shapes, grouping_column = "program", clustering_column = "absence_rate_all")
input_6_moran_ill = calculate_Morans(input_shape_file = input_6_shapes, grouping_column = "program", clustering_column = "absence_rate_ill")

names(input_6_moran_all) = c("Pre-Program", "Intervention Period")
names(input_6_moran_ill) = names(input_6_moran_all)

# Input 7 (program - PrePost intervention)
input_7_shapes = sp::merge(
  x = all_study_school_shapes,
  y = input_7,
  by.x = c("absentee_alias", "dist.n"),
  by.y = c("school", "dist.n"),
  duplicateGeoms = TRUE
)

input_7_moran_all = calculate_Morans(input_shape_file = input_7_shapes, grouping_column = "program", clustering_column = "absence_rate_all")
input_7_moran_ill = calculate_Morans(input_shape_file = input_7_shapes, grouping_column = "program", clustering_column = "absence_rate_ill")

names(input_7_moran_all) = names(input_6_moran_all)
names(input_7_moran_ill) = names(input_6_moran_all)

# Input 8 (period - PreWeakStrong vaccines)
input_8_shapes = sp::merge(
  x = all_study_school_shapes,
  y = input_8,
  by.x = c("absentee_alias", "dist.n"),
  by.y = c("school", "dist.n"),
  duplicateGeoms = TRUE
)

input_8_moran_all = calculate_Morans(input_shape_file = input_8_shapes, grouping_column = "period", clustering_column = "absence_rate_all")
input_8_moran_ill = calculate_Morans(input_shape_file = input_8_shapes, grouping_column = "period", clustering_column = "absence_rate_ill")

names(input_8_moran_all) = c("Pre-Program", "Ineffective Vaccine", "Effective Vaccine")
names(input_8_moran_ill) = names(input_8_moran_all)

# Input 9 (period - PreWeakStrong vaccines)
input_9_shapes = sp::merge(
  x = all_study_school_shapes,
  y = input_9,
  by.x = c("absentee_alias", "dist.n"),
  by.y = c("school", "dist.n"),
  duplicateGeoms = TRUE
)

input_9_moran_all = calculate_Morans(input_shape_file = input_9_shapes, grouping_column = "period", clustering_column = "absence_rate_all")
input_9_moran_ill = calculate_Morans(input_shape_file = input_9_shapes, grouping_column = "period", clustering_column = "absence_rate_ill")

names(input_9_moran_all) = names(input_8_moran_all)
names(input_9_moran_ill) = names(input_8_moran_all)

################################################################################
# Extract Results
################################################################################
results = list(
  input_1_moran_all, input_1_moran_ill,
  input_2_moran_all, input_2_moran_ill,
  input_3_moran_all, input_3_moran_ill,
  input_4_moran_all, input_4_moran_ill,
  input_5_moran_all, input_5_moran_ill,
  input_6_moran_all, input_6_moran_ill,
  input_7_moran_all, input_7_moran_ill,
  input_8_moran_all, input_8_moran_ill,
  input_9_moran_all, input_9_moran_ill
)

names(results) = list(
  "input_1_moran_all", "input_1_moran_ill",
  "input_2_moran_all", "input_2_moran_ill",
  "input_3_moran_all", "input_3_moran_ill",
  "input_4_moran_all", "input_4_moran_ill",
  "input_5_moran_all", "input_5_moran_ill",
  "input_6_moran_all", "input_6_moran_ill",
  "input_7_moran_all", "input_7_moran_ill",
  "input_8_moran_all", "input_8_moran_ill",
  "input_9_moran_all", "input_9_moran_ill"
)

mc = "mc.sim" %in% (input_9_moran_ill[[1]] %>% class)

# Formatting for Moran Monte Carlo
if (mc) {
  
  extracted_results = frame_data(~"Input", ~"Grouping", ~"Moran I Statistic", ~"P-Value")
  for (result_name in names(results)) {
    input_x_moran = results[[result_name]]
    
    for (grouping in names(input_x_moran)){
      raw_result = input_x_moran[[grouping]]
      statistic  = raw_result[["statistic"]]
      p_value    = raw_result[["p.value"]]
      
      extracted_results = extracted_results %>% 
        add_row(
          "Input"             = result_name,
          "Grouping"          = grouping,
          "Moran I Statistic" = statistic,
          "P-Value"           = p_value
        )
    }
  }

# Formatting for Moran test w/ assumptions
} else {
  
  extracted_results = frame_data(~"Input", ~"Grouping", ~"Moran I Statistic", ~"Expectation", ~"Variance", ~"P-Value")
  for (result_name in names(results)) {
    input_x_moran = results[[result_name]]
    
    for (grouping in names(input_x_moran)){
      raw_result = input_x_moran[[grouping]]
      estimate   = raw_result[["estimate"]]
      p_value    = raw_result[["p.value"]]
      
      extracted_results = extracted_results %>% 
        add_row(
          "Input"             = result_name,
          "Grouping"          = grouping,
          "Moran I Statistic" = estimate[["Moran I statistic"]],
          "Expectation"       = estimate[["Expectation"]],
          "Variance"          = estimate[["Variance"]],
          "P-Value"           = p_value
        )
    }
  }
  
}



extracted_results_all = extracted_results[str_which(string=extracted_results[["Input"]], pattern="all"),]
extracted_results_ill = extracted_results[str_which(string=extracted_results[["Input"]], pattern="ill"),]

################################################################################
# Export all results of clustering statistics for each statistical input
################################################################################

write_rds(x = results, path = raw_results_path)
write_csv(x = extracted_results, path = extracted_results_path)
write_csv(x = extracted_results_all, path = extracted_results_all_path)
write_csv(x = extracted_results_ill, path = extracted_results_ill_path)
