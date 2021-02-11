
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
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
runs = ga_run_list("muschellij2", "pycwa")
runs$workflow_runs[[1]]
#> $id
#> [1] 392215958
#> 
#> $name
#> [1] "R-CMD-check"
#> 
#> $node_id
#> [1] "MDExOldvcmtmbG93UnVuMzkyMjE1OTU4"
#> 
#> $head_branch
#> [1] "master"
#> 
#> $head_sha
#> [1] "735490ace2a2e408d2d571a60c2961b82ffcf44d"
#> 
#> $run_number
#> [1] 48
#> 
#> $event
#> [1] "push"
#> 
#> $status
#> [1] "completed"
#> 
#> $conclusion
#> [1] "failure"
#> 
#> $workflow_id
#> [1] 3382918
#> 
#> $check_suite_id
#> [1] 1584183444
#> 
#> $check_suite_node_id
#> [1] "MDEwOkNoZWNrU3VpdGUxNTg0MTgzNDQ0"
#> 
#> $url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/actions/runs/392215958"
#> 
#> $html_url
#> [1] "https://github.com/muschellij2/pycwa/actions/runs/392215958"
#> 
#> $pull_requests
#> list()
#> 
#> $created_at
#> [1] "2020-11-30T18:27:20Z"
#> 
#> $updated_at
#> [1] "2020-11-30T18:38:55Z"
#> 
#> $jobs_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/actions/runs/392215958/jobs"
#> 
#> $logs_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/actions/runs/392215958/logs"
#> 
#> $check_suite_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/check-suites/1584183444"
#> 
#> $artifacts_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/actions/runs/392215958/artifacts"
#> 
#> $cancel_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/actions/runs/392215958/cancel"
#> 
#> $rerun_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/actions/runs/392215958/rerun"
#> 
#> $workflow_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/actions/workflows/3382918"
#> 
#> $head_commit
#> $head_commit$id
#> [1] "735490ace2a2e408d2d571a60c2961b82ffcf44d"
#> 
#> $head_commit$tree_id
#> [1] "9d5d65db850a3ab58911c48ae135c8dab3cf2073"
#> 
#> $head_commit$message
#> [1] "updated the tests"
#> 
#> $head_commit$timestamp
#> [1] "2020-11-30T18:27:15Z"
#> 
#> $head_commit$author
#> $head_commit$author$name
#> [1] "muschellij2"
#> 
#> $head_commit$author$email
#> [1] "muschellij2@gmail.com"
#> 
#> 
#> $head_commit$committer
#> $head_commit$committer$name
#> [1] "muschellij2"
#> 
#> $head_commit$committer$email
#> [1] "muschellij2@gmail.com"
#> 
#> 
#> 
#> $repository
#> $repository$id
#> [1] 308054992
#> 
#> $repository$node_id
#> [1] "MDEwOlJlcG9zaXRvcnkzMDgwNTQ5OTI="
#> 
#> $repository$name
#> [1] "pycwa"
#> 
#> $repository$full_name
#> [1] "muschellij2/pycwa"
#> 
#> $repository$private
#> [1] FALSE
#> 
#> $repository$owner
#> $repository$owner$login
#> [1] "muschellij2"
#> 
#> $repository$owner$id
#> [1] 1075118
#> 
#> $repository$owner$node_id
#> [1] "MDQ6VXNlcjEwNzUxMTg="
#> 
#> $repository$owner$avatar_url
#> [1] "https://avatars.githubusercontent.com/u/1075118?v=4"
#> 
#> $repository$owner$gravatar_id
#> [1] ""
#> 
#> $repository$owner$url
#> [1] "https://api.github.com/users/muschellij2"
#> 
#> $repository$owner$html_url
#> [1] "https://github.com/muschellij2"
#> 
#> $repository$owner$followers_url
#> [1] "https://api.github.com/users/muschellij2/followers"
#> 
#> $repository$owner$following_url
#> [1] "https://api.github.com/users/muschellij2/following{/other_user}"
#> 
#> $repository$owner$gists_url
#> [1] "https://api.github.com/users/muschellij2/gists{/gist_id}"
#> 
#> $repository$owner$starred_url
#> [1] "https://api.github.com/users/muschellij2/starred{/owner}{/repo}"
#> 
#> $repository$owner$subscriptions_url
#> [1] "https://api.github.com/users/muschellij2/subscriptions"
#> 
#> $repository$owner$organizations_url
#> [1] "https://api.github.com/users/muschellij2/orgs"
#> 
#> $repository$owner$repos_url
#> [1] "https://api.github.com/users/muschellij2/repos"
#> 
#> $repository$owner$events_url
#> [1] "https://api.github.com/users/muschellij2/events{/privacy}"
#> 
#> $repository$owner$received_events_url
#> [1] "https://api.github.com/users/muschellij2/received_events"
#> 
#> $repository$owner$type
#> [1] "User"
#> 
#> $repository$owner$site_admin
#> [1] FALSE
#> 
#> 
#> $repository$html_url
#> [1] "https://github.com/muschellij2/pycwa"
#> 
#> $repository$description
#> [1] "Parse Actigraph 'Axivity' 'CWA' Accelerometer Data"
#> 
#> $repository$fork
#> [1] FALSE
#> 
#> $repository$url
#> [1] "https://api.github.com/repos/muschellij2/pycwa"
#> 
#> $repository$forks_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/forks"
#> 
#> $repository$keys_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/keys{/key_id}"
#> 
#> $repository$collaborators_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/collaborators{/collaborator}"
#> 
#> $repository$teams_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/teams"
#> 
#> $repository$hooks_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/hooks"
#> 
#> $repository$issue_events_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/issues/events{/number}"
#> 
#> $repository$events_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/events"
#> 
#> $repository$assignees_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/assignees{/user}"
#> 
#> $repository$branches_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/branches{/branch}"
#> 
#> $repository$tags_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/tags"
#> 
#> $repository$blobs_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/git/blobs{/sha}"
#> 
#> $repository$git_tags_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/git/tags{/sha}"
#> 
#> $repository$git_refs_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/git/refs{/sha}"
#> 
#> $repository$trees_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/git/trees{/sha}"
#> 
#> $repository$statuses_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/statuses/{sha}"
#> 
#> $repository$languages_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/languages"
#> 
#> $repository$stargazers_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/stargazers"
#> 
#> $repository$contributors_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/contributors"
#> 
#> $repository$subscribers_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/subscribers"
#> 
#> $repository$subscription_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/subscription"
#> 
#> $repository$commits_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/commits{/sha}"
#> 
#> $repository$git_commits_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/git/commits{/sha}"
#> 
#> $repository$comments_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/comments{/number}"
#> 
#> $repository$issue_comment_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/issues/comments{/number}"
#> 
#> $repository$contents_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/contents/{+path}"
#> 
#> $repository$compare_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/compare/{base}...{head}"
#> 
#> $repository$merges_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/merges"
#> 
#> $repository$archive_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/{archive_format}{/ref}"
#> 
#> $repository$downloads_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/downloads"
#> 
#> $repository$issues_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/issues{/number}"
#> 
#> $repository$pulls_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/pulls{/number}"
#> 
#> $repository$milestones_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/milestones{/number}"
#> 
#> $repository$notifications_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/notifications{?since,all,participating}"
#> 
#> $repository$labels_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/labels{/name}"
#> 
#> $repository$releases_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/releases{/id}"
#> 
#> $repository$deployments_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/deployments"
#> 
#> 
#> $head_repository
#> $head_repository$id
#> [1] 308054992
#> 
#> $head_repository$node_id
#> [1] "MDEwOlJlcG9zaXRvcnkzMDgwNTQ5OTI="
#> 
#> $head_repository$name
#> [1] "pycwa"
#> 
#> $head_repository$full_name
#> [1] "muschellij2/pycwa"
#> 
#> $head_repository$private
#> [1] FALSE
#> 
#> $head_repository$owner
#> $head_repository$owner$login
#> [1] "muschellij2"
#> 
#> $head_repository$owner$id
#> [1] 1075118
#> 
#> $head_repository$owner$node_id
#> [1] "MDQ6VXNlcjEwNzUxMTg="
#> 
#> $head_repository$owner$avatar_url
#> [1] "https://avatars.githubusercontent.com/u/1075118?v=4"
#> 
#> $head_repository$owner$gravatar_id
#> [1] ""
#> 
#> $head_repository$owner$url
#> [1] "https://api.github.com/users/muschellij2"
#> 
#> $head_repository$owner$html_url
#> [1] "https://github.com/muschellij2"
#> 
#> $head_repository$owner$followers_url
#> [1] "https://api.github.com/users/muschellij2/followers"
#> 
#> $head_repository$owner$following_url
#> [1] "https://api.github.com/users/muschellij2/following{/other_user}"
#> 
#> $head_repository$owner$gists_url
#> [1] "https://api.github.com/users/muschellij2/gists{/gist_id}"
#> 
#> $head_repository$owner$starred_url
#> [1] "https://api.github.com/users/muschellij2/starred{/owner}{/repo}"
#> 
#> $head_repository$owner$subscriptions_url
#> [1] "https://api.github.com/users/muschellij2/subscriptions"
#> 
#> $head_repository$owner$organizations_url
#> [1] "https://api.github.com/users/muschellij2/orgs"
#> 
#> $head_repository$owner$repos_url
#> [1] "https://api.github.com/users/muschellij2/repos"
#> 
#> $head_repository$owner$events_url
#> [1] "https://api.github.com/users/muschellij2/events{/privacy}"
#> 
#> $head_repository$owner$received_events_url
#> [1] "https://api.github.com/users/muschellij2/received_events"
#> 
#> $head_repository$owner$type
#> [1] "User"
#> 
#> $head_repository$owner$site_admin
#> [1] FALSE
#> 
#> 
#> $head_repository$html_url
#> [1] "https://github.com/muschellij2/pycwa"
#> 
#> $head_repository$description
#> [1] "Parse Actigraph 'Axivity' 'CWA' Accelerometer Data"
#> 
#> $head_repository$fork
#> [1] FALSE
#> 
#> $head_repository$url
#> [1] "https://api.github.com/repos/muschellij2/pycwa"
#> 
#> $head_repository$forks_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/forks"
#> 
#> $head_repository$keys_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/keys{/key_id}"
#> 
#> $head_repository$collaborators_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/collaborators{/collaborator}"
#> 
#> $head_repository$teams_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/teams"
#> 
#> $head_repository$hooks_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/hooks"
#> 
#> $head_repository$issue_events_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/issues/events{/number}"
#> 
#> $head_repository$events_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/events"
#> 
#> $head_repository$assignees_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/assignees{/user}"
#> 
#> $head_repository$branches_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/branches{/branch}"
#> 
#> $head_repository$tags_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/tags"
#> 
#> $head_repository$blobs_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/git/blobs{/sha}"
#> 
#> $head_repository$git_tags_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/git/tags{/sha}"
#> 
#> $head_repository$git_refs_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/git/refs{/sha}"
#> 
#> $head_repository$trees_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/git/trees{/sha}"
#> 
#> $head_repository$statuses_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/statuses/{sha}"
#> 
#> $head_repository$languages_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/languages"
#> 
#> $head_repository$stargazers_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/stargazers"
#> 
#> $head_repository$contributors_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/contributors"
#> 
#> $head_repository$subscribers_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/subscribers"
#> 
#> $head_repository$subscription_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/subscription"
#> 
#> $head_repository$commits_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/commits{/sha}"
#> 
#> $head_repository$git_commits_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/git/commits{/sha}"
#> 
#> $head_repository$comments_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/comments{/number}"
#> 
#> $head_repository$issue_comment_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/issues/comments{/number}"
#> 
#> $head_repository$contents_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/contents/{+path}"
#> 
#> $head_repository$compare_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/compare/{base}...{head}"
#> 
#> $head_repository$merges_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/merges"
#> 
#> $head_repository$archive_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/{archive_format}{/ref}"
#> 
#> $head_repository$downloads_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/downloads"
#> 
#> $head_repository$issues_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/issues{/number}"
#> 
#> $head_repository$pulls_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/pulls{/number}"
#> 
#> $head_repository$milestones_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/milestones{/number}"
#> 
#> $head_repository$notifications_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/notifications{?since,all,participating}"
#> 
#> $head_repository$labels_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/labels{/name}"
#> 
#> $head_repository$releases_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/releases{/id}"
#> 
#> $head_repository$deployments_url
#> [1] "https://api.github.com/repos/muschellij2/pycwa/deployments"

