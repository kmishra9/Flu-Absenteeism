################################################################################
# Master's Thesis - Spatial Epidemiology of Absenteeism 
# Shoo the Flu Evaluation
# 2012-2018 Spatial Epidemiology Analysis
# File for managing, consolidating, formatting, and presenting clustering results tables
################################################################################
source(here::here("Flu-Absenteeism", "Master's Thesis - Spatial Epidemiology of Influenza", "0 - Config.R"))

################################################################################
# Import extracted results
################################################################################
extracted_results_all = read_csv(file = extracted_results_all_path)
extracted_results_ill = read_csv(file = extracted_results_ill_path)

################################################################################
# Subset dataframes of relevant results
################################################################################

# Most Relevant Results
  # Illness-specific absence rates
    # Input 3 and Input 4 - DID yearly in flu season and peakwk 
    # Input 5 - Vaccination Coverage
    # Input 6, 7, 8, 9 - rates in pre/intervention and pre/weak/strong periods in flu season and peakwk

# Input 3 & 4 - grouped by program year
input_3_4_results = extracted_results_ill %>% slice(str_which(string = extracted_results_ill$Input, pattern= "input_3|input_4"))

# Input 5 - grouped by program year
input_5_results = extracted_results_ill %>% slice(str_which(string = extracted_results_ill$Input, pattern= "input_5"))

# Input 6 & 7 - grouped by PrePost Intervention status
input_6_7_results = extracted_results_ill %>% slice(str_which(string = extracted_results_ill$Input, pattern= "input_6|input_7"))

# Input 8 & 9
input_8_9_results = extracted_results_ill %>% slice(str_which(string = extracted_results_ill$Input, pattern= "input_8|input_9"))

################################################################################
# Use Kable to generate tables
################################################################################

input_3_4_table = kable(input_3_4_results, "latex", booktabs = T) %>%
  kable_styling(latex_options = "striped") 


################################################################################
# Save tables
################################################################################
input_3_4_table %>% as_image(file = paste0(project_dir, "3a-AbsenceRate-DID-ill.png"))
