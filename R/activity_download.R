# ------------------------
#  Download
# ------------------------

#' @title Download activity
#' @description Downloads a set of template scripts for pmx activities
#' @param path path to copy to, defaults to a 'Scripts' folder
#' @param activity_type type of activity, default poppk
#' @param overwrite PARAM_DESCRIPTION, Default: FALSE
#' @return A set of template script files for the specified activity
#' @rdname activity_download
#' @export 
#' @importFrom glue glue
#' @importFrom crayon red blue
#' @importFrom purrr map

activity_download <- function(path = "./Scripts",
                              activity_type = "poppk",
                              overwrite = FALSE) {
    
    project_folder <- package_filepath(activity_type)
    if (project_folder == "") {
      stop(glue::glue("No activity detected for type:  {activity_type},
                      check available via `activity_available()`"))
    }
    
    if (dir.exists(path) && !overwrite) {
      if(length(list_files(path))) {
        stop_failure("Files already detected in folder ", 
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
    
    # Messages for successful downloads/progress
    purrr::map(to_dirs, mkdirp)
    done("Directory structure created")

    file.copy(to_copy, to_path)
    done("Files copied")
    
    done(crayon::blue(activity_type), " files available at ", crayon::blue(path) )
    return(TRUE) 
  }
