
<!-- README.md is generated from README.Rmd. Please edit that file -->

# aghast

<!-- badges: start -->

[![R build
status](https://github.com/muschellij2/aghast/workflows/R-CMD-check/badge.svg)](https://github.com/muschellij2/aghast/actions)
<!-- badges: end -->

The goal of aghast is to provide functions to interact with the ‘GitHub’
Actions ‘API’.

## Installation

You can install the released version of aghast from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("aghast")
```

And the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("muschellij2/aghast")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(aghast)
runs = ga_run_list("muschellij2", "pycwa")
```
