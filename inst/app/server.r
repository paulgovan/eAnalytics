# Load data from 'energyr' package
data(electric, package = "energyr")
data(hydropower, package = "energyr")
data(gas, package = "energyr")
data(oil, package = "energyr")
data(storage, package = "energyr")
data(pipeline, package = "energyr")
data(lng, package = "energyr")

# Aggregate pipeline data for googleVis chart
motionData <- dplyr::select(pipeline, Type, Year, Cost, Miles, Capacity)
motionData <- dplyr::filter(motionData,!is.na(Year))
motionData[is.na(motionData)] <- 0
motionData <- aggregate(
  motionData[, 3:5],
  by = list(Year = motionData$Year, Type = motionData$Type),
  FUN = sum
)
motionData$Year <- as.Date(as.character(motionData$Year), format = "%Y")

# Calculate the number of unique companies, projects, and facilities in database
company <- length(unique(electric[, 1])) + length(unique(hydropower[, "Company"])) + length(unique(gas[, 1])) + length(unique(storage[, "Company"])) + length(unique(lng[, "Company"])) + length(unique(oil[, 1]))
project <- length(unique(pipeline[, "Name"]))
facility <- length(unique(hydropower[, "Name"])) + length(unique(storage[, "Field"])) + length(unique(lng[, "Company"]))

