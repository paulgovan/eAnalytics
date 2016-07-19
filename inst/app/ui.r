shinydashboard::dashboardPage(
  shinydashboard::dashboardHeader(title = "eAnalytics",
                                  shinydashboard::dropdownMenu(type = "messages",
                                                               shinydashboard::messageItem(
                                                                 from = "Support",
                                                                 message = "Welcome to eAnalytics!"
                                                               )
                                  )),
  shinydashboard::dashboardSidebar(
    shinydashboard::sidebarMenu(
      shinydashboard::menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
      shinydashboard::menuItem("Electric", icon = icon("th"), tabName = "electric", shinydashboard::menuSubItem("Trends", tabName = "elecTrends", icon = icon("line-chart")), shinydashboard::menuSubItem("Data", tabName = "elecData", icon = icon("table"))),
      shinydashboard::menuItem("Hydropower", icon = icon("th"), tabName = "hydroelectric", shinydashboard::menuSubItem("Profile", tabName = "hydroProfile", icon = icon("globe")), shinydashboard::menuSubItem("Data", tabName = "hydroData", icon = icon("table"))),
      shinydashboard::menuItem("Natural Gas", icon = icon("th"), tabName = "naturalgas", shinydashboard::menuSubItem("Profile", tabName = "gasProfile", icon = icon("globe")), shinydashboard::menuSubItem("Performance", tabName = "gasPerform", icon = icon("bar-chart")), shinydashboard::menuSubItem("Trends", tabName = "gasTrends", icon = icon("line-chart")), shinydashboard::menuSubItem("Explorer", tabName = "gasExplorer", icon = icon("gear")), shinydashboard::menuSubItem("Data", tabName = "gasData", icon = icon("table"))),
      shinydashboard::menuItem("Oil", icon = icon("th"), tabName = "oil", shinydashboard::menuSubItem("Trends", tabName = "oilTrends", icon = icon("line-chart")), shinydashboard::menuSubItem("Data", tabName = "oilData", icon = icon("table")))
    )),
  shinydashboard::dashboardBody(
    tags$head(tags$link(rel = "icon", type = "image/png", href = "favicon.png"),
              tags$title("eAnalytics")),
    shinydashboard::tabItems(
      shinydashboard::tabItem(tabName = "dashboard",
                              fluidRow(
                                shinydashboard::box(
                                  title = "eAnalytics", status = "primary", width = 8,
                                  img(src = "favicon.png", height = 50, width = 50),
                                  h3("Welcome to eAnalytics!"),
                                  h4("eAnalytics is a ",
                                     a(href = 'http://shiny.rstudio.com', 'Shiny'),
                                     "web application, powered by the ",
                                     a(href = 'https://plot.ly/r/', 'plotly'),
                                     ",",
                                     a(href = 'https://rstudio.github.io/leaflet/', 'Leaflet'),
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
      shinydashboard::tabItem(tabName = "elecTrends",
                              fluidRow(
                                shinydashboard::box(
                                  title = "Rates Trends", status = "primary", width = 12, collapsible = T,
                                  plotly::plotlyOutput("lineChart1")
                                )
                              ),
                              fluidRow(
                                shinydashboard::box(
                                  title = "Control", status = "primary", width = 4, collapsible = T,
                                  selectInput("elec", h5("Select Input:"),
                                              c("Revenue (USD)"="Revenue",
                                                "Bill (USD)"= "Bill"))
                                )
                              )
      ),
      shinydashboard::tabItem(tabName = "elecData",
                              shinydashboard::box(
                                title = "Rates Data", status = "primary", width = 12, collapsible = T,
                                DT::dataTableOutput("elecTable")
                              )
      ),
      shinydashboard::tabItem(tabName = "hydroProfile",
                              tabPanel("Hydropower",
                                       leaflet::leafletOutput("map1"),
                                       absolutePanel(
                                         draggable = TRUE, fixed = TRUE,
                                         wellPanel(
                                           h4("Hydropower Facilities"),
                                           selectInput("hydroSize", h5("Size:"),
                                                       c("Total Capacity (MW)"="Total")),
                                           selectInput("hydroCol", h5("Color:"),
                                                       c("Status"="status"))
                                           #                            ,
                                           #                            plotly::plotlyOutput("hist1")
                                         ),
                                         style = "opacity: 0.75"
                                       )
                              )
      ),
      shinydashboard::tabItem(tabName = "hydroData",
                              shinydashboard::box(
                                title = "Hydropower Data", status = "primary", width = 12, collapsible = T,
                                DT::dataTableOutput("hydroTable")
                              )
      ),
      shinydashboard::tabItem(tabName = "gasProfile",
                              shinydashboard::tabBox(width = 12,
                                                     tabPanel("Storage Facilities",
                                                              leaflet::leafletOutput("map2"),
                                                              absolutePanel(
                                                                draggable = TRUE, fixed = TRUE,
                                                                wellPanel(
                                                                  h4("NG Storage Facilities"),
                                                                  selectInput("storageSize", h5("Size:"),
                                                                              c("Total Capacity (BCF)"="Total",
                                                                                "Working Capacity (BCF)"= "Working")),
                                                                  selectInput("storageColor", h5("Color:"),
                                                                              c("Storage Type"="type")),
                                                                  br(),
                                                                  plotly::plotlyOutput("hist2")
                                                                ),
                                                                style = "opacity: 0.75"
                                                              )
                                                     ),
                                                     tabPanel("LNG Facilities",
                                                              leaflet::leafletOutput("map3"),
                                                              absolutePanel(
                                                                draggable = TRUE, fixed = TRUE,
                                                                wellPanel(
                                                                  h4("LNG Facilities"),
                                                                  selectInput("lngSize", h5("Size:"),
                                                                              c("Total Capacity (BCFD)"="Total")),
                                                                  selectInput("lngColor", h5("Color:"),
                                                                              c("Facility Type"="type",
                                                                                "Status"="status")),
                                                                  br(),
                                                                  plotly::plotlyOutput("hist3")
                                                                ),
                                                                style = "opacity: 0.75"
                                                              )
                                                     )
                              )
      ),
      shinydashboard::tabItem(tabName = "gasPerform",
                              fluidRow(
                                shinydashboard::box(
                                  title = "KPI", status = "primary", width = 6, collapsible = T,
                                  plotly::plotlyOutput("hist5")
                                ),
                                shinydashboard::box(
                                  title = "Heatmap", status = "primary", width = 6, collapsible = T,
                                  d3heatmap::d3heatmapOutput("heatmap")
                                )
                              ),
                              fluidRow(
                                shinydashboard::box(
                                  title = "Controls", status = "primary", width = 4, collapsible = T,
                                  selectInput("perform", h5("Select KPI:"),
                                              c("Cost/Mile (kUSD/Mile)"="costMile",
                                                "Cost/Added Capacity (kUSD/MMcf/d)"= "costCap"
                                              )),
                                  selectInput("sensitivity", h5("Select Type of Sensitivity Measure:"),
                                              c("Contribution to Variance"="varr",
                                                "Rank Correlation"="corr"
                                              ))
                                )
                              )
      ),
      shinydashboard::tabItem(tabName = "gasTrends",
                              shinydashboard::tabBox(width = 12,
                                                     tabPanel("Cost",
                                                              fluidRow(
                                                                shinydashboard::box(
                                                                  title = "Project Cost Trends", status = "primary", width = 12, collapsible = T,
                                                                  plotly::plotlyOutput("boxplot")
                                                                )
                                                              ),
                                                              fluidRow(
                                                                shinydashboard::box(
                                                                  title = "Control", status = "primary", width = 4, collapsible = T,
                                                                  selectInput("gas", h5("Select Input:"),
                                                                              c("Cost (mUSD)"="cost",
                                                                                "Cost/Mile (mUSD/Mile)"="costMile"))
                                                                )
                                                              )
                                                     ),
                                                     tabPanel("Revenue",
                                                              fluidRow(
                                                                shinydashboard::box(
                                                                  title = "Rates Trends", status = "primary", width = 12, collapsible = T,
                                                                  plotly::plotlyOutput("lineChart3")
                                                                )
                                                              ),
                                                              fluidRow(
                                                                shinydashboard::box(
                                                                  title = "Control", status = "primary", width = 4, collapsible = T,
                                                                  selectInput("gasRates", h5("Select Input:"),
                                                                              c("Revenue (USD)"="Revenue",
                                                                                "Bill (USD)"= "Bill"))
                                                                )
                                                              )
                                                     )
                              )
      ),
      shinydashboard::tabItem(tabName = "gasExplorer",
                              shinydashboard::box(
                                title = "Explorer", status = "primary", width = 12, collapsible = T,
                                htmlOutput("motion1"), style = "overflow:hidden;"
                              )
      ),
      shinydashboard::tabItem(tabName = "gasData",
                              shinydashboard::tabBox(width = 12,
                                                     tabPanel("Project Data",
                                                              DT::dataTableOutput("pipelineTable")
                                                     ),
                                                     tabPanel("Rates Data",
                                                              DT::dataTableOutput("gasTable")
                                                     )
                              )
      ),
      shinydashboard::tabItem(tabName = "oilTrends",
                              fluidRow(
                                shinydashboard::box(
                                  title = "Rates Trends", status = "primary", width = 12, collapsible = T,
                                  plotly::plotlyOutput("lineChart4")
                                )
                              ),
                              fluidRow(
                                shinydashboard::box(
                                  title = "Control", status = "primary", width = 4, collapsible = T,
                                  selectInput("oil", h5("Select Input:"),
                                              c("Revenue (USD)"="Revenue",
                                                "Bill (USD)"= "Bill"
                                              ))
                                )
                              )
      ),
      shinydashboard::tabItem(tabName = "oilData",
                              shinydashboard::box(
                                title = "Rates Data", status = "primary", width = 12, collapsible = T,
                                DT::dataTableOutput("oilTable")
                              )
      )
    )
  )
)
