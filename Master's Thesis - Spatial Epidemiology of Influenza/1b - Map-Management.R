################################################################################
# Master's Thesis - Spatial Epidemiology of Absenteeism 
# Shoo the Flu Evaluation
# 2012-2017 Spatial Epidemiology Analysis
# Transforms and cleans shape file to be ggplot-friendly and cleans data to include only relevant study schools

# Documentation
# LEAID Documentation: https://nces.ed.gov/ccd/pdf/sdf101agen.pdf
# SABS-1516 Documentation: https://nces.ed.gov/programs/edge/docs/EDGE_SABS_2015_2016_TECHDOC.pdf
# NCES_ID Search: https://nces.ed.gov/ccd/districtsearch/
# School Name References: https://www.ousd.org/schools and https://www.wccusd.net/domain/96
# 5 Oakland schools closed in 2013 https://oaklandnorth.net/2011/10/27/ousd-board-votes-to-close-five-elementary-schools-at-a-contentious-meeting/
################################################################################
source(here::here("Flu-Absenteeism", "Master's Thesis - Spatial Epidemiology of Influenza", "0 - Config.R"))

################################################################################
# Import school shape data & downsize
################################################################################

# TODO: Transition to sf
school_shapes = readOGR(dsn=school_shapes_dir, layer=school_shapes_layer)

# Declare NCES_IDs (LEAID) documented above and filter by district
OUSD_NCES_ID = "0628050"
WCCSD_NCES_ID = "0632550"

select_OUSD_schools = school_shapes[["leaid"]] %in% OUSD_NCES_ID
select_WCCSD_schools = school_shapes[["leaid"]] %in% WCCSD_NCES_ID

OUSD_school_shapes = school_shapes[select_OUSD_schools,]
WCCSD_school_shapes = school_shapes[select_WCCSD_schools,]

################################################################################
# Match school names across absentee and school shape data 
################################################################################

# School names from the absentee data set for both districts
absentee_school_names = read_rds(path = school_names_path)
OUSD_absentee_school_names = absentee_school_names$OUSD_school_names
WCCSD_absentee_school_names = absentee_school_names$WCCSD_school_names

OUSD_found = tolower(OUSD_absentee_school_names) %in% tolower(OUSD_school_shapes$schnam)
WCCSD_found = tolower(WCCSD_absentee_school_names) %in% tolower(WCCSD_school_shapes$schnam)

OUSD_found_names = OUSD_absentee_school_names[OUSD_found]
WCCSD_found_names = WCCSD_absentee_school_names[WCCSD_found]

# School names from the absentee data set that did not have an exact match 
OUSD_not_found_names = OUSD_absentee_school_names[!OUSD_found]
WCCSD_not_found_names = WCCSD_absentee_school_names[!WCCSD_found]

# Mapping schools without an exact match to an alias that does appear 


OUSD_not_found_aliases = list(
  "Brookfield Village Elementary"      = str_subset(string = OUSD_school_shapes$schnam, pattern = "Brookfield"),
  "Carl Munck Elementary"              = str_subset(string = OUSD_school_shapes$schnam, pattern = "Munck"),
  "Community United Elementary School" = str_subset(string = OUSD_school_shapes$schnam, pattern = "Community United"),
  "EnCompass Academy"                  = str_subset(string = OUSD_school_shapes$schnam, pattern = "EnCompass"),
  "Global Family School"               = str_subset(string = OUSD_school_shapes$schnam, pattern = "Global"),
  "International Community School"     = str_subset(string = OUSD_school_shapes$schnam, pattern = "International Community"),
  "Madison Park Lower Campus"          = "Madison Park Academy TK-5",
  "Manzanita Community School"         = str_subset(string = OUSD_school_shapes$schnam, pattern = "Manzanita Community"),
  "Martin Luther King Jr Elementary"   = str_subset(string = OUSD_school_shapes$schnam, pattern = "King"),
  "PLACE @ Prescott"                   = "Preparatory Literary Academy of Cultural Excellence",
  "RISE Community School"              = str_subset(string = OUSD_school_shapes$schnam, pattern = "Rise Community")
)

WCCSD_not_found_aliases = list(
  "Chavez Elementary" = str_subset(string = WCCSD_school_shapes$schnam, pattern = "Chavez"),
  "Downer Elementary" = str_subset(string = WCCSD_school_shapes$schnam, pattern = "Downer"),
  "King Elementary" = str_subset(string = WCCSD_school_shapes$schnam, pattern = "King"),
  "Montalvin Elementary" = str_subset(string = WCCSD_school_shapes$schnam, pattern = "Montalvin")
)

assert_that(all(names(OUSD_not_found_aliases) %in% OUSD_not_found_names))
assert_that(all(names(WCCSD_not_found_aliases) %in% WCCSD_not_found_names))

# All study schools - the combination of exact matches and aliases 
select_OUSD_study_schools = tolower(OUSD_school_shapes$schnam) %in% tolower(c(OUSD_found_names, OUSD_not_found_aliases))
select_WCCSD_study_schools = tolower(WCCSD_school_shapes$schnam) %in% tolower(c(WCCSD_found_names, WCCSD_not_found_aliases))

OUSD_study_school_shapes = OUSD_school_shapes[select_OUSD_study_schools,]
WCCSD_study_school_shapes = WCCSD_school_shapes[select_WCCSD_study_schools,]

# Transform into mappable dataframe & add absentee_alias column for school names that appear in the absentee dataset (while id contains names that appear in shape file dataset)
OUSD_study_school_shapes_longlat = OUSD_study_school_shapes %>% 
  spTransform(CRSobj = CRS("+proj=longlat +datum=WGS84")) %>% 
  tidy(region = "schnam") %>%
  mutate(absentee_alias = id, dist.n = 1)
  
WCCSD_study_school_shapes_longlat = WCCSD_study_school_shapes %>% 
  spTransform(CRSobj = CRS("+proj=longlat +datum=WGS84")) %>% 
  tidy(region = "schnam") %>% 
  mutate(absentee_alias = id, dist.n = 0)

# Update values in absentee_alias column
for (absentee_school_name in names(OUSD_not_found_aliases)) {
  shape_school_name = OUSD_not_found_aliases[[absentee_school_name]]
  
  if (shape_school_name != "") {
    OUSD_study_school_shapes_longlat = OUSD_study_school_shapes_longlat %>% 
      mutate(absentee_alias = str_replace(string = absentee_alias, pattern = shape_school_name, replacement = absentee_school_name))
  }
}

for (absentee_school_name in names(WCCSD_not_found_aliases)) {
  shape_school_name = WCCSD_not_found_aliases[[absentee_school_name]]
  
  if (shape_school_name != "") {
    WCCSD_study_school_shapes_longlat = WCCSD_study_school_shapes_longlat %>% 
      mutate(absentee_alias = str_replace(string = absentee_alias, pattern = shape_school_name, replacement = absentee_school_name))
  }
}

# Sanity Check Polygon Plot
# register_google(key = "")
qmplot(
  x = long,
  y = lat,
  group = group,
  data = rbind(
    OUSD_study_school_shapes_longlat,
    WCCSD_study_school_shapes_longlat
  ),
  maptype = "toner-lite",
  geom = "polygon"
)

ggsave(filename = paste0(project_dir, "1b-Study-Districts-Polygon-Plot.png"))

################################################################################
# Export several pieces of relevant mapping data
################################################################################

write_csv(x = OUSD_study_school_shapes_longlat, path = OUSD_study_school_shapes_longlat_path)
write_csv(x = WCCSD_study_school_shapes_longlat, path = WCCSD_study_school_shapes_longlat_path)
