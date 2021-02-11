#' Extract Log Configuration
#'
#' @param zipfile Log zip file from [ga_run_download_log]
#'
#' @return A list of character vectors
#' @export
#'
#' @examples
#' zipfile = ga_run_download_log("r-lib", "actions",  "551409765")
#' config = ga_run_log_config(zipfile)
ga_run_log_config = function(zipfile) {
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
  out
}
