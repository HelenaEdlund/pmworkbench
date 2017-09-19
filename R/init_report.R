#' initialize a project
#' @param path path
#' @param proj_type project template type, default poppk
#' @export
init_project <- function(path = ".", proj_type = "poppk") {
  if (!dir.exists(path)) {
    dir.create(path, recursive = TRUE)
  }
  project_folder <-  system.file(proj_type, package = "xreport")
  if (project_folder == "") {
    stop(glue::glue("no report template detected for type:  {proj_type}"))
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
}

#' show report templates
#' @export
report_templates <- function() {
  dir(system.file(package = "xreport")) 
}