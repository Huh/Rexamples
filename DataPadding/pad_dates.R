    #  R example of padding focal data with data from before and/or after
    #  Josh Nowak
    #  11/2016
################################################################################
    require(dplyr)
################################################################################
    #  Scenario:  In general terms, we want to add n dates from some time period 
    #   before, after or both to some focal data.  For example, we might want to
    #   add the last two locations in January to February data.  We might also 
    #   want to add the first two locations from March to the Feb data.  
    #  The functions should also work on Date and POSIXct classes seamlessly.
    
    #  Create some data
    tel.data <- data.frame(
      id = "deer1",
      date = as.Date(
        paste(
          2016, 
          c(rep(1, 3), rep(2, 8), rep(3, 4)), 
          sample(1:28, 12, replace = T)
        , sep = "-")
      ),
      stringsAsFactors = F
    ) %>% 
    arrange(date) %>%
    mutate(
      date_posix = as.POSIXct(date) + runif(n(), -60, 60),
      week = as.numeric(format(date, "%w")) + 1,
      month = as.numeric(format(date, "%m"))
    )
################################################################################
    #  Define a function to do what we want...
    extend_ndates <- function(add_to, add_from, n = 2, date_colnm = "date", 
      when = c("before", "after", "extend")){
      #  A function to pad both ends of an existing data set with some other 
      #   data set based on dates
      #  Takes the data you wish to add to (add_to), the data from which data 
      #   will be added (add_from), the number of rows of data/dates to add (n),
      #   the date column name (date_colnm) and the when to add with options
      #   before, after and extend, which does both sides
      #  Returns data with rows/dates added on the beginning and end
      #  Row names of add_to and add_from must match
      #  Function expects add_to/add_from are data.frames or similar
      
      #  Get data in add_from that is before and/or after the data in add_to and 
      #   subset it to the number of dates to add
      dtrng <- range(add_to %>% .[[date_colnm]], na.rm = T)

      #  Count how many dates are before and after, mutate n if needed so we do
      #   not subset out of bounds...only 3 dates before but we ask for 6
      before_cnt <- sum(add_from %>% .[[date_colnm]] < dtrng[1], na.rm = T)
      after_cnt <- sum(add_from %>% .[[date_colnm]] > dtrng[2], na.rm = T)
      n1 <- min(n, before_cnt, na.rm = T)
      if(n != n1 & any(when %in% c("before", "extend"))){
        warning(paste(n, "dates requested before data, but only", n1, 
          "available."))
      }
      n2 <- min(n, after_cnt, na.rm = T)
      if(n != n1 & any(when %in% c("after", "extend"))){
        warning(paste(n, "dates requested after data, but only", n2, 
          "available."))
      }

      #  If when is before or extend
      #  Conditional on some add dates < than mind being present so we don't 
      #   add NA's
      if((when == "before" | when == "extend") & n1 > 0){
        before <- add_from %>%
          filter(.[,date_colnm] < dtrng[1]) %>%
          arrange_(date_colnm) %>%
          .[(nrow(.) - (n1 - 1)):nrow(.),]
      }
      
      #  If when is after or extend
      #  Conditional on some add dates > than dtrng[2] being present so we don't 
      #   add NA's
      if((when == "after" | when == "extend") & n2 > 0){
        after <- add_from %>%
          filter(.[,date_colnm] > dtrng[2]) %>%
          arrange_(date_colnm) %>%
          .[1:n2,]
      }

      #  Combine data sources
      hold <- add_to
      if(exists("before")){
        hold <- full_join(hold, before)
      }
      if(exists("after")){
        hold <- full_join(hold, after)
      }

      out <- hold %>% 
        arrange_(date_colnm)

    return(out)
    }
################################################################################
    #  Pad before
    extend_ndates(filter(tel.data, month == 2), tel.data, 4, "date", "before")
    #  Pad after
    extend_ndates(filter(tel.data, month == 2), tel.data, 2, "date", "after")
    #  Extend data
    extend_ndates(filter(tel.data, month == 2), tel.data, 1, "date", "extend")
    #  Extend again using the posix class
    extend_ndates(filter(tel.data, month == 2), tel.data, 1, "date_posix", 
      "extend")
    #  Cool!!!
################################################################################
    #  Create a new data set that will allow us to pad multiple period from a 
    #   single animal
    collard <- data.frame(
      id = "deer1",
      date = as.Date(
        paste(
          2016, 
          c(rep(1, 10), rep(2, 10), rep(3, 10)), 
          sample(1:28, 30, replace = T)
        , sep = "-")
      ),
      stringsAsFactors = F
    ) %>% 
    arrange(date) %>%
    mutate(
      x = runif(30, -115, -112),
      y = runif(30, 43, 46),
      month = as.numeric(format(date, "%m"))
    )

    #  Extend each month of each individual by 3 telemetry fixes
    padded <- collard %>%
      group_by(month) %>%
      do(result = extend_ndates(., collard, 3, "date", "extend"))

    #  The original data had 10 observations per month, the new data's
    #   dimensions are shown in the result column...you add after the first
    #   month, on both sides of the middle month and after the last month
    padded
    
    #  Looks good
    #  To access the february data we would
    padded$result[[2]]
################################################################################
    #  Do it one more time with multiple individuals and months
    collard <- data.frame(
      id = rep(paste("deer", 1:2), length.out = 30),
      date = as.Date(
        paste(
          2016, 
          c(rep(1, 10), rep(2, 10), rep(3, 10)), 
          sample(1:28, 30, replace = T)
        , sep = "-")
      ),
      stringsAsFactors = F
    ) %>% 
    arrange(date) %>%
    mutate(
      x = runif(30, -115, -112),
      y = runif(30, 43, 46),
      month = as.numeric(format(date, "%m"))
    )

    #  Extend each month of each individual by 3 telemetry fixes
    clean <- collard %>%
      group_by(id, month) %>%
      do(result = extend_ndates(., collard, 3, "date", "extend"))

    #  If desired, you could collapse the result column using something like
    bind_rows(clean$result)
    #  but that would strip the uniqueness and simply create duplicates
################################################################################
    #  Add example of working on result column and maintaining df like structure
################################################################################
    #  End