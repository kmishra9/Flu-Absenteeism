################################################################################
# Master's Thesis - Spatial Epidemiology of Absenteeism 
# Shoo the Flu Evaluation
# 2011-2018 Spatial Epidemiology Analysis
# Cluster analysis file for generating numerical measures of clustering for Objective 3: 
# Objective 3: To find and characterize global and local clustering in absenteeism and vaccination coverage following the introduction of SLIV and understand how clusters of high/low vaccination coverage are correlated with clusters of high/low absenteeism
# Motivating Articles: https://github.com/gisUTM/spatialplots and https://aledemogr.com/2017/10/16/global-and-local-measures-of-spatial-autocorrelation/
################################################################################
source(here::here("Flu-Absenteeism", "Master's Thesis - Spatial Epidemiology of Influenza", "0 - Config.R"))

################################################################################
# Import statistical inputs & clustering-prepped shapefiles
################################################################################

input_1 = read_csv(file = input_1_path) %>% mutate(school_dist = paste0(school, "-", dist.n))
input_2 = read_csv(file = input_2_path) %>% mutate(school_dist = paste0(school, "-", dist.n))
input_3 = read_csv(file = input_3_path) %>% mutate(school_dist = paste0(school, "-", dist.n))
input_4 = read_csv(file = input_4_path) %>% mutate(school_dist = paste0(school, "-", dist.n))
input_5 = read_csv(file = input_5_path) %>% mutate(school_dist = paste0(school, "-", dist.n))
input_6 = read_csv(file = input_6_path) %>% mutate(school_dist = paste0(school, "-", dist.n))
input_7 = read_csv(file = input_7_path) %>% mutate(school_dist = paste0(school, "-", dist.n))
input_8 = read_csv(file = input_8_path) %>% mutate(school_dist = paste0(school, "-", dist.n))
input_9 = read_csv(file = input_9_path) %>% mutate(school_dist = paste0(school, "-", dist.n))

OUSD_study_school_shapes = read_rds(path = OUSD_study_school_shapes_path)
WCCSD_study_school_shapes = read_rds(path = WCCSD_study_school_shapes_path)
all_study_school_shapes = raster::union(OUSD_study_school_shapes, WCCSD_study_school_shapes)

# Ordering by absentee_alias-dist.n to match the eventual ordering of counts
all_study_school_shapes$school_dist = paste0(all_study_school_shapes$absentee_alias, "-", all_study_school_shapes$dist.n)
all_study_school_shapes = all_study_school_shapes[order(all_study_school_shapes$school_dist),]

################################################################################
# # Define functions for Kuldorff Spatial Scan Statistics
################################################################################

theme_update(
  plot.title = element_text(hjust = 0.5),
  legend.key.width = unit(1, "cm")
)

calculate_KSSS = function(centroids, statistical_input, time_column = "schoolyr", location_column = "school_dist", value_column = "absences_ill", population_column = "student_days", k_nearest_neighbors = 5, nsim = 9999, heat_map = TRUE, heat_map_title = NULL, heat_map_caption = NULL) {
  # @Description: Calculates the population-based KSSS
  # @Arg: centroids: an SPDF from which the centroids of each school catchment area can be drawn, along with a uniquely identifying location_column (such as an ID or School-District combo)
  # @Arg: statistical_input: a tibble of at least 4 columns containing a location, time, value, and population size, ordered by (location_column, time_column)
  # @Arg: time_column: an integer or string column on which values can be clustered temporally
  # @Arg: location_column: an integer or string column on which values can be clustered spatially (must be a unique key)
  # @Arg: value_column: an integer or string column containing the count data for the given space-time
  # @Arg: population_column: an integer column containing the size of the population for the given space-time
  # @Arg: heat_map: a boolean variable dictating whether to plot a heat_map based on how likely a school catchment is to be part of a cluster
  # @Arg: heat_map_title: a string used as the title for a heat_map if one is drawn
  # @Arg: heat_map_caption: a string used as the caption for a heat_map if one is drawn
  # @Output: plots a heatmap local clustering and prints the total number of significant clusters if heat_map = TRUE
  # @Return: the a list containing the results of running KSSS and a tibble of the significant clusters

  # Calculate observed counts - columns represent locations and rows represent time intervals, ordered chronologically from earliest to most recent
  sorted_statistical_input = statistical_input %>% arrange_(location_column, time_column)
  counts =  sorted_statistical_input %>% 
    df_to_matrix(time_col = time_column, location_col = location_column, value_col = value_column)
  
  # Generate zones using k-nearest-neighbors
  zones = spDists(x = centroids) %>% 
    dist_to_knn(k = k_nearest_neighbors) %>% 
    knn_zones
  
  # Get the population vector and convert it to a matrix
  counts_num_rows = dim(counts)[1]
  counts_num_cols = dim(counts)[2]
  population_vector = statistical_input[[population_column]]
  assert_that(counts_num_rows * counts_num_cols == length(population_vector))
  population_matrix = matrix(data = population_vector, nrow = counts_num_rows, ncol = counts_num_cols)
  
  # Calculate the population-based Poisson scan statistic
  poisson_result = scan_pb_poisson(counts = counts, zones = zones, population = population_matrix, n_mcsim = nsim)
  
  significant_clusters = top_clusters(x = poisson_result, k = poisson_result$n_zones, zones = zones) %>% 
    filter(Gumbel_pvalue <= .05)
  
  # Generate a heatmap for each location based on how likely it is to be part of a cluster if specified
  if (heat_map) {
    centroids_long_lat = centroids %>% 
      spTransform(CRSobj = CRS("+proj=longlat +datum=WGS84")) %>% 
      tidy(region = location_column)
    
    location_scores = score_locations(x = poisson_result, zones = zones) %>%
      mutate(locations = sorted_statistical_input %>% pull(location_column) %>% unique)
    
    location_scores_long_lat = location_scores %>% 
      left_join(centroids_long_lat, by = c("locations" = "id"))
    
    num_clusters = significant_clusters %>% nrow
    
    print(
      qmplot(
        x = long,
        y = lat,
        fill = (score - min(score)) / (max(score) - min(score)),
        group = group,
        data = location_scores_long_lat,
        maptype = "toner-lite",
        geom = "polygon",
        legend = "bottom"
      ) +
        scale_fill_distiller(palette='Spectral') +
        labs(title = heat_map_title, fill = "", caption = paste0(heat_map_caption, "\n", "There were ", num_clusters, " significant local clusters found.")) +
        theme(plot.title = element_text(size = 10), plot.caption = element_text(hjust =.5))
    )
  }
  
  return(list("Poisson Result"=poisson_result, "Significant Clusters"=significant_clusters))
}

