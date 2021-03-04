#' GitHub runs
#'
#' @param owner owner of repo/username
#' @param repo repository name
#' @param run_id identifier of run
#' @param page page to query.  If \code{NULL}, then will iterate through all pages
#' @param per_page number of results per page.
#' @param ... additional arguments to pass to [gh::gh()]
#'
#' @return Answer from the API as a `ga_response` object, which is also a list.
#' Failed requests will generate an R error.
#' Requests that generate a raw response will return a raw vector.
#' @export
#'
#' @rdname ga_runs
#' @examples
#' runs = ga_run_list("muschellij2", "pycwa")
#' tab = ga_run_table("muschellij2", "pycwa")
#' tab$head_sha
#' run_id = runs$workflow_runs[[1]]$id
#' \donttest{
#' tab = ga_run_table("muschellij2/pycwa@a9cd1b25ba80a17fb5085f165962785f70590565")
#' run = ga_run("muschellij2", "pycwa", run_id)
#' run_jobs = ga_run_jobs("muschellij2", "pycwa", run_id)
#' run_log = ga_run_download_log("muschellij2", "pycwa", run_id)
#' usage = ga_run_usage("muschellij2", "pycwa", run_id)
#' run_artifacts = ga_run_artifacts("muschellij2", "pycwa", run_id)
#' }
ga_run_list = function(owner, repo = NULL, page = NULL, per_page = NULL, ...) {
  out = gh_helper(
    endpoint =  "GET /repos/{owner}/{repo}/actions/runs",
    owner = owner, repo = repo,
    per_page = per_page, page = page, ...)
  return(out)
  # out = ensure_owner_repo(owner, repo)
  # owner = out$owner
  # repo = out$repo
  # run_list = function(owner, repo, page = NULL, per_page = NULL, ...) {
  #   gh::gh(
  #     glue::glue(
  #       "GET /repos/{owner}/{repo}/actions/runs",
  #     ),
  #     page = page,
  #     per_page = per_page,
  #     ...
  #   )
  # }
  # args = list(owner, repo, page = page, per_page = per_page, ...)
  # first = do.call(run_list, args = args)
  # rerun_multiple_pages(first, page, args, run_list, extract_column = "workflow_runs")
}

#' @rdname ga_runs
#' @param name name of the workflow
#' @export
ga_run_table = function(..., sha = NULL, name = NULL) {
  runs = ga_run_list(..., sha = sha)
  runs = make_table(runs)
  sha = attr(runs, "sha")
  if (!is.null(sha)) {
    row = which(runs$head_sha == sha)
    if (length(row) == 0) {
      warning("sha passed to ga_run_table, but no rows found, returning NULL")
      return(NULL)
    }
    runs = runs[row,]
  }
  if (!is.null(name)) {
    row = which(runs$name == sha)
    if (length(row) == 0) {
      warning("name passed to ga_run_table, but no rows found, returning NULL")
      return(NULL)
    }
    runs = runs[row,]
  }
  runs
}

#' @rdname ga_runs
#' @export
ga_run = function(owner, repo = NULL, run_id, ...) {
  gh_helper(
    endpoint = "GET /repos/{owner}/{repo}/actions/runs/{run_id}",
    owner = owner, repo = repo, run_id = run_id, ...)
}

#' @rdname ga_runs
#' @export
ga_run_delete = function(owner, repo = NULL, run_id, ...) {
  gh_helper(
    endpoint = "DELETE /repos/{owner}/{repo}/actions/runs/{run_id}",
    owner = owner, repo = repo, run_id = run_id, ...)
}

#' @rdname ga_runs
#' @export
ga_run_cancel = function(owner, repo = NULL, run_id, ...) {
  gh_helper(
    endpoint = "POST /repos/{owner}/{repo}/actions/runs/{run_id}/cancel",
    owner = owner, repo = repo, run_id = run_id, ...)
}

#' @rdname ga_runs
#' @export
ga_run_download_log = function(owner, repo = NULL, run_id, ...) {
  args = list(
    endpoint = "GET /repos/{owner}/{repo}/actions/runs/{run_id}/logs",
    owner = owner,
    repo = repo,
    run_id = run_id,
    ...)
  if (!".destfile" %in% names(args)) {
    destfile = tempfile(fileext = ".zip")
    args$.destfile = destfile
  } else {
    destfile = args$.destfile
  }
  result = do.call(gh_helper, args = args)
}

