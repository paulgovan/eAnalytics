#' Launch eAnalytics Shiny Application
#'
#' This function launches the eAnalytics Shiny application, which provides
#' interactive visualizations and analyses of energy data. The application
#' includes features such as time series plots, motion charts, data tables,
#' and geographic maps.
#'
#' @seealso \url{http://paulgovan.github.io/eAnalytics/}
#' @examples
#' if (interactive()) {
#'   eAnalytics()
#' }
#' @return The function does not return a value; it launches the Shiny app.
#' @importFrom plotly as.widget renderPlotly plot_ly plotlyOutput "%>%"
#' @importFrom dplyr select filter
#' @importFrom DT dataTableOutput renderDataTable datatable formatCurrency "%>%"
#' @import energyr
#' @importFrom googleVis renderGvis gvisMotionChart
#' @importFrom leaflet renderLeaflet colorFactor leaflet fitBounds
#'   addProviderTiles addCircles addLegend addLayersControl layersControlOptions
#'   leafletOutput "%>%"
#' @importFrom shiny shinyServer renderUI icon fluidRow img a uiOutput
#'   absolutePanel wellPanel selectInput
#' @importFrom shinydashboard dashboardPage dashboardHeader dropdownMenu
#'   messageItem dashboardSidebar sidebarMenu menuItem menuSubItem dashboardBody
#'   tabItems tabItem box tabBox
#' @importFrom shinyWidgets dropdownButton tooltipOptions
#' @export
eAnalytics <- function() {
  shiny::runApp(system.file("app", package = "eAnalytics"))
}
