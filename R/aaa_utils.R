ensure_owner_repo = function(owner, repo, sha = NULL) {
  if (missing(repo) ||
      is.null(repo)) {
    owner = strsplit(owner, "/")[[1]]
    repo = owner[[2]]
    owner = owner[[1]]
  }
  if (missing(sha) || is.null(sha)) {
    repo = strsplit(repo, "@")[[1]]
    sha = repo[2]
    repo = repo[1]
  }
  if (is.na(sha)) {
    sha = NULL
  }
  list(owner = owner, repo = repo, sha = sha)
}
rerun_multiple_pages = function(first, page, args, run_list, extract_column = names(first)[2]) {
  if (length(first[[extract_column]]) < first$total_count &&
      !is.null(first[[extract_column]]) && is.null(page)) {
    n_pages = ceiling(first$total_count / length(first[[extract_column]]))
    run_pages = seq(2, n_pages)
    # general solution but returns list
    # out = vector(mode = "list", length = n_pages)
    # out[[1]] = first
    # for (page in run_pages) {
    #   args$page = page
    #   out[[page]] = do.call(run_list, args = args)
    # }
    # out
    out = first
    for (page in run_pages) {
      args$page = page
      out[[extract_column]] = c(out[[extract_column]],
                                do.call(run_list, args = args)[[extract_column]])
    }
    class(out) = c("gh_response", "list")
    if (length(out[[extract_column]]) != out$total_count) {
      warning("Total results is not equal to total count")
    }
    attr(out, "owner") = args$owner
    attr(out, "repo") = args$repo
    attr(out, "sha") = args$sha
    return(out)
  } else {
    attr(first, "owner") = args$owner
    attr(first, "repo") = args$repo
    attr(first, "sha") = args$sha
    return(first)
  }
}

unlist_df = function(out) {
  for (i in seq_along(out)) {
    x = out[[i]]
    if (is.list(x) && all(sapply(x, length) == 1)) {
      x = unlist(x)
    }
    out[[i]] = x
  }
  out
}

make_table = function(runs) {
  owner = attr(runs, "owner")
  repo = attr(runs, "repo")
  sha = attr(runs, "sha")
  out = jsonlite::fromJSON(jsonlite::toJSON(runs[[2]]), flatten = TRUE)
  out = unlist_df(out)

  if ("steps" %in% names(out)) {
    s = out$steps
    for (i in seq_along(s)) {
      x = s[[i]]
      x = unlist_df(x)
      s[[i]] = x
    }
    out$steps = s
  }
  colnames(out) = gsub("[.]", "_", colnames(out))
  out = tibble::as_tibble(out)
  attr(out, "owner") = owner
  attr(out, "repo") = repo
  attr(out, "sha") = sha
  out
}

make_character = function(x) {
  if (length(x) > 0) {
    x = as.character(x)
  }
  x
}
gh_helper = function(endpoint, owner, repo, add_limit = TRUE, ...) {
  sha = list(...)$sha
  out = ensure_owner_repo(owner, repo, sha = sha)
  owner = out$owner
  repo = out$repo
  sha = out$sha
  args = list(
    endpoint,
    owner = owner,
    repo = repo,
    ...)
  args$run_id = make_character(args$run_id)
  args$job_id = make_character(args$job_id)
  args$artifact_id = make_character(args$artifact_id)
  args$workflow_id = make_character(args$workflow_id)

  if (!".limit" %in% names(args) &&
      is.null(args$page) &&
      add_limit) {
    args$.limit = Inf
  }
  out = do.call(gh::gh, args = args)
  attr(out, "owner") = owner
  attr(out, "repo") = repo
  attr(out, "sha") = sha
  out
}
