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
#' \dontrun{
#' run = ga_run("muschellij2", "pycwa", run_id)
#' run_jobs = ga_run_jobs("muschellij2", "pycwa", run_id)
#' run_log = ga_run_download_log("muschellij2", "pycwa", run_id)
#' usage = ga_run_usage("muschellij2", "pycwa", run_id)
#' run_artifacts = ga_run_artifacts("muschellij2", "pycwa", run_id)
#' }
ga_run_list = function(owner, repo, page = NULL, per_page = NULL, ...) {
  out = ensure_owner_repo(owner, repo)
  owner = out$owner
  repo = out$repo
  run_list = function(owner, repo, page = NULL, per_page = NULL, ...) {
    gh::gh(
      glue::glue(
        "GET /repos/{owner}/{repo}/actions/runs",
      ),
      page = page,
      per_page = per_page,
      ...
    )
  }
  args = list(owner, repo, page = page, per_page = per_page, ...)
  first = do.call(run_list, args = args)
  rerun_multiple_pages(first, page, args, run_list, extract_column = "workflow_runs")
}

#' @rdname ga_runs
#' @export
ga_run_table = function(...) {
  runs = ga_run_list(...)
  make_table(runs)
}

#' @rdname ga_runs
#' @export
ga_run = function(owner, repo, run_id, ...) {
  out = ensure_owner_repo(owner, repo)
  owner = out$owner
  repo = out$repo
  gh::gh(
    glue::glue(
      "GET /repos/{owner}/{repo}/actions/runs/{run_id}",
    ),
    ...
  )
}

#' @rdname ga_runs
#' @export
ga_run_delete = function(owner, repo, run_id, ...) {
  out = ensure_owner_repo(owner, repo)
  owner = out$owner
  repo = out$repo
  gh::gh(
    glue::glue(
      "DELETE /repos/{owner}/{repo}/actions/runs/{run_id}",
    ),
    ...
  )
}

#' @rdname ga_runs
#' @export
ga_run_cancel = function(owner, repo, run_id, ...) {
  out = ensure_owner_repo(owner, repo)
  owner = out$owner
  repo = out$repo
  gh::gh(
    glue::glue(
      "POST /repos/{owner}/{repo}/actions/runs/{run_id}/cancel",
    ),
    ...
  )
}

#' @rdname ga_runs
#' @export
ga_run_download_log = function(owner, repo, run_id, ...) {
  out = ensure_owner_repo(owner, repo)
  owner = out$owner
  repo = out$repo
  args = list(
    glue::glue(
      "GET /repos/{owner}/{repo}/actions/runs/{run_id}/logs",
    ),
    ...)
  if (!".destfile" %in% names(args)) {
    destfile = tempfile(fileext = ".zip")
    args$.destfile = destfile
  } else {
    destfile = args$.destfile
  }
  result = do.call(gh::gh, args = args)
}


#' @rdname ga_runs
#' @export
ga_run_delete_log = function(owner, repo, run_id, ...) {
  out = ensure_owner_repo(owner, repo)
  owner = out$owner
  repo = out$repo
  gh::gh(
    glue::glue(
      "DELETE /repos/{owner}/{repo}/actions/runs/{run_id}/logs",
    ),
    ...
  )
}

#' @rdname ga_runs
#' @export
ga_run_rerun = function(owner, repo, run_id, ...) {
  out = ensure_owner_repo(owner, repo)
  owner = out$owner
  repo = out$repo
  gh::gh(
    glue::glue(
      "POST /repos/{owner}/{repo}/actions/runs/{run_id}/rerun",
    ),
    ...
  )
}


#' @rdname ga_runs
#' @export
ga_run_usage = function(owner, repo, run_id, ...) {
  out = ensure_owner_repo(owner, repo)
  owner = out$owner
  repo = out$repo
  gh::gh(
    glue::glue(
      "GET /repos/{owner}/{repo}/actions/runs/{run_id}/timing",
    ),
    ...
  )
}

#' @rdname ga_runs
#' @export
ga_run_jobs = function(owner, repo, run_id, page = NULL, per_page = NULL, ...) {
  out = ensure_owner_repo(owner, repo)
  owner = out$owner
  repo = out$repo
  run_list = function(owner, repo, run_id, page = NULL, per_page = NULL, ...) {
    gh::gh(
      glue::glue(
        "GET /repos/{owner}/{repo}/actions/runs/{run_id}/jobs",
      ),
      page = page,
      per_page = per_page,
      ...
    )
  }
  args = list(owner, repo, run_id, page = page, per_page = per_page, ...)
  first = do.call(run_list, args = args)
  rerun_multiple_pages(first, page, args, run_list, extract_column = "jobs")
}


#' @rdname ga_runs
#' @export
ga_run_jobs_table = function(...) {
  runs = ga_run_jobs(...)
  make_table(runs)
}


#' @rdname ga_runs
#' @export
ga_run_artifacts = function(owner, repo, run_id, page = NULL, per_page = NULL, ...) {
  out = ensure_owner_repo(owner, repo)
  owner = out$owner
  repo = out$repo
  run_list = function(owner, repo, run_id, page = NULL, per_page = NULL, ...) {
    gh::gh(
      glue::glue(
        "GET /repos/{owner}/{repo}/actions/runs/{run_id}/artifacts",
      ),
      page = page,
      per_page = per_page,
      ...
    )
  }
  args = list(owner, repo, run_id, page = page, per_page = per_page, ...)
  first = do.call(run_list, args = args)
  rerun_multiple_pages(first, page, args, run_list, extract_column = "artifacts")
}
