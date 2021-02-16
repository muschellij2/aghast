
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
runs = ga_run_list("muschellij2", "pycwa")
names(runs$workflow_runs[[1]])
#>  [1] "id"                  "name"                "node_id"            
#>  [4] "head_branch"         "head_sha"            "run_number"         
#>  [7] "event"               "status"              "conclusion"         
#> [10] "workflow_id"         "check_suite_id"      "check_suite_node_id"
#> [13] "url"                 "html_url"            "pull_requests"      
#> [16] "created_at"          "updated_at"          "jobs_url"           
#> [19] "logs_url"            "check_suite_url"     "artifacts_url"      
#> [22] "cancel_url"          "rerun_url"           "workflow_url"       
#> [25] "head_commit"         "repository"          "head_repository"

runs = ga_run_table("muschellij2", "pycwa")
run_id = runs$id[1]
run_id
#> [1] 392215958
out = ga_run_jobs_table("muschellij2", "pycwa", run_id, download_logs = TRUE)
head(out$name)
#> [1] "macOS-latest (release)"   "windows-latest (release)"
#> [3] "windows-latest (3.6)"     "ubuntu-16.04 (devel)"    
#> [5] "ubuntu-16.04 (release)"   "ubuntu-16.04 (oldrel)"
head(out$log)
#> [1] "/var/folders/1s/wrtqcpxn685_zk570bnx9_rr0000gr/T//RtmpJ5OKIx/file11a8d1b19d5fc.txt"
#> [2] "/var/folders/1s/wrtqcpxn685_zk570bnx9_rr0000gr/T//RtmpJ5OKIx/file11a8d3d2fa14a.txt"
#> [3] "/var/folders/1s/wrtqcpxn685_zk570bnx9_rr0000gr/T//RtmpJ5OKIx/file11a8d20620a8.txt" 
#> [4] "/var/folders/1s/wrtqcpxn685_zk570bnx9_rr0000gr/T//RtmpJ5OKIx/file11a8d6049f6a1.txt"
#> [5] "/var/folders/1s/wrtqcpxn685_zk570bnx9_rr0000gr/T//RtmpJ5OKIx/file11a8d17def56a.txt"
#> [6] "/var/folders/1s/wrtqcpxn685_zk570bnx9_rr0000gr/T//RtmpJ5OKIx/file11a8d2ec20e64.txt"

log = ga_run_download_log(
  attr(out, "owner"), 
  repo = attr(out, "repo"), 
  run_id = run_id)
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
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
#> Joining, by = "name"
#> # A tibble: 6 x 6
#>       job_id   run_id name               r_version os         completed_at      
#>        <int>    <int> <chr>              <chr>     <chr>      <chr>             
#> 1 1475662226   3.92e8 macOS-latest (rel… release   macOS-lat… 2020-11-30T18:35:…
#> 2 1475662450   3.92e8 ubuntu-16.04 (3.4) 3.4       ubuntu-16… 2020-11-30T18:32:…
#> 3 1475662417   3.92e8 ubuntu-16.04 (3.5) 3.5       ubuntu-16… 2020-11-30T18:32:…
#> 4 1475662309   3.92e8 ubuntu-16.04 (dev… devel     ubuntu-16… 2020-11-30T18:32:…
#> 5 1475662371   3.92e8 ubuntu-16.04 (old… oldrel    ubuntu-16… 2020-11-30T18:32:…
#> 6 1475662335   3.92e8 ubuntu-16.04 (rel… release   ubuntu-16… 2020-11-30T18:33:…
# ga_job_logs("muschellij2", "pycwa", out$id[1])
```

Here is the

``` r
find_sha = "f2e0935fb4623b6432c177590bcfb7d13a09767f"
tab = ga_run_table("r-lib", "actions", page = 1)
row = which(tab$head_sha == find_sha)[1]
itab = tab[row,]
run_id = itab$id
run_log = ga_run_download_log(itab$repository_owner_login,
                              itab$repository_name, 
                              run_id)
config = ga_run_log_config(run_log)
config$`macOS-latest (release)/3_Run r-libactionssetup-r@master.txt`
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
jobs = ga_run_jobs_table(itab$repository_owner_login,
                         itab$repository_name, 
                         run_id = run_id)
head(jobs[, !colnames(jobs) %in% "steps"])
#> # A tibble: 4 x 13
#>       id run_id run_url node_id head_sha url   html_url status conclusion
#>    <int>  <int> <chr>   <chr>   <chr>    <chr> <chr>    <chr>  <chr>     
#> 1 1.86e9 5.51e8 https:… MDg6Q2… f2e0935… http… https:/… compl… success   
#> 2 1.86e9 5.51e8 https:… MDg6Q2… f2e0935… http… https:/… compl… success   
#> 3 1.86e9 5.51e8 https:… MDg6Q2… f2e0935… http… https:/… compl… success   
#> 4 1.86e9 5.51e8 https:… MDg6Q2… f2e0935… http… https:/… compl… success   
#> # … with 4 more variables: started_at <chr>, completed_at <chr>, name <chr>,
#> #   check_run_url <chr>
head(jobs$steps[[1]])
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
