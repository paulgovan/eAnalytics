# Copyright 2015 Paul Govan

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

# http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

library(shiny)
library(shinydashboard)
library(plotly)
library(leaflet)
library(dygraphs)
library(googleVis)
library(DT)

dashboardPage(
  dashboardHeader(title = "eAnalytics",
                  dropdownMenu(type = "messages",
                               messageItem(
                                 from = "Support",
                                 message = "Welcome to eAnalytics!"
                               )
                  )),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
      menuItem("Electric", icon = icon("th"), tabName = "electric", menuSubItem("Trends", tabName = "elecTrends", icon = icon("line-chart")), menuSubItem("Data", tabName = "elecData", icon = icon("table"))),
      menuItem("Hydropower", icon = icon("th"), tabName = "hydroelectric", menuSubItem("Profile", tabName = "hydroProfile", icon = icon("globe")), menuSubItem("Data", tabName = "hydroData", icon = icon("table"))),
      menuItem("Natural Gas", icon = icon("th"), tabName = "naturalgas", menuSubItem("Profile", tabName = "gasProfile", icon = icon("globe")), menuSubItem("Performance", tabName = "gasPerform", icon = icon("bar-chart")), menuSubItem("Trends", tabName = "gasTrends", icon = icon("line-chart")), menuSubItem("Explorer", tabName = "gasExplorer", icon = icon("gear")), menuSubItem("Data", tabName = "gasData", icon = icon("table"))),
      menuItem("Oil", icon = icon("th"), tabName = "oil", menuSubItem("Trends", tabName = "oilTrends", icon = icon("line-chart")), menuSubItem("Data", tabName = "oilData", icon = icon("table")))
    )),
  dashboardBody(
    tags$head(tags$link(rel = "icon", type = "image/png", href = "favicon.png"),
              tags$title("eAnalytics")),
    tabItems(
      tabItem(tabName = "dashboard",
              fluidRow(
                box(
                  title = "eAnalytics", status = "primary", width = 8,
                  img(src = "favicon.png", height = 50, width = 50),
                  h3("Welcome to eAnalytics!"),
                  h4("eAnalytics is a ",
                     a(href = 'http://shiny.rstudio.com', 'Shiny'),
                     "web application, powered by ",
                     a(href = 'http://rcharts.io', 'rCharts'),
                     ",",
                     a(href = 'https://rstudio.github.io/leaflet/', 'Leaflet'),
                     ",",
                     a(href = 'https://rstudio.github.io/dygraphs/', 'dygraphs'),
                     ", and",
                     a(href = 'https://cran.r-project.org/web/packages/googleVis/vignettes/googleVis_examples.html', 'googleVis'),
                     "packages."
                  ),
                  h4("eAnalytics has the largest open database of US energy industry information, providing interactive and dynamic web analytics to industry stakeholders."),
                  h4("Select an industry in the sidepanel to get started."),
                  h4('Copyright 2015 By Paul Govan. ',
                     a(href = 'http://www.apache.org/licenses/LICENSE-2.0', 'Terms of Use.'))
                ),
                uiOutput("projectBox"),
                uiOutput("companyBox"), 
                uiOutput("facilityBox")
              )
      ),
      tabItem(tabName = "elecTrends",
              fluidRow(
                box(
                  title = "Rates", status = "primary", width = 12, collapsible = T,
                  plotlyOutput("lineChart1")
                )
              ),
              fluidRow(
                box(
                  title = "Controls", status = "primary", width = 4, collapsible = T,
                  selectInput("elec", h5("Select Input:"), 
                              c("Revenue (USD)"="Revenue",
                                "Bill (USD)"= "Bill"))
                )
              )
      ),
      tabItem(tabName = "elecData",
              box(
                title = "Rates Data", status = "primary", width = 12, collapsible = T,
                DT::dataTableOutput("elecTable")
              )
      ),
      tabItem(tabName = "hydroProfile",
              tabPanel("Hydropower", 
                       leafletOutput("map1"),
                       absolutePanel(
                         top = 75, left = 300, width = 250, height = 500,
                         draggable = TRUE,
                         wellPanel(
                           h4("Hydropower Facilities"),
                           selectInput("hydroSize", h5("Size:"), 
                                       c("Total Capacity (MW)"="Total")),
                           selectInput("hydroCol", h5("Color:"), 
                                       c("Status"="status"))
#                            ,
#                            plotlyOutput("hist1")
                         ),
                         style = "opacity: 0.90"
                       )
              )
      ),
      tabItem(tabName = "hydroData",
              box(
                title = "Hydropower Data", status = "primary", width = 12, collapsible = T,
                DT::dataTableOutput("hydroTable")
              )
      ),
      tabItem(tabName = "gasProfile",
              tabBox(width = 12,
                     tabPanel("Storage",
                              leafletOutput("map2"), 
                              absolutePanel(
                                top = 75, left = 50, width = 250, height = 500,
                                draggable = TRUE,
                                wellPanel(
                                  h4("NG Storage Facilities"),
                                  selectInput("storageSize", h5("Size:"), 
                                              c("Total Capacity (BCF)"="Total",
                                                "Working Capacity (BCF)"= "Working")),
                                  selectInput("storageColor", h5("Color:"), 
                                              c("Storage Type"="type")),
                                  plotlyOutput("hist2")
                                ),
                                style = "opacity: 0.90"
                              )
                     ),
                     tabPanel("LNG", 
                              leafletOutput("map3"),
                              absolutePanel(
                                top = 75, left = 50, width = 250, height = 500,
                                draggable = TRUE,
                                wellPanel(
                                  h4("LNG Facilities"),
                                  selectInput("lngSize", h5("Size:"), 
                                              c("Total Capacity (BCFD)"="Total")),
                                  selectInput("lngColor", h5("Color:"), 
                                              c("Facility Type"="type",
                                                "Status"="status")),
                                  plotlyOutput("hist3")
                                ),
                                style = "opacity: 0.90"
                              )
                     )
              )
      ),
      tabItem(tabName = "gasPerform",
              fluidRow(
                box(
                  title = "Project Performance Indicator", status = "primary", width = 6, collapsible = T,
                  plotlyOutput("hist5")
                ),
                box(
                  title = "Sensitivity Analysis", status = "primary", width = 6, collapsible = T,
                  plotlyOutput("barChart1")
                )
              ),
              fluidRow(
                box(
                  title = "Controls", status = "primary", width = 4, collapsible = T,
                  selectInput("perform", h5("Select Performance Indicator:"), 
                              c("Cost/Mile (kUSD/Mile)"="costMile",
                                "Cost/Added Capacity (kUSD/MMcf/d)"= "costCap",
                                "Cost/Added Compression (kUSD/HP)" = "costHP"
                              )),
                  selectInput("sensitivity", h5("Select Type of Sensitivity Analysis:"), 
                              c("Contribution to Variance"="varr",
                                "Rank Correlation"="corr"
                              ))
                )
              )
      ),
      tabItem(tabName = "gasTrends",
              tabBox(width = 12,
                     tabPanel("Cost",
                              fluidRow(
                                box(
                                  title = "Project Cost", status = "primary", width = 12, collapsible = T,
                                  dygraphOutput("lineChart2")
                                )
                              ),
                              fluidRow(
                                box(
                                  title = "Controls", status = "primary", width = 4, collapsible = T,
                                  selectInput("gas", h5("Select Input:"), 
                                              c("Cost (mUSD)"="cost",
                                                "Cost/Mile (mUSD/Mile)"="costMile",
                                                "Cost/Added Capacity (mUSD/MMcf/d)"= "costCap"))
                                )
                              )
                     ),
                     tabPanel("Revenue",
                              fluidRow(
                                box(
                                  title = "Rates", status = "primary", width = 12, collapsible = T,
                                  plotlyOutput("lineChart3")
                                )
                              ),
                              fluidRow(
                                box(
                                  title = "Controls", status = "primary", width = 4, collapsible = T,
                                  selectInput("gasRates", h5("Select Input:"), 
                                              c("Revenue (USD)"="Revenue",
                                                "Bill (USD)"= "Bill"))
                                )
                              )
                     )
              )
      ),
      tabItem(tabName = "gasExplorer",
              box(
                title = "Explorer", status = "primary", width = 12, collapsible = T,
                htmlOutput("motion1"), style = "overflow:hidden;"
              )
      ),
      tabItem(tabName = "gasData",
              tabBox(width = 12,
                     tabPanel("Project Data",
                              DT::dataTableOutput("projectTable")
                     ),
                     tabPanel("Revenue Data",
                              DT::dataTableOutput("gasTable")
                     )
              )
      ),
      tabItem(tabName = "oilTrends",
              fluidRow(
                box(
                  title = "Rates", status = "primary", width = 12, collapsible = T,
                  plotlyOutput("lineChart4")
                )
              ),
              fluidRow(
                box(
                  title = "Controls", status = "primary", width = 4, collapsible = T,
                  selectInput("oil", h5("Select Input:"), 
                              c("Revenue (USD)"="Revenue",
                                "Bill (USD)"= "Bill"
                              ))
                )
              )
      ),
      tabItem(tabName = "oilData",
              box(
                title = "Rates Data", status = "primary", width = 12, collapsible = T,
                DT::dataTableOutput("oilTable")
              )
      )
    )
  )
)