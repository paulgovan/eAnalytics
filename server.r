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
library(plotly)
library(dplyr)
library(leaflet)
library(dygraphs)
library(xts)
library(googleVis)
library(DT)
library(devtools)

# Get data
electric <- data.frame(read.csv("data/ElectricRates.csv", na.strings = c("na")), stringsAsFactors = FALSE)
hydro <- data.frame(read.csv("data/Hydropower.csv", na.strings = c("na")), stringsAsFactors = FALSE)
gas <- data.frame(read.csv("data/PipelineRates.csv", na.strings = c("na")), stringsAsFactors = FALSE)
oil <- data.frame(read.csv("data/OilRates.csv", na.strings = c("na")), stringsAsFactors = FALSE)
storage <- data.frame(read.csv("data/Storage.csv", na.strings = c("na")), stringsAsFactors = FALSE)
pipeline <- data.frame(read.csv("data/PipelineProjects.csv", na.strings = c("na")), stringsAsFactors = FALSE)
motionData <- data.frame(read.csv("data/motionData.csv", na.strings = c("na")), stringsAsFactors = FALSE)
choroData <- data.frame(read.csv("data/choroData.csv", na.strings = c("na")), stringsAsFactors = FALSE)
lng <- data.frame(read.csv("data/LNG.csv", na.strings = c("na")), stringsAsFactors = FALSE)

# Calculate the number of unique companies, projects, and facilities in database
company <- length(unique(electric[,1])) + length(unique(hydro[,"Company"])) + length(unique(gas[,1])) + length(unique(storage[,"Company"])) + length(unique(lng[,"Company"])) + length(unique(oil[,1]))
project <- length(unique(pipeline[,"Name"]))
facility <- length(unique(hydro[,"Name"])) + length(unique(storage[,"Field"])) + length(unique(lng[,"Company"]))

