shinydashboard::dashboardPage(
  shinydashboard::dashboardHeader(
    title = "eAnalytics",
    shinydashboard::dropdownMenu(
      type = "messages",
      shinydashboard::messageItem(from = "Support",
                                  message = "Welcome to eAnalytics!")
    )
  ),
  shinydashboard::dashboardSidebar(
    shinydashboard::sidebarMenu(
      shinydashboard::menuItem(
        "Dashboard",
        tabName = "dashboard",
        icon = shiny::icon("dashboard")
      ),
      shinydashboard::menuItem(
        "Electric",
        icon = shiny::icon("th"),
        tabName = "electric",
        shinydashboard::menuSubItem(
          "Trends",
          tabName = "elecTrends",
          icon = shiny::icon("line-chart")
        ),
        shinydashboard::menuSubItem("Data", tabName = "elecData", icon = shiny::icon("table"))
      ),
      shinydashboard::menuItem(
        "Hydropower",
        icon = shiny::icon("th"),
        tabName = "hydroelectric",
        shinydashboard::menuSubItem(
          "Profile",
          tabName = "hydroProfile",
          icon = shiny::icon("globe")
        ),
        shinydashboard::menuSubItem("Data", tabName = "hydroData", icon = shiny::icon("table"))
      ),
      shinydashboard::menuItem(
        "Natural Gas",
        icon = shiny::icon("th"),
        tabName = "naturalgas",
        shinydashboard::menuSubItem(
          "Profile",
          tabName = "gasProfile",
          icon = shiny::icon("globe")
        ),
        shinydashboard::menuSubItem(
          "Performance",
          tabName = "gasPerform",
          icon = shiny::icon("bar-chart")
        ),
        shinydashboard::menuSubItem(
          "Trends",
          tabName = "gasTrends",
          icon = shiny::icon("line-chart")
        ),
        shinydashboard::menuSubItem(
          "Explorer",
          tabName = "gasExplorer",
          icon = shiny::icon("gear")
        ),
        shinydashboard::menuSubItem("Data", tabName = "gasData", icon = shiny::icon("table"))
      ),
      shinydashboard::menuItem(
        "Oil",
        icon = shiny::icon("th"),
        tabName = "oil",
        shinydashboard::menuSubItem(
          "Trends",
          tabName = "oilTrends",
          icon = shiny::icon("line-chart")
        ),
        shinydashboard::menuSubItem("Data", tabName = "oilData", icon = shiny::icon("table"))
      )
    )
  ),
  shinydashboard::dashboardBody(
    tags$head(
      tags$link(rel = "icon", type = "image/png", href = "favicon.png"),
      tags$title("eAnalytics")
    ),
    shinydashboard::tabItems(
      shinydashboard::tabItem(
        tabName = "dashboard",
        shiny::fluidRow(
          shinydashboard::box(
            title = "eAnalytics",
            status = "primary",
            width = 8,
            shiny::img(
              src = "favicon.png",
              height = 50,
              width = 50
            ),
            shiny::h3("Welcome to eAnalytics!"),
            shiny::h4(
              "eAnalytics is a ",
              shiny::a(href = 'http://shiny.rstudio.com', 'Shiny'),
              "web application built on top of R for energy-related data analytics, powered by the excellent",
              shiny::a(href = 'https://plot.ly/r/', 'plotly'),
              ",",
              shiny::a(href = 'https://rstudio.github.io/leaflet/', 'Leaflet'),
              ",",
              shiny::a(href = 'https://rstudio.github.io/DT/', 'DT'),
              ", and",
              shiny::a(href = 'https://cran.r-project.org/web/packages/googleVis/vignettes/googleVis_examples.html', 'googleVis'),
              "packages."
            ),
            shiny::h4(
              "eAnalytics has the largest open database of US energy industry information, providing interactive and dynamic web-based analytics to industry stakeholders."
            ),
            shiny::h4("To get started, select an industry in the sidepanel."),
            shiny::h4(
              shiny::HTML('&copy'),
              '2016 By Paul Govan. ',
              shiny::a(href = 'http://www.apache.org/licenses/LICENSE-2.0', 'Terms of Use.')
            )
          ),
          shiny::uiOutput("projectBox"),
          shiny::uiOutput("companyBox"),
          shiny::uiOutput("facilityBox")
        )
      ),
      shinydashboard::tabItem(
        tabName = "elecTrends",
        shiny::fluidRow(
          shinydashboard::box(
            title = "Rates Trends",
            status = "primary",
            width = 12,
            collapsible = T,
            plotly::plotlyOutput("lineChart1")
          )
        ),
        shiny::fluidRow(
          shinydashboard::box(
            title = "Control",
            status = "primary",
            width = 4,
            collapsible = T,
            shiny::selectInput(
              "elec",
              h5("Select Input:"),
              c("Revenue (USD)" =
                  "Revenue",
                "Bill (USD)" = "Bill")
            )
          )
        )
      ),
      shinydashboard::tabItem(
        tabName = "elecData",
        shinydashboard::box(
          title = "Rates Data",
          status = "primary",
          width = 12,
          collapsible = T,
          DT::dataTableOutput("elecTable")
        )
      ),
      shinydashboard::tabItem(
        tabName = "hydroProfile",
        shiny::tabPanel(
          "Hydropower",
          leaflet::leafletOutput("map1"),
          shiny::absolutePanel(
            draggable = TRUE,
            fixed = TRUE,
            shiny::wellPanel(
              shiny::h4("Hydropower Facilities"),
              shiny::selectInput("hydroSize", h5("Size:"),
                                 c("Total Capacity (MW)" =
                                     "Total")),
              shiny::selectInput("hydroCol", h5("Color:"),
                                 c("Status" =
                                     "status")),
              plotly::plotlyOutput("hist1")
            ),
            style = "opacity: 0.75"
          )
        )
      ),
      shinydashboard::tabItem(
        tabName = "hydroData",
        shinydashboard::box(
          title = "Hydropower Data",
          status = "primary",
          width = 12,
          collapsible = T,
          DT::dataTableOutput("hydroTable")
        )
      ),
      shinydashboard::tabItem(
        tabName = "gasProfile",
        shinydashboard::tabBox(
          width = 12,
          shiny::tabPanel(
            "Storage Facilities",
            leaflet::leafletOutput("map2"),
            shiny::absolutePanel(
              draggable = TRUE,
              fixed = TRUE,
              shiny::wellPanel(
                shiny::h4("NG Storage Facilities"),
                shiny::selectInput(
                  "storageSize",
                  h5("Size:"),
                  c(
                    "Total Capacity (BCF)" = "Total",
                    "Working Capacity (BCF)" = "Working"
                  )
                ),
                shiny::selectInput("storageColor", h5("Color:"),
                                   c("Storage Type" =
                                       "type")),
                br(),
                plotly::plotlyOutput("hist2")
              ),
              style = "opacity: 0.75"
            )
          ),
          shiny::tabPanel(
            "LNG Facilities",
            leaflet::leafletOutput("map3"),
            shiny::absolutePanel(
              draggable = TRUE,
              fixed = TRUE,
              shiny::wellPanel(
                shiny::h4("LNG Facilities"),
                shiny::selectInput("lngSize", h5("Size:"),
                                   c("Total Capacity (BCFD)" =
                                       "Total")),
                shiny::selectInput(
                  "lngColor",
                  h5("Color:"),
                  c("Facility Type" =
                      "type",
                    "Status" =
                      "status")
                ),
                br(),
                plotly::plotlyOutput("hist3")
              ),
              style = "opacity: 0.75"
            )
          )
        )
      ),
      shinydashboard::tabItem(
        tabName = "gasPerform",
        shiny::fluidRow(
          shinydashboard::box(
            title = "KPI",
            status = "primary",
            width = 6,
            collapsible = T,
            plotly::plotlyOutput("hist5")
          ),
          shinydashboard::box(
            title = "Heatmap",
            status = "primary",
            width = 6,
            collapsible = T,
            d3heatmap::d3heatmapOutput("heatmap")
          )
        ),
        shiny::fluidRow(
          shinydashboard::box(
            title = "Controls",
            status = "primary",
            width = 4,
            collapsible = T,
            shiny::selectInput(
              "perform",
              h5("Select KPI:"),
              c(
                "Cost/Mile (kUSD/Mile)" = "costMile",
                "Cost/Added Capacity (kUSD/MMcf/d)" = "costCap"
              )
            ),
            shiny::selectInput(
              "sensitivity",
              h5("Select Type of Sensitivity Measure:"),
              c(
                "Contribution to Variance" = "varr",
                "Rank Correlation" =
                  "corr"
              )
            )
          )
        )
      ),
      shinydashboard::tabItem(
        tabName = "gasTrends",
        shinydashboard::tabBox(
          width = 12,
          shiny::tabPanel(
            "Cost",
            shiny::fluidRow(
              shinydashboard::box(
                title = "Project Cost Trends",
                status = "primary",
                width = 12,
                collapsible = T,
                plotly::plotlyOutput("boxplot")
              )
            ),
            shiny::fluidRow(
              shinydashboard::box(
                title = "Control",
                status = "primary",
                width = 4,
                collapsible = T,
                shiny::selectInput(
                  "gas",
                  h5("Select Input:"),
                  c("Cost (mUSD)" =
                      "cost",
                    "Cost/Mile (mUSD/Mile)" =
                      "costMile")
                )
              )
            )
          ),
          shiny::tabPanel(
            "Revenue",
            fluidRow(
              shinydashboard::box(
                title = "Rates Trends",
                status = "primary",
                width = 12,
                collapsible = T,
                plotly::plotlyOutput("lineChart3")
              )
            ),
            shiny::fluidRow(
              shinydashboard::box(
                title = "Control",
                status = "primary",
                width = 4,
                collapsible = T,
                shiny::selectInput(
                  "gasRates",
                  h5("Select Input:"),
                  c("Revenue (USD)" =
                      "Revenue",
                    "Bill (USD)" = "Bill")
                )
              )
            )
          )
        )
      ),
      shinydashboard::tabItem(
        tabName = "gasExplorer",
        shinydashboard::box(
          title = "Explorer",
          status = "primary",
          width = 12,
          collapsible = T,
          shiny::htmlOutput("motion1"),
          style = "overflow:hidden;"
        )
      ),
      shinydashboard::tabItem(
        tabName = "gasData",
        shinydashboard::tabBox(
          width = 12,
          shiny::tabPanel("Project Data",
                          DT::dataTableOutput("pipelineTable")),
          shiny::tabPanel("Rates Data",
                          DT::dataTableOutput("gasTable"))
        )
      ),
      shinydashboard::tabItem(
        tabName = "oilTrends",
        shiny::fluidRow(
          shinydashboard::box(
            title = "Rates Trends",
            status = "primary",
            width = 12,
            collapsible = T,
            plotly::plotlyOutput("lineChart4")
          )
        ),
        shiny::fluidRow(
          shinydashboard::box(
            title = "Control",
            status = "primary",
            width = 4,
            collapsible = T,
            shiny::selectInput(
              "oil",
              h5("Select Input:"),
              c("Revenue (USD)" =
                  "Revenue",
                "Bill (USD)" = "Bill")
            )
          )
        )
      ),
      shinydashboard::tabItem(
        tabName = "oilData",
        shinydashboard::box(
          title = "Rates Data",
          status = "primary",
          width = 12,
          collapsible = T,
          DT::dataTableOutput("oilTable")
        )
      )
    )
  )
)
