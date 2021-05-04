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
#' have_token = length(gh::gh_token()) > 0
#' if (have_token) {
#'   runs = ga_run_list("muschellij2", "pycwa")
#'   tab = ga_run_table("muschellij2", "pycwa")
#'   tab$head_sha
#'   run_id = runs$workflow_runs[[1]]$id
#' }
#' \donttest{
#' if (have_token) {
#'   tab = ga_run_table("muschellij2/pycwa@a9cd1b25ba80a17fb5085f165962785f70590565")
#'   run = ga_run("muschellij2", "pycwa", run_id)
#'   run_jobs = ga_run_jobs("muschellij2", "pycwa", run_id)
#'   if (difftime(Sys.time(), as.POSIXct(tab$created_at), "days")<= 90) {
#'     run_log = ga_run_download_log("muschellij2", "pycwa", run_id)
#'   }
#'   usage = ga_run_usage("muschellij2", "pycwa", run_id)
#'   run_artifacts = ga_run_artifacts("muschellij2", "pycwa", run_id)
#' }
#' }
ga_secrets = function(owner, repo = NULL, page = NULL, per_page = NULL, ...) {
  out = gh_helper(
    endpoint =  "GET /repos/{owner}/{repo}/actions/secrets",
    owner = owner, repo = repo,
    per_page = per_page, page = page, ...)
  return(out)
}

#' @export
#' @rdname ga_secrets
ga_org_secrets = function(org, page = NULL, per_page = NULL, ...) {
  out = gh_helper(
    endpoint =  "GET /orgs/{org}/actions/secrets",
    org = org,
    per_page = per_page, page = page, ...)
  return(out)
}

#' @export
#' @rdname ga_secrets
ga_org_secret = function(org, secret_name, page = NULL, per_page = NULL, ...) {
  out = gh_helper(
    endpoint =  "GET /orgs/{org}/actions/secrets/{secret_name}",
    org = org,
    secret_name = secret_name,
    per_page = per_page, page = page, ...)
  return(out)
}


#' @export
#' @rdname ga_secrets
ga_secret_public_key = function(owner, repo = NULL, ...) {
  out = gh_helper(
    endpoint =  "GET /repos/{owner}/{repo}/actions/secrets/public-key",
    owner = owner, repo = repo,
    .limit = NULL,
    ...)
  return(out)
}





#' @export
#' @rdname ga_secrets
#' @param secret value of the secret that you are updating
#' @param secret_name name of the secret you are updating or creating
ga_secret_update = function(owner, repo = NULL,
                            secret_name,
                            secret, ...) {
  if (!requireNamespace("sodium", quietly = TRUE) ||
      !requireNamespace("base64enc", quietly = TRUE)) {
    stop("sodium and base64enc packages is required for updating a secret")
  }

    public_key = ga_secret_public_key(
      owner = owner,
      repo = repo,
      ...)
    public_key_id = public_key$key_id
    public_key = public_key$key
  stopifnot(!is.null(public_key) &&
              length(public_key) > 0 &&
              nchar(public_key) > 0)
  key = base64enc::base64decode(what = public_key)
  pub = sodium::pubkey(key)
  msg = serialize(secret, NULL)
  encrypted <- sodium::simple_encrypt(msg, pub)
  encrypted_value = base64enc::base64encode(encrypted)

  out = gh_helper(
    endpoint =  "PUT /repos/{owner}/{repo}/actions/secrets/{secret_name}",
    owner = owner, repo = repo,
    encrypted_value = encrypted_value,
    secret_name = secret_name,
    key_id = public_key_id,
    .limit = NULL
  )
  return(out)
}