runs = ga_run_table("muschellij2", "pycwa")
run_id = runs$id[1]
out = ga_run_jobs_table("muschellij2", "pycwa", run_id)
out$name
#> [1] "macOS-latest (release)"   "windows-latest (release)"
#> [3] "windows-latest (3.6)"     "ubuntu-16.04 (devel)"    
#> [5] "ubuntu-16.04 (release)"   "ubuntu-16.04 (oldrel)"   
#> [7] "ubuntu-16.04 (3.5)"       "ubuntu-16.04 (3.4)"
if (requireNamespace("dplyr", quietly = TRUE)) {
  library(dplyr)
  out = out %>% 
    dplyr::mutate(r_version = sub("\\((.*)\\)", "\\1", name),
           os = trimws(sub("\\(.*", "", name)))
  head(out %>% 
         dplyr::select(job_id = id, run_id, name, r_version, os))
}
#>       job_id    run_id                     name              r_version
#> 1 1475662226 392215958   macOS-latest (release)   macOS-latest release
#> 2 1475662260 392215958 windows-latest (release) windows-latest release
#> 3 1475662285 392215958     windows-latest (3.6)     windows-latest 3.6
#> 4 1475662309 392215958     ubuntu-16.04 (devel)     ubuntu-16.04 devel
#> 5 1475662335 392215958   ubuntu-16.04 (release)   ubuntu-16.04 release
#> 6 1475662371 392215958    ubuntu-16.04 (oldrel)    ubuntu-16.04 oldrel
#>               os
#> 1   macOS-latest
#> 2 windows-latest
#> 3 windows-latest
#> 4   ubuntu-16.04
#> 5   ubuntu-16.04
#> 6   ubuntu-16.04
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
#>           id    run_id
#> 1 1863254389 551409765
#> 2 1863254422 551409765
#> 3 1863254446 551409765
#> 4 1863254472 551409765
#>                                                             run_url
#> 1 https://api.github.com/repos/r-lib/actions/actions/runs/551409765
#> 2 https://api.github.com/repos/r-lib/actions/actions/runs/551409765
#> 3 https://api.github.com/repos/r-lib/actions/actions/runs/551409765
#> 4 https://api.github.com/repos/r-lib/actions/actions/runs/551409765
#>                        node_id                                 head_sha
#> 1 MDg6Q2hlY2tSdW4xODYzMjU0Mzg5 f2e0935fb4623b6432c177590bcfb7d13a09767f
#> 2 MDg6Q2hlY2tSdW4xODYzMjU0NDIy f2e0935fb4623b6432c177590bcfb7d13a09767f
#> 3 MDg6Q2hlY2tSdW4xODYzMjU0NDQ2 f2e0935fb4623b6432c177590bcfb7d13a09767f
#> 4 MDg6Q2hlY2tSdW4xODYzMjU0NDcy f2e0935fb4623b6432c177590bcfb7d13a09767f
#>                                                                  url
#> 1 https://api.github.com/repos/r-lib/actions/actions/jobs/1863254389
#> 2 https://api.github.com/repos/r-lib/actions/actions/jobs/1863254422
#> 3 https://api.github.com/repos/r-lib/actions/actions/jobs/1863254446
#> 4 https://api.github.com/repos/r-lib/actions/actions/jobs/1863254472
#>                                           html_url    status conclusion
#> 1 https://github.com/r-lib/actions/runs/1863254389 completed    success
#> 2 https://github.com/r-lib/actions/runs/1863254422 completed    success
#> 3 https://github.com/r-lib/actions/runs/1863254446 completed    success
#> 4 https://github.com/r-lib/actions/runs/1863254472 completed    success
#>             started_at         completed_at                     name
#> 1 2021-02-09T13:12:23Z 2021-02-09T13:15:44Z windows-latest (release)
#> 2 2021-02-09T13:14:05Z 2021-02-09T13:18:22Z   macOS-latest (release)
#> 3 2021-02-09T13:12:21Z 2021-02-09T13:14:46Z   ubuntu-20.04 (release)
#> 4 2021-02-09T13:12:20Z 2021-02-09T13:15:18Z     ubuntu-20.04 (devel)
#>                                                      check_run_url
#> 1 https://api.github.com/repos/r-lib/actions/check-runs/1863254389
#> 2 https://api.github.com/repos/r-lib/actions/check-runs/1863254422
#> 3 https://api.github.com/repos/r-lib/actions/check-runs/1863254446
#> 4 https://api.github.com/repos/r-lib/actions/check-runs/1863254472
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
