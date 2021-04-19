library(tidyverse)
library(here)
library(janitor)

#test where the top level of the project directory is 
here::here()

#use this to set the path to the data file
raw_data <- read_rds( here("raw_data/decathlon.rds"))

#assign raw data and apply janitor to clean names 
result_table <- clean_names(raw_data)

names(result_table)

#no column for name - must be a row name perhaps

row.names(result_table)

rt_name <- rownames_to_column(result_table, var="name")

rt_name %>% 
  mutate_all(.funs = tolower)

#to make into a long form table


long_form_data <- rt_name %>%
  pivot_longer(
    cols = c(x100m, long_jump, shot_put, high_jump, x400m, x110m_hurdle, discus, pole_vault, javeline, x1500m),
    names_to = "event",
    values_to = "results"
  ) %>% 
  mutate_all(.funs=tolower) %>% 
  mutate_at(vars(points, rank, results), as.numeric)


#write to a new csv
write_csv(long_form_data, file = "clean_data/clean_data.csv")

