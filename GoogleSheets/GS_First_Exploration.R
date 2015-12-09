		#  Exploring google sheets
		#  Josh Nowak
		#  11/2015
################################################################################
		#  Packages
		#install.packages("googlesheets")
		require(googlesheets)
		require(dplyr)
################################################################################
		#  Get list of google doc titles available
		gs_ls()
		gs_ls() %>% glimpse()
		
		#  Get the key of the required document for later
		dwd <- gs_title("Disease_Workshop_Data")
		
		#  Show sheet key
		dwd$sheet_key
		
		#  Access sheet by key
		gs_key(dwd$sheet_key)
		
		#  No thought required data reading function
		dat <- dwd %>% gs_read()
		
		#  Read as fast as possible
		fast_dat <- dwd %>% gs_read_csv()
		
		#  Edit sheet
		new_d <- data.frame(
			ID = 1,
			Disease = 1,
			Scenario = 2,
			Name = "Test",
			Facilitator = 1,
			Time = 1,
			Distribution = "beta",
			Parameter = c("alpha", "beta"),
			Value = c(1, 1),
			Sum20 = NA)
		
		edit_dat <- dwd %>% gs_edit_cells(ws = 1, input = new_d, trim = T)
		
		####  From scratch...
		#  Make new googlesheet (workbook)
		foo <- gs_new("foo")
		
		#  Add a worksheet
		foo <- foo %>% gs_ws_new("add_row")
		
		#  Initialize sheet with column headers and one row of data
		#  the list feed is picky about this
		foo <- foo %>% 
			gs_edit_cells(ws = "add_row", input = head(iris, 1), trim = TRUE)
		
		#  Add the next 5 rows of data ... careful not to go too fast
		for(i in 2:6) {
		  foo <- foo %>% gs_add_row(ws = "add_row", input = iris[i, ])
		  #Sys.sleep(0.3)
		}
		
		#  Read it back in to inspect
		foo %>% gs_read(ws = "add_row")
		
		#  
		data_url <- "https://docs.google.com/spreadsheets/d/1S2yrIGxIu4O8AoGondi3Iqj-QXoeGHlzXLkyprwj8Pg/pub?output=csv"
		link <- gs_url(data_url)
		link %>% gs_add_row(ws = 1, input = new_d)
		
		
		

		
		