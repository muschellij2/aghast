#' GitHub Artifacts
#'
#' @param owner owner of repo/username
#' @param repo repository name
#' @param artifact_id identifier of artifact
#' @param page page to query.  If \code{NULL}, then will iterate through all pages
#' @param per_page number of results per page, max is 100.
#' @param ... additional arguments to pass to [gh::gh()]
#'
#' @return Answer from the API as a `ga_response` object, which is also a list.
#' Failed requests will generate an R error.
#' Requests that generate a raw response will return a raw vector.
#' @export
#'
#' @rdname ga_artifacts
#' @examples
#' a = ga_artifact_list("muschellij2", "pycwa")
#' a
#' a_id = a$artifacts[[1]]$id
#' \dontrun{
#' art = ga_artifact("muschellij2", "pycwa", a$artifacts[[1]]$id)
#' dl = ga_artifact_download("muschellij2", "pycwa", a$artifacts[[1]]$id)
#' }
ga_artifact_list = function(owner, repo, page = NULL, per_page = NULL, ...) {
  run_list = function(owner, repo, page = NULL, per_page = NULL, ...) {
    gh::gh(
      glue::glue(
        "GET /repos/{owner}/{repo}/actions/artifacts",
      ),
      page = page,
      per_page = per_page,
      ...
    )
  }
  args = list(owner, repo, page = page, per_page = per_page, ...)
  first = do.call(run_list, args = args)
  rerun_multiple_pages(first, page, args, run_list, extract_column = "artifacts")
}

#' @rdname ga_artifacts
#' @export
ga_artifact = function(owner, repo, artifact_id, ...) {
  gh::gh(
    glue::glue(
      "GET /repos/{owner}/{repo}/actions/artifacts/{artifact_id}",
    ),
    ...
  )
}

#' @rdname ga_artifacts
#' @export
ga_artifact_delete = function(owner, repo, artifact_id, ...) {
  gh::gh(
    glue::glue(
      "DELETE /repos/{owner}/{repo}/actions/artifacts/{artifact_id}",
    ),
    ...
  )
}

#' @rdname ga_artifacts
#' @param archive_format format of archive
#' @export
ga_artifact_download = function(owner, repo, artifact_id,
                                archive_format = "zip",
                                ...) {
  args = list(
    glue::glue(
      "GET /repos/{owner}/{repo}/actions/artifacts/{artifact_id}/{archive_format}"
    ),
    ...)
  if (!".destfile" %in% names(args)) {
    destfile = tempfile(fileext = paste0(".", archive_format))
    args$.destfile = destfile
  } else {
    destfile = args$.destfile
  }
  result = do.call(gh::gh, args = args)
}
