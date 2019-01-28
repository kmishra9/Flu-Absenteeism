################################################################################
# Master's Thesis - Spatial Epidemiology of Absenteeism 
# Shoo the Flu Evaluation
# 2012-2017 Spatial Epidemiology Analysis
# File for generating maps
################################################################################
source(here::here("Flu-Absenteeism", "Master's Thesis - Spatial Epidemiology of Influenza", "0 - Config.R"))

################################################################################
# Import school shape data & downsize
################################################################################

school_shapes = readOGR(dsn=school_shapes_dir, layer=school_shapes_layer)

# Declare NCES_IDs (leaID) documented here: https://nces.ed.gov/ccd/districtsearch/, and filter by district
OUSD_NCES_ID = "0628050"
WCCSD_NCES_ID = "0632550"

select_OUSD_schools = school_shapes[["leaid"]] %in% OUSD_NCES_ID
select_WCCSD_schools = school_shapes[["leaid"]] %in% WCCSD_NCES_ID

OUSD_school_shapes = school_shapes[select_OUSD_schools,]
WCCSD_school_shapes = school_shapes[select_WCCSD_schools,]

# Find all school names within the absentee data set for both districts and compare them to school names from the shape file
absentee_school_names = read_rds(path = school_names_path)
OUSD_absentee_school_names = absentee_school_names$OUSD_school_names
WCCSD_absentee_school_names = absentee_school_names$WCCSD_school_names

OUSD_found = tolower(OUSD_absentee_school_names) %in% tolower(OUSD_school_shapes$schnam)
WCCSD_found = tolower(WCCSD_absentee_school_names) %in% tolower(WCCSD_school_shapes$schnam)

OUSD_found_names = OUSD_absentee_school_names[OUSD_found]
WCCSD_found_names = WCCSD_absentee_school_names[WCCSD_found]

OUSD_not_found_names = OUSD_absentee_school_names[!OUSD_found]
WCCSD_not_found_names = WCCSD_absentee_school_names[!WCCSD_found]

# For each school name that doesn't have an exact match in the opposing shape file, map the name to an alias that *does* appear 
# School Name References: https://www.ousd.org/schools and https://www.wccusd.net/domain/96
# 5 Oakland schools closed https://oaklandnorth.net/2011/10/27/ousd-board-votes-to-close-five-elementary-schools-at-a-contentious-meeting/

OUSD_not_found_aliases = list(
  "ASCEND K-8"                         = str_subset(string = OUSD_school_shapes$schnam, pattern = "ASCEND"),
  "Brookfield Village Elementary"      = str_subset(string = OUSD_school_shapes$schnam, pattern = "Brookfield"),
  "Carl Munck Elementary"              = str_subset(string = OUSD_school_shapes$schnam, pattern = "Munck"),
  "Community United Elementary School" = str_subset(string = OUSD_school_shapes$schnam, pattern = "Community United"),
  "EnCompass Academy"                  = str_subset(string = OUSD_school_shapes$schnam, pattern = "EnCompass"),
  "Glenview Elementary @ Sante Fe"     = str_subset(string = OUSD_school_shapes$schnam, pattern = "Glenview"),
  "Global Family School"               = str_subset(string = OUSD_school_shapes$schnam, pattern = "Global"),
  "Hillcrest School"                   = str_subset(string = OUSD_school_shapes$schnam, pattern = "Hillcrest"),
  "Hillcrest School (K-8)"             = str_subset(string = OUSD_school_shapes$schnam, pattern = "Hillcrest"),
  "International Community School"     = str_subset(string = OUSD_school_shapes$schnam, pattern = "International Community"),
  "Madison Park Lower Campus"          = "Madison Park Academy TK-5",
  "Madison Park Upper Campus"          = "Madison Park Academy TK-5",
  "Manzanita Community School"         = str_subset(string = OUSD_school_shapes$schnam, pattern = "Manzanita Community"),
  "Martin Luther King Jr Elementary"   = str_subset(string = OUSD_school_shapes$schnam, pattern = "King"),
  "PLACE @ Prescott"                   = "Preparatory Literary Academy of Cultural Excellence",
  "RISE Community School"              = str_subset(string = OUSD_school_shapes$schnam, pattern = "Rise Community"),
  # All closed in 2013 and have no absentee data beyond 2011-12
  "Hillside Academy"                   = "",
  "Lakeview Elementary"                = "",
  "Lazear Elementary"                  = "",
  "Marshall Elementary"                = "",
  "Maxwell Park International Academy" = ""
)

WCCSD_not_found_aliases = list(
  "Chavez Elementary" = str_subset(string = WCCSD_school_shapes$schnam, pattern = "Chavez"),
  "Downer Elementary" = str_subset(string = WCCSD_school_shapes$schnam, pattern = "Downer"),
  "King Elementary" = str_subset(string = WCCSD_school_shapes$schnam, pattern = "King"),               # "Martin Luther King Jr. Elementary" isn't on the WCCSD school directory (King Elementary is) but there is no other pattern matching "King" in WCCSD_school_shapes
  "Montalvin Elementary" = str_subset(string = WCCSD_school_shapes$schnam, pattern = "Montalvin")
)

assert_that(all(names(OUSD_not_found_aliases) %in% OUSD_not_found_names))
assert_that(all(names(WCCSD_not_found_aliases) %in% WCCSD_not_found_names))

################################################################################
# Merge in statistical inputs and retrieve full location
################################################################################

# NOTE: Both districts have a "Lincoln Elementary" ... need to find a way to add a dist.n column to the shapefile depending on its longitude (north, dist.n=0, etc.)

# https://stackoverflow.com/questions/10212956/subset-spatialpolygonsdataframe

# Check accuracy : all WCC schools are above UC Berkeley's latitude (larger) and all OUSD schools are below

study_school_locations_input_1 = study_school_shapes %>% 
  spTransform(CRSobj = CRS("+proj=longlat +datum=WGS84")) %>% 
  tidy()

################################################################################
# Filter by school year
################################################################################

################################################################################
# Create the base ggmap layer 
################################################################################

sf_east_bay_map = get_map(
  location = UCB_coords,
  source = "google",
  color = "color",
  zoom = 9
)

europe <- c(left = -12, bottom = 35, right = 30, top = 63)
get_stamenmap(europe, zoom = 5) %>% ggmap()

