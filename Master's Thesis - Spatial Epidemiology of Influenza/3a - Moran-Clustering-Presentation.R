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
# Build dataframes of relevant results, grouping by their natural grouping variables
################################################################################

# Most Relevant Results
  # Illness-specific absence rates
    # Input 3 and Input 4 - DID yearly in flu season and peakwk 
    # Input 5 - Vaccination Coverage
    # Input 6, 7, 8, 9 - rates in pre/intervention and pre/weak/strong periods in flu season and peakwk

# Input 3 & 4 - grouped by program year
input_3_4_results = extracted_results_ill[c(3, 4)]

bind_rows(input_3_4_results)

# Input 5

# Input 6 & 7

# Input 8 & 9
