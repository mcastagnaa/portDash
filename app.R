## TO DO
### 

library(shiny)
library(shinyjs)
library(shinythemes)
library(shinyauthr)
library(dplyr)
library(tidyr)
library(lubridate)
library(ggplot2)
library(ggrepel)
library(DT)
library(tidyquant)
library(janitor)
library(ggcorrplot)
library(Microsoft365R)
library(shinyWidgets)

rm(list = ls())
options(dplyr.summarise.inform = FALSE)

### SETUP ######################################
source("datamanagement.R")
source("f_getMainTable.R")

################################################

ui <- fluidPage(theme=shinytheme("lumen"),
                htmlwidgets::getDependency('sparkline'),
                useShinyjs(),
                
                # logout button
                div(class = "pull-right", shinyauthr::logoutUI(id = "logout")),
                # login section
                shinyauthr::loginUI(id = "login"),
                
                fluidRow(
                  column(2,
                         br(), br(),
                         div(img(src = "logo.png", width = "100")),
                         br(), br(), style="text-align: center;"),
                  column(10,
                         titlePanel("Portfolio level dashboard"),
                         h5("Pick last business day of the month"),
                         hr())
                ),
                sidebarLayout(
                  sidebarPanel = sidebarPanel(
                    selectInput("filter1",
                                "Asset Class",
                                c("Equity", "Fincome", "MultiAsset", "Liquidity")),
                    multiple = F,
                    selected = "Fixed Income",
                  width = 2),
                  mainPanel = mainPanel(
                    fluidRow(column(4, dateInput("refDate", "Reference date", value = max(dataTop$repDate), 
                                                 format = "d-M-yy", width = "150px",
                                                 weekstart = 1)),
                             div("Click on the table to get the historical charts for risk and fundamentals",
                                 style ="color: red;"),
                             br(),
                             div(dataTableOutput("MainTable"), style = "font-size:80%"),
                             br()),
                    tabsetPanel(
                      type = "tabs",
                      tabPanel("Characteristics",
                               br()),
                      tabPanel("Risk",
                               br()))
                    , width = 8))
)

server <- function(input, output, session) {
  
  credentials <- shinyauthr::loginServer(
    id = "login",
    data = user_base,
    user_col = user,
    pwd_col = password,
    sodium_hashed = TRUE#,
    #log_out = reactive(logout_init())
  )
  
  # Logout to hide
  # logout_init <- shinyauthr::logoutServer(
  #   id = "logout",
  #   active = reactive(credentials()$user_auth)
  # )
  
  output$MainTable <- renderDataTable({
    req(credentials()$user_auth)
    
    datatable(f_getMainTable(input$filter1, input$refDate),
              escape = F,
              #options = list(drawCallback = cb),
              #server = T,
              selection = "single",
              rownames = FALSE,
              filter= "bottom")
  })
}

shinyApp(ui = ui, server = server)
