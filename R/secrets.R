#' GitHub Actions Secrets
#'
#' @param owner owner of repo/username
#' @param repo repository name
#' @param page page to query.  If \code{NULL}, then will iterate through all pages
#' @param per_page number of results per page.
#' @param ... additional arguments to pass to [gh::gh()]
#'
#' @return Answer from the API as a `ga_response` object, which is also a list.
#' Failed requests will generate an R error.
#' Requests that generate a raw response will return a raw vector.
#' @export
#'
#' @rdname ga_secrets
#' @examples
#' \dontrun{
#'   have_token = length(gh::gh_token()) > 0
#'   if (have_token) {
#'     secrets = ga_secrets("muschellij2/pycwa")
#'     secrets$secrets[[1]]
#'     # ga_secret_public_key("muschellij2/pycwa")
#'     ga_secret_update("muschellij2/pycwa", secret_name = "TEST",
#'     secret = as.character(Sys.time()))
#'     ga_secret("muschellij2/pycwa", secret_name = "TEST")
#'   }
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
ga_secret = function(owner, repo = NULL, secret_name,
                     ...) {
  out = gh_helper(
    endpoint =  "GET /repos/{owner}/{repo}/actions/secrets/{secret_name}",
    owner = owner, repo = repo,
    secret_name = secret_name,
    .limit = NULL,
    ...)
  return(out)
}

#' @export
#' @rdname ga_secrets
ga_secret_delete = function(owner, repo = NULL, secret_name,
                            ...) {
  out = gh_helper(
    endpoint =  "DELETE /repos/{owner}/{repo}/actions/secrets/{secret_name}",
    owner = owner, repo = repo,
    secret_name = secret_name,
    ...)
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


encrypt_secret = function(public_key, public_key_id, secret) {
  stopifnot(!is.null(public_key) &&
              length(public_key) > 0 &&
              nchar(public_key) > 0)
  key = base64enc::base64decode(what = public_key)
  pub = sodium::pubkey(key)
  msg = serialize(secret, NULL)
  encrypted <- sodium::simple_encrypt(msg, pub)
  encrypted_value = base64enc::base64encode(encrypted)
  encrypted_value
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
  encrypted_value = encrypt_secret(public_key = public_key,
                 public_key_id = public_key_id,
                 secret = secret)

  out = gh_helper(
    endpoint =  "PUT /repos/{owner}/{repo}/actions/secrets/{secret_name}",
    owner = owner, repo = repo,
    encrypted_value = encrypted_value,
    secret_name = secret_name,
    key_id = public_key_id,
    .limit = NULL,
    ...
  )
  return(out)
}


#' @export
#' @rdname ga_secrets
ga_secret_create = ga_secret_update



###############################################
######      Organizations     #################
###############################################

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
ga_org_secret_public_key = function(org,  ...) {
  out = gh_helper(
    endpoint =  "GET /orgs/{org}/actions/secrets/public-key",
    org = org,
    .limit = NULL,
    ...)
  return(out)
}




#' @export
#' @rdname ga_secrets
ga_org_secret = function(org, secret_name, ...) {
  out = gh_helper(
    endpoint =  "GET /orgs/{org}/actions/secrets/{secret_name}",
    org = org,
    secret_name = secret_name,
    .limit = NULL,
    ...)
  return(out)
}


#' @export
#' @rdname ga_secrets
#' @param visibility for keys, what visibility should it have:
#' `all` - All repositories in an organization can access the secret.
#' `private` - Private repositories in an organization can access the secret.
#' `selected` - Only specific repositories can access the secret.
#' @param selected_repository_ids identifiers of repositories if visibility
#' is `selected`
ga_org_secret_update = function(org,
                            secret_name,
                            secret,
                            visibility = c("all", "private", "selected"),
                            selected_repository_ids = NULL,
                            ...) {
  visibility = match.arg(visibility)
  if (visibility == "selected") {
    stopifnot(!is.null(selected_repository_ids))
  }
  if (!requireNamespace("sodium", quietly = TRUE) ||
      !requireNamespace("base64enc", quietly = TRUE)) {
    stop("sodium and base64enc packages is required for updating a secret")
  }

  public_key = ga_org_secret_public_key(
    owner = org,
    ...)
  public_key_id = public_key$key_id
  public_key = public_key$key
  encrypted_value = encrypt_secret(public_key = public_key,
                                   public_key_id = public_key_id,
                                   secret = secret)

  out = gh_helper(
    endpoint =  "PUT /orgs/{org}/actions/secrets/{secret_name}",
    org = org,
    encrypted_value = encrypted_value,
    secret_name = secret_name,
    key_id = public_key_id,
    visibility = visibility,
    selected_repository_ids = selected_repository_ids,
    .limit = NULL,
    ...
  )
  return(out)
}

#' @export
#' @rdname ga_secrets
ga_org_secret_create = ga_org_secret_update




###############################################
######      Environments      #################
###############################################
