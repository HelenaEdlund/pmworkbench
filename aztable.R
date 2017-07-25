aztable <- function(dataframe, caption=NULL, label=NULL){
  table <- 
    dust(dataframe,
         longtable=T,
         hhline = T, 
         caption = caption, 
         label = label) %>% # label without the "tab:" (added automatically)
    sprinkle(part="head", bold=T, 
             border=c("top", "bottom"), 
             border_thickness=3, border_units="pt") %>% 
    sprinkle(row=nrow(dataframe), border=c("bottom"), 
             border_thickness=3, border_units="pt") %>% 
    sprinkle_print_method("latex")
  return(table)
  # To fix: 
  # automatically includes two additional linebreaks between caption and table - remove.
  # proably good to set a default for significant digits of numeric cols
  # border thickness does for some reason not work:  
  # Trying to update latex packages on cluster to see it that solves it
  # possibly make longtable optional to not break short tables
}