#' @rdname ga_runs
#' @param sha commit ID sha to cross reference for runs.
#' @export
ga_sha_download_log = function(owner, repo = NULL, sha = NULL, ...) {
  # list the runs
  # match the sha
  # fail if not found
  # warn if multiple found
  # parse into list
  # give back result
  out = ensure_owner_repo(owner, repo, sha)
  sha = out$sha
  stopifnot(!is.null(sha))
  runs = ga_run_table(owner, repo, ...)
  row = which(runs$head_sha == sha)
  if (length(row) == 0) {
    warning("No records were found, returning NULL")
    return(NULL)
  }
  if (length(row) > 1) {
    warning("Multiple runs were found - returning a list of them")
  }
  out = lapply(row, function(index) {
    itab = runs[index,]
    run_id = itab$id
    run_log = ga_run_download_log(
      itab$repository_owner_login,
      itab$repository_name,
      run_id)
  })
  if (length(out) == 1) {
    out = out[[1]]
  }
  out
}


#' @rdname ga_runs
#' @export
ga_run_delete_log = function(owner, repo = NULL, run_id, ...) {
  gh_helper(endpoint = "DELETE /repos/{owner}/{repo}/actions/runs/{run_id}/logs",
            owner = owner, repo = repo, run_id = run_id, ...)
}

#' @rdname ga_runs
#' @export
ga_run_rerun = function(owner, repo = NULL, run_id, ...) {
  gh_helper(endpoint = "POST /repos/{owner}/{repo}/actions/runs/{run_id}/rerun",
            owner = owner, repo = repo, run_id = run_id, add_limit = FALSE,  ...)
}


#' @rdname ga_runs
#' @export
ga_run_usage = function(owner, repo = NULL, run_id, ...) {
  gh_helper(endpoint = "GET /repos/{owner}/{repo}/actions/runs/{run_id}/timing",
            owner = owner, repo = repo, run_id = run_id, ...)
}

#' @rdname ga_runs
#' @export
ga_run_jobs = function(owner, repo = NULL, run_id, page = NULL, per_page = NULL, ...) {
  out = gh_helper(
    endpoint = "GET /repos/{owner}/{repo}/actions/runs/{run_id}/jobs",
    owner = owner, repo = repo,
    run_id = run_id,
    per_page = per_page, page = page, ...)
  return(out)
  # out = ensure_owner_repo(owner, repo)
  # owner = out$owner
  # repo = out$repo
  # run_list = function(owner, repo, run_id, page = NULL, per_page = NULL, ...) {
  #   gh::gh(
  #     glue::glue(
  #       "GET /repos/{owner}/{repo}/actions/runs/{run_id}/jobs",
  #     ),
  #     page = page,
  #     per_page = per_page,
  #     ...
  #   )
  # }
  # args = list(owner, repo, run_id, page = page, per_page = per_page, ...)
  # first = do.call(run_list, args = args)
  # rerun_multiple_pages(first, page, args, run_list, extract_column = "jobs")
}


#' @rdname ga_runs
#' @param download_logs should the logs be downloaded for each job?
#' @export
ga_run_jobs_table = function(..., download_logs = FALSE) {
  runs = ga_run_jobs(...)
  runs = make_table(runs)
  if (download_logs) {
    runs$log = sapply(runs$id, function(id) {
      ga_job_logs(
        attr(runs, "owner")[1],
        attr(runs, "repo")[1],
        job_id = id)
    })
  }
  runs
}


#' @rdname ga_runs
#' @export
ga_run_artifacts = function(owner, repo = NULL, run_id, page = NULL, per_page = NULL, ...) {
  out = gh_helper(
    endpoint = "GET /repos/{owner}/{repo}/actions/runs/{run_id}/artifacts",
    owner = owner, repo = repo,
    run_id = run_id,
    per_page = per_page, page = page, ...)
  return(out)
  # out = ensure_owner_repo(owner, repo)
  # owner = out$owner
  # repo = out$repo
  # run_list = function(owner, repo, run_id, page = NULL, per_page = NULL, ...) {
  #   gh::gh(
  #     glue::glue(
  #       "GET /repos/{owner}/{repo}/actions/runs/{run_id}/artifacts",
  #     ),
  #     page = page,
  #     per_page = per_page,
  #     ...
  #   )
  # }
  # args = list(owner, repo, run_id, page = page, per_page = per_page, ...)
  # first = do.call(run_list, args = args)
  # rerun_multiple_pages(first, page, args, run_list, extract_column = "artifacts")
}
