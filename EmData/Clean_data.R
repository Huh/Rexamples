    #  Cleaning Emily's data with R Group
    #  Josh Nowak
    #  10/2016
################################################################################
    #  Load packages
    require(readr)
    require(tidyr)
    require(dplyr)
################################################################################
    #  Source functions from GitHub
    script_url <- "https://raw.githubusercontent.com/Huh/Rexamples/master/DataValidation/Check_char_num.R"
    downloader::source_url(script_url, prompt = F, quiet = T)
    
    #  Create directories
    data_dir <- "C:/tmp/rgroup/data"
    result_dir <- "C:/tmp/rgroup/results"
################################################################################
    #  Read in data
    rawd <- read_csv(
      file.path(
        data_dir, 
        list.files(data_dir, pattern = "csv$")
      )
    )
################################################################################
    #  Subset columns to useful
    use_cols <- c("site", "session", "web", "date", "tag", "fate", "letter_2",
      "sex", "age", "mass", "snv_pos")
    keep <- rawd %>%
      select(which(tolower(colnames(.)) %in% use_cols))
      
    #  Learn about data - one time deal
    sapply(keep, range)
    keep %>%
      summarise(
        Site = unique(site)
      )
      
    #  Group_by on Session
    keep %>% 
      group_by(Session) %>%
      summarise(
        MuAge = mean(age),
        MuMass = mean(mass)
      ) %>%
      mutate(
        MuAge = replace(MuAge, MuAge < 0, NA)
      )
      
      