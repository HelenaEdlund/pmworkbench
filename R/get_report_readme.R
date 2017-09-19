#' get the report readme docx file
#' @param path path to copy to, defaults to current working dir
#' @export
get_report_readme <- function(path = ".") {
  file.copy(system.file("report.template.read.me.docx", package = "azreport"), 
            file.path(path, "report.template.read.me.docx"))
}