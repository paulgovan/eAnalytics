# Features
* Profile: take an overview of the industry
* Performance: measure key performance indicators (KPIs)
* Trends: identify changes in the industry over time
* Explorer: discover new relationships in the data

# Overview
eAnalytics is a [Shiny](http://shiny.rstudio.com) web application, powered by the excellent [plotly](https://plot.ly/r/), [Leaflet](https://rstudio.github.io/leaflet/), [DT](https://rstudio.github.io/DT/), and [googleVis](https://cran.r-project.org/web/packages/googleVis/vignettes/googleVis_examples.html) packages. eAnalytics has the largest open database of US energy industry information, providing interactive and dynamic web analytics to industry stakeholders. To learn more about our project, see this [publication](http://ascelibrary.org/doi/abs/10.1061/9780784413012.143).

# Getting Started
To install eAnalytics in [R](https://www.r-project.org):

```S
devtools::install_github('paulgovan/eAnalytics')
```

To launch the app:

```S
eAnalytics()
```

Or to access the app through a browser, visit [paulgovan.shinyapps.io/eAnalytics](https://paulgovan.shinyapps.io/eAnalytics).

# Data
eAnalytics imports the [energyr](https://github.com/paulgovan/energyr) R package, which contains data from [www.ferc.gov](www.ferc.gov). This package contains the following datasets:

* `electric`: Electric Company Financial Data
* `gas`: Natural Gas Company Financial Data
* `hydropower`: Hydropower Plant Data
* `lng`: LNG Plant Data
* `oil`: Oil Company Financial Data
* `pipeline`: Natural Gas Pipeline Project Data
* `storage`: Natural Gas Storage Field Data

# Tutorial

## Dashboard
Launching the app first brings up the *Dashboard*. The *Dashboard* is basically a landing page that gives a brief introduction to the app and also includes three value boxes for the current number of projects, companies, and facilities, respectively, in the database. 

![Dashboard](https://github.com/paulgovan/eAnalytics/blob/master/inst/images/Dashboard2.png?raw=true)

## Profile
The *Profile* tab contains a number of interactive maps with information about facilities for the selected industry. The screenshot below shows the *Profile* tab for the *Natural Gas* industry. 

Multiple options are currently available for customizing the maps. Choose a preferred *size* or *color* variable in the movable `wellPanel`, select from different basemaps via the lower-right corner control, and click on a specific facility to view additional information. 

*Note: industry profiles are currently only available for the Hydropower and Natural Gas industries.*

![Profile](https://github.com/paulgovan/eAnalytics/blob/master/inst/images/Profile2.png?raw=true)

For example, if interested in the LNG facilities that are located along the Gulf Coast, select the *Natural Gas* industry, followed by the *Profile* tab, then the *LNG Facilities* tab, and finally zoom into the area of interest using the controls in the upper-left corner. To view the data overlay with satellite imagery, choose *Satellite* via the lower-right control. 

![Profile2](https://github.com/paulgovan/eAnalytics/blob/master/inst/images/Profile3.png?raw=true)

## Performance
The *Performance* tab tracks a number of "well-established" Key Performance Indicators (KPIs) for the selected industry. 

*Note: KPIs are currently only available for the Natural Gas industry.*

![Performance](https://github.com/paulgovan/eAnalytics/blob/master/inst/images/Performance2.png?raw=true)

For example, the screenshot above shows the *Performance* tab for the *Natural Gas* industry, which shows a histogram of the cost/mile (USD/mile) KPI for all natural gas pipeline projects in the database and a heatmap of the correlation matrix for a number of highly correlated variables. 

## Trends

The *Trends* tab contains multiple interactive time-series charts of financial information for the selected industry. The screenshot below shows the *Trends* tab for the *Electric* industry. 

![Trends](https://github.com/paulgovan/eAnalytics/blob/master/inst/images/Trends2.png?raw=true)

However, the information above is not very useful as of yet because there are currently too many data series plotted. Alternatively, the information in the time-series chart can be controlled through the *Data* tab. 

## Data 
The *Data* tab contains interactive datatables of information for the selected industry. 

Click on the *Data* tab and search, filter, sort the data as required. As an example, make a search for any company with the word "electric" in the name: 

![Data](https://github.com/paulgovan/eAnalytics/blob/master/inst/images/Data2.png?raw=true)

Going back to the *Trends* tab, the time-series chart now shows trends that can actually be understood and compared:

![Trends2](https://github.com/paulgovan/eAnalytics/blob/master/inst/images/Trends3.png?raw=true)

## Explorer
The *Explorer* tab contains a dynamic motion chart for exploring several indicators over time, as made famous by Hans Rosling in his 2007 [TED talk](https://www.ted.com/talks/hans_rosling_reveals_new_insights_on_poverty?language=en).

*Note: the Explorer tab is currently only available for the Natural Gas industry.*

![Explorer2](https://github.com/paulgovan/eAnalytics/blob/master/inst/images/Explorer2.png?raw=true)

As an example, the screenshot above shows a motion chart with cost on the x-axis, miles on the y-axis, and the type of project (conversion, expansion, lateral, new pipeline, and reversal) represented by the color of each bubble. Pressing the *Play* button would show how the relationship between project cost and miles of pipeline changes over time (per type of project). 

To learn more about the functionality of the motion chart, visit the  [googleVis](https://cran.r-project.org/web/packages/googleVis/vignettes/googleVis_examples.html) site.

# Source Code
eAnalytics is an [open source](http://opensource.org) project, and the source code and project data is available at [https://github.com/paulgovan/eAnalytics](https://github.com/paulgovan/eAnalytics)

# Issues
For issues or requests, please use the GitHub issue tracker at [https://github.com/paulgovan/eAnalytics/issues](https://github.com/paulgovan/eAnalytics/issues)

# Contributions
Ccontributions are welcome by sending a [pull request](https://github.com/paulgovan/eAnalytics/pulls)

# License
eAnalytics is licensed under the [Apache](http://www.apache.org/licenses/LICENSE-2.0) licence. &copy; Paul Govan (2015)
