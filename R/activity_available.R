# ------------------------
#  Show available 
# ------------------------

#' @title Show available activities
#' @description Show available activities
#' @param devel (Logical) Show activities currently under development, Default: FALSE
#' @return Character string of the activities available
#' @rdname activity_available
#' @export 

activity_available <- function(devel = FALSE){
  
  if(!is.logical(devel)){
    message(devel, "is not a logical. Ignored.")
    devel <- FALSE
  }

  # find stable activities
  if(!devel){
    
    activities <- dir(package_filepath("activity_templates_stable"), recursive = F) 
  
  } else {
    
    activities <- dir(package_filepath("activity_templates_devel"), recursive = F)

  }
  
  return(activities)
}
