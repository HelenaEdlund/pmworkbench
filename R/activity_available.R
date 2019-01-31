# ------------------------
#  Show available 
# ------------------------

#' @title Show available activities
#' @description Show available activities
#' @param show_devel (Logical) Show activities currently under development, Default: FALSE
#' @return Character string of the activities available
#' @rdname activity_available
#' @export 

activity_available <- function(show_devel = FALSE){
  
  if(!is.logical(show_devel)){
    message(show_devel, "is not a logical. Ignored.")
    show_devel <- FALSE
  }
  
  # find stable activities
  if(!show_devel){
    
    activities <- dir(file.path(
      system.file(package = "pmworkbench"), "activity_templates_stable"), recursive = F) 
  } else {
    
    activities <- dir(file.path(
      system.file(package = "pmworkbench"), "activity_templates_devel"), recursive = F) 
  }
  
  return(activities)
}
