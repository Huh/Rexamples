    
    require(sp)
    require(raster)
    require(rgdal)
    
    ext_fun <- function(fldr, xy = fake_tran, cores = 1, ...){
      #  A function to build a data frame from a raster of fire intensity and 
      #   a spatial polygon object
      #  Takes a folder name where the folder contains both files and 
      #   a xy object as can be used by raster::extract, cores is the number of
      #   processors to use when doing the extract bit
      #  Returns a data frame with information from both spatial objects
      
      #  Get shapefile name
      spnm <- list.files(fldr, pattern = "burn_bndy.shp$")
      
      sp_obj <- readOGR(
        dsn = fldr, 
        layer = gsub(".shp", "", spnm)
      )
      
      if(attributes(class(sp_obj))[[1]] == "sp"){
      
        #  Get raster
        rnm <- list.files(fldr, pattern = "_dnbr.tif$")
        
        if(length(rnm) > 0){
          r_obj <- try(raster(file.path(fldr, rnm)))
        
          #  Mask raster using sp_obj
          mask_r <- try(mask(r_obj, sp_obj))
          
          ex_val <- try(extract(mask_r, xy))
          
          if(any(class(r_obj) == "try-error", class(mask_r) == "try-error",
            class(ex_val) == "try-error")){
            
            out <- data.frame(
              as.data.frame(sp_obj),
              Intensity = -123456789            
            )
            
          }else{
            out <- data.frame(
              as.data.frame(sp_obj),
              Intensity = ex_val
            )
          }
        }else{
          out <- data.frame(
            sp_obj,
            Intensity = -123456789
          )
        }
      }else{
        out <- data.frame(
          "Id" = NA,
          "Area" = NA,
          "Perimeter" = NA,
          "Acres" = NA,
          "Fire_ID" = NA,
          "Fire_Name" = NA,
          "Year" = NA,
          "StartMonth" = NA,
          "StartDay" = NA,
          "Confidence" = NA,
          "Comment" = NA,
          "Intensity" = -123456789
        )
      
      }
    
    return(out)
    }
################################################################################
    #  Example call
    #  Base directory containing folder
    base_dir <- "F:/FireTarTest"
    
    #  Get folder names
    fname <- file.path(base_dir, list.files(base_dir))
    
    #  Create a fake location for testing  
    fake_tran <- matrix(c(-1179312, 1505932), ncol = 2)
    
    #  Loop over folders
    tst <- lapply(fname, function(x){
      out <- try(ext_fun(x, fake_tran, 5)) 
      #  write to file
      #  calculate summary stats
      #  do other stuff to make it smaller
    return(out)
    })
    
    #  Find failures
    fname[which(unlist(lapply(tst, function(x){ class(x) == "try-error" })))]
    
    #  Create df if there were no errors
    tst_df <- dplyr::bind_rows(tst)
    
    

    