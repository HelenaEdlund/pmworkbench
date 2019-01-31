#' @title Source all scripts in dir
#' @description Sources all .R/.r scripts in a directory
#' @param path Path to directory of files to source, Default: '.'
#' @param trace , Default: TRUE
#' @param ... other arguments to pass to source
#' @return 
#' @rdname source_dir
#' @export 

source_dir <- function(path = ".", trace=TRUE, ...){
  
  r_scripts <- list.files(path, pattern = "[.][Rr]$")
  
  if(length(r_scripts) == 0) {
    
    message("Provided path does not contain any R scripts")
    
  } else {
    
    for(files in r_scripts){
      if(trace) cat(files, ":")
      source(file.path(path, files), ...)
      if(trace) cat("\n")
    }
  }
}
