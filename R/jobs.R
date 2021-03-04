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
#' job_id = "1475662285"
#' job_out = ga_job("muschellij2", "pycwa", job_id)
#' job_out2 = ga_job("muschellij2/pycwa", job_id = job_id)
#' if (difftime(Sys.time(), as.POSIXct(job_out$completed_at), "days")<= 90) {
#' job_log = ga_job_logs("muschellij2", "pycwa", job_id)
#' job_log = ga_job_logs("muschellij2/pycwa", job_id = job_id)
#' }
ga_job = function(owner, repo = NULL, job_id, ...) {
  gh_helper(endpoint =  "GET /repos/{owner}/{repo}/actions/jobs/{job_id}",
            owner = owner, repo = repo, job_id = job_id, ...)
}

#' @rdname ga_jobs
#' @export
ga_job_logs = function(owner, repo = NULL, job_id, ...) {
  args = list(
    endpoint = "GET /repos/{owner}/{repo}/actions/jobs/{job_id}/logs",
    owner = owner,
    repo = repo,
    job_id = job_id,
    ...)
  if (!".destfile" %in% names(args)) {
    destfile = tempfile(fileext = ".txt")
    args$.destfile = destfile
  } else {
    destfile = args$.destfile
  }
  result = do.call(gh_helper, args = args)
}


