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
    return(out)
  } else {
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
  out
}
