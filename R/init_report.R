#' initialize a project
#' @param path path to copy to, defaults to current working dir
#' @param template project template type, default: poppk_workflow
#' @param 
#' @importFrom purrr discard
#' @export
init_project <- function(path = ".", template = "poppk_workflow",  overwrite = FALSE) {
  
  project_folder <-  package_filepath(template)
  if (project_folder == "") {
    stop(glue::glue("no template detected for type:  {proj_type}, 
                    check available via `pmworkbench_templates()`"))
  }
  
  if (dir.exists(path) && !overwrite) {
    if(length(list_files(path))) {
      stop_failure("files already detected in folder ", 
              crayon::red(path), 
              ", set overwrite = TRUE to overwrite")
    }
  }
  
  if (!dir.exists(path)) {
    mkdirp(path)
  }
  
  project_files <- list_files(project_folder) %>%
    discard(is_dir)
  to_copy <- file.path(project_folder, project_files)
  to_path <- file.path(path, project_files)
  
  to_dirs <- unique(dirname(to_path)) %>% discard(~ .x == ".") 
  
  purrr::map(to_dirs, mkdirp)
  done("directory structure created")
  
  
  file.copy(to_copy, to_path)
  done("template files copied")
  
  done("template ", crayon::blue(template), " available at ", crayon::blue(path) )
  return(TRUE) 
  
  # Add more informative message here
  # Should we add some overwrite/check for exisiting files functionality?
  # function should be renamed to something more appropriate: e.g. download_scripts
  # (too similar to make_project within tidyproject)
}

#' show report templates
#' @export
pmworkbench_templates <- function(){
  fullList <- dir(package_filepath(), recursive = F) 
  # don't show package files
  templates <- 
    fullList[! fullList %in% 
               c("DESCRIPTION", "help", "html", "INDEX",
                 "Meta", "NAMESPACE", "R","ReadMeFiles")]
  return(templates)
}