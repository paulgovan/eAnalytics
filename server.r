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

library(rCharts)
library(leaflet)
library(ggmap)
library(dygraphs)
library(xts)
library(googleVis)
library(DT)
library(energyr)

# Get data
electric <- electric
hydro <- hydropower
gas <- gas
oil <- oil
storage <- storage
pipeline <- pipeline
motionData <- data.frame(read.csv("motionData.csv", na.strings = c("na")), stringsAsFactors = FALSE)
choroData <- data.frame(read.csv("choroData.csv", na.strings = c("na")), stringsAsFactors = FALSE)
lng <- lng

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
  output$lineChart1 <- renderChart({
    h1 <- hPlot("Year", input$elec, 
                data = electric,
                type = "line",
                group = "Company"
    )
    h1$addParams(dom = 'lineChart1')
    h1$xAxis(type = "date")
    h1$yAxis(min = 0)
    h1$legend(layout = "vertical", align = "right", verticalAlign = "middle", borderWidth = 0)
    h1$plotOptions(
      line = list(
        marker = list(enabled = F)
      )
    )
    return(h1)
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
                      "<br><strong>Capacity (MW): </strong>",
                      hydro$Capacity/1000)
    pal <- colorFactor(c("navy", "red"), domain = c("Expired", "Active"))
    leaflet(hydro) %>% addTiles() %>%
      fitBounds(-125, 49, -62, 18) %>%
      addCircleMarkers(radius = ~sqrt(Capacity/100000), color = ~pal(Status), popup = ~content) %>%
      addLegend("topright", pal = pal, values = ~Status,
                title = "Status"
      ) 
    })
  
  # Plot the hydropower histogram
  output$hist1 <- renderChart({
    hst <- as.numeric(hydro$Capacity/1000)
    hst <- hist(hst, breaks = 5, plot = FALSE)
    hst <- data.frame(mid = hst$mids, counts = hst$counts)
    h2 <- hPlot(counts~mid, 
                data = hst,
                type = "column"
    )
    h2$addParams(dom = 'hist11')
    h2$chart(height = 200, width = 210)
    h2$plotOptions(series = list(name = 'Capacity'), column = list(groupPadding = 0, pointPadding = 0, borderWidth = 0.1))
    h2$xAxis(title = list(text = "Capacity (MW)"))
    h2$yAxis(title = list(text = "Frequency"))
    return(h2)
  })
  
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
      leaflet(storage) %>% addTiles() %>%
        addCircleMarkers(radius = ~Total/100, color = ~pal(Type), popup = ~content) %>%
        addLegend("topright", pal = pal, values = ~Type,
                  title = "Storage Type"
        )
    } else if (input$storageSize == "Working") {
      leaflet(storage) %>% addTiles() %>%
        addCircleMarkers(radius = ~Working/100, color = ~pal(Type), popup = ~content) %>%
        addLegend("topright", pal = pal, values = ~Type,
                  title = "Storage Type"
        )
    }
  })
  
  # Plot the storage histogram
  output$hist2 <- renderChart({
    if (input$storageSize == "Total") {
      hst <- as.numeric(storage$Total)
    } else if (input$storageSize == "Working") {
      hst <- as.numeric(storage$Working)
    }
    hst <- hist(hst, plot = FALSE)
    hst <- data.frame(mid = hst$mids, counts = hst$counts)
    h3 <- hPlot(counts~mid, 
                data = hst,
                type = "column"
    )
    h3$addParams(dom = 'hist2')
    h3$chart(height = 200, width = 210)
    h3$plotOptions(series = list(name = 'Capacity'), column = list(groupPadding = 0, pointPadding = 0, borderWidth = 0.1))
    h3$xAxis(title = list(text = "Capacity (BCF)"))
    h3$yAxis(title = list(text = "Frequency"))
    return(h3)
  })
  
  # Plot the LNG map
  output$map3 <- renderLeaflet({
    content <- paste0("<strong>Company: </strong>",
                      lng$Company,
                      "<br><strong>Capacity (BCFD): </strong>",
                      lng$Capacity)
    if (input$lngColor == "type") {
    pal <- colorFactor(c("navy", "red"), domain = c("Export", "Import"))
    leaflet(lng) %>% addTiles() %>%
      addCircleMarkers(radius = ~Capacity, color = ~pal(Type), popup = ~content) %>%
      addLegend("topright", pal = pal, values = ~Type,
                title = "Facility Type",
      )
    } else if (input$lngColor == "status") {
      pal <- colorFactor(c("navy", "red", "green", "orange"), domain = c("Not under construction", "Under construction", "Existing", "Proposed"))
      leaflet(lng) %>% addTiles() %>%
        addCircleMarkers(radius = ~Capacity, color = ~pal(Status), popup = ~content) %>%
        addLegend("topright", pal = pal, values = ~Status,
                  title = "Facility Status",
        )
    }
  })
  
  # Plot the LNG capacity histogram
  output$hist3 <- renderChart({
    hst <- as.numeric(lng$Capacity)
    hst <- hist(hst, plot = FALSE)
    hst <- data.frame(mid = hst$mids, counts = hst$counts)
    h4 <- hPlot(counts~mid, 
                data = hst,
                type = "column"
    )
    h4$addParams(dom = 'hist3')
    h4$chart(height = 200, width = 210)
    h4$plotOptions(series = list(name = 'Capacity'), column = list(groupPadding = 0, pointPadding = 0, borderWidth = 0.1))
    h4$xAxis(title = list(text = "Capacity (BCFD)"))
    h4$yAxis(title = list(text = "Frequency"))
    return(h4)
  })
  
  # Plot the NG projects choropleth. Note: not currently compatable with rCharts
  choroDat <- reactive({
    if (input$projectCol == "Cost") {
      choroDat <- subset(choroData, select = c('Year', 'State', 'Cost'))
      choroDat <- na.omit(choroDat)
      choroDat <- transform(choroDat,
                            Year = as.numeric(substr(Year, 1, 4)),
                            State = as.character(State),
                            Var = as.numeric(Cost)
      )
    } else if (input$projectCol == "Miles") {
      choroDat <- subset(choroData, select = c('Year', 'State', 'Miles'))
      choroDat <- na.omit(choroDat)
      choroDat <- transform(choroDat,
                            Year = as.numeric(substr(Year, 1, 4)),
                            State = as.character(State),
                            Var = as.numeric(Miles)
      )
    } else if (input$projectCol == "Capacity") {
      choroDat <- subset(choroData, select = c('Year', 'State', 'Capacity'))
      choroDat <- na.omit(choroDat)
      choroDat <- transform(choroDat,
                            Year = as.numeric(substr(Year, 1, 4)),
                            State = as.character(State),
                            Var = as.numeric(Capacity)
      )
    }

  })
  
  output$choropleth1 = rCharts::renderChart2({
    choropleth(cut(Var, 5, labels = F) ~ State,
                data = subset(choroDat(), Year == input$projectYear),
                pal = 'Blues',
               legend = T
    )
  })
  
  # Plot the NG projects histogram
  output$hist4 <- renderChart({
    pipeline <- subset(pipeline, select = c("Cost", "Miles", "Capacity"))
    if (input$projectCol == "Cost") {
      hst <- as.numeric(pipeline$Cost)
    } else if (input$projectCol == "Miles") {
      hst <- as.numeric(pipeline$Miles)
    } else if (input$projectCol == "Capacity") {
      hst <- as.numeric(pipeline$Capacity)
    }
    hst <- hist(hst, plot = FALSE)
    hst <- data.frame(mid = hst$mids, counts = hst$counts)
    h5 <- hPlot(counts~mid, 
                data = hst,
                type = "column"
    )
    h5$addParams(dom = 'hist4')
    h5$chart(height = 200, width = 210)
    h5$plotOptions(series = list(name = 'Projects'), column = list(groupPadding = 0, pointPadding = 0, borderWidth = 0.1))
    h5$xAxis(title = list(text = ""))
    h5$yAxis(title = list(text = "Frequency"))
    return(h5)
  })
  
  # Plot the natural gas performance histogram
  output$hist5 <- renderChart({
    pipeline <- subset(pipeline, select = c("Cost", "Miles", "Capacity", "Compression"))
    if (input$perform == "costMile") {
      hst <- pipeline[,"Cost"]/pipeline[,"Miles"]
    } else if (input$perform == "costCap") {
      hst <- pipeline[,"Cost"]/pipeline[,"Capacity"]
    } else if (input$perform == "costHP") {
      hst <- pipeline[,"Cost"]/pipeline[,"Compression"]
    }
    hst <- hist(hst, plot = FALSE)
    hst <- data.frame(mid = hst$mids, counts = hst$counts)
    h6 <- hPlot(counts~mid, 
                data = hst,
                type = "column"
    )
    h6$addParams(dom = 'hist5')
    h6$chart(height = 450, width = 450)
    h6$plotOptions(series = list(name = 'Performance'), column = list(groupPadding = 0, pointPadding = 0, borderWidth = 0.1))
    h6$xAxis(title = list(text = "Project Performance Indicator"))
    h6$yAxis(title = list(text = "Frequency"))
    return(h6)
  })
  
  # Draw a natural gas sensitivity bar chart
  output$barChart1 <- renderChart({
    pipeline <- subset(pipeline, select = c("Cost", "Miles", "Capacity", "Compression"))
    dfcor <- round(cor(pipeline[,"Cost"], pipeline[,2:4], use="complete.obs"), digits=2)
    dfvar <- round(dfcor^2*100, digits=1)
    
    if (input$sensitivity == "varr") {
      df <- dfvar
    } else if (input$sensitivity == "corr") {
      df <- dfcor
    }
    
    bar <- data.frame(Variable = c("Miles", "Compression", "Capacity"), Value = c(df[1], df[3], df[2]))
    h7 <- hPlot(Value ~ Variable, 
                data = bar,
                type = "bar"
    )
    h7$addParams(dom = 'barChart1')
    h7$chart(height = 450, width = 450)
    h7$plotOptions(series = list(name = 'Sensitivity', color = '#aaff99'))
    h7$yAxis(title = list(text = "Project Cost Sensitivity"))
    return(h7)
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
  output$lineChart3 <- renderChart({
    h8 <- hPlot("Year", input$gasRates, 
                data = gas,
                type = "line",
                group = "Company"
    )
    h8$addParams(dom = 'lineChart3')
    h8$xAxis(type = "date")
    h8$yAxis(min = 0)
    h8$legend(layout = "vertical", align = "right", verticalAlign = "middle", borderWidth = 0)
    h8$plotOptions(
      line = list(
        marker = list(enabled = F)
      )
    )
    return(h8)
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
  output$lineChart4 <- renderChart({
    h9 <- hPlot("Year", input$oil, 
                data = oil,
                type = "line",
                group = "Company"
    )
    h9$addParams(dom = 'lineChart4')
    h9$xAxis(type = "date")
    h9$yAxis(min = 0)
    h9$legend(layout = "vertical", align = "right", verticalAlign = "middle", borderWidth = 0)
    h9$plotOptions(
      line = list(
        marker = list(enabled = F)
      )
    )
    return(h9)
  })
  
  # Show oil rates table
  output$oilTable <- DT::renderDataTable({
    DT::datatable(oil, rownames = FALSE) %>% 
      formatCurrency(c('Revenue', 'Bill'))
  })
})