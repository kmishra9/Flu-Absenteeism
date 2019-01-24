################################################################################
# Master's Thesis - Spatial Epidemiology of Absenteeism 
# Shoo the Flu Evaluation
# 2012-2017 Spatial Epidemiology Analysis
# Data Management file for raw dataset import, cleaning, and export
################################################################################
source(here::here("Flu-Absenteeism", "Master's Thesis - Spatial Epidemiology of Influenza", "0 - Config.R"))

################################################################################
# Import absentee data & downsample
################################################################################

absentee_all = fread(file = raw_data_path) %>% as.tibble()
absentee_all_downsample = down_sample(data = absentee_all)

school_shapes = readOGR(dsn=school_shapes_dir, layer=school_shapes_layer)

################################################################################
# Clean and limit absentee data to what is relevant to analysis
################################################################################

absentee_flu = absentee_all %>% filter(fluseasCDPH == 1)
absentee_flu_downsample = absentee_all_downsample %>% filter(fluseasCDPH == 1)

absentee_peakwk = absentee_all %>% filter(peakwk == 1)
absentee_peakwk_downsample = absentee_all_downsample %>% filter(peakwk == 1)

################################################################################
# Export several versions of absentee data
################################################################################

write_csv(x = absentee_all_downsample, path = raw_data_path_downsample)

write_csv(x = absentee_flu, path = flu_path)
write_csv(x = absentee_flu_downsample, path = flu_path_downsample)

write_csv(x = absentee_peakwk, path = peakwk_path)
write_csv(x = absentee_peakwk_downsample, path = peakwk_path_downsample)

################################################################################
# Import school shape data & downsize
################################################################################

school_shapes = readOGR(dsn=school_shapes_dir, layer=school_shapes_layer)

select_CA = school_shapes[["stAbbrev"]] == "CA"
CA_school_shapes = school_shapes_transformed[select_CA,]

study_school_names = absentee_all %>% pull(school) %>% unique
CA_school_names = CA_school_shapes[["schnam"]]

found_schools = tolower(study_school_names) %in% tolower(CA_school_names)
exact_matches = study_school_names[found_schools]
no_exact_matches = study_school_names[!found_schools]

update_vals = list(
  "ASCEND",
  "Brookfield",
  "Carl B. Munck Elementary",
  "Community United Elementary",
  "EnCompass Academy Elementary",
  "Global Family",
  "Hillcrest Elementary",
  "International Community",
  "Lazear Elementary", # No match found still
  "Madison Park Academy TK-5",
  "Manzanita Community",
  "Martin Luther King Jr. Elementary",
  "Melrose Leadership Academy", # Renamed from Maxwell Park International Academy... Only has 1 yr of data but Melrose Academy has data for the whole period O.o .... weird 
  "Preparatory Literary Academy of Cultural Excellence",
  "Rise Community",
  "Edward M. Downer Elementary",
  "Montalvin Manor Elementary",
  "Glenview Elementary",
  "Hillcrest Elementary",
  "Hillside Elementary",
  "Madison Park Academy 6-12"
)

exact_match_indices = (CA_school_names %>% tolower) %in% (study_school_names %>% tolower)
study_school_shapes = 

# grep(x = CA_school_names, pattern = "madison park", ignore.case = TRUE, value = TRUE)

# TODO: shape data%>% spTransform(CRSobj = CRS("+proj=longlat +datum=WGS84")) %>% tidy() to extract school_locations for ggmap

# TODO: Merge in statistical inputs
# TODO: Filter by year
# TODO: Run ggmap 
