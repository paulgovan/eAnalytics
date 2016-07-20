# Features
* Profile: take an overview of the industry
* Performance: measure key performance indicators (KPIs)
* Trends: identify changes in the industry over time
* Explorer: discover new relationships in the data

# Overview
eAnalytics is a [Shiny](http://shiny.rstudio.com) web application, powered by the excellent [plotly](https://plot.ly/r/), [Leaflet](https://rstudio.github.io/leaflet/), [dygraphs](https://rstudio.github.io/dygraphs/), and [googleVis](https://cran.r-project.org/web/packages/googleVis/vignettes/googleVis_examples.html) packages. eAnalytics has the largest open database of US energy industry information, providing interactive and dynamic web analytics to industry stakeholders. To learn more about our project, see this [publication](http://ascelibrary.org/doi/abs/10.1061/9780784413012.143).

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
eAnalytics imports the [energyr](https://github.com/paulgovan/energyr) package, which contains data from [www.ferc.gov](www.ferc.gov). energyr contains the following datasets:

* `electric`: Electric Company Financial Data
* `gas`: Natural Gas Company Financial Data
* `hydropower`: Hydropower Plant Data
* `lng`: LNG Plant Data
* `oil`: Oil Company Financial Data
* `pipeline`: Natural Gas Pipeline Project Data
* `storage`: Natural Gas Storage Field Data

# Example

## Dashboard
Launching the app brings up the *Dashboard*. The *Dashboard* is basically a landing page that gives a brief introduction to the app and includes three value boxes for the current number of projects, companies, and facilities, respectively, in the database. 

![Dashboard](https://github.com/paulgovan/eAnalytics/blob/master/inst/images/Dashboard2.png?raw=true)

## Profile
Select an industry in the sidepanel and then click *Profile*. The *Profile* tab contains a number of interactive maps with information about facilities for the selected industry. A number of options are currently available for customizing the maps, such as choosing the preferred *size* and *color* variables in the movable `wellpanel`, selecting different basemaps via the lower-right control, or actually clicking on a specific facility to view additional information. 

Note: industry profiles are currently only available for the Hydropower and Natural Gas industries.

![Profile](https://github.com/paulgovan/eAnalytics/blob/master/inst/images/Profile2.png?raw=true)

For example, to view the LNG facilities located along the Gulf Coast, select the *Natural Gas* industry, then the *Profile* tab, then the *LNG Facilities* tab, and then finally zoom into the area of interest using the controls in the upper-left corner. To view the data overlay with satellite imagery, choose *Satellite* via the lower-right control. 

![Profile2](https://github.com/paulgovan/eAnalytics/blob/master/inst/images/Profile3.png?raw=true)

## Performance
Now click the *Performance* tab. The *Performance* tab tracks a number of well-established Key Performance Indicators (KPI's) for the selected industry. Select the preferred KPI using the input controls and interact witht the corresponding charts. 



# Source Code
eAnalytics is an [open source](http://opensource.org) project, and the source code and project data is available at [https://github.com/paulgovan/eAnalytics](https://github.com/paulgovan/eAnalytics)

# Issues
For issues or requests, please use the GitHub issue tracker at [https://github.com/paulgovan/eAnalytics/issues](https://github.com/paulgovan/eAnalytics/issues)

# Contributions
Ccontributions are welcome by sending a [pull request](https://github.com/paulgovan/eAnalytics/pulls)

# License
eAnalytics is licensed under the [Apache](http://www.apache.org/licenses/LICENSE-2.0) licence. &copy; Paul Govan (2015)
