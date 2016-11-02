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
        list.files(data_dir, pattern = "^UNM")
      ),
      na = c("", " ", "NA", -9)
    )
    code <- read_csv(
      file.path(
        data_dir,
        "codes.csv"
      )
    )
    #  Load dictionaries
    load("C:/tmp/rgroup/data/dics.RData")
################################################################################
    #  Subset columns to useful
    use_cols <- c("site", "session", "web", "date", "tag", "fate", "letter_2",
      "sex", "age", "mass", "snv_pos")
    keep <- rawd %>%
      select(which(tolower(colnames(.)) %in% use_cols)) 
    
    dat <- keep
    colnames(dat) <- tolower(colnames(dat))
    
    #  Format dates and then insert date class back into df
    clean <- dat %>%
      mutate(
        tmp_dt1 = as.Date(date, "%m/%d/%Y"),
        tmp_dt2 = as.Date(date, "%d-%b-%y"),
        date = coalesce(tmp_dt1, tmp_dt2),
        sex = dics$sex$Name[match(dat$sex, dics$sex$Code)]
      ) %>%
      select(-tmp_dt1, -tmp_dt2) %>%
      filter(
        !is.na(tag),
        !is.na(letter_2),
        !(is.na(age) & is.na(mass))
      ) %>%
      left_join(., dics$recap, by = c("fate" = "Code"))
      
    # #  Crete EH
    # eh <- clean %>%
      # spread(date, fate)
      
    # #  Learn about data - one time deal
    # sapply(keep, range)
    # keep %>%
      # summarise(
        # Site = unique(site)
      # )
      
    # #  Group_by on Session
    # keep %>% 
      # group_by(Session) %>%
      # summarise(
        # MuAge = mean(age),
        # MuMass = mean(mass)
      # ) %>%
      # mutate(
        # MuAge = replace(MuAge, MuAge < 0, NA)
      # )
      
      