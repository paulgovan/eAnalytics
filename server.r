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
library(rMaps)
library(ggmap)
library(dygraphs)
library(xts)
library(googleVis)
library(DT)

# Get data
electric <- data.frame(read.csv("ElectricRates.csv"))
hydro <- data.frame(read.csv("Hydropower.csv"), na.strings = c("na"))
pipeline <- data.frame(read.csv("PipelineRates.csv"))
oil <- data.frame(read.csv("OilRates.csv"))
storage <- data.frame(read.csv("Storage.csv"), na.strings = c("na"))
pipelineProject <- data.frame(read.csv("PipelineProjects.csv", na.strings = c("na")))
pipeSum <- data.frame(read.csv("PipelineSummary.csv", na.strings = c("na")))
pipeSum2 <- data.frame(read.csv("PipelineSummary3.csv", na.strings = c("na")))
lng <- data.frame(read.csv("LNG.csv"), na.strings = c("na"))

# Calculate the number of unique companies, projects, and facilities in database
company <- length(unique(electric[,1])) + length(unique(hydro[,"Company"])) + length(unique(pipeline[,1])) + length(unique(storage[,"Company"])) + length(unique(lng[,"Company"])) + length(unique(oil[,1]))
project <- length(unique(pipelineProject[,"Name"]))
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
      DT::datatable(electric, rownames = FALSE) %>% 
        formatCurrency(c('Revenue', 'Bill'))
  })
  
  # Plot the hydropower map
  output$map1 <- renderLeaflet({
    content <- as.character(tagList(
      tags$strong(paste(hydro$Name, sep = '')),
      tags$br(),
      tags$p(paste("Company: ", hydro$Company, sep = ''))
    ))    
    leaflet(hydro) %>% addTiles() %>%
      fitBounds(-125, 49, -62, 18) %>%
      addCircleMarkers(radius = ~Capacity/100000, popup = ~Name)
  })
  
  # Plot the hydropower histogram
  output$hist1 <- renderChart2({
    hst <- as.numeric(hydro$Capacity)
    hst <- hist(hst, plot = FALSE)
    hst <- data.frame(mid = hst$mids, counts = hst$counts)
    h2 <- hPlot(counts~mid, 
                data = hst,
                type = "column"
    )
    h2$addParams(dom = 'hist1')
    h2$chart(height = 200, width = 210)
    h2$plotOptions(series = list(name = 'Capacity'), column = list(groupPadding = 0, pointPadding = 0, borderWidth = 0.1))
    h2$xAxis(title = list(text = "Capacity (KW)"))
    h2$yAxis(title = list(text = "Frequency"))
    return(h2)
  })
  
  # Show hydropower data table
  output$hydroTable <- DT::renderDataTable({
    DT::datatable(hydro[,4:10], rownames = FALSE, colnames = c('Capacity (KW)' = 'Capacity'), extensions = 'Responsive') 
  })
  
  # Plot the Storage map
  output$map2 <- renderLeaflet({
    if (input$storageSize == "Total") {
      leaflet(storage) %>% addTiles() %>%
        addCircleMarkers(radius = ~Total/100, popup = ~Field)
    } else if (input$storageSize == "Working") {
      leaflet(storage) %>% addTiles() %>%
        addCircleMarkers(radius = ~Working/100, popup = ~Field)
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
    leaflet(lng) %>% addTiles() %>%
      addCircleMarkers(radius = ~Capacity, popup = ~Company)
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
  
  # Plot the NG projects choropleth
  output$choropleth1 = rCharts::renderChart2({
    if (input$projectCol == "Cost") {
      pipeSum2 <- subset(pipeSum2, select = c('Year', 'State', 'Cost'))
      pipeSum2 <- na.omit(pipeSum2)
      pipeSum2 <- transform(pipeSum2,
                            Year = as.numeric(substr(Year, 1, 4)),
                            State = as.character(State),
                            Var = as.numeric(Cost)
      )
    } else if (input$projectCol == "Miles") {
      pipeSum2 <- subset(pipeSum2, select = c('Year', 'State', 'Miles'))
      pipeSum2 <- na.omit(pipeSum2)
      pipeSum2 <- transform(pipeSum2,
                            Year = as.numeric(substr(Year, 1, 4)),
                            State = as.character(State),
                            Var = as.numeric(Miles)
      )
    } else if (input$projectCol == "Capacity") {
      pipeSum2 <- subset(pipeSum2, select = c('Year', 'State', 'Capacity'))
      pipeSum2 <- na.omit(pipeSum2)
      pipeSum2 <- transform(pipeSum2,
                            Year = as.numeric(substr(Year, 1, 4)),
                            State = as.character(State),
                            Var = as.numeric(Capacity)
      )
    }
    pipeSum2 <- subset(pipeSum2, Year == input$projectYear)
    ichoropleth(
      Var ~ State, 
      data = pipeSum2,
      pal = 'Blues',
      ncuts = 5
    )
  })
  
  # Plot the NG projects histogram
  output$hist4 <- renderChart2({
    pipelineProject <- subset(pipelineProject, select = c("Cost", "Miles", "Capacity"))
    pipelineProject <- transform(pipelineProject, Cost = as.numeric(Cost), Miles = as.numeric(Miles), Capacity = as.numeric(Capacity))
    if (input$projectCol == "Cost") {
      hst <- as.numeric(pipelineProject$Cost)
    } else if (input$projectCol == "Miles") {
      hst <- as.numeric(pipelineProject$Miles)
    } else if (input$projectCol == "Capacity") {
      hst <- as.numeric(pipelineProject$Capacity)
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
    pipelineProject <- subset(pipelineProject, select = c("Cost", "Miles", "Capacity"))
    pipelineProject <- transform(pipelineProject, Cost = as.numeric(Cost), Miles = as.numeric(Miles), Capacity = as.numeric(Capacity))
    if (input$perform == "costMile") {
      hst <- pipelineProject[,"Cost"]/pipelineProject[,"Miles"]
    } else if (input$perform == "costCap") {
      hst <- pipelineProject[,"Cost"]/pipelineProject[,"Capacity"]
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
    pipelineProject <- subset(pipelineProject, select = c("Cost", "Miles", "Capacity"))
    pipelineProject <- transform(pipelineProject, Cost = as.numeric(Cost), Miles = as.numeric(Miles), Capacity = as.numeric(Capacity))
    dfcor <- round(cor(pipelineProject[,"Cost"], pipelineProject[,2:3], use="complete.obs"), digits=2)
    dfvar <- round(dfcor^2*100, digits=1)
    
    if (input$sensitivity == "varr") {
      df <- dfvar
    } else if (input$sensitivity == "corr") {
      df <- dfcor
    }
    
    bar <- data.frame(Variable = c("Miles", "Capacity"), Value = c(df[1], df[2]))
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
    pipelineProject <- subset(pipelineProject, select = c("Year", "Cost", "Miles", "Capacity"))
    pipelineProject <- na.omit(pipelineProject)
    if (input$gas == "cost") {
      cost <- data.frame(Year = pipelineProject[,"Year"], Cost = pipelineProject[,"Cost"])
    } else if (input$gas == "costMile") {
      pipelineProject <- pipelineProject[apply(pipelineProject[,-1], 1, function(x) !all(x==0)),]
      cost <- data.frame(Year = pipelineProject[,"Year"], Cost = pipelineProject[,"Cost"]/pipelineProject[,"Miles"])
    } else if (input$gas == "costCap") {
      pipelineProject <- pipelineProject[apply(pipelineProject[,-1], 1, function(x) !all(x==0)),]
      cost <- data.frame(Year = pipelineProject[,"Year"], Cost = pipelineProject[,"Cost"]/pipelineProject[,"Capacity"])
    }
    cost <- data.frame(aggregate(cost[,"Cost"], list(cost$Year), FUN=function(x) c(quantile(x, probs = c(0.05, 0.95), na.rm = TRUE), median(x))))
    cost <- do.call(data.frame, cost)
    colnames(cost) <- c("Year", "lwr", "upr", "med")
    cost[,"Year"] <- as.Date(cost[,"Year"], format = "%d/%m/%Y")
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
                data = pipeline,
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
  
  # Show natural gas projects table
  output$projectTable <- DT::renderDataTable({
    pipelineProject <- pipelineProject[,!(names(pipelineProject) %in% 'Year')]
    DT::datatable(pipelineProject, rownames = FALSE, colnames = c('Cost ($MM)' = 'Cost', 'Capacity (MMcf/d)' = 'Capacity', 'Diameter (IN)' = 'Diameter'), extensions = 'Responsive') 
  })
  
  # Show natural gas rates table
  output$gasTable <- DT::renderDataTable({
    DT::datatable(pipeline, rownames = FALSE) %>% 
      formatCurrency(c('Revenue', 'Bill'))
  })
  
  # Plot the natural gas project motion chart
  output$motion1 <- renderGvis({
    pipeSum[,"Year"] <- as.Date(pipeSum[,"Year"], format = "%d/%m/%y")
    gvisMotionChart(pipeSum, idvar="Type", 
                    timevar="Year",
                    options=list(width=1000, height=500
                    ))
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