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
#' have_token = length(gh::gh_token()) > 0
#' if (have_token) {
#'   a = ga_artifact_list("muschellij2", "pycwa")
#'   tab = ga_artifact_table("muschellij2/pycwa")
#'   a
#'   a_id = a$artifacts[[1]]$id
#' }
#' \donttest{
#' if (have_token) {
#'   art = ga_artifact("muschellij2", "pycwa", a$artifacts[[1]]$id)
#'   if (as.POSIXct(art$expires_at) > Sys.time()) {
#'     dl = ga_artifact_download("muschellij2", "pycwa", a$artifacts[[1]]$id)
#'   }
#' }
#' }
ga_artifact_list = function(owner, repo = NULL, page = NULL, per_page = NULL, ...) {
  out = gh_helper(endpoint =  "GET /repos/{owner}/{repo}/actions/artifacts",
            owner = owner, repo = repo,
            per_page = per_page, page = page, ...)
  return(out)
  # out = ensure_owner_repo(owner, repo)
  # owner = out$owner
  # repo = out$repo
  # run_list = function(owner, repo, page = NULL, per_page = NULL, ...) {
  #   gh::gh(
  #     glue::glue(
  #       "GET /repos/{owner}/{repo}/actions/artifacts",
  #     ),
  #     page = page,
  #     per_page = per_page,
  #     ...
  #   )
  # }
  # args = list(owner, repo, page = page, per_page = per_page, ...)
  # first = do.call(run_list, args = args)
  # rerun_multiple_pages(first, page, args, run_list, extract_column = "artifacts")
}

#' @rdname ga_artifacts
#' @export
ga_artifact_table = function(...) {
  runs = ga_artifact_list(...)
  runs = make_table(runs)
  runs
}

#' @rdname ga_artifacts
#' @export
ga_artifact = function(owner, repo = NULL, artifact_id, ...) {
  gh_helper(endpoint =  "GET /repos/{owner}/{repo}/actions/artifacts/{artifact_id}",
            owner = owner, repo = repo, artifact_id = artifact_id, ...)
}

#' @rdname ga_artifacts
#' @export
ga_artifact_delete = function(owner, repo = NULL, artifact_id, ...) {
  gh_helper(
    endpoint = "DELETE /repos/{owner}/{repo}/actions/artifacts/{artifact_id}",
    owner = owner, repo = repo, artifact_id = artifact_id, ...)
}

#' @rdname ga_artifacts
#' @param archive_format format of archive
#' @export
ga_artifact_download = function(owner, repo = NULL, artifact_id,
                                archive_format = "zip",
                                ...) {
  args = list(
    endpoint = "GET /repos/{owner}/{repo}/actions/artifacts/{artifact_id}/{archive_format}",
    owner = owner,
    repo = repo,
    archive_format = archive_format,
    artifact_id = artifact_id,
    ...)
  if (!".destfile" %in% names(args)) {
    destfile = tempfile(fileext = paste0(".", archive_format))
    args$.destfile = destfile
  } else {
    destfile = args$.destfile
  }
  result = do.call(gh_helper, args = args)
}
