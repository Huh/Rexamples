    #  A simple application to find MODIS tiles
    #  Josh Nowak
    #  08/2016
################################################################################
    #  Load packages
    require(DT)
    require(leaflet)
################################################################################
    #  Define user interface
    shinyUI(
      navbarPage(tags$a(href = "http://popr.cfc.umt.edu/", "PopR MODIS Helper", target = "blank"),
        tabPanel("Tiles",
          leafletOutput("tile_map", width = "100%", height = "100%")
        ),
        tabPanel("Products",
          sidebarLayout(
            sidebarPanel(
              tags$div(title = "Select a MODIS product to see the dates available",
                selectInput("prod_select",
                  "Select product to see dates",
                  choices = "No Data",
                  multiple = F
                )
              )
            ),
            mainPanel(
              DT::dataTableOutput("prod_tbl",
                width = "100%",
                height = "auto"
              )
            )
          )
        )
      , id = "tile", windowTitle = "PopR"
      )  #  navbarPage
    )  # shinyUI