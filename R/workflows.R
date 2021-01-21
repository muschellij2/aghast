#' GitHub Workflows
#'
#' @param owner owner of repo/username
#' @param repo repository name
#' @param workflow_id identifier of workflow
#' @param ... additional arguments to pass to [gh::gh()]
#'
#' @return Answer from the API as a `ga_response` object, which is also a list.
#' Failed requests will generate an R error.
#' Requests that generate a raw response will return a raw vector.
#' @export
#'
#' @rdname ga_workflows
#' @examples
#' ga_workflow_list("muschellij2", "fslr")
ga_workflow_list = function(owner, repo, ...) {
  gh::gh(
    glue::glue(
      "GET /repos/{owner}/{repo}/actions/workflows",
    ),
    ...
  )
}

#' @rdname ga_workflows
#' @export
ga_workflow_runs = function(owner, repo, workflow_id, ...) {
  gh::gh(
    glue::glue(
      "GET /repos/{owner}/{repo}/actions/workflows/{workflow_id}/runs",
    ),
    ...
  )
}



#' @rdname ga_workflows
#' @export
ga_workflow = function(owner, repo, workflow_id, ...) {
  gh::gh(
    glue::glue(
      "GET /repos/{owner}/{repo}/actions/workflows/{workflow_id}",
    ),
    ...
  )
}

#' @rdname ga_workflows
#' @export
ga_workflow_usage = function(owner, repo, workflow_id, ...) {
  gh::gh(
    glue::glue(
      "GET /repos/{owner}/{repo}/actions/workflows/{workflow_id}/timing",
    ),
    ...
  )
}

#' @rdname ga_workflows
#' @export
ga_workflow_disable = function(owner, repo, workflow_id, ...) {
  gh::gh(
    glue::glue(
      "PUT /repos/{owner}/{repo}/actions/workflows/{workflow_id}/disable",
    ),
    ...
  )
}

#' @rdname ga_workflows
#' @export
ga_workflow_enable = function(owner, repo, workflow_id, ...) {
  gh::gh(
    glue::glue(
      "PUT /repos/{owner}/{repo}/actions/workflows/{workflow_id}/enable",
    ),
    ...
  )
}







