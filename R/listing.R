#' GitHub Artifacts
#'
#' @param owner owner of repo/username
#' @param repo repository name
#' @param artifact_id identifier of artifact
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
#' art = ga_artifact("muschellij2", "pycwa", a$artifacts[[1]]$id)
#' dl = ga_artifact_download("muschellij2", "pycwa", a$artifacts[[1]]$id)
ga_artifact_list = function(owner, repo, ...) {
  gh::gh(
    glue::glue(
      "GET /repos/{owner}/{repo}/actions/artifacts",
    ),
    ...
  )
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
