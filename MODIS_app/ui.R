    #  Modis download shiny application
    #  Josh Nowak
    #  08/2016
################################################################################
    #  Source packages and functions
    source("helpers/app_init.R")
################################################################################
    #  UI definition
    shinyUI(
      navbarPage(
        #  Home Page
        tabPanel("Home",
          source("pages/home.R", local = T)$value,
          icon = icon("home")
        ),  #  tabPanel

        #  Analysis Page
        source("pages/analysis_page/ipm_analysis.R", local = T)$value,

        tabPanel("Help",
          source("pages/contact_page/contact.R", local = T)$value,
        icon = icon("life-ring")
        )#  tabPanel

      , id = "popr_page", windowTitle = "PopR", collapsible = T,
        position = "fixed-top"
      )  # NavbarPage
    )  #  ShinyUI