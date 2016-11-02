    #  Lookup tables for EM Data cleaning
    #  Josh Nowak
    #  11/2016
################################################################################
    dics <- list()
    
    #  Recapture
    dics$recap <- data.frame(
      Code = c(1, 2, 3, 23, 34),
      Name = NA
    )
    
    #  Sex
    dics$sex <- data.frame(
      Code = 0:1,
      Name = c("Female", "Male"),
      stringsAsFactors = F
    )
    
    #  Age 
    dics$age <- data.frame(
      Code = 1:3,
      Name = c("Juv", "SubAd", "Ad"),
      stringsAsFactors = F
    )
    
    #  Save output
    save(dics, file = "C:/tmp/rgroup/data/dics.RData")