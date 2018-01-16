#' initialize a project
#' @param path path to copy to, defaults to current working dir
#' @param template project template type, default: poppk_workflow
#' @export
init_project <- function(path = ".", template = "poppk_workflow") {
  
  project_folder <-  package_filepath(proj_type)
  if (project_folder == "") {
    stop(glue::glue("no report template detected for type:  {proj_type}"))
  }
  
  if (!dir.exists(path)) {
    dir.create(path, recursive = TRUE)
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
  # function should be renamed to something more appropriate: e.g. download_scripts
  # (too similar to make_project within tidyproject)
}

#' show report templates
#' @export
report_templates <- function(){
  fullList <- dir(package_filepath(), recursive = F) 
  # don't show package files
  templates <- 
    fullList[! fullList %in% 
               c("DESCRIPTION", "help", "html", "INDEX",
                 "Meta", "NAMESPACE", "R","ReadMeFiles")]
  return(templates)
}