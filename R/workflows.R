#' GitHub Workflows
#'
#' @param owner owner of repo/username
#' @param repo repository name
#' @param workflow_id identifier of workflow
#' @param page page to query.  If \code{NULL}, then will iterate through all pages
#' @param per_page number of results per page.
#' @param ... additional arguments to pass to [gh::gh()]
#'
#' @return Answer from the API as a `ga_response` object, which is also a list.
#' Failed requests will generate an R error.
#' Requests that generate a raw response will return a raw vector.
#' @export
#'
#' @rdname ga_workflows
#' @examples
#' w = ga_workflow_list("muschellij2/pycwa", page = 1)
#' w = ga_workflow_list("muschellij2", "pycwa")
#' workflow_id = w$workflows[[1]]$id
#' \donttest{
#' runs = ga_workflow_runs("muschellij2", "pycwa", workflow_id)
#' flow = ga_workflow("muschellij2", "pycwa", workflow_id)
#' usage = ga_workflow_usage("muschellij2", "pycwa", workflow_id)
#' }
ga_workflow_list = function(owner, repo = NULL,
                            page = NULL,
                            per_page = NULL, ...) {
  out = gh_helper(endpoint =  "GET /repos/{owner}/{repo}/actions/workflows",
                  owner = owner, repo = repo,
                  per_page = per_page, page = page, ...)
  return(out)
  # out = ensure_owner_repo(owner, repo)
  # owner = out$owner
  # repo = out$repo
  # run_list = function(owner, repo, page = NULL, per_page = NULL, ...) {
  #   gh::gh(
  #     glue::glue(
  #       "GET /repos/{owner}/{repo}/actions/workflows",
  #     ),
  #     page = page,
  #     per_page = per_page,
  #     ...
  #   )
  # }
  # args = list(owner, repo, page = page, per_page = per_page, ...)
  # first = do.call(run_list, args = args)
  # rerun_multiple_pages(first, page, args, run_list)
}

#' @rdname ga_workflows
#' @export
ga_workflow_runs = function(owner, repo = NULL, workflow_id,
                            page = NULL, per_page = NULL, ...) {
  out = gh_helper(
    endpoint =  "GET /repos/{owner}/{repo}/actions/workflows/{workflow_id}/runs",
    owner = owner, repo = repo,
    workflow_id = workflow_id,
    per_page = per_page, page = page, ...)
  return(out)
  # out = ensure_owner_repo(owner, repo)
  # owner = out$owner
  # repo = out$repo
  # run_list = function(owner, repo, workflow_id, page = NULL, per_page = NULL, ...) {
  #   gh::gh(
  #     glue::glue(
  #       "GET /repos/{owner}/{repo}/actions/workflows/{workflow_id}/runs",
  #     ),
  #     page = page,
  #     per_page = per_page,
  #     ...
  #   )
  # }
  # args = list(owner, repo, workflow_id, page = page, per_page = per_page, ...)
  # first = do.call(run_list, args = args)
  # rerun_multiple_pages(first, page, args, run_list)
}



#' @rdname ga_workflows
#' @export
ga_workflow = function(owner, repo = NULL, workflow_id, ...) {
  gh_helper(
    endpoint = "GET /repos/{owner}/{repo}/actions/workflows/{workflow_id}",
    owner = owner, repo = repo, workflow_id = workflow_id, ...)
}

#' @rdname ga_workflows
#' @export
ga_workflow_usage = function(owner, repo = NULL, workflow_id, ...) {
  gh_helper(
    endpoint = "GET /repos/{owner}/{repo}/actions/workflows/{workflow_id}/timing",
    owner = owner, repo = repo, workflow_id = workflow_id, ...)
}

#' @rdname ga_workflows
#' @export
ga_workflow_disable = function(owner, repo = NULL, workflow_id, ...) {
  gh_helper(
    endpoint = "PUT /repos/{owner}/{repo}/actions/workflows/{workflow_id}/disable",
    owner = owner, repo = repo, workflow_id = workflow_id, ...)
}

#' @rdname ga_workflows
#' @export
ga_workflow_enable = function(owner, repo = NULL, workflow_id, ...) {
  gh_helper(
    endpoint = "PUT /repos/{owner}/{repo}/actions/workflows/{workflow_id}/enable",
    owner = owner, repo = repo, workflow_id = workflow_id, ...)
}


