# load packages -----------------------------------------------------------
library(pointblank)
library(dplyr)
library(medicaldata)

# load dataset ---------------------------------------------------------------
help(medicaldata::covid_testing)
covid_data <- covid_testing
glimpse(covid_data)

# validate data -----------------------------------------------------------
oldest_verified_age <- 122
## pipeline data validation
covid_data %>% 
  # cycle at which threshold reached during PCR within range
  col_vals_between(vars(ct_result), 14.05, 45, na_pass = TRUE) %>%
  # time elapsed between collect time and receive time within range
  col_vals_between(vars(col_rec_tat), 0, 61370.2) %>%
  # patient age within range
  col_vals_between(vars(age), 0, 122)

## data quality reporting
dt_lbl <- "Deidentified Results of COVID-19 testing at the 
Children's Hospital of Pennsylvania (CHOP) in 2020"
covid_data %>%
  create_agent(
    label = dt_lbl,
    actions = action_levels(warn_at = 0.001, stop_at = 0.01)
  ) %>%
  col_vals_between(vars(ct_result), 14.05, 45, na_pass = TRUE) %>%
  col_vals_between(vars(col_rec_tat), 0, 61370.2) %>%
  col_vals_between(vars(age), 0, 122) %>%
  interrogate()

## table scan (optional)
if(FALSE){
  scan_data(covid_data)
}
