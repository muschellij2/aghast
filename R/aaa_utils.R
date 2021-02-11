rerun_multiple_pages = function(first, page, args, run_list, extract_column = "artifacts") {
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
      out$artifacts = c(out[[extract_column]],
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
