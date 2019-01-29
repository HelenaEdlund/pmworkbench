PMWORKBENCH
=======

**UNDER DEVELOPMENT**

This package provides template scripts for pharmacometric workflows in R. 


```r
library(pmworkbench)
```

Currently containing: 

```r
template_available()
```

```
## [1] "latex_class_files"           "poppk_report_latex_doNotUse"
## [3] "poppk_workflow"
```

## Download templates
Each project type have a read me documentation for what is required to use that particular set, which can be downloaded with get_report_readme(). 

## Demo / tutorial
A demo of how the scripts work together is under development.

## Planned expansions
Plans are to expand the set of templates as more people start using it. Next analysis type will likely be QT analysis (workflow + report) and then PK/PD analyses (probably stratified by therapeutic areas). 

## Available templates

### Pop PK workflow
The provided workflows include a combination of .R, .Rmd and .Rwd files. They integrate Nonmem, PSN and R packages for pharmacometrics.

Templates, including folder structures, are downloaded using init_project(). The templates are *not* executable files but to be seen as templates. Modifications and setup are needed. 
