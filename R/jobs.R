#' GitHub jobs
#'
#' @param owner owner of repo/username
#' @param repo repository name
#' @param job_id identifier of job
#' @param ... additional arguments to pass to [gh::gh()]
#'
#' @return Answer from the API as a `ga_response` object, which is also a list.
#' Failed requests will generate an R error.
#' Requests that generate a raw response will return a raw vector.
#' @export
#'
#' @rdname ga_jobs
#' @examples
ga_job = function(owner, repo, job_id, ...) {
  gh::gh(
    glue::glue(
      "GET /repos/{owner}/{repo}/actions/jobs/{job_id}",
    ),
    ...
  )
}

#' @rdname ga_jobs
#' @export
ga_job_logs = function(owner, repo, job_id, ...) {
  gh::gh(
    glue::glue(
      "GET /repos/{owner}/{repo}/actions/jobs/{job_id}/logs",
    ),
    ...
  )
}


