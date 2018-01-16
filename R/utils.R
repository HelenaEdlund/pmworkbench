
#' detect if a filepath is for a directory
#' @param x vector of file paths
#' @export
is_dir <- function(x) {
  isTRUE(file.info(x)$isdir)
}

#' get a file or dir from a the package
#' @param ... parameters to pass to system.file
#' @details
#' a light wrapper around system.file
package_filepath <- function(...) {
  system.file(..., package = "xpmworkbench")
}
