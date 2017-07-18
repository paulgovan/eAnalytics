![](http://www.r-pkg.org/badges/version/eAnalytics)
![](http://cranlogs.r-pkg.org/badges/grand-total/eAnalytics)
![](https://travis-ci.org/paulgovan/eAnalytics.svg?branch=master)
[![Rdoc](http://www.rdocumentation.org/badges/version/eAnalytics)](http://www.rdocumentation.org/packages/eAnalytics) 
[![DOI](https://zenodo.org/badge/35055898.svg)](https://zenodo.org/badge/latestdoi/35055898)

# Features
* Profile: take an overview of the industry
* Performance: measure key performance indicators (KPIs)
* Trends: identify changes in the industry over time
* Explorer: discover new relationships in the data

# Overview
eAnalytics is a [Shiny](http://shiny.rstudio.com) web application built on top of [R](https://www.r-project.org) for energy analytics. The app is powered by the excellent [plotly](https://plot.ly/r/), [Leaflet](https://rstudio.github.io/leaflet/), [DT](https://rstudio.github.io/DT/), and [googleVis](https://CRAN.R-project.org/package=googleVis) packages. To learn more about our project, check out [doi.org/10.5334/jors.144](http://doi.org/10.5334/jors.144).

# Getting Started
To install eAnalytics in R:

```S
install.packages("eAnalytics")
```

Or to install the latest developmental version:

```S
devtools::install_github('paulgovan/eAnalytics')
```

To launch the app:

```S
eAnalytics::eAnalytics()
```

Or to access the app through a browser, visit [paulgovan.shinyapps.io/eAnalytics](https://paulgovan.shinyapps.io/eAnalytics/).

# Data
eAnalytics is built around the [energyr](https://github.com/paulgovan/energyr) R package of data published by the United States Federal Energy Regulatory Commission [www.ferc.gov](www.ferc.gov). energyr contains several datasets for different industry segments:

* `electric`: Electric Company Financial Data
* `gas`: Natural Gas Company Financial Data
* `hydropower`: Hydropower Plant Data
* `lng`: LNG Plant Data
* `oil`: Oil Company Financial Data
* `pipeline`: Natural Gas Pipeline Project Data
* `storage`: Natural Gas Storage Field Data

# Tutorial

## Home
Launching the app first brings up the Home tab, which is basically a landing page that gives a brief introduction to the app and includes three value boxes for the current number of projects, companies, and facilities in the database. 

![Home](https://github.com/paulgovan/eAnalytics/blob/master/inst/images/Dashboard.png?raw=true)

## Profile
The Profile tab contains a number of interactive maps with information about facilities for the selected industry. The figure below shows the Profile tab for the Natural Gas Industry.

Multiple options are currently available for customizing the maps. Choose a preferred size or color variable in the movable well panel, select from different basemaps via the lower-right control, and click on a specific facility to view additional information.

![Profile](https://github.com/paulgovan/eAnalytics/blob/master/inst/images/Profile2.png?raw=true)

## Performance
The Performance tab tracks a number of Key Performance Indicators (KPIs) for the selected industry. The following figure shows the Performance tab for the Natural Gas Industry.

![Performance](https://github.com/paulgovan/eAnalytics/blob/master/inst/images/Performance2.png?raw=true) 

## Trends

The Trends tab contains multiple interactive time-series charts of financial information for the selected industry. The following figure shows the Performance tab for the Electric industry.

The time-series chart in the Trends tab is linked to the data table shown in the Data tab. Searching, filtering, and sorting the data in the data table will automatically update the time-series chart with the selected data.

![Trends](https://github.com/paulgovan/eAnalytics/blob/master/inst/images/Trends2.png?raw=true)

## Data 
The Data tab contains interactive datatables of information for the selected industry. The data can be searched, filtered, and sorted as required. The selected data can then be copied to the clipboard, downloaded to a csv or pdf file, or sent to a local printer. The figure below shows the Data tab for the Hydropower industry.

![Data](https://github.com/paulgovan/eAnalytics/blob/master/inst/images/Data.png?raw=true)

## Explorer
The Explorer tab contains a dynamic motion chart for exploring several indicators over time. The following figure shows the Explorer tab for the Natural Gas Industry.

![Explorer2](https://github.com/paulgovan/eAnalytics/blob/master/inst/images/Explorer2.png?raw=true)

# Source Code
eAnalytics is an [open source](http://opensource.org) project, and the source code and project data is available at [https://github.com/paulgovan/eAnalytics](https://github.com/paulgovan/eAnalytics)

# Issues
For issues or requests, please use the GitHub issue tracker at [https://github.com/paulgovan/eAnalytics/issues](https://github.com/paulgovan/eAnalytics/issues)

# Contributions
Ccontributions are welcome by sending a [pull request](https://github.com/paulgovan/eAnalytics/pulls)

# License
eAnalytics is licensed under the [Apache](http://www.apache.org/licenses/LICENSE-2.0) licence. &copy; Paul Govan (2015)
