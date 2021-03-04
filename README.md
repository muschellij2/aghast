
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

List a number of runs:

``` r
library(aghast)
have_token = length(gh::gh_token()) > 0
if (have_token) {
  runs = ga_run_list("muschellij2", "pycwa")
  names(runs$workflow_runs[[1]])
  
  runs = ga_run_table("muschellij2", "pycwa")
  runs = runs[order(as.POSIXct(runs$created_at), decreasing = TRUE), ]
  run_id = runs$id[1]
  art = ga_run_artifacts(attr(runs, "owner"), attr(runs, "repo"), run_id)
  art
  run_id
  out = ga_run_jobs_table("muschellij2", "pycwa", run_id, download_logs = TRUE)
  head(out$name)
  head(out$log)
  
  time = as.POSIXct(runs$created_at[1])
  within_90 = difftime(Sys.time(), time, units = "days") <= 90
  if (within_90) {
    log = ga_run_download_log(
      attr(out, "owner"), 
      repo = attr(out, "repo"), 
      run_id = run_id)
    # use name of thing somewhere in config output
    config = ga_run_log_config(log, make_data_frame = TRUE)
    
    
    if (requireNamespace("dplyr", quietly = TRUE)) {
      library(dplyr)
      out = dplyr::full_join(config, out)
      out = out %>% 
        dplyr::mutate(r_version = sub(".*\\((.*)\\)", "\\1", name),
                      os = trimws(sub("\\(.*", "", name)))
      head(out %>% 
             dplyr::select(job_id = id, run_id, name, r_version, os, completed_at))
    }
  }
}
#> Warning in (function (id, time) : id 1475662226 log cannot be downloaded, over 90 days
#> Warning in (function (id, time) : id 1475662260 log cannot be downloaded, over 90 days
#> Warning in (function (id, time) : id 1475662285 log cannot be downloaded, over 90 days
#> Warning in (function (id, time) : id 1475662309 log cannot be downloaded, over 90 days
#> Warning in (function (id, time) : id 1475662335 log cannot be downloaded, over 90 days
#> Warning in (function (id, time) : id 1475662371 log cannot be downloaded, over 90 days
#> Warning in (function (id, time) : id 1475662417 log cannot be downloaded, over 90 days
#> Warning in (function (id, time) : id 1475662450 log cannot be downloaded, over 90 days
# ga_job_logs("muschellij2", "pycwa", out$id[1])
```

Here is the

``` r
if (have_token) {
  find_sha = "f2e0935fb4623b6432c177590bcfb7d13a09767f"
  tab = ga_run_table("r-lib", "actions")
  row = which(tab$head_sha == find_sha)[1]
  itab = tab[row,]
  run_id = itab$id
  time = as.POSIXct(itab$created_at)
  within_90 = difftime(Sys.time(), time, units = "days") <= 90
  if (within_90) {
    run_log = ga_run_download_log(itab$repository_owner_login,
                                  itab$repository_name, 
                                  run_id)
    config = ga_run_log_config(run_log)
    config$`macOS-latest (release)/3_Run r-libactionssetup-r@master.txt`
  }
}
#> ℹ Running gh query
#> ℹ Running gh query, got 2 records of about 44
#> ℹ Running gh query, got 4 records of about 44
#> ℹ Running gh query, got 6 records of about 44
#> ℹ Running gh query, got 8 records of about 44
#> ℹ Running gh query, got 10 records of about 44
#> ℹ Running gh query, got 12 records of about 44
#> ℹ Running gh query, got 14 records of about 44
#> ℹ Running gh query, got 16 records of about 44
#> ℹ Running gh query, got 18 records of about 44
#> ℹ Running gh query, got 20 records of about 44
#> ℹ Running gh query, got 22 records of about 44
#> ℹ Running gh query, got 24 records of about 44
#> ℹ Running gh query, got 26 records of about 44
#> ℹ Running gh query, got 28 records of about 44
#> ℹ Running gh query, got 30 records of about 44
#> ℹ Running gh query, got 32 records of about 44
#> ℹ Running gh query, got 34 records of about 44
#> ℹ Running gh query, got 36 records of about 44
#> ℹ Running gh query, got 38 records of about 44
#> ℹ Running gh query, got 40 records of about 44
#> ℹ Running gh query, got 42 records of about 44
#> $`Run r-lib/actions/setup-r@master`
#>  [1] "with:"                                    
#>  [2] "  r-version: release"                     
#>  [3] "  Ncpus: 1"                               
#>  [4] "  crayon.enabled: NULL"                   
#>  [5] "  remove-openmp-macos: true"              
#>  [6] "  http-user-agent: default"               
#>  [7] "  install-r: true"                        
#>  [8] "  windows-path-include-mingw: true"       
#>  [9] "env:"                                     
#> [10] "  R_REMOTES_NO_ERRORS_FROM_WARNINGS: true"
#> [11] "  RSPM: "                                 
#> [12] "  GITHUB_PAT: <redacted>"
```

``` r
if (have_token) {
  jobs = ga_run_jobs_table(itab$repository_owner_login,
                           itab$repository_name, 
                           run_id = run_id)
  head(jobs[, !colnames(jobs) %in% "steps"])
  head(jobs$steps[[1]])
}
#>                                    name    status conclusion number
#> 1                            Set up job completed    success      1
#> 2               Run actions/checkout@v2 completed    success      2
#> 3      Run r-lib/actions/setup-r@master completed    success      3
#> 4 Run r-lib/actions/setup-pandoc@master completed    success      4
#> 5                    Query dependencies completed    success      5
#> 6                      Cache R packages completed    skipped      6
#>                      started_at                  completed_at
#> 1 2021-02-09T08:12:23.000-05:00 2021-02-09T08:12:26.000-05:00
#> 2 2021-02-09T08:12:26.000-05:00 2021-02-09T08:12:34.000-05:00
#> 3 2021-02-09T08:12:34.000-05:00 2021-02-09T08:14:49.000-05:00
#> 4 2021-02-09T08:14:49.000-05:00 2021-02-09T08:14:53.000-05:00
#> 5 2021-02-09T08:14:53.000-05:00 2021-02-09T08:14:59.000-05:00
#> 6 2021-02-09T08:14:59.000-05:00 2021-02-09T08:14:59.000-05:00
```
