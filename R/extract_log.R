#' Extract Log Configuration
#'
#' @param zipfile Log zip file from [ga_run_download_log]
#' @param make_data_frame Make it into a `data.frame`
#'
#' @return A list of character vectors
#' @export
#'
#' @examples
#' have_token = length(gh::gh_token()) > 0
#'
#' if (have_token) {
#'   run = ga_run("muschellij2", "pycwa",  "392215958")
#'   if (difftime(Sys.time(), as.POSIXct(run$created_at), "days")<= 90) {
#'     zipfile = ga_run_download_log("muschellij2", "pycwa",  "392215958")
#'   }
#' }
#' \dontrun{
#'   if (have_token) {
#'     run = ga_run("r-lib", "actions",  "551409765")
#'     if (difftime(Sys.time(), as.POSIXct(run$created_at), "days")<= 90) {
#'       zipfile = ga_run_download_log("r-lib", "actions",  "551409765")
#'       config = ga_run_log_config(zipfile)
#'     }
#'   }
#' }
ga_run_log_config = function(zipfile, make_data_frame = FALSE) {
  out = step = value = NULL
  rm(list = c("out", "step", "value"))

  files = utils::unzip(zipfile, list = TRUE)
  files = files[ grepl(".txt$", files$Name) & grepl("/", files$Name),]
  files = files[order(files$Name),]
  utils::unzip(zipfile,
               files = files$Name,
               exdir = tempdir(),
               overwrite = TRUE)
  out = lapply(files$Name, function(fname) {
    log = readLines(file.path(tempdir(), fname))
    start = grep("##[group]", log, fixed = TRUE)
    stop = grep("##[endgroup]", log, fixed = TRUE)
    if (length(start) == 0 | length(stop) == 0) {
      return(NULL)
    }
    n = mapply(function(start, stop) {
      ind = seq(start, stop)
      config = log[ind]
      config = sub("^.*Z ", "", config)
      config = config[grepl("^##\\[group\\]", config)]
      config = sub(".*\\[group\\]", "", config)
      config = trimws(config)
    }, start, stop, SIMPLIFY = TRUE)
    out = mapply(function(start, stop) {
      ind = seq(start, stop)
      config = log[ind]
      config = sub("^.*Z ", "", config)
      config = config[!grepl("^#", config)]
      config = fansi::strip_ctl(config)
      config = gsub("***", "<redacted>", config, fixed = TRUE)
    }, start, stop, SIMPLIFY = FALSE)
    names(out) = n
    out
  })
  names(out) = files$Name
  if (make_data_frame) {
    out = lapply(out, function(x) {
      x = lapply(x, function(r) {
        tibble::tibble(row = seq_len(length(r)),
                       value = r)
      })
      dplyr::bind_rows(x, .id = "step")
    })
    out = dplyr::bind_rows(out, .id = "name")
    out$name = dirname(out$name)
    out = tidyr::nest(out, config = c(step, row, value))
  }
  out
}

ga_run_r_versions = function(zipfile) {
  out = ga_run_log_config(zipfile)
}
