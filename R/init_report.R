#' initialize a project
#' @param path path
#' @export
init_project <- function(path = ".") {
  if (!dir.exists(path)) {
    dir.create(path, recursive = TRUE)
  }
  project_folder <-  system.file("report_folder_structure", package = "azreport")
  project_files <- dir(project_folder, recursive = TRUE)
  to_copy <- file.path(project_folder, project_files)
  to_path <- file.path(path, project_files)
  purrr::map2(to_copy, to_path, function(.from, .to) {
    dir_name <- dirname(.to)
    if (!dir.exists(dir_name)) {
      dir.create(dir_name)
    }
    file.copy(.from, .to)
    })
  return(TRUE)
}