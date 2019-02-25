################################################################################
# Master's Thesis - Spatial Epidemiology of Absenteeism 
# Shoo the Flu Evaluation
# 2011-2018 Spatial Epidemiology Analysis
# Input management file for creating aggregated, publishable datasets of statistical inputs
################################################################################
source(here::here("Flu-Absenteeism", "Master's Thesis - Spatial Epidemiology of Influenza", "0 - Config.R"))

################################################################################
# Import data
################################################################################

absentee_flu             = fread(file = flu_path) %>% as_tibble()
absentee_peakwk          = fread(file = peakwk_path) %>% as_tibble()

absentee_flu_limited     = absentee_flu %>% 
  select(school, schoolyr, grade, race, enrolled, dist.n, program, period, absent_all, absent_ill)
absentee_peakwk_limited  = absentee_peakwk %>% 
  select(school, schoolyr, grade, race, enrolled, dist.n, program, period, absent_all, absent_ill)

vaccination_coverage_raw = read_rds(path = vaccination_coverage_path)

################################################################################
# Input 1: Mean absence rate per school during flu season in each year prior to and during the program
################################################################################

input_1 = absentee_flu_limited %>%
  group_by(school, dist.n, schoolyr) %>%
  summarize(
    absences_all = sum(absent_all),
    absences_ill = sum(absent_ill),
    student_days = n(),
    absence_rate_all = mean(absent_all),
    absence_rate_ill = mean(absent_ill)
  )

################################################################################
# Input 2: Mean absence rate per school during the peak week in each year prior to and during the program
################################################################################

input_2 = absentee_peakwk_limited %>%
  group_by(school, dist.n, schoolyr) %>%
  summarize(
    absences_all = sum(absent_all),
    absences_ill = sum(absent_ill),
    student_days = n(),
    absence_rate_all = mean(absent_all),
    absence_rate_ill = mean(absent_ill)
  )

################################################################################
# Input 3: Difference in difference of absence rate per school during flu season in each program year vs pre-program years
################################################################################

pre_program_means_flu = absentee_flu_limited %>%
  filter(program == 0) %>%
  group_by(school, dist.n) %>%
  summarize(
    pre_program_absence_rate_all = mean(absent_all),
    pre_program_absence_rate_ill = mean(absent_ill)
  )

input_3 = absentee_flu_limited %>%
  filter(schoolyr %in% program_schoolyrs) %>%
  group_by(school, dist.n, schoolyr) %>%
  left_join(pre_program_means_flu) %>%
  summarize(
    did_absence_rate_all = mean(absent_all) - mean(pre_program_absence_rate_all),
    did_absence_rate_ill = mean(absent_ill) - mean(pre_program_absence_rate_ill)
  )

################################################################################
# Input 4: Difference in difference of absence rate per school during the peak week in each program year vs pre-program years
################################################################################

pre_program_means_peakwk = absentee_peakwk_limited %>%
  filter(program == 0) %>%
  group_by(school, dist.n) %>%
  summarize(
    pre_program_absence_rate_all = mean(absent_all),
    pre_program_absence_rate_ill = mean(absent_ill)
  )

input_4 = absentee_peakwk_limited %>%
  filter(schoolyr %in% program_schoolyrs) %>%
  group_by(school, dist.n, schoolyr) %>%
  left_join(pre_program_means_peakwk) %>%
  summarize(
    did_absence_rate_all = mean(absent_all) - mean(pre_program_absence_rate_all),
    did_absence_rate_ill = mean(absent_ill) - mean(pre_program_absence_rate_ill)
  )

################################################################################
# Input 5: Vaccination coverage per school during flu season in each year during the program
################################################################################

remapped_schoolyrs = c(
  "vx.y1.school" = "2014-15",
  "vx.y2.school" = "2015-16",
  "vx.y3.school" = "2016-17",
  "vx.y4.school" = "2017-18"
)