################################################################################
# Calculate KSSS - Per Year, Program Period (Pre/Post), Primary STF Vaccine Type Period (Pre/LAIV/IIV)
################################################################################

input_1_KSSS_ill = calculate_KSSS(
  centroids = all_study_school_shapes,
  statistical_input = input_1,
  k_nearest_neighbors = 5,
  heat_map_title = "Local Clustering of Illness-Specific\n Absence Rates in all years during Flu Season"
)

input_2_KSSS_ill = calculate_KSSS(
  centroids = all_study_school_shapes,
  statistical_input = input_2,
  k_nearest_neighbors = 5,
  heat_map_title = "Local Clustering of Illness-Specific\n Absence Rates in all years during Peak Week"
)

# Inputs 3, 4, and 5 are rate data, rather than count data... Thus they require other local clustering techniques, such as Local Moran's I

input_8_KSSS_ill_0 = calculate_KSSS(
  centroids = all_study_school_shapes,
  statistical_input = input_8 %>% filter(period == 0),
  time_column = "period",
  k_nearest_neighbors = 5,
  heat_map_title = "Local Clustering during Flu Seasons\n of Pre-Program Period"
)

ggsave(filename=paste0(project_dir, "2e-P3-Figure-1-FluLocalClusters-ill_PRE.png"))

input_8_KSSS_ill_1 = calculate_KSSS(
  centroids = all_study_school_shapes,
  statistical_input = input_8 %>% filter(period == 1),
  time_column = "period",
  k_nearest_neighbors = 5,
  heat_map_title = "Local Clustering during Flu Seasons\n of LAIV Period"
)

ggsave(filename=paste0(project_dir, "2e-P3-Figure-2-FluLocalClusters-ill_LAIV.png"))

input_8_KSSS_ill_2 = calculate_KSSS(
  centroids = all_study_school_shapes,
  statistical_input = input_8 %>% filter(period == 2),
  time_column = "period",
  k_nearest_neighbors = 5,
  heat_map_title = "Local Clustering during Flu Seasons\n of IIV Period"
)

ggsave(filename=paste0(project_dir, "2e-P3-Figure-3-FluLocalClusters-ill_IIV.png"))

input_9_KSSS_ill_0 = calculate_KSSS(
  centroids = all_study_school_shapes,
  statistical_input = input_9 %>% filter(period == 0),
  time_column = "period",
  k_nearest_neighbors = 5,
  heat_map_title = "Local Clustering during Peak Weeks\n of Pre-Program Period"
)

ggsave(filename=paste0(project_dir, "2e-P3-Figure-4-PeakwkLocalClusters-ill_PRE.png"))

input_9_KSSS_ill_1 = calculate_KSSS(
  centroids = all_study_school_shapes,
  statistical_input = input_9 %>% filter(period == 1),
  time_column = "period",
  k_nearest_neighbors = 5,
  heat_map_title = "Local Clustering during Peak Weeks\n of LAIV Period"
)

ggsave(filename=paste0(project_dir, "2e-P3-Figure-5-PeakwkLocalClusters-ill_LAIV.png"))

input_9_KSSS_ill_2 = calculate_KSSS(
  centroids = all_study_school_shapes,
  statistical_input = input_9 %>% filter(period == 2),
  time_column = "period",
  k_nearest_neighbors = 5,
  heat_map_title = "Local Clustering during Peak Weeks\n of IIV Period"
)

ggsave(filename=paste0(project_dir, "2e-P3-Figure-6-PeakwkLocalClusters-ill_IIV.png"))

