PMWORKBENCH
===========

**UNDER DEVELOPMENT**

R package serving as a repository for (sets of) template scripts:
includes a combination of .R, .Rmd and .Rwd files.

    library(pmworkbench)

Currently containing:

    template_available()

    ## [1] "latex_class_files"           "poppk_report_latex_doNotUse"
    ## [3] "poppk_workflow"

Download templates
------------------

Templates, including folder structures, are downloaded using
init\_project(). The templates are *not* executable files but to be seen
as a templates. Modifications and setup are needed.

Each project types have a read me documentation for what is required to
use that particular set, which can be downloaded with
get\_report\_readme().

Demo / tutorial
---------------

A demo of how the scripts work together is under development.

Planned expansions
------------------

Plans are to expand the set of templates as more people start using it.
Next analysis type will likely be QT analysis (workflow + report) and
then PK/PD analyses (probably stratified by therapeutic areas).