input_5 = vaccination_coverage_raw[grep("vx", vaccination_coverage_raw %>% names)] %>%
  bind_rows(.id = "schoolyr") %>%
  mutate(
    schoolyr = remapped_schoolyrs[schoolyr],
    dist.n = ifelse(dist == "OUSD", 1, 0)
  ) %>%
  rename(school = schoolname, vaccination_coverage = Mean) %>%
  select(school, dist.n, schoolyr, vaccination_coverage) %>%
  as_tibble()

# Updating school names to match absentee set
absentee_school_names = read_rds(path = school_names_path)
absentee_school_names = c(absentee_school_names$OUSD_school_names, absentee_school_names$WCCSD_school_names)
vaccination_coverage_not_found_aliases = list(
  "Brookfield Elementary"         = str_subset(string = absentee_school_names, pattern = "Brookfield"),
  "Carl B. Munck Elementary"      = str_subset(string = absentee_school_names, pattern = "Munck"),
  "Community United Elementary"   = str_subset(string = absentee_school_names, pattern = "Community United"),
  "East Oakland Pride Elementary" = str_subset(string = absentee_school_names, pattern = "East Oakland"),
  "EnCompass Academy Elementary"  = str_subset(string = absentee_school_names, pattern = "EnCompass"),
  "Montalvin Manor Elementary"    = str_subset(string = absentee_school_names, pattern = "Montalvin"),
  "Rise Community"                = str_subset(string = absentee_school_names, pattern = "RISE")
)

for (unfound_alias in names(vaccination_coverage_not_found_aliases)) {
  input_5 = input_5 %>% mutate(school = str_replace(string = school, pattern = unfound_alias, replacement = vaccination_coverage_not_found_aliases[[unfound_alias]]))
}

# Remove 2017-18 Vaccination data
input_5 = input_5 %>% filter(schoolyr != "2017-18")

################################################################################
# Input 6: Mean absence rate per school during flu season in the pre-program and post-program periods
################################################################################

input_6 = absentee_flu_limited %>%
  group_by(school, dist.n, program) %>%
  summarize(
    absences_all = sum(absent_all),
    absences_ill = sum(absent_ill),
    student_days = n(),
    absence_rate_all = mean(absent_all),
    absence_rate_ill = mean(absent_ill)
  )

################################################################################
# Input 7: Mean absence rate per school during the peak week in the pre-program and post-program periods
################################################################################

input_7 = absentee_peakwk_limited %>%
  group_by(school, dist.n, program) %>%
  summarize(
    absences_all = sum(absent_all),
    absences_ill = sum(absent_ill),
    student_days = n(),
    absence_rate_all = mean(absent_all),
    absence_rate_ill = mean(absent_ill)
  )

################################################################################
# Input 8: Mean absence rate per school during flu season in the pre-program, LAIV, and IIV periods
################################################################################

input_8 = absentee_flu_limited %>%
  group_by(school, dist.n, period) %>%
  summarize(
    absences_all = sum(absent_all),
    absences_ill = sum(absent_ill),
    student_days = n(),
    absence_rate_all = mean(absent_all),
    absence_rate_ill = mean(absent_ill)
  )

################################################################################
# Input 9: Mean absence rate per school during flu season in the pre-program, LAIV, and IIV periods
################################################################################

input_9 = absentee_peakwk_limited %>%
  group_by(school, dist.n, period) %>%
  summarize(
    absences_all = sum(absent_all),
    absences_ill = sum(absent_ill),
    student_days = n(),
    absence_rate_all = mean(absent_all),
    absence_rate_ill = mean(absent_ill)
  )
  
################################################################################
# Export several versions of aggregated input data
################################################################################

write_csv(x = input_1, path = input_1_path)
write_csv(x = input_2, path = input_2_path)
write_csv(x = input_3, path = input_3_path)
write_csv(x = input_4, path = input_4_path)
write_csv(x = input_5, path = input_5_path)
write_csv(x = input_6, path = input_6_path)
write_csv(x = input_7, path = input_7_path)
write_csv(x = input_8, path = input_8_path)
write_csv(x = input_9, path = input_9_path)
