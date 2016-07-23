# Load data
data(electric, package = "energyr")
data(hydropower, package = "energyr")
data(gas, package = "energyr")
data(oil, package = "energyr")
data(storage, package = "energyr")
data(pipeline, package = "energyr")
data(lng, package = "energyr")

# Aggregate pipeline data for googleVis chart
motionData <- dplyr::select(pipeline, Type, Year, Cost, Miles, Capacity)
motionData <- dplyr::filter(motionData, !is.na(Year))
motionData[is.na(motionData)] <- 0
motionData <- aggregate(motionData[,3:5],
                        by = list(Year = motionData$Year, Type = motionData$Type), FUN = sum)
motionData$Year <- as.Date(as.character(motionData$Year), format = "%Y")

# Calculate the number of unique companies, projects, and facilities in database
company <- length(unique(electric[,1])) + length(unique(hydropower[,"Company"])) + length(unique(gas[,1])) + length(unique(storage[,"Company"])) + length(unique(lng[,"Company"])) + length(unique(oil[,1]))
project <- length(unique(pipeline[,"Name"]))
facility <- length(unique(hydropower[,"Name"])) + length(unique(storage[,"Field"])) + length(unique(lng[,"Company"]))

shiny::shinyServer(function(input, output, session) {

  # Create the projects box
  output$projectBox <- shiny::renderUI({
    shinydashboard::valueBox(project, "Projects in Database", icon = shiny::icon("database"), color = "green")
  })

  # Create the companies box
  output$companyBox <- shiny::renderUI({
    shinydashboard::valueBox(company, "Company Profiles", icon = shiny::icon("users"), color = "purple")
  })

  # Create the facilities box
  output$facilityBox <- shiny::renderUI({
    shinydashboard::valueBox(facility, "Facility Profiles", icon = shiny::icon("building"), color = "yellow")
  })

  # Plot the electric rates line chart
  output$lineChart1 <- plotly::renderPlotly({
    s1 <- input$elecTable_rows_all
    if (length(s1) > 0 && length(s1) < nrow(electric)) {
      electric <- electric[s1,]
    }
    if (input$elec == "Revenue") {
      Rate <- electric$Revenue
    } else {
      Rate <- electric$Bill
    }
    plotly::plot_ly(electric, x = Year, y = Rate, group = Company)
  })

  # Show electric rates table
  output$elecTable <- DT::renderDataTable({
    DT::datatable(electric, rownames = FALSE,
                  options = list(searchHighlight = TRUE,
                                 order = list(list(3, 'desc')))) %>%
      DT::formatCurrency(c('Revenue', 'Bill'))
  }, server = FALSE)

  # Plot the hydropower map
  output$map1 <- leaflet::renderLeaflet({
    hydropower <- hydropower[complete.cases(hydropower),]
    content <- paste0("<strong>Name: </strong>",
                      hydropower$Name,
                      "<br><strong>Company: </strong>",
                      hydropower$Company,
                      "<br><strong>Waterway: </strong>",
                      hydropower$Waterway,
                      "<br><strong>Capacity (KW): </strong>",
                      hydropower$Capacity)
    pal <- leaflet::colorFactor(c("navy", "red"), domain = c("Expired", "Active"))
    leaflet::leaflet(hydropower) %>%
      leaflet::fitBounds(-125, 49, -62, 18) %>%
      leaflet::addProviderTiles("Esri.WorldStreetMap", group = "WSM") %>%
      leaflet::addProviderTiles("CartoDB.DarkMatter", group = "Dark") %>%
      leaflet::addProviderTiles("Esri.WorldImagery", group = "Satellite") %>%
      leaflet::addCircles(radius = ~sqrt(Capacity/1000), color = ~pal(Status), popup = ~content) %>%
      leaflet::addLegend("topright", pal = pal, values = ~Status, title = "Status") %>%
      leaflet::addLayersControl(baseGroups = c("WSM", "Dark", "Satellite"),
                                position = "bottomright",
                                options = leaflet::layersControlOptions(collapsed = TRUE))
  })

  # Plot the hydropower histogram
  output$hist1 <- plotly::renderPlotly({
    hydropower <- hydropower[complete.cases(hydropower),]
    Capacity <- hydropower$Capacity/1000
    plotly::plot_ly(x = Capacity, type = "histogram", opacity = 0.75) %>%
      layout(autosize = F, width = 300, height = 250)
  })

  # Show hydropower data table
  output$hydroTable <- DT::renderDataTable({
    DT::datatable(hydropower[,1:9], rownames = FALSE, colnames = c('Capacity (KW)' = 'Capacity'), extensions = 'Responsive')
  })

  # Plot the storage map
  output$map2 <- leaflet::renderLeaflet({
    storage <- storage[complete.cases(storage),]
    content <- paste0("<strong>Company: </strong>",
                      storage$Company,
                      "<br><strong>Field: </strong>",
                      storage$Field,
                      "<br><strong>Total Capacity (BCF): </strong>",
                      storage$Total)
    pal <- leaflet::colorFactor(c("navy", "red", "green"), domain = c("Depleted Field", "Salt Dome", "Aquifer"))
    if (input$storageSize == "Total") {
      leaflet::leaflet(storage) %>%
        leaflet::addProviderTiles("Esri.WorldStreetMap", group = "WSM") %>%
        leaflet::addProviderTiles("CartoDB.DarkMatter", group = "Dark") %>%
        leaflet::addProviderTiles("Esri.WorldImagery", group = "Satellite") %>%
        leaflet::addCircles(radius = ~Total/1000, color = ~pal(Type), popup = ~content) %>%
        leaflet::addLayersControl(baseGroups = c("WSM", "Dark", "Satellite"),
                                  position = "bottomright",
                                  options = leaflet::layersControlOptions(collapsed = TRUE)) %>%
        leaflet::addLegend("topright", pal = pal, values = ~Type, title = "Storage Type")

    } else if (input$storageSize == "Working") {
      leaflet::leaflet(storage) %>%
        leaflet::addProviderTiles("Esri.WorldStreetMap", group = "WSM") %>%
        leaflet::addProviderTiles("CartoDB.DarkMatter", group = "Dark") %>%
        leaflet::addProviderTiles("Esri.WorldImagery", group = "Satellite") %>%
        leaflet::addCircles(radius = ~Working/1000, color = ~pal(Type), popup = ~content) %>%

        leaflet::addLayersControl(baseGroups = c("WSM", "Dark", "Satellite"),
                                  position = "bottomright",
                                  options = leaflet::layersControlOptions(collapsed = TRUE)) %>%
        leaflet::addLegend("topright", pal = pal, values = ~Type, title = "Storage Type")
    }
  })

  # Plot the storage histogram
  output$hist2 <- plotly::renderPlotly({
    storage <- storage[complete.cases(storage),]
    if (input$storageSize == "Total") {
      Capacity <- storage$Total/1000
    } else if (input$storageSize == "Working") {
      Capacity <- storage$Working/1000
    }
    plotly::plot_ly(x = Capacity, type = "histogram", opacity = 0.75) %>%
      layout(autosize = F, width = 300, height = 250)
  })

  # Plot the LNG map
  output$map3 <- leaflet::renderLeaflet({
    lng <- lng[complete.cases(lng),]
    content <- paste0("<strong>Company: </strong>",
                      lng$Company,
                      "<br><strong>Capacity (BCFD): </strong>",
                      lng$Capacity)
    if (input$lngColor == "type") {
      pal <- leaflet::colorFactor(c("navy", "red"), domain = c("Export", "Import"))
      leaflet::leaflet(lng) %>%
        leaflet::addProviderTiles("Esri.WorldStreetMap", group = "WSM") %>%
        leaflet::addProviderTiles("CartoDB.DarkMatter", group = "Dark") %>%
        leaflet::addProviderTiles("Esri.WorldImagery", group = "Satellite") %>%
        leaflet::addCircles(radius = ~Capacity, color = ~pal(Type), popup = ~content) %>%
        leaflet::addLegend("topright", pal = pal, values = ~Type, title = "Facility Type") %>%
        leaflet::addLayersControl(baseGroups = c("WSM", "Dark", "Satellite"),
                                  position = "bottomright",
                                  options = leaflet::layersControlOptions(collapsed = TRUE))
    } else if (input$lngColor == "status") {
      pal <- leaflet::colorFactor(c("navy", "red", "green", "orange"), domain = c("Not under construction", "Under construction", "Existing", "Proposed"))
      leaflet::leaflet(lng) %>%
        leaflet::addProviderTiles("Esri.WorldStreetMap", group = "WSM") %>%
        leaflet::addProviderTiles("CartoDB.DarkMatter", group = "Dark") %>%
        leaflet::addProviderTiles("Esri.WorldImagery", group = "Satellite") %>%
        leaflet::addCircles(radius = ~Capacity, color = ~pal(Status), popup = ~content) %>%
        leaflet::addLegend("topright", pal = pal, values = ~Status, title = "Facility Status") %>%
        leaflet::addLayersControl(baseGroups = c("WSM", "Dark", "Satellite"),
                                  position = "bottomright",
                                  options = leaflet::layersControlOptions(collapsed = TRUE))
    }
  })

  # Plot the LNG capacity histogram
  output$hist3 <- plotly::renderPlotly({
    lng <- lng[complete.cases(lng),]
    Capacity <- lng$Capacity
    plotly::plot_ly(x = Capacity, type = "histogram", opacity = 0.75) %>%
      layout(autosize = F, width = 300, height = 250)
  })

  # Plot the natural gas pipeline histogram
  output$hist5 <- plotly::renderPlotly({
    if (input$perform == "costMile") {
      KPI <- pipeline[,"Cost"]/pipeline[,"Miles"]
    } else if (input$perform == "costCap") {
      KPI <- pipeline[,"Cost"]/pipeline[,"Capacity"]
    }
    plotly::plot_ly(x = KPI, type = "histogram", opacity = 0.75, nbinx = 10)
  })

  # Draw a natural gas pipeline heatmap
  output$heatmap <- d3heatmap::renderD3heatmap({
    pipeline <- subset(pipeline, select = c("Cost", "Miles", "Capacity"))
    dfcor <- cor(pipeline, use="complete.obs")
    dfvar <- dfcor^2*100

    if (input$sensitivity == "varr") {
      df <- dfvar
    } else if (input$sensitivity == "corr") {
      df <- dfcor
    }
    d3heatmap::d3heatmap(df, symm = TRUE, digits = 2, cexRow = 0.8, cexCol = 0.8)
  })

  # Plot the natural gas cost boxplot
  output$boxplot <- plotly::renderPlotly({
    pipeline <- na.omit(pipeline)
    if (input$gas == "cost") {
      cost <- data.frame(Year = pipeline[,"Year"], Cost = pipeline[,"Cost"])
    } else if (input$gas == "costMile") {
      cost <- data.frame(Year = pipeline[,"Year"], Cost = pipeline[,"Cost"]/pipeline[,"Miles"])
    } else if (input$gas == "costCap") {
      cost <- data.frame(Year = pipeline[,"Year"], Cost = pipeline[,"Cost"]/pipeline[,"Capacity"])
    }
    plotly::plot_ly(cost, y = Cost, group = Year, type = "box")
  })

  # Plot the natural gas rates line chart
  output$lineChart3 <- plotly::renderPlotly({
    s2 <- input$gasTable_rows_all
    if (length(s2) > 0 && length(s2) < nrow(gas)) {
      gas <- gas[s2,]
    }
    if (input$gasRates == "Revenue") {
      Rate <- gas$Revenue
    } else {
      Rate <- gas$Bill
    }
    plotly::plot_ly(gas, x = Year, y = Rate, group = Company)
  })

  # Plot the natural gas pipeline motion chart
  output$motion1 <- googleVis::renderGvis({
    googleVis::gvisMotionChart(motionData, idvar="Type",
                               timevar="Year")
  })

  # Show natural gas pipeline table
  output$pipelineTable <- DT::renderDataTable({
    pipeline <- pipeline[,!(names(pipeline) %in% 'Year')]
    DT::datatable(pipeline[,], rownames = FALSE, colnames = c('Cost ($MM)' = 'Cost', 'Capacity (MMcf/d)' = 'Capacity', 'Diameter (IN)' = 'Diameter'), extensions = 'Responsive')
  })

  # Show natural gas rates table
  output$gasTable <- DT::renderDataTable({
    DT::datatable(gas, rownames = FALSE,
                  options = list(searchHighlight = TRUE,
                                 order = list(list(3, 'desc')))) %>%
      DT::formatCurrency(c('Revenue', 'Bill'))
  }, server = FALSE)

  # Plot the oil rates line chart
  output$lineChart4 <- plotly::renderPlotly({
    s3 <- input$oilTable_rows_all
    if (length(s3) > 0 && length(s3) < nrow(oil)) {
      oil <- oil[s3,]
    }
    if (input$oil == "Revenue") {
      Rate <- oil$Revenue
    } else {
      Rate <- oil$Bill
    }
    plotly::plot_ly(oil, x = Year, y = Rate, group = Company)
  })

  # Show oil rates table
  output$oilTable <- DT::renderDataTable({
    DT::datatable(oil, rownames = FALSE,
                  options = list(searchHighlight = TRUE,
                                 order = list(list(3, 'desc')))) %>%
      DT::formatCurrency(c('Revenue', 'Bill'))
  }, server = FALSE)
})
