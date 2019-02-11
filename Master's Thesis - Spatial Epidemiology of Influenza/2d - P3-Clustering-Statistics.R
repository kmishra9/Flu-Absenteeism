################################################################################
# Master's Thesis - Spatial Epidemiology of Absenteeism 
# Shoo the Flu Evaluation
# 2012-2017 Spatial Epidemiology Analysis
# Cluster analysis file for generating numerical measures of clustering for Objective 3: 
# Objective 3: To find and characterize global and local clustering in absenteeism and vaccination coverage following the introduction of SLIV and understand how clusters of high/low vaccination coverage are correlated with clusters of high/low absenteeism
################################################################################
source(here::here("Flu-Absenteeism", "Master's Thesis - Spatial Epidemiology of Influenza", "0 - Config.R"))

################################################################################
# Import statistical inputs & clustering-prepped shapefiles
################################################################################

inputs = list(
  input_1 = read_csv(file = input_1_path),
  input_2 = read_csv(file = input_2_path),
  input_3 = read_csv(file = input_3_path),
  input_4 = read_csv(file = input_4_path),
  input_5 = read_csv(file = input_5_path),
  input_6 = read_csv(file = input_6_path),
  input_7 = read_csv(file = input_7_path),
  input_8 = read_csv(file = input_8_path),
  input_9 = read_csv(file = input_9_path)
)

OUSD_study_school_shapes = read_rds(path = OUSD_study_school_shapes_path)
WCCSD_study_school_shapes = read_rds(path = WCCSD_study_school_shapes_path)
all_study_school_shapes = raster::union(OUSD_study_school_shapes, WCCSD_study_school_shapes)

################################################################################
# Moran's I - Per Grouping
################################################################################

calculate_Morans = function(input_shape_file, grouping_column, queen = TRUE, style = "W", nsim=999) {
  # @Description: "Facet_wrap" for calculating Moran's I on every unique element in grouping_column
  # @Arg: input_shape_file: an SPDF that countains a grouping_colum
  # @Arg: grouping_column: a string column name of a column on which input_shape_file should be separated on and Moran's I calculated on each unique group
  # @Arg: queen: a boolean argument passed to poly2nb determining neighbor type
  # @Arg: style: a character argument passed to nb2listw determining style
  # @Arg: nsim: the number of times to sample for a bootstrap permutation test for Moran's I
  # @Return: a named list where names correspond to unique elements in grouping_column and values are the result of running moran.mc on the input shape file faceted by elements of grouping_column
  
  # Prep for Moran's I clustering by finding neighbors 
  neighbors = poly2nb(pl = input_shape_file, queen = queen)
  list_weights = nb2listw(neighbours = study_school_neighbors, style = "W", zero.policy = FALSE)
  
  # 
  for (unique_grouping_value in sort(unique(input_shape_file$grouping_column))) {
    select_on_unique_grouping_value = input_shape_file[[grouping_column]] == unique_grouping_value
    subsetted_input_shape_file = input_shape_file[select_on_unique_grouping_value,]
  }
  
}

# Input 1 (year)
input_1_shapes = sp::merge(x = all_study_school_shapes, y = input_1, by.x = c("absentee_alias", "dist.n"), by.y = c("school", "dist.n"), duplicateGeoms=TRUE)



# Input 2 (year)

# Input 3 (year)

# Input 4 (year)

# Input 5 (year)

################################################################################
# Geary's C - Per Year
################################################################################
