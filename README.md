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
eAnalytics imports the [energyr](https://github.com/paulgovan/energyr) R package, which contains data from [www.ferc.gov](www.ferc.gov). energyr contains the following datasets:

* `electric`: Electric Company Financial Data
* `gas`: Natural Gas Company Financial Data
* `hydropower`: Hydropower Plant Data
* `lng`: LNG Plant Data
* `oil`: Oil Company Financial Data
* `pipeline`: Natural Gas Pipeline Project Data
* `storage`: Natural Gas Storage Field Data

# Example

## Dashboard
Launching the app first brings up the *Dashboard*. The *Dashboard* is basically a landing page that gives a brief introduction to the app and also includes three value boxes for the current number of projects, companies, and facilities, respectively, in the database. 

![Dashboard](https://github.com/paulgovan/eAnalytics/blob/master/inst/images/Dashboard2.png?raw=true)

## Profile
Select an industry in the sidepanel and then click *Profile*. The *Profile* tab contains a number of interactive maps with information about facilities for the selected industry. The screenshot below shows the *Profile* tab for the *Natural Gas* industry. 

Several options are currently available for customizing the maps. Choose a preferred *size* or *color* variable in the movable `wellPanel`, select different basemaps via the lower-right corner control, or actually click on a specific facility to view additional information. 

*Note: industry profiles are currently only available for the Hydropower and Natural Gas industries.*

![Profile](https://github.com/paulgovan/eAnalytics/blob/master/inst/images/Profile2.png?raw=true)

For example, to view the LNG facilities located along the Gulf Coast, select the *Natural Gas* industry, then the *Profile* tab, then the *LNG Facilities* tab, and then finally zoom into the area of interest using the controls in the upper-left corner. To view the data overlay with satellite imagery, choose *Satellite* via the lower-right control. 

![Profile2](https://github.com/paulgovan/eAnalytics/blob/master/inst/images/Profile3.png?raw=true)

## Performance
Now click the *Performance* tab. The *Performance* tab tracks a number of "well-established" Key Performance Indicators (KPIs) for the selected industry. 

*Note: KPIs are currently only available for the Natural Gas industry.*

![Performance](https://github.com/paulgovan/eAnalytics/blob/master/inst/images/Performance2.png?raw=true)

For example, the screenshot above shows the *Performance* tab for the *Natural Gas* industry, which includes a histogram of the cost/mile (USD/mile) for all natural gas pipeline projects in the database and a heatmap of the correlation matrix of cost with other highly related variables. 

## Trends

Next click the *Trends* tab. The *Trends* tab contains interactive time-series charts of financial information for the selected industry. The screenshot below shows the *Trends* tab for the *Electric* industry. 

![Trends](https://github.com/paulgovan/eAnalytics/blob/master/inst/images/Trends2.png?raw=true)

However, the information above is not very useful as of yet because there are so many data series plotted in the chart. Alternatively, the time-series chart can be controlled through the *Data* tab. Click on the *Data* tab and search, filter, sort the data as preferred. As an example, let the search be for any company with the word "Electric" in the name: 

![Data](https://github.com/paulgovan/eAnalytics/blob/master/inst/images/Data2.png?raw=true)

Now going back to the *Trends* tab, the time-series chart shows trends that can actually be understood and compared:

![Trends2](https://github.com/paulgovan/eAnalytics/blob/master/inst/images/Trends3.png?raw=true)

# Source Code
eAnalytics is an [open source](http://opensource.org) project, and the source code and project data is available at [https://github.com/paulgovan/eAnalytics](https://github.com/paulgovan/eAnalytics)

# Issues
For issues or requests, please use the GitHub issue tracker at [https://github.com/paulgovan/eAnalytics/issues](https://github.com/paulgovan/eAnalytics/issues)

# Contributions
Ccontributions are welcome by sending a [pull request](https://github.com/paulgovan/eAnalytics/pulls)

# License
eAnalytics is licensed under the [Apache](http://www.apache.org/licenses/LICENSE-2.0) licence. &copy; Paul Govan (2015)
