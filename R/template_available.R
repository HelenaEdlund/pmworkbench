# ------------------------
#  Show available 
# ------------------------

#' @title Show available project templates
#' 
#' @description Show available project templates
#' 
#' @return set of template R and Rmarkdown script files
#' @rdname template_available
#' @export

activity_available <- function(){
  # find all files in package
  fullList <- dir(system.file(package = "pmworkbench"), recursive = F) 
  
  # only show available activity folders
  activities <- 
    fullList[! fullList %in% 
               c("DESCRIPTION", "help", "html", "INDEX",
                 "Meta", "NAMESPACE", "R")]
  return(activities)
}
