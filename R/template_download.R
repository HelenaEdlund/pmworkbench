# ------------------------
#  Download
# ------------------------

#' @title Download project templates
#' 
#' @description Downloads a set of template scripts for nlme projects in nonmem
#' 
#' @param path path to copy to, defaults to a 'Scripts' folder
#' @param template_type type of project template, default poppk_workflow
#' @return set of template R and Rmarkdown script files
#' @export 
#' @rdname template_download
#' @importFrom purrr map discard

template_download <- function(path = "./Scripts",
                              template_type = "poppk_workflow",
                              overwrite = FALSE) {
    
    project_folder <- package_filepath(template_type)
    if (project_folder == "") {
      stop(glue::glue("No template detected for type:  {template_type},
                      check available via `template_available()`"))
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
    done("Template files copied")
    
    done(crayon::blue(template_type), " templates available at ", crayon::blue(path) )
    return(TRUE) 
  }
