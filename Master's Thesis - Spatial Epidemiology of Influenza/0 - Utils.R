################################################################################
# Colford-Hubbard Group
# Utility functions
################################################################################

# [TEMPLATE FOR NEW FUNCTIONS]
# Documentation: 
# Usage: 
# Description: 
# Args/Options: 
# 
# Returns: 
# Output: ...
# [TEMPLATE FOR NEW FUNCTIONS]

################################################################################
################################################################################


# Documentation: down_sample
# Usage: down_sample(data, sample_pct, seed)
# Description: down samples data according to a random seed
# Args/Options: data, sample_pct, seed
# Returns: A sample of the data
# Output: ...

down_sample = function(data, sample_pct=.01, seed=1) {
  assert_that(is.data.frame(data))
  assert_that(is.double(sample_pct) & 0 < sample_pct & sample_pct < 1)
  assert_that(is.double(seed))
  
  set.seed(seed)
  return(data[sample(nrow(data), floor(nrow(data) * sample_pct)),])
}

################################################################################
################################################################################

# Documentation: compress_dataframe
# Usage: compress_dataframe(data, vars)
# Description: Create weighted version of dataframe that restricts to a single observation
# for each unique combination of covariates, but add a weight column that
# notes how many observations were collapsed into the de-duplicated dataframe.
# Args/Options: data, vars
# Returns: a de-duplicated, weighted tibble representing the same data 
# Output: Prints the compression rate (compression size vs uncompressed size) acheived

compress_dataframe = function(data, vars = colnames(data)) {
  compressed_data = data %>%
    group_by_at(vars) %>%               # Group by all columns.
    mutate(weight = n()) %>%            # Create a new weight columns.
    filter(row_number() == 1)           # Select first observation within group.
  
  print(cat("Compression of",
            deparse(substitute(data)),
            round((1 - nrow(compressed_data) / nrow(data)) * 100, 1), 
            "%\n"))
  
  return(compressed_data)
}

################################################################################
################################################################################
# Documentation: convert_nested_listoflists_to_DF
# Usage: convert_nested_listoflists_to_DF(nested_list)
# Description: Converts a list of lists into a single dataframe
# Args/Options: 
# Returns: a dataframe with the column names from the first 
# element in the list of lists
# Output: ...

convert_nested_listoflists_to_DF = function(nested_list) {
  # return_DF = data.frame()
  
  rrlist =list()
  rdlist =list()
  
  for(i in 1:length(nested_list)){
    rrlist[[i]]= as.vector(nested_list[[i]]$rr)
    rdlist[[i]]= as.vector(nested_list[[i]]$rd)
  }
  
  rr.df = suppressWarnings(bind_rows(rrlist))
  rd.df = suppressWarnings(bind_rows(rdlist))
  
  return_DF = rbind(rr.df, rd.df)
  
  return(return_DF)
}

################################################################################
################################################################################
# Documentation: load_to_list
# Usage: load_to_list(data, sample_pct, seed)
# Description: Loads the contents of an RData to an environment and returns the environment as a list
# Args/Options: RData_path (a path to the RData_file, either relative to the working directory
# or as an absolute path)
# Returns: a named list corresponding to the named objects from the loaded RData file 
# Output: ...

load_to_list <- function(RData_path) {
  if (!file.exists(RData_path)) {
    stop(paste("Error, file does not exist:", RData_path))
  }
  env = new.env()
  load(RData_path, env)
  return(env %>% as.list()) 
}
