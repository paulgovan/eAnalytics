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
library(shinyapps)
library(shinydashboard)
library(rCharts)
library(leaflet)
library(rMaps)
library(ggmap)
library(dygraphs)
library(googleVis)

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
      menuItem("Electric", icon = icon("th"), tabName = "electric", menuSubItem("Trends", tabName = "elecTrends", icon = icon("line-chart"))),
      menuItem("Hydropower", icon = icon("th"), tabName = "hydroelectric", menuSubItem("Profile", tabName = "hydroProfile", icon = icon("globe"))),
      menuItem("Natural Gas", icon = icon("th"), tabName = "naturalgas", menuSubItem("Profile", tabName = "gasProfile", icon = icon("globe")), menuSubItem("Performance", tabName = "gasPerform", icon = icon("bar-chart")), menuSubItem("Trends", tabName = "gasTrends", icon = icon("line-chart")), menuSubItem("Explorer", tabName = "gasExplorer", icon = icon("gear"))),
      menuItem("Oil", icon = icon("th"), tabName = "oil", menuSubItem("Trends", tabName = "oilTrends", icon = icon("line-chart")))
    )),
  dashboardBody(
    tags$head(tags$link(rel = "icon", type = "image/png", href = "favicon.png"),
              tags$title("eAnalytics")),
    tabItems(
      tabItem(tabName = "dashboard",
              fluidRow(
                box(
                  title = "eAnalytics", status = "primary", solidHeader = TRUE, width = 8,
                  img(src = "favicon.png", height = 50, width = 50),
                  h3("Welcome to eAnalytics!"),
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
                  title = "Rates", status = "primary", solidHeader = TRUE, width = 12, collapsible = T,
                  showOutput("lineChart1", "highcharts")
                )
              ),
              fluidRow(
                box(
                  title = "Controls", status = "primary", solidHeader = TRUE, width = 4, collapsible = T,
                  selectInput("elec", h5("Select Input:"), 
                              c("Revenue"="Revenue",
                                "Bill"= "Bill"))
                )
              )
      ),
      tabItem(tabName = "hydroProfile",
              box(
                title = "Hydropower", status = "primary", solidHeader = TRUE, width = 12, collapsible = T,
                leafletOutput("map1"),
                absolutePanel(
                  top = 75, left = 50, width = 250,
                  draggable = TRUE,
                  wellPanel(
                    h4("Hydropower Facilities"),
                    selectInput("hydroSize", h5("Size:"), 
                                c("Total Capacity (KW)"="Total")),
                    showOutput("hist1", "highcharts")
                  ),
                  style = "opacity: 0.90"
                )
              )
      ),
      tabItem(tabName = "gasProfile",
              tabBox(width = 12,
                     tabPanel("Storage",
                              leafletOutput("map2"), 
                              absolutePanel(
                                top = 75, left = 50, width = 250,
                                draggable = TRUE,
                                wellPanel(
                                  h4("NG Storage Facilities"),
                                  selectInput("storageSize", h5("Size:"), 
                                              c("Total Capacity (BCF)"="Total",
                                                "Working Capacity (BCF)"= "Working")),
                                  showOutput("hist2", "highcharts")
                                ),
                                style = "opacity: 0.90"
                              )
                     ),
                     tabPanel("LNG", 
                              leafletOutput("map3"),
                              absolutePanel(
                                top = 75, left = 50, width = 250,
                                draggable = TRUE,
                                wellPanel(
                                  h4("LNG Facilities"),
                                  selectInput("lngSize", h5("Size:"), 
                                              c("Total Capacity (BCFD)"="Total")),
                                  showOutput("hist3", "highcharts")
                                ),
                                style = "opacity: 0.90"
                              )
                     ),
                     tabPanel("Projects",
                              rCharts::chartOutput('choropleth1', 'datamaps'),
                              absolutePanel(
                                top = 75, right = 50, width = 250, 
                                draggable = TRUE,
                                wellPanel(
                                  h4("NG Projects"),
                                  selectInput("projectCol", h5("Color:"), 
                                              c("Project Cost ($MM)"="Cost",
                                                "Added Miles of Pipeline"="Miles",
                                                "Added Capacity (MMcf/d)"="Capacity")),
                                  sliderInput("projectYear", h5("Year:"), min = 2006, max = 2015, value = 2014, step = 1, animate = TRUE, sep = ""),
                                  showOutput("hist4", "highcharts")
                                ),
                                style = "opacity: 0.90"
                              )
                     )
              )
      ),
      tabItem(tabName = "gasPerform",
              fluidRow(
                box(
                  title = "Project Performance Indicator", status = "primary", solidHeader = TRUE, width = 6, collapsible = T,
                  showOutput("hist5", "highcharts")
                ),
                box(
                  title = "Sensitivity Analysis", status = "primary", solidHeader = TRUE, width = 6, collapsible = T,
                  showOutput("barChart1", "highcharts")
                )
              ),
              fluidRow(
                box(
                  title = "Controls", status = "primary", solidHeader = TRUE, width = 4, collapsible = T,
                  selectInput("perform", h5("Select Performance Indicator:"), 
                              c("Cost/Mile ($1000/Mile)"="costMile",
                                "Cost/Added Capacity ($1000/MMcf/d)"= "costCap"
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
                                  title = "Project Cost", status = "primary", solidHeader = TRUE, width = 12, collapsible = T,
                                  dygraphOutput("lineChart2")
                                )
                              ),
                              fluidRow(
                                box(
                                  title = "Controls", status = "primary", solidHeader = TRUE, width = 4, collapsible = T,
                                  selectInput("gas", h5("Select Input:"), 
                                              c("Cost ($MM)"="cost",
                                                "Cost/Mile ($MM/Mile)"="costMile",
                                                "Cost/Added Capacity ($MM/MMcf/d)"= "costCap"))
                                )
                              )
                     ),
                     tabPanel("Revenue",
                              fluidRow(
                                box(
                                  title = "Rates", status = "primary", solidHeader = TRUE, width = 12, collapsible = T,
                                  showOutput("lineChart3", "highcharts")
                                )
                              ),
                              fluidRow(
                                box(
                                  title = "Controls", status = "primary", solidHeader = TRUE, width = 4, collapsible = T,
                                  selectInput("gasRates", h5("Select Input:"), 
                                              c("Revenue"="Revenue",
                                                "Bill"= "Bill"))
                                )
                              )
                     )
              )
      ),
      tabItem(tabName = "gasExplorer",
              box(
                title = "Explorer", status = "primary", solidHeader = TRUE, width = 12, collapsible = T,
                htmlOutput("motion1"), style = "overflow:hidden;"
              )
      ),
      tabItem(tabName = "oilTrends",
              fluidRow(
                box(
                  title = "Rates", status = "primary", solidHeader = TRUE, width = 12, collapsible = T,
                  showOutput("lineChart4", "highcharts")
                )
              ),
              fluidRow(
                box(
                  title = "Controls", status = "primary", solidHeader = TRUE, width = 4, collapsible = T,
                  selectInput("oil", h5("Select Input:"), 
                              c("Revenue"="Revenue",
                                "Bill"= "Bill"
                              ))
                )
              )
      )
    )
  )
)