# Define required server logic
shinyServer(function(input, output, session) {
  
  # Create the projects box
  output$projectBox <- renderUI({
    valueBox(project, "Projects in Database", icon = icon("database"), color = "green")
  })
  
  # Create the companies box
  output$companyBox <- renderUI({
    valueBox(company, "Company Profiles", icon = icon("users"), color = "purple")
  })
  
  # Create the facilities box
  output$facilityBox <- renderUI({
    valueBox(facility, "Facility Profiles", icon = icon("building"), color = "yellow")
  })
  
  # Plot the electric rates line chart
  output$lineChart1 <- renderPlotly({
    if (input$elec == "Revenue") {
      Rate <- electric$Revenue
    } else {
      Rate <- electric$Bill
    }
    p1 <- plot_ly(electric, x = Year, y = Rate, group = Company)
    p1
  })
  
  # Show electric rates table
  output$elecTable <- DT::renderDataTable({
      DT::datatable(electric, rownames = FALSE, options = list(
        autoWidth = TRUE, searchHighlight = TRUE)) %>% 
        formatCurrency(c('Revenue', 'Bill'))
  })
  
  # Plot the hydropower map
  output$map1 <- renderLeaflet({
    content <- paste0("<strong>Name: </strong>",
                      hydro$Name,
                      "<br><strong>Company: </strong>",
                      hydro$Company,
                      "<br><strong>Waterway: </strong>",
                      hydro$Waterway,
                      "<br><strong>Capacity (KW): </strong>",
                      hydro$Capacity)
    pal <- colorFactor(c("navy", "red"), domain = c("Expired", "Active"))
    leaflet(hydro) %>% 
      fitBounds(-125, 49, -62, 18) %>%
      addProviderTiles("Esri.WorldStreetMap", group = "WSM") %>%
      addProviderTiles("CartoDB.DarkMatter", group = "Dark") %>%
      addProviderTiles("Esri.WorldImagery", group = "Satellite") %>%
      addCircles(radius = ~sqrt(Capacity/10000), color = ~pal(Status), popup = ~content) %>%
      addLegend("topright", pal = pal, values = ~Status, title = "Status") %>%
      addLayersControl(baseGroups = c("WSM", "Dark", "Satellite"), 
                       position = "bottomright", 
                       options = layersControlOptions(collapsed = TRUE))
  })
  
#   # Plot the hydropower histogram
#   output$hist1 <- renderPlotly({
#     Capacity <- hydro$Capacity
#     p2 <- plot_ly(x = Capacity, type = "histogram", height = 100)
#     p2
#   })
  
  # Show hydropower data table
  output$hydroTable <- DT::renderDataTable({
    DT::datatable(hydro[,4:9], rownames = FALSE, colnames = c('Capacity (KW)' = 'Capacity'), extensions = 'Responsive') 
  })
  
  # Plot the Storage map
  output$map2 <- renderLeaflet({
    content <- paste0("<strong>Company: </strong>",
                      storage$Company,
                      "<br><strong>Field: </strong>",
                      storage$Field,
                      "<br><strong>Total Capacity (BCF): </strong>",
                      storage$Total)
    pal <- colorFactor(c("navy", "red", "green"), domain = c("DGF", "SC", "Aquifer"))
    if (input$storageSize == "Total") {
      leaflet(storage) %>% 
        addProviderTiles("Esri.WorldStreetMap", group = "WSM") %>%
        addProviderTiles("CartoDB.DarkMatter", group = "Dark") %>%
        addProviderTiles("Esri.WorldImagery", group = "Satellite") %>%
        addCircles(radius = ~Total/100, color = ~pal(Type), popup = ~content) %>%
        addLegend("topright", pal = pal, values = ~Type, title = "Storage Type") %>%
        addLayersControl(baseGroups = c("WSM", "Dark", "Satellite"), 
                         position = "bottomright", 
                         options = layersControlOptions(collapsed = TRUE))
    } else if (input$storageSize == "Working") {
      leaflet(storage) %>% 
        addProviderTiles("Esri.WorldStreetMap", group = "WSM") %>%
        addProviderTiles("CartoDB.DarkMatter", group = "Dark") %>%
        addProviderTiles("Esri.WorldImagery", group = "Satellite") %>%
        addCircles(radius = ~Working/100, color = ~pal(Type), popup = ~content) %>%
        addLegend("topright", pal = pal, values = ~Type, title = "Storage Type") %>%
        addLayersControl(baseGroups = c("WSM", "Dark", "Satellite"), 
                         position = "bottomright", 
                         options = layersControlOptions(collapsed = TRUE))
    }
  })
  
  # Plot the storage histogram
  output$hist2 <- renderPlotly({
    if (input$storageSize == "Total") {
      Capacity <- storage$Total
    } else if (input$storageSize == "Working") {
      Capacity <- storage$Working
    }
    p3 <- plot_ly(x = Capacity, type = "histogram", height = 100)
    p3
  })
    
  
  # Plot the LNG map
  output$map3 <- renderLeaflet({
    content <- paste0("<strong>Company: </strong>",
                      lng$Company,
                      "<br><strong>Capacity (BCFD): </strong>",
                      lng$Capacity)
    if (input$lngColor == "type") {
    pal <- colorFactor(c("navy", "red"), domain = c("Export", "Import"))
    leaflet(lng) %>% 
      addProviderTiles("Esri.WorldStreetMap", group = "WSM") %>%
      addProviderTiles("CartoDB.DarkMatter", group = "Dark") %>%
      addProviderTiles("Esri.WorldImagery", group = "Satellite") %>%
      addCircles(radius = ~Capacity, color = ~pal(Type), popup = ~content) %>%
      addLegend("topright", pal = pal, values = ~Type, title = "Facility Type") %>%
      addLayersControl(baseGroups = c("WSM", "Dark", "Satellite"), 
                       position = "bottomright", 
                       options = layersControlOptions(collapsed = TRUE))
    } else if (input$lngColor == "status") {
      pal <- colorFactor(c("navy", "red", "green", "orange"), domain = c("Not under construction", "Under construction", "Existing", "Proposed"))
      leaflet(lng) %>% 
        addProviderTiles("Esri.WorldStreetMap", group = "WSM") %>%
        addProviderTiles("CartoDB.DarkMatter", group = "Dark") %>%
        addProviderTiles("Esri.WorldImagery", group = "Satellite") %>%
        addCircles(radius = ~Capacity, color = ~pal(Status), popup = ~content) %>%
        addLegend("topright", pal = pal, values = ~Status, title = "Facility Status") %>%
        addLayersControl(baseGroups = c("WSM", "Dark", "Satellite"), 
                         position = "bottomright", 
                         options = layersControlOptions(collapsed = TRUE))
    }
  })
  
  # Plot the LNG capacity histogram
  output$hist3 <- renderPlotly({
    Capacity <- lng$Capacity
    p4 <- plot_ly(x = Capacity, type = "histogram", height = 100)
    p4
  })
  
  # Plot the NG projects histogram
  output$hist5 <- renderPlotly({
    pipeline <- subset(pipeline, select = c("Cost", "Miles", "Capacity", "Compression"))
    if (input$perform == "costMile") {
      Performance <- pipeline[,"Cost"]/pipeline[,"Miles"]
    } else if (input$perform == "costCap") {
      Performance <- pipeline[,"Cost"]/pipeline[,"Capacity"]
    } else if (input$perform == "costHP") {
      Performance <- pipeline[,"Cost"]/pipeline[,"Compression"]
    }
    p5 <- plot_ly(x = Performance, type = "histogram")
    p5
  })
  
  # Draw a natural gas sensitivity bar chart
  output$barChart1 <- renderPlotly({
    pipeline <- subset(pipeline, select = c("Cost", "Miles", "Capacity", "Compression"))
    dfcor <- round(cor(pipeline[,"Cost"], pipeline[,2:4], use="complete.obs"), digits=2)
    dfvar <- round(dfcor^2*100, digits=1)
    
    if (input$sensitivity == "varr") {
      df <- dfvar
    } else if (input$sensitivity == "corr") {
      df <- dfcor
    }
    
    bar <- data.frame(Indicator = c("Miles", "Compression", "Capacity"), Value = c(df[1], df[3], df[2]))
    p6 <- plot_ly(bar, x = Value, y = Indicator, type = "bar", color = Indicator, orientation = 'h')
    p6
  })
  
  # Plot the natural gas cost line chart
  output$lineChart2 <- renderDygraph({
    pipeline <- subset(pipeline, select = c("Year", "Cost", "Miles", "Capacity"))
    pipeline <- na.omit(pipeline)
    if (input$gas == "cost") {
      cost <- data.frame(Year = pipeline[,"Year"], Cost = pipeline[,"Cost"])
    } else if (input$gas == "costMile") {
      pipeline <- pipeline[apply(pipeline[,-1], 1, function(x) !all(x==0)),]
      cost <- data.frame(Year = pipeline[,"Year"], Cost = pipeline[,"Cost"]/pipeline[,"Miles"])
    } else if (input$gas == "costCap") {
      pipeline <- pipeline[apply(pipeline[,-1], 1, function(x) !all(x==0)),]
      cost <- data.frame(Year = pipeline[,"Year"], Cost = pipeline[,"Cost"]/pipeline[,"Capacity"])
    }
    cost <- data.frame(aggregate(cost[,"Cost"], list(cost$Year), FUN=function(x) c(quantile(x, probs = c(0.05, 0.95), na.rm = TRUE), median(x))))
    cost <- do.call(data.frame, cost)
    colnames(cost) <- c("Year", "lwr", "upr", "med")
    cost[,"Year"] <- as.Date(cost[,"Year"], format = "%d/%m/%Y")
    cost <- na.omit(cost)
    cost <- cbind(xts(cost$lwr, cost$Year), cost$med, cost$upr)
    colnames(cost) <- c("lwr", "med", "upr")
    dygraph(cost) %>%
      dySeries(c("lwr", "med", "upr"), label = "Median") %>%
      dyAxis("x", label = "Year") %>%
      dyAxis("y", label = "Project Cost ($MM)") %>%
      dyShading(from = "2015-01-01", to = "2020-01-01") %>%
      dyEvent(date = "2015-01-01", "Forecasted", labelLoc = "bottom") %>%
      dyRangeSelector()
  })
  
  # Plot the natural gas rates line chart
  output$lineChart3 <- renderPlotly({
    if (input$gasRates == "Revenue") {
      Rate <- gas$Revenue
    } else {
      Rate <- gas$Bill
    }
    p5 <- plot_ly(gas, x = Year, y = Rate, group = Company)
    p5
  })
  
  # Plot the natural gas project motion chart
  output$motion1 <- renderGvis({
    gvisMotionChart(motionData, idvar="Type", 
                    timevar="Year",
                    options=list(width=1000, height=500
                    ))
  })
  
  # Show natural gas projects table
  output$projectTable <- DT::renderDataTable({
    pipeline <- pipeline[,!(names(pipeline) %in% 'Year')]
    DT::datatable(pipeline, rownames = FALSE, colnames = c('Cost ($MM)' = 'Cost', 'Capacity (MMcf/d)' = 'Capacity', 'Diameter (IN)' = 'Diameter'), extensions = 'Responsive') 
  })
  
  # Show natural gas rates table
  output$gasTable <- DT::renderDataTable({
    DT::datatable(gas, rownames = FALSE) %>% 
      formatCurrency(c('Revenue', 'Bill'))
  })
  
  # Plot the oil rates line chart
  output$lineChart4 <- renderPlotly({
    if (input$oil == "Revenue") {
      Rate <- oil$Revenue
    } else {
      Rate <- oil$Bill
    }
    p6 <- plot_ly(oil, x = Year, y = Rate, group = Company)
    p6
  })
  
  # Show oil rates table
  output$oilTable <- DT::renderDataTable({
    DT::datatable(oil, rownames = FALSE) %>% 
      formatCurrency(c('Revenue', 'Bill'))
  })
})