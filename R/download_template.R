# ------------------------
#  Download
# ------------------------

#' @title Download project templates
#' 
#' @description Downloads a set of template scripts for nlme projects in nonmem
#' 
#' @param path path to copy to, defaults to a 'Scripts' folder
#' @param proj_type type of project template, default poppk_workflow
#' @export
#' @return set of template R and Rmarkdown script files
#' @export 
#' @rdname template_download
#' @importFrom purrr map2

template_download <- 
  function(path = "./Scripts", proj_type = "poppk_workflow") {
  
  # Create folder if it does not exist
  if (!dir.exists(path)) {
    dir.create(path, recursive = TRUE)
  }
  
  project_folder <- system.file(proj_type, package = "pmworkbench")
  
  # error if selecting non-existing type
  if (project_folder == "") {
    stop(glue::glue("No template detected for type: {proj_type}"))
  }
  
  project_files <- dir(project_folder, recursive = TRUE)
  to_copy <- file.path(project_folder, project_files)
  to_path <- file.path(path, project_files)
  
  purrr::map2(to_copy, to_path, function(.from, .to) {
    dir_name <- dirname(.to)
    if (!dir.exists(dir_name)) {
      dir.create(dir_name, recursive = TRUE)
    }
    file.copy(.from, .to)
    })
  return(TRUE) 
  
  # Add more informative message here
  # Should we add some overwrite/check for exisiting files functionality?
}


#   if(file.exists(file.path(path, readMeName))){
#     if(path == "."){
#       message(paste(readMeName, "has been downloaded to your current working directory"))      
#     }else{
#       message(paste(readMeName, "has been downloaded to, ", path))
#     }
#   }


# ------------------------
#  Show available 
# ------------------------

#' @title Show available project templates
#' 
#' @description Show available project templates
#' 
#' @export
#' @return set of template R and Rmarkdown script files
#' @rdname template_available

template_available <- function(){
  # find all files in package
  fullList <- dir(system.file(package = "pmworkbench"), recursive = F) 
  
  # only show available template folders
  templates <- 
    fullList[! fullList %in% 
               c("DESCRIPTION", "help", "html", "INDEX",
                 "Meta", "NAMESPACE", "R","ReadMeFiles")]
  return(templates)
}
