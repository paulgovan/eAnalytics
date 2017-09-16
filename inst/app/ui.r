# Dashboard page
shinydashboard::dashboardPage(

  # Dashboard header
  shinydashboard::dashboardHeader(title = "eAnalytics"),

  # Dashboard sidebar
  shinydashboard::dashboardSidebar(

    # Sidebar menu
    shinydashboard::sidebarMenu(

      # Home menu item
      shinydashboard::menuItem("Home",
                               tabName = "home",
                               icon = shiny::icon("home")),

      # Electric menu item
      shinydashboard::menuItem(
        "Electric",
        icon = shiny::icon("th"),
        tabName = "electric",

        # Electric trends menu sub-item
        shinydashboard::menuSubItem(
          "Trends",
          tabName = "elecTrends",
          icon = shiny::icon("line-chart")
        ),

        # Electric data menu sub-item
        shinydashboard::menuSubItem(
          "Data",
          tabName = "elecData",
          icon = shiny::icon("table"))
      ),

      # Hydropower menu item
      shinydashboard::menuItem(
        "Hydropower",
        icon = shiny::icon("th"),
        tabName = "hydroelectric",

        # Hydropower profile menu sub-item
        shinydashboard::menuSubItem(
          "Profile",
          tabName = "hydroProfile",
          icon = shiny::icon("globe")
        ),

        # Hydropower data menu sub-item
        shinydashboard::menuSubItem(
          "Data",
          tabName = "hydroData",
          icon = shiny::icon("table"))
      ),

      # Natural gas menu item
      shinydashboard::menuItem(
        "Natural Gas",
        icon = shiny::icon("th"),
        tabName = "naturalgas",

        # Natural gas profile menu sub-item
        shinydashboard::menuSubItem(
          "Profile",
          tabName = "gasProfile",
          icon = shiny::icon("globe")
        ),

        # Natural gas performance menu sub-item
        shinydashboard::menuSubItem(
          "Performance",
          tabName = "gasPerform",
          icon = shiny::icon("bar-chart")
        ),

        # Natural gas trends menu sub-item
        shinydashboard::menuSubItem(
          "Trends",
          tabName = "gasTrends",
          icon = shiny::icon("line-chart")
        ),

        # Natural gas explorer menu sub-item
        shinydashboard::menuSubItem(
          "Explorer",
          tabName = "gasExplorer",
          icon = shiny::icon("gear")
        ),

        # Natural gas data menu sub-item
        shinydashboard::menuSubItem(
          "Data",
          tabName = "gasData",
          icon = shiny::icon("table"))
      ),

      # Oil menu item
      shinydashboard::menuItem(
        "Oil",
        icon = shiny::icon("th"),
        tabName = "oil",

        # Oil trends menu sub-item
        shinydashboard::menuSubItem(
          "Trends",
          tabName = "oilTrends",
          icon = shiny::icon("line-chart")
        ),

        # Oil data menu sub-item
        shinydashboard::menuSubItem(
          "Data",
          tabName = "oilData",
          icon = shiny::icon("table"))
      ),
      br(),

      # Help menu item
      shinydashboard::menuItem("Help",
                               icon = icon("info-circle"),
                               href = "http://paulgovan.github.io/eAnalytics/"),

      # Source code menu item
      shinydashboard::menuItem("Source Code",
                               icon = icon("code"),
                               href = "https://github.com/paulgovan/eAnalytics")
    )
  ),

  # Dashboard body
  shinydashboard::dashboardBody(

    # Dashboard favicon and title
    tags$head(
      tags$link(rel = "icon", type = "image/png", href = "favicon.png"),
      tags$title("eAnalytics")
    ),

    # Dashboard tab items
    shinydashboard::tabItems(

      # Home tab item
      shinydashboard::tabItem(
        tabName = "home",
        shiny::fluidRow(

          # Welcome box
          shinydashboard::box(
            title = "",
            status = "primary",
            width = 8,
            shiny::img(
              src = "favicon.png",
              height = 50,
              width = 50
            ),
            shiny::h2("eAnalyics"),
            shiny::h4("Dynamic Web-based Analytics for the Energy Industry"),
            br(),
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
            br(),
            shiny::h4(
              shiny::HTML('&copy'),
              '2016 By Paul Govan. ',
              shiny::a(href = 'http://www.apache.org/licenses/LICENSE-2.0', 'Terms of Use.')
            )
          ),

          # Projects, companies, and facilities value boxes
          shiny::uiOutput("projectBox"),
          shiny::uiOutput("companyBox"),
          shiny::uiOutput("facilityBox")
        )
      ),

      # Electric trends tab item
      shinydashboard::tabItem(
        tabName = "elecTrends",
        shiny::fluidRow(

          # Electric trends box
          shinydashboard::box(

            title = "Revenue Trends",
            status = "primary",
            width = 12,
            collapsible = T,

            # Electric rates line chart
            plotly::plotlyOutput("lineChart1"),

            shinyWidgets::dropdownButton(

              # Panel title
              shiny::h4("List of Inputs"),

              # Electric rates input select
              shiny::selectInput(
                "elec",
                h5("Select Input:"),
                c("Revenue (USD)" =
                    "Revenue",
                  "Bill (USD)" = "Bill")
              ),
              circle = TRUE, status = "danger", icon = icon("gear"), width = "300px",
              tooltip = shinyWidgets::tooltipOptions(title = "Click to see inputs"),
              up = TRUE
            )
          )
        )
      ),

      # Electric data tab item
      shinydashboard::tabItem(
        tabName = "elecData",

        # Electric rates data box
        shinydashboard::box(
          title = "Revenue Data",
          status = "primary",
          width = 12,
          collapsible = T,

          # Electric rates data table
          DT::dataTableOutput("elecTable")
        )
      ),

      # Hydropower profile tab item
      shinydashboard::tabItem(
        tabName = "hydroProfile",

        # Hydropower profile tab panel
        shiny::tabPanel(
          "Hydropower Facilities",

          # Hydropower profile map
          leaflet::leafletOutput("map1"),
          # tags$style(type = "text/css", "#map1 {height: calc(100vh - 80px) !important;}"),

          # Hydropower panel
          shinyWidgets::dropdownButton(

            # Panel title
            shiny::h4("List of Inputs"),

            # Marker size input select
            shiny::selectInput("hydroSize", h5("Marker Size:"),
                               c("Total Capacity (MW)" = "Total")),

            # Marker color input select
            shiny::selectInput("hydroCol", h5("Marker Color:"),
                               c("Status" = "status")),

            circle = TRUE, status = "danger", icon = icon("gear"), width = "300px",
            tooltip = shinyWidgets::tooltipOptions(title = "Click to see inputs"),
            up = TRUE
          )
        )
      ),

      # Hydropower data tab item
      shinydashboard::tabItem(
        tabName = "hydroData",

        # Hydropower data box
        shinydashboard::box(
          title = "Hydropower Facility Data",
          status = "primary",
          width = 12,
          collapsible = T,

          # Hydropower data table
          DT::dataTableOutput("hydroTable")
        )
      ),

      # Natural gas profile tab item
      shinydashboard::tabItem(
        tabName = "gasProfile",

        # Natural gas storage facilities tab box
        shinydashboard::tabBox(
          width = 12,

          # Natural gas storage facilities tab panel
          shiny::tabPanel(
            "Storage Facilities",

            # Storage facilities map
            leaflet::leafletOutput("map2"),
            # tags$style(type = "text/css", "#map2 {height: calc(100vh - 80px) !important;}"),

            shinyWidgets::dropdownButton(

                # Panel title
                shiny::h4("List of Inputs"),

                # Marker size input select
                shiny::selectInput(
                  "storageSize",
                  h5("Marker Size:"),
                  c("Total Capacity (BCF)" = "Total",
                    "Working Capacity (BCF)" = "Working"
                  )
                ),

                # Marker color input select
                shiny::selectInput("storageColor", h5("Marker Color:"),
                                   c("Storage Type" =
                                       "type")),
                circle = TRUE, status = "danger", icon = icon("gear"), width = "300px",
                tooltip = shinyWidgets::tooltipOptions(title = "Click to see inputs"),
                up = TRUE
            )
          ),

          # LNG facilities tab panel
          shiny::tabPanel(
            "LNG Facilities",

            # LNG facilities map
            leaflet::leafletOutput("map3"),
            # tags$style(type = "text/css", "#map3 {height: calc(100vh - 80px) !important;}"),

            shinyWidgets::dropdownButton(

              # Panel title
                shiny::h4("List of Inputs"),

                # Marker size input select
                shiny::selectInput("lngSize", h5("Marker Size:"),
                                   c("Total Capacity (BCFD)" = "Total")),

                # Marker color input select
                shiny::selectInput("lngColor", h5("Marker Color:"),
                                   c("Facility Type" = "type",
                                     "Status" = "status")
                ),
                circle = TRUE, status = "danger", icon = icon("gear"), width = "300px",
                tooltip = shinyWidgets::tooltipOptions(title = "Click to see inputs"),
                up = TRUE
            )
          )
        )
      ),

      # Natural gas performance tab item
      shinydashboard::tabItem(
        tabName = "gasPerform",
        shiny::fluidRow(

          # Natural gas performance box
          shinydashboard::box(
            title = "Performance Indicator",
            status = "primary",
            width = 6,
            collapsible = T,

            # Natural gas performance histogram
            plotly::plotlyOutput("hist5")
          ),

          # Natural gas heatmap box
          shinydashboard::box(
            title = "Heatmap",
            status = "primary",
            width = 6,
            collapsible = T,

            # Natural gas heatmap
            plotly::plotlyOutput("heatmap")
          )
        ),
        shiny::fluidRow(

          shinyWidgets::dropdownButton(

            # Panel title
            shiny::h4("List of Inputs"),

            # Performance variable input select
            shiny::selectInput(
              "perform",
              h5("Select Performance Indicator:"),
              c(
                "Cost/Mile (kUSD/Mile)" = "costMile",
                "Cost/Added Capacity (kUSD/MMcf/d)" = "costCap"
              )
            ),

            # Heatmap type input select
            shiny::selectInput(
              "sensitivity",
              h5("Select Type of Sensitivity Measure:"),
              c(
                "Contribution to Variance" = "varr",
                "Rank Correlation" = "corr"
              )
            ),
            circle = TRUE, status = "danger", icon = icon("gear"), width = "300px",
            tooltip = shinyWidgets::tooltipOptions(title = "Click to see inputs !"),
            up = TRUE
          )
        )
      ),

      # Natural gas trends tab item
      shinydashboard::tabItem(
        tabName = "gasTrends",

        # Natural gas trends tab box
        shinydashboard::tabBox(
          width = 12,

          # Natural gas cost trends tab panel
          shiny::tabPanel(
            "Cost Trends",
            shiny::fluidRow(

              # Natural gas cost trends box
              shinydashboard::box(
                title = "Project Cost Trends",
                status = "primary",
                width = 12,
                collapsible = T,

                # Natural gas cost trends box plots
                plotly::plotlyOutput("boxplot"),

                shinyWidgets::dropdownButton(

                  # Panel title
                  shiny::h4("List of Inputs"),

                  # Cost variable input select
                  shiny::selectInput(
                    "gas",
                    h5("Select Input:"),
                    c("Cost (mUSD)" = "cost",
                      "Cost/Mile (mUSD/Mile)" = "costMile")
                  ),
                  circle = TRUE, status = "danger", icon = icon("gear"), width = "300px",
                  tooltip = shinyWidgets::tooltipOptions(title = "Click to see inputs"),
                  up = TRUE
                )
              )
            )
          ),

          # Natural gas revenue trends tab panel
          shiny::tabPanel(
            "Revenue Trends",
            fluidRow(

              # Natural gas revenue trends box
              shinydashboard::box(
                title = "Revenue Trends",
                status = "primary",
                width = 12,
                collapsible = T,

                # Natural gas revenue line chart
                plotly::plotlyOutput("lineChart3"),

                shinyWidgets::dropdownButton(

                  # Panel title
                  shiny::h4("List of Inputs"),

                  # Revenue variable input select
                  shiny::selectInput(
                    "gasRates",
                    h5("Select Input:"),
                    c("Revenue (USD)" = "Revenue",
                      "Bill (USD)" = "Bill")
                  ),
                  circle = TRUE, status = "danger", icon = icon("gear"), width = "300px",
                  tooltip = shinyWidgets::tooltipOptions(title = "Click to see inputs"),
                  up = TRUE
                )
              )
            )
          )
        )
      ),

        # Natural gas explorer tab item
        shinydashboard::tabItem(
          tabName = "gasExplorer",

          # Natural gas explorer box
          shinydashboard::box(
            title = "Explorer",
            status = "primary",
            width = 12,
            collapsible = T,

            # Natural gas googleVis motion chart
            shiny::htmlOutput("motion1"),
            style = "overflow:hidden;"
          )
        ),

        # Natural gas data tab item
        shinydashboard::tabItem(
          tabName = "gasData",

          # Natural gas data tab box
          shinydashboard::tabBox(
            width = 12,

            # Natural gas project data tab panel
            shiny::tabPanel("Project Data",
                            DT::dataTableOutput("pipelineTable")),

            # Natural gas revenue data tab panel
            shiny::tabPanel("Revenue Data",
                            DT::dataTableOutput("gasTable"))
          )
        ),

        # Oil trends tab item
        shinydashboard::tabItem(
          tabName = "oilTrends",
          shiny::fluidRow(

            # Oil trends box
            shinydashboard::box(
              title = "Revenue Trends",
              status = "primary",
              width = 12,
              collapsible = T,

              # Oil trends line chart
              plotly::plotlyOutput("lineChart4"),

              shinyWidgets::dropdownButton(

                # Panel title
                shiny::h4("List of Inputs"),

                # Rates variable input select
                shiny::selectInput(
                  "oil",
                  h5("Select Input:"),
                  c("Revenue (USD)" = "Revenue",
                    "Bill (USD)" = "Bill")
                ),
                circle = TRUE, status = "danger", icon = icon("gear"), width = "300px",
                tooltip = shinyWidgets::tooltipOptions(title = "Click to see inputs"),
                up = TRUE
              )
            )
          )
        ),

        # Oil data tab item
        shinydashboard::tabItem(
          tabName = "oilData",

          # Oil data box
          shinydashboard::box(
            title = "Revenue Data",
            status = "primary",
            width = 12,
            collapsible = T,

            # Oil data table
            DT::dataTableOutput("oilTable")
          )
        )
      )
    )
  )
