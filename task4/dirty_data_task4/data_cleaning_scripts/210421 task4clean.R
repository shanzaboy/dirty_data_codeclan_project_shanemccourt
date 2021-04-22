#load in libraries to be used
library(tidyverse)
library(here)
library(janitor)
library(readxl)

#test where the top level of the project directory is 
here::here()

#use this to set the path to the data file
raw1 <- read_xlsx(here("raw_data/boing-boing-candy-2015.xlsx"))


# 2015 clean--------------------------------------------------------------------

raw1 <- as_tibble(raw1)

raw1 <- add_column(raw1, "observation" = 2015, .after = "Timestamp")

# select(observation, going_out, gender, age, country, event,response)



names(raw1) <- gsub("Are you going actually going trick or treating yourself?", "going_out", names(raw1), fixed = TRUE)
names(raw1) <- gsub("How old are you?", "age", names(raw1), fixed = TRUE)
raw1 <- clean_names(raw1)

#pivot long 
long_form_data1 <- raw1 %>%
  pivot_longer(
    cols = c(5:99, 114:116),
    names_to = "event",
    values_to = "response") %>% 
  select(observation, going_out, age, event,response)

#mutate_at(vars(age), as.numeric) - best doing this to the full rbind



#drop all rows that have NA's
cleaned1 <- drop_na(long_form_data1)

#need to drop_na before we add these 2 fields
cleaned1 <- add_column(cleaned1, "country" = "", .after = "age")
cleaned1 <- add_column(cleaned1, "gender" = "", .after = "going_out")



# 2016 clean--------------------------------------------------------------------

raw2 <- read_xlsx( here("raw_data/boing-boing-candy-2016.xlsx"))


#load 2016
raw2 <- as_tibble(raw2)

raw2 <- add_column(raw2, "observation" = 2016, .after = "Timestamp")



names(raw2) <- gsub("Are you going actually going trick or treating yourself?", "going_out", names(raw2), fixed = TRUE)
names(raw2) <- gsub("Your gender:", "gender", names(raw2), fixed = TRUE)
names(raw2) <- gsub("How old are you?", "age", names(raw2), fixed = TRUE)
names(raw2) <- gsub("Which country do you live in?", "country", names(raw2), fixed = TRUE)


raw2 <- clean_names(raw2)

long_form_data2 <- raw2 %>%
  pivot_longer(
    cols = 7:107,
    names_to = "event",
    values_to = "response") %>% 
  select(observation, going_out, gender, age, country, event,response)




#drop all rows that have NA's
cleaned2 <- drop_na(long_form_data2)

#clean up the country column
cleaned2<- cleaned2 %>% 
  mutate(country = str_replace_all(country,"canada","Canada")) %>% 
  mutate(country = str_to_title(country)) %>% 
  mutate(country = str_replace_all(country,"United States","USA")) %>% 
  mutate(country = str_replace_all(country,"Uk","UK")) %>% 
  mutate(country = str_replace_all(country,"Usa","USA")) %>% 
  mutate(country = str_replace_all(country,"Us","USA")) %>% 
  mutate(country = str_replace_all(country,"USA Of America","USA")) %>% 
  mutate(country = str_replace_all(country,"U.s.","USA")) %>% 
  mutate(country = str_replace_all(country,"U.s.a.","USA"))






# 2017 clean--------------------------------------------------------------------

raw3 <- read_xlsx( here("raw_data/boing-boing-candy-2017.xlsx"))


#clean columns with Q6 in it to allow for pivot

names(raw3) <- gsub("Q6 |", "", names(raw3), fixed = TRUE)
names(raw3) <- gsub("Q5:", "", names(raw3), fixed = TRUE)
names(raw3) <- gsub("Q4:", "", names(raw3), fixed = TRUE)
names(raw3) <- gsub("Q3:", "", names(raw3), fixed = TRUE)
names(raw3) <- gsub("Q2:", "", names(raw3), fixed = TRUE)
names(raw3) <- gsub("Q1:", "", names(raw3), fixed = TRUE)
raw3 <- clean_names(raw3)



# #Add a row "year" and make all entries 2017
# 
raw3 <- add_column(raw3, "observation" = 2017, .after = "internal_id")

raw3 <- clean_names(raw3)




long_form_data3 <- raw3 %>%
  pivot_longer(
    cols = 7:110,
    names_to = "event",
    values_to = "response") %>% 
  
  
  select(observation, going_out, gender, age, country, event,response)


#drop all rows that have NA's
cleaned3 <- drop_na(long_form_data3)

#country clean up

cleaned3<- cleaned3 %>% 
  mutate(country = str_replace_all(country,"canada","Canada")) %>% 
  mutate(country = str_to_title(country)) %>% 
  mutate(country = str_replace_all(country,"United States","USA")) %>% 
  mutate(country = str_replace_all(country,"Uk","UK")) %>% 
  mutate(country = str_replace_all(country,"Usa","USA")) %>% 
  mutate(country = str_replace_all(country,"Us","USA")) %>% 
  mutate(country = str_replace_all(country,"USA Of America","USA")) %>% 
  mutate(country = str_replace_all(country,"U.s.","USA")) %>% 
  mutate(country = str_replace_all(country,"U.s.a.","USA"))




# rbind & write new file -------------------------------------------------------------------

total <- rbind(cleaned1, cleaned2, cleaned3)

write_csv(total, file = here("clean_data/combinedrawscript1.csv"))