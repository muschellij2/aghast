#' GitHub runs
#'
#' @param owner owner of repo/username
#' @param repo repository name
#' @param run_id identifier of run
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
#' run_id = runs$workflow_runs[[1]]$id
#' \dontrun{
#' run = ga_run("muschellij2", "pycwa", run_id)
#' run_jobs = ga_run_jobs("muschellij2", "pycwa", run_id)
#' run_log = ga_run_download_log("muschellij2", "pycwa", run_id)
#' usage = ga_run_usage("muschellij2", "pycwa", run_id)
#' run_artifacts = ga_run_artifacts("muschellij2", "pycwa", run_id)
#' }
ga_run_list = function(owner, repo, ...) {
  gh::gh(
    glue::glue(
      "GET /repos/{owner}/{repo}/actions/runs",
    ),
    ...
  )
}

#' @rdname ga_runs
#' @export
ga_run = function(owner, repo, run_id, ...) {
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
  args = list(
    glue::glue(
      "GET /repos/{owner}/{repo}/actions/runs/{run_id}/logs",
    ),
    ...)
  if (!".destfile" %in% names(args)) {
    destfile = tempfile(fileext = ".txt")
    args$.destfile = destfile
  } else {
    destfile = args$.destfile
  }
  result = do.call(gh::gh, args = args)
}

#' @rdname ga_runs
#' @export
ga_run_delete_log = function(owner, repo, run_id, ...) {
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
  gh::gh(
    glue::glue(
      "GET /repos/{owner}/{repo}/actions/runs/{run_id}/timing",
    ),
    ...
  )
}

#' @rdname ga_runs
#' @export
ga_run_jobs = function(owner, repo, run_id, ...) {
  gh::gh(
    glue::glue(
      "GET /repos/{owner}/{repo}/actions/runs/{run_id}/jobs",
    ),
    ...
  )
}


#' @rdname ga_runs
#' @export
ga_run_artifacts = function(owner, repo, run_id, ...) {
  gh::gh(
    glue::glue(
      "GET /repos/{owner}/{repo}/actions/runs/{run_id}/artifacts",
    ),
    ...
  )
}
