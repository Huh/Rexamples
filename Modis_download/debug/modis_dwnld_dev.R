    #  A script to download NPP data, MODIS MOD17A3
    #  Josh Nowak
    #  11/2015
################################################################################
    #  Packages
    require(raster)
    require(rts)
    require(gdalUtils)
################################################################################
    #  Set working directory to the top level of hierarchy where files will
    #  be saved, read from, etc...
    setwd("C:/GISPlay")

    #  You don't have this file, but it is a reference file I use to get the 
    #  final projection and to crop the mosaiced MODIS tiles
    #  Below, the lines that use this raster are commented out
    #tmpp <- raster("C:/GIS/sDr/ppt_sd")

    #  Product Short Name, get from MODIS products table
    product <- "MOD13Q1"
    
    #  If you don't know which MODIS product you want you can go to
    #  https://joshnwk.shinyapps.io/MODIS_helper/
    #  or in R type, but be aware that these lists only include v6 products
    #  MOD12Q1, for example, is not a v6 product and so is not on the list
    modisProducts()

    #  More official/complete documentation can be found at 
    #  https://lpdaac.usgs.gov/dataset_discovery/modis/modis_products_table

    #  Tiles, I looked this up at the MODIS_helper tools linked above
    h = c(9, 10)
    v = 4

    #  The MODIS tools package is great for getting MODIS data at a point, 
    #  but in this case I wanted all the data for an entire state.  I called
    #  the useful GetDates function by namespace to get the available dates 
    #  for the product of interest.  The Lat and Long were taken from 
    #  Google Earth and represent the center of the state of interest.
    dts <- MODISTools::GetDates(
      Product = product, 
      Lat = 44.3, 
      Long = -100.3
    )

    #  The dates now look like A2000001, which is the 4 digit year + julian
    #  day and the correct MODIS format, but I need a POSIX like date to format
    #  for the getMODIS function below
    dts <- as.Date(gsub("A", "", dts), "%Y%j")
    
    #  Format dates for getMODIS function
    dts_in <- format(dts, "%Y.%m.%d")
    
    #  Download the hdf5 files using the getMODIS function from the rts 
    #  package.  You can do this using RCurl, but most ftp sites limit you
    #  to 10 or so downloads.  Using this function and soap (1999 called and it 
    #  wants its webservice back) we can download all the data we want.
    #  This can take a while depending on the number of files requested
    #  Here I subset dates in case anyone actually runs this code
    getMODIS(product, h = h, v = v, dates = dts_in[1])

    #  Get hdf names, the downloaded files were saved in our working 
    #   directory that we set at the beginning of the script.  The HDF files we 
    #   are interested all end in hdf, so find those files using a regular 
    #   expression that finds hdf at the end of the string ($)
    hdfs <- list.files(pattern = "hdf$")

    #  Create new file names, in this case we will make geoTIFFs
    gtiffs <- gsub("hdf", "tif", hdfs)

    #  Define projections
    #  from_proj is the MODIS projection that all MODIS data are in
    #  to_proj is the projection I want them in, spatialreference.org is a 
    #  huge help in defining the proj4 strings for projections
    from_proj <- "+proj=sinu +lon_0=0 +x_0=0 +y_0=0 +a=6371007.181 +b=6371007.181 +units=m +no_defs" 
    #  Here I just stick in WGS84 as an example
    to_proj <- "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"
    #  We can also use the shorter epsg code for projections, in this case the
    #   epsg code is 4326

    #  Convert hdf to tif using gdal translate
    #  Another option is to download the MODIS reprojection tool and call it 
    #   using the MODISTools package
    for(i in 1:length(hdfs)){
      gdal_translate(hdfs[i], gtiffs[i], sd_index = 2)
    }

    #  Project and Mosaic tiffs - gdalwarp
    gtif2mos <- unique(substr(gtiffs, 10, 16))
    for(i in 1:length(gtif2mos)){
      tmp <- gtiffs[grepl(gtif2mos[i], gtiffs)]
      gdalwarp(tmp, 
        dstfile = file.path(getwd(), "Mosaicked",   
          paste0("MOD17A3_", gtif2mos[i], ".tif")),
        s_srs = from_proj,
        t_srs = to_proj,
        srcnodata = paste(as.character(65529:65535), collapse = ","),
        dstnodata = "9999",
        overwrite = T)
    }
    
    fnms <- file.path(getwd(), "Mosaicked", list.files(file.path(getwd(), 
      "Mosaicked")))
    
    #  Test the first raster, if you had a reference raster you could 
    #  overlay it here
    r <- raster(fnms[1])
    plot(r)
    #plot(tmpp, add = T)
    
    #  Clip raster and then scale values, clipping omitted because of 
    #  absence of reference raster
    tst <- lapply(1:length(fnms), function(i){
      r <- raster(fnms[i])
      #r2 <- crop(r, tmpp)
      r2 <- r * 0.0001
    r2
    })
    
    #  Create a raster stack
    npp_stack <- stack(tst)
    
    #  Calculate summary statistics, if desired
    npp_mu <- calc(npp_stack, fun = mean, na.rm = T)
    
    #  Save your stack if desired or the summary statistic raster
################################################################################
    #  End