# Define a server for the app
shiny::shinyServer(function(input, output, session) {

  # Create the projects box
  output$projectBox <- shiny::renderUI({
    shinydashboard::valueBox(
      project,
      "Projects in Database",
      icon = shiny::icon("database"),
      color = "green"
    )
  })

  # Create the companies box
  output$companyBox <- shiny::renderUI({
    shinydashboard::valueBox(company,
                             "Company Profiles",
                             icon = shiny::icon("users"),
                             color = "purple")
  })

  # Create the facilities box
  output$facilityBox <- shiny::renderUI({
    shinydashboard::valueBox(
      facility,
      "Facility Profiles",
      icon = shiny::icon("building"),
      color = "yellow"
    )
  })

  # Plot the electric rates line chart
  output$lineChart1 <- plotly::renderPlotly({

    # Get the curently selected table rows from the user
    s1 <- input$elecTable_rows_all

    # Subset data based on user selection
    if (length(s1) > 0 && length(s1) < nrow(electric)) {
      electric <- electric[s1, ]
    }

    # Get the rate variable from the user
    if (input$elec == "Revenue") {
      Rate <- electric$Revenue
    } else {
      Rate <- electric$Bill
    }

    # Plot the line chart
    plotly::plot_ly(electric,
                    x = ~Year,
                    y = ~Rate,
                    split = ~Company,
                    type = "scatter") %>%

      # Add style options
      layout(
        updatemenus = list(
          list(
            buttons = list(

              list(method = "restyle",
                   args = list("mode", "lines"),
                   label = "Lines"),

              list(method = "restyle",
                   args = list("mode", "lines+markers"),
                   label = "Lines + Markers"),

              list(method = "restyle",
                   args = list("mode", "markers"),
                   label = "Markers")))
        ))
  })

  # Show electric rates table
  output$elecTable <- DT::renderDataTable({

    DT::datatable(
      electric,
      rownames = FALSE,
      extensions = 'Buttons',
      options = list(
        searchHighlight = TRUE,
        order = list(list(3, 'desc')),
        dom = 'Bfrtip',
        buttons = c('copy', 'csv', 'excel', 'pdf', 'print')
      )
    ) %>%
      DT::formatCurrency(c('Revenue', 'Bill'))
  }, server = FALSE)

  # Plot the hydropower map
  output$map1 <- leaflet::renderLeaflet({

    # Get complete cases from hydropower data
    hydropower <- hydropower[complete.cases(hydropower), ]

    # Create the popup content
    content <- paste0(
      "<strong>Name: </strong>",
      hydropower$Name,
      "<br><strong>Company: </strong>",
      hydropower$Company,
      "<br><strong>Waterway: </strong>",
      hydropower$Waterway,
      "<br><strong>Capacity (KW): </strong>",
      hydropower$Capacity
    )

    # Create the color palette
    pal <- leaflet::colorFactor(c("navy", "red"), domain = c("Expired", "Active"))

    # Create the leaflet map
    leaflet::leaflet(hydropower) %>%

      # Manually adjust the bounds of the map
      leaflet::fitBounds(-125, 49,-62, 18) %>%

      # Add provider tiles to the map
      leaflet::addProviderTiles("Esri.WorldStreetMap", group = "World Street Map") %>%
      leaflet::addProviderTiles("CartoDB.DarkMatter", group = "Dark Matter") %>%
      leaflet::addProviderTiles("Esri.WorldImagery", group = "World Imagery") %>%

      # Add circle markers to the map
      leaflet::addCircles(
        radius = ~ sqrt(Capacity / 1000),
        color = ~ pal(Status),
        popup = ~ content
      ) %>%

      # Add a legend to the map
      leaflet::addLegend(
        "topright",
        pal = pal,
        values = ~ Status,
        title = "Status"
      ) %>%

      # Add a control widget to the map
      leaflet::addLayersControl(
        baseGroups = c("World Street Map", "Dark Matter", "World Imagery"),
        position = "bottomright",
        options = leaflet::layersControlOptions(collapsed = TRUE)
      )
  })

  # Plot the hydropower histogram
  output$hist1 <- plotly::renderPlotly({

    # Get the complete cases from hydropower data
    hydropower <- hydropower[complete.cases(hydropower), ]

    # Convert capacity variable
    Capacity <- hydropower$Capacity / 1000

    # Plot the histogram
    plotly::plot_ly(x = ~Capacity,
                    type = "histogram",
                    opacity = 0.75) %>%
      layout(autosize = F,
             width = 300,
             height = 250)
  })

  # Show hydropower data table
  output$hydroTable <- DT::renderDataTable({

    DT::datatable(
      hydropower[, 1:9],
      rownames = FALSE,
      colnames = c('Capacity (KW)' = 'Capacity'),
      extensions = c('Responsive', 'Buttons'),
      options = list(
        searchHighlight = TRUE,
        dom = 'Bfrtip',
        buttons = c('copy', 'csv', 'excel', 'pdf', 'print')
      )
    )
  })

  # Plot the storage map
  output$map2 <- leaflet::renderLeaflet({

    # Get the complete cases from storage data
    storage <- storage[complete.cases(storage), ]

    # Create the popup content
    content <- paste0(
      "<strong>Company: </strong>",
      storage$Company,
      "<br><strong>Field: </strong>",
      storage$Field,
      "<br><strong>Total Capacity (BCF): </strong>",
      storage$Total
    )

    # Create the color palette
    pal <- leaflet::colorFactor(c("navy", "red", "green"),
                           domain = c("Depleted Field", "Salt Dome", "Aquifer"))

    # Plot the leaflet map based on 'Total Capacity' variable
    if (input$storageSize == "Total") {

      leaflet::leaflet(storage) %>%

        # Add provider tiles to the map
        leaflet::addProviderTiles("Esri.WorldStreetMap", group = "World Street Map") %>%
        leaflet::addProviderTiles("CartoDB.DarkMatter", group = "Dark Matter") %>%
        leaflet::addProviderTiles("Esri.WorldImagery", group = "World Imagery") %>%

        # Add circle markers to the map
        leaflet::addCircles(
          radius = ~ Total / 1000,
          color = ~ pal(Type),
          popup = ~ content
        ) %>%

        # Add a control widget to the map
        leaflet::addLayersControl(
          baseGroups = c("World Street Map", "Dark Matter", "World Imagery"),
          position = "bottomright",
          options = leaflet::layersControlOptions(collapsed = TRUE)
        ) %>%

        # Add a legend to the map
        leaflet::addLegend(
          "topright",
          pal = pal,
          values = ~ Type,
          title = "Storage Type"
        )

      # Plot the leaflet map based on 'Working Capacity' variable
    } else if (input$storageSize == "Working") {

      leaflet::leaflet(storage) %>%

        # Add provider tiles to the map
        leaflet::addProviderTiles("Esri.WorldStreetMap", group = "World Street Map") %>%
        leaflet::addProviderTiles("CartoDB.DarkMatter", group = "Dark Matter") %>%
        leaflet::addProviderTiles("Esri.WorldImagery", group = "World Imagery") %>%

        # Add circle markers to the map
        leaflet::addCircles(
          radius = ~ Working / 1000,
          color = ~ pal(Type),
          popup = ~ content
        ) %>%

        # Add a control widget to the map
        leaflet::addLayersControl(
          baseGroups = c("World Street Map", "Dark Matter", "World Imagery"),
          position = "bottomright",
          options = leaflet::layersControlOptions(collapsed = TRUE)
        ) %>%

        # Add a legend to the map
        leaflet::addLegend(
          "topright",
          pal = pal,
          values = ~ Type,
          title = "Storage Type"
        )
    }
  })

  # Plot the storage histogram
  output$hist2 <- plotly::renderPlotly({

    # Get the complete cases from storage data
    storage <- storage[complete.cases(storage), ]

    # Get the selected variable from the user
    if (input$storageSize == "Total") {
      Capacity <- storage$Total / 1000
    } else if (input$storageSize == "Working") {
      Capacity <- storage$Working / 1000
    }

    # Plot the histogram
    plotly::plot_ly(x = ~Capacity,
                    type = "histogram",
                    opacity = 0.75) %>%
      layout(autosize = F,
             width = 300,
             height = 250)
  })

  # Plot the LNG map
  output$map3 <- leaflet::renderLeaflet({

    # Get the complete cases from lng data
    lng <- lng[complete.cases(lng), ]

    # Create the popup content
    content <- paste0(
      "<strong>Company: </strong>",
      lng$Company,
      "<br><strong>Capacity (BCFD): </strong>",
      lng$Capacity
    )

    # Create the leaflet map based on 'type' variable
    if (input$lngColor == "type") {

      # Create the color palette
      pal <- leaflet::colorFactor(c("navy", "red"), domain = c("Export", "Import"))

      leaflet::leaflet(lng) %>%

        # Add provider tiles to the map
        leaflet::addProviderTiles("Esri.WorldStreetMap", group = "World Street Map") %>%
        leaflet::addProviderTiles("CartoDB.DarkMatter", group = "Dark Matter") %>%
        leaflet::addProviderTiles("Esri.WorldImagery", group = "World Imagery") %>%

        # Add circle markers to the map
        leaflet::addCircles(
          radius = ~ Capacity,
          color = ~ pal(Type),
          popup = ~ content
        ) %>%

        # Add a legend to the map
        leaflet::addLegend(
          "topright",
          pal = pal,
          values = ~ Type,
          title = "Facility Type"
        ) %>%

        # Add a control widget to the map
        leaflet::addLayersControl(
          baseGroups = c("World Street Map", "Dark Matter", "World Imagery"),
          position = "bottomright",
          options = leaflet::layersControlOptions(collapsed = TRUE)
        )

      # Create the leaflet map based on 'status' variable
    } else if (input$lngColor == "status") {

      # Create the color palette
      pal <- leaflet::colorFactor(c("navy", "red", "green", "orange"),
          domain = c(
            "Not under construction",
            "Under construction",
            "Existing",
            "Proposed"
          )
        )

      leaflet::leaflet(lng) %>%

        # Add provider tiles to the map
        leaflet::addProviderTiles("Esri.WorldStreetMap", group = "World Street Map") %>%
        leaflet::addProviderTiles("CartoDB.DarkMatter", group = "Dark Matter") %>%
        leaflet::addProviderTiles("Esri.WorldImagery", group = "World Imagery") %>%

        # Add circle markers to the map
        leaflet::addCircles(
          radius = ~ Capacity,
          color = ~ pal(Status),
          popup = ~ content
        ) %>%

        # Add a legend to the map
        leaflet::addLegend(
          "topright",
          pal = pal,
          values = ~ Status,
          title = "Facility Status"
        ) %>%

        # Add a control widget to the map
        leaflet::addLayersControl(
          baseGroups = c("World Street Map", "Dark Matter", "World Imagery"),
          position = "bottomright",
          options = leaflet::layersControlOptions(collapsed = TRUE)
        )
    }
  })

  # Plot the LNG capacity histogram
  output$hist3 <- plotly::renderPlotly({

    # Get the complete cases from lng data
    lng <- lng[complete.cases(lng), ]

    # Get the selected variable from the user
    Capacity <- lng$Capacity

    # Plot the histogram
    plotly::plot_ly(x = ~Capacity,
                    type = "histogram",
                    opacity = 0.75) %>%
      layout(autosize = F,
             width = 300,
             height = 250)
  })

  # Plot the natural gas pipeline histogram
  output$hist5 <- plotly::renderPlotly({

    # Get the selected variable from the user
    if (input$perform == "costMile") {
      Cost <- pipeline[, "Cost"] / pipeline[, "Miles"]
    } else if (input$perform == "costCap") {
      Cost <- pipeline[, "Cost"] / pipeline[, "Capacity"]
    }

    # Plot the histogram
    plotly::plot_ly(
      x = ~Cost,
      type = "histogram",
      opacity = 0.75,
      nbinx = 10
    )
  })

  # Draw a natural gas pipeline heatmap
  output$heatmap <- plotly::renderPlotly({

    # Subset data to get numeric variables
    pipeline <- subset(pipeline, select = c("Cost", "Miles", "Capacity"))

    # Get correlation matrix
    dfcor <- cor(pipeline, use = "complete.obs")

    # Get covariance matrix
    dfvar <- dfcor ^ 2 * 100

    # Get the type of heatmap from the user
    if (input$sensitivity == "varr") {
      df <- dfvar
    } else if (input$sensitivity == "corr") {
      df <- dfcor
    }

    # Plot the heatmap
    plotly::plot_ly(
      x = c("Cost", "Miles", "Capacity"),
      y = c("Cost", "Miles", "Capacity"),
      z = df,
      colorscale = "Greys",
      type = "heatmap"
    )
  })

  # Plot the natural gas cost boxplot
  output$boxplot <- plotly::renderPlotly({

    # Omit missing data
    pipeline <- na.omit(pipeline)

    # Get selected variable from the user
    if (input$gas == "cost") {
      cost <- data.frame(Year = pipeline[, "Year"], Cost = pipeline[, "Cost"])
    } else if (input$gas == "costMile") {
      cost <- data.frame(Year = pipeline[, "Year"], Cost = pipeline[, "Cost"] / pipeline[, "Miles"])
    } else if (input$gas == "costCap") {
      cost <- data.frame(Year = pipeline[, "Year"], Cost = pipeline[, "Cost"] / pipeline[, "Capacity"])
    }

    # Plot the boxplot
    plotly::plot_ly(cost,
                    y = ~Cost,
                    split = ~Year,
                    type = "box")
  })

  # Plot the natural gas rates line chart
  output$lineChart3 <- plotly::renderPlotly({

    # Get the currently selected table rows from the user
    s2 <- input$gasTable_rows_all

    # Subset data based on user selection
    if (length(s2) > 0 && length(s2) < nrow(gas)) {
      gas <- gas[s2, ]
    }

    # Get the selected variable from the user
    if (input$gasRates == "Revenue") {
      Rate <- gas$Revenue
    } else {
      Rate <- gas$Bill
    }

    # Plot the line chart
    plotly::plot_ly(gas,
                    x = ~Year,
                    y = ~Rate,
                    split = ~Company,
                    type = "scatter") %>%

      # Add style options
      layout(
        updatemenus = list(
          list(
            buttons = list(

              list(method = "restyle",
                   args = list("mode", "lines"),
                   label = "Lines"),

              list(method = "restyle",
                   args = list("mode", "lines+markers"),
                   label = "Lines + Markers"),

              list(method = "restyle",
                   args = list("mode", "markers"),
                   label = "Markers")))
        ))

  })

  # Plot the natural gas pipeline motion chart
  output$motion1 <- googleVis::renderGvis({
    googleVis::gvisMotionChart(motionData, idvar = "Type",
                               timevar = "Year")
  })

  # Show natural gas pipeline table
  output$pipelineTable <- DT::renderDataTable({

    pipeline <- pipeline[, !(names(pipeline) %in% 'Year')]

    DT::datatable(
      pipeline[, ],
      rownames = FALSE,
      colnames = c(
        'Cost ($MM)' = 'Cost',
        'Capacity (MMcf/d)' = 'Capacity',
        'Diameter (IN)' = 'Diameter'
      ),
      extensions = c('Responsive', 'Buttons'),
      options = list(
        searchHighlight = TRUE,
        dom = 'Bfrtip',
        buttons = c('copy', 'csv', 'excel', 'pdf', 'print')
      )
    )
  })

  # Show natural gas rates table
  output$gasTable <- DT::renderDataTable({

    DT::datatable(
      gas,
      rownames = FALSE,
      extensions = 'Buttons',
      options = list(
        searchHighlight = TRUE,
        order = list(list(3, 'desc')),
        dom = 'Bfrtip',
        buttons = c('copy', 'csv', 'excel', 'pdf', 'print')
      )
    ) %>%
      DT::formatCurrency(c('Revenue', 'Bill'))
  }, server = FALSE)

  # Plot the oil rates line chart
  output$lineChart4 <- plotly::renderPlotly({

    # Get the currently selected table rows from the user
    s3 <- input$oilTable_rows_all

    # Subset data based on user selection
    if (length(s3) > 0 && length(s3) < nrow(oil)) {
      oil <- oil[s3, ]
    }

    # Get the type of variable from the user
    if (input$oil == "Revenue") {
      Rate <- oil$Revenue
    } else {
      Rate <- oil$Bill
    }

    # Plot the line chart
    plotly::plot_ly(oil,
                    x = ~Year,
                    y = ~Rate,
                    split = ~Company,
                    type = "scatter") %>%

      # Add style options
      layout(
        updatemenus = list(
          list(
            buttons = list(

              list(method = "restyle",
                   args = list("mode", "lines"),
                   label = "Lines"),

              list(method = "restyle",
                   args = list("mode", "lines+markers"),
                   label = "Lines + Markers"),

              list(method = "restyle",
                   args = list("mode", "markers"),
                   label = "Markers")))
        ))
  })

  # Show oil rates table
  output$oilTable <- DT::renderDataTable({

    DT::datatable(
      oil,
      rownames = FALSE,
      extensions = 'Buttons',
      options = list(
        searchHighlight = TRUE,
        order = list(list(3, 'desc')),
        dom = 'Bfrtip',
        buttons = c('copy', 'csv', 'excel', 'pdf', 'print')
      )
    ) %>%
      DT::formatCurrency(c('Revenue', 'Bill'))
  }, server = FALSE)
})
