#' Interactive and dynamic web analytics for the energy industry.
#'
#' eAnalytics is a shiny web application for energy industry analytics.
#' eAnalytics has the largest open database of US energy industry information,
#' providing interactive and dynamic web analytics to industry stakeholders.
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
#' @import shinytest
#' @importFrom shinyWidgets dropdownButton tooltipOptions
#' @export
#' @seealso \url{http://paulgovan.github.io/eAnalytics/}
#' @examples
#' if (interactive()) {
#'   eAnalytics()
#' }
eAnalytics <- function() {
  shiny::runApp(system.file('app', package = 'eAnalytics'))
}
