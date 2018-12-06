# ------------------------
#  Pipe
# ------------------------

#' Pipe operator
#'
#' See \code{magrittr::\link[magrittr]{\%>\%}} for details.
#'
#' @name %>%
#' @rdname pipe
#' @keywords internal
#' @export
#' @importFrom magrittr %>%
#' @usage lhs \%>\% rhs
NULL

# ------------------------
#  Detect if a filepath is a directory
# ------------------------

#' detect if a filepath is for a directory
#' @param x vector of file paths
#' @export
is_dir <- function(x) {
  isTRUE(file.info(x)$isdir)
}

# ------------------------
#  Source all .R files in a directory
# ------------------------

#' Source all .R files in a directory
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
