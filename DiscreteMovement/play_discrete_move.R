    #  Basic discrete random movement
    #  Josh Nowak
    #  11/2016
################################################################################
    require(raster)
################################################################################
    r <- raster(nrow = 10, ncol = 10)
    nstep <- 50

    walk <- numeric(length = nstep)
    walk[1] <- sample(1:ncell(r), 1)
    
    

    for(i in 2:nstep){
      tmp <- adjacent(r, walk[i-1], directions = 8, include = T, pairs = F, 
        id = T)
      walk[i] <- tmp[sample(1:length(tmp), 1, replace = T)]
    }

    #  Fill raster - walk is an index of cell numbers used to index the visited
    #   cells
    r[] <- 0
    r[walk] <- 1

    #  Plot
    plot(r)
################################################################################
    #  Movement with repeat visits recorded
    r <- raster(nrow = 10, ncol = 10)
    r[] <- 0
    nstep <- 50

    walk <- numeric(length = nstep)
    walk[1] <- sample(1:ncell(r), 1)

    for(i in 2:nstep){
      tmp <- adjacent(r, walk[i-1], directions = 8, include = T, pairs = F, 
        id = T)
      walk[i] <- tmp[sample(1:length(tmp), 1, replace = T)]
      r[walk[i]] <- r[walk[i]] + 1
    }
    
    plot(r)
################################################################################
    #  Movement with discrete steps 
    #  This way is tough because the animal can leave the map and the step
    #   length matters relative to grid cell size and would need to be projected
    #   to units with meters, etc...
    # r <- raster(nrow = 10, ncol = 10)
    # r[] <- 0
    # nstep <- 10
    
    # walk <- matrix(NA, nrow = nstep, ncol = 2)
    # walk[1,1] <- sample(1:nrow(r), 1)
    # walk[1,2] <- sample(1:ncol(r), 1)
    
    # #  Draw movements in the x and y direction
    # move_x <- sample(-5:5, nstep, replace = T)
    # move_y <- sample(-5:5, nstep, replace = T)

    # #  Use move values to move the animal
    # for(i in 2:nrow(walk)){
      # walk[i,1] <- walk[i-1,1] + move_x[i]
      # walk[i,2] <- walk[i-1,2] + move_y[i]
    # }
    
    # #  Extract cells where animal walked
    # stepped <- extract(r, walk, cellnumbers = T)[,"cells"]
    
    # r[stepped] <- 1
    # plot(r)
################################################################################
    #  End