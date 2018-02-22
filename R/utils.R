
#' detect if a filepath is for a directory
#' @param x vector of file paths
#' @export
is_dir <- function(x) {
  isTRUE(file.info(x)$isdir)
}

#' source all .R files in a directory
#' @param path directory paths
#' @param trace Default = TRUE
#' @export
source_dir <- function(path, trace=TRUE, ...) {
  for(nm in list.files(path, pattern = "[.][Rr]$")){
    if(trace) cat(nm,":")
    source(file.path(path, nm), ...)
    if(trace) cat("\n")
  }
}
