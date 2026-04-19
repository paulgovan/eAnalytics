# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working
with code in this repository.

## Package Overview

**eAnalytics** is an R Shiny web application for energy industry
analytics, built on FERC (Federal Energy Regulatory Commission) data
from the `energyr` package. The main entry point is a single exported
function
[`eAnalytics()`](http://paulgovan.github.io/eAnalytics/reference/eAnalytics.md)
that launches the Shiny app.

Supported industry segments: Electric, Natural Gas (companies,
pipelines, storage), Hydropower, Oil, and LNG.

## Common Commands

``` r
# Load package for interactive development
devtools::load_all()

# Run the app
eAnalytics::eAnalytics()

# Full R CMD check (equivalent to CI)
devtools::check()

# Install development dependencies
devtools::install_dev_deps()

# Regenerate documentation from roxygen2 comments
roxygen2::roxygenise()

# Run tests
devtools::test()
```

**Linting:** Use [Air](https://posit-dev.github.io/air/) to apply
tidyverse style. Only restyle code directly related to your change.

## Architecture

    R/eAnalytics.R          # Single exported function — launches the Shiny app
    inst/app/
      global.r              # Loads plotly and shiny at startup
      dependencies.r        # Loads all other required packages
      ui.r                  # Full dashboard UI (~580 lines)
      server.r              # Full server logic (~665 lines)
      plotlyGraphWidget.r   # Custom Plotly widget
      www/                  # Static web assets (favicon, JS)

The app is a monolithic Shiny dashboard (not modularized). All UI is in
`ui.r` and all reactive server logic is in `server.r`. Data is sourced
entirely from the `energyr` package at startup.

Each industry segment has up to five tabs: **Profile** (leaflet map),
**Performance** (KPIs), **Trends** (plotly time-series + DT table),
**Data** (searchable DT table with CSV/PDF/Excel export), and
**Explorer** (googleVis motion chart).

## Documentation

- Docs are in roxygen2 comments in `.R` files — never edit `.Rd` files
  directly.
- The pkgdown site is auto-deployed to GitHub Pages on push via
  `.github/workflows/pkgdown.yaml`.
- User-facing changes should include a `NEWS.md` entry under the top
  header.

## CI

Three GitHub Actions workflows run on push/PR to master: -
**R-CMD-check.yaml** — matrix check across macOS, Windows, Ubuntu
(release/devel/oldrel-1) - **pkgdown.yaml** — builds and deploys the
documentation site - **pkgcheck.yaml** — ropensci automated package
checks
