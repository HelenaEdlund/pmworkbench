## Removed for now: will replace readMe with vignettes

# #' get the report readme docx file
# #' @param path path to copy to, defaults to current working dir
# #' @param proj_type project template type, default poppk_workflow
# #' @export
# get_report_readme <- 
#   function(path = ".", proj_type = "poppk_workflow"){
#   
#   packagePaths <- list.dirs(system.file(package = "xreport"), recursive = F)
#   readMePath <- packagePaths[stringr::str_detect(packagePaths, "ReadMeFiles")]
#   readMeName <- paste0(proj_type, "_readme.docx")
#   
#   availableProjTypes <- stringr::str_replace(list.files(readMePath), 
#                                      "_readme.docx", "")    
#   
#   # Check that read me exists 
#   if(!file.exists(file.path(readMePath, readMeName))){
#     stop(paste("No read me file found for the project type provided. Try: ", 
#                availableProjTypes))
#   }
#   
#   file.copy(from=file.path(readMePath, readMeName), 
#             to=file.path(path, readMeName))
#   
#   if(file.exists(file.path(path, readMeName))){
#     if(path == "."){
#       message(paste(readMeName, "has been downloaded to your current working directory"))      
#     }else{
#       message(paste(readMeName, "has been downloaded to, ", path))
#     }
#   }
# }