# Workbench developers' notebook

## Workbench functionality

### Todo
- [ ] Add a readme file for developers. Mention in .Rbuildignore

- [x] Delete packagify branch. 

- [ ] Add NEWS file (for between releases)

- [x] Decide on either .Md or .html for the README file. The rest of the README files should be listed in .Rbuildignore. Philip: Done. Using .md.

- [ ] Cleanup workflows "latex_class_files", "poppk_report_latex_doNotUse". I guess we should have a structure like inst/workflows/stable inst/workflows/devel, and inst/workflows/stale or something. Helena: yes please

### Download_template:
- [ ] The test whether there is anything in the destination dir is unnecessarily rigid. It will be annoying in a lot of cases. I suggest creating all the destination file names and check whether any of these exist. If so, give an error and tell user which ones were found. 

- [x] Template_available should be moved to its own file. I wouldn't expect to find other functions in download_template.R than download_template due to the name of the file. Helena: Done.

- [ ] Definition of workflows. Guide to how to create one / contribute to the package.

### Tests 
- [ ] Basically no tests added so far...

- [ ] How do we go about with testing of the template scripts? Standard testing frame work will not work.. 


## poppk_workflow

### Todo

- [ ] Look at and potentially incorporate EDA sections from Nuria

- [ ] re-think model evaluation script using parameter based .Rmd files.

- [ ] include vpc examples? Other simulation examples?

#### List_directories
- [ ] I suggest shortening names. Is what is created with the
     templates an activity? Then I suggest adirs$scripts to be a
     function(...)  file.path("path/to/scripts",...). Then I would use
     it! Helena: Ok, sure, let's discuss how to get that to work better.
	 
- [ ] Define the list first, then do a an lapply(list,
     assign(...)). This is just to not having to check that we
     remember all of them. Make sure to define things - but only once!
     Status: philip to implement

- [ ] I don't understand what the user is supposed to use the function
for. Why not just define directories (which I suggest to call adirs or
something short in line with other names)?

#### Setup03_variables.R
- [ ] Decision on whether to save setup. 
Philip: Should create just one object saved to an rds, not an RData. Why save all the potential crap that the user may have in their workspace? 
Helena: Yeah. I think that entire save command can actually be deleted actually. The file is short and can be sourced in the others anyway. 

- [ ] Philip: We should consider commenting out some of this. So that the user can easily include if wanted, but so that it isn't there and being wrong by default. If the latter is the case, we are introducing a tasks rather than help to the user. Helena: Ok, let's discuss 

#### Bugs
- [ ] poppk_workflow/s02_data_review.R: Check the units in BEGFR calculations in poppk_workflow/s02_data_review.R

- [ ] poppk_workflow/s02_data_review.R: TADF and TAPD shift calculations not working... (collapse_unique not outputting a logical)

- [ ] poppk_workflow/s02_data_review.R II vs Freq scrips for chekcing unexpected changes - cannot use collapse_unique. try with distict insted. 


## Discussion
### General
-	Philip: I fear there is something wrong with the use of relative paths to
working dir. What is the point in not demanding a path relative to at
least QCP_MODELING? I fear that by not wanting to deal with anything
that looks like an absolute path, it is assumed that the user knows
how things should be done? What if the working dir is wrong, say from
another project that the user was working on earlier that day? I
believe we should have an internal package residing in QCP_MODELING
that gives this kind of addresses and a function that points to
addresses in our file system. Then the user must once and for all
declare a path relative to QCP_MODELING. And then, that can be changed
that one place if it should change in the future. Let's discuss, there
are some upcoming changes to the infrastructure so we will not have
the QCP_modeling structure I believe. We should have a solution that
works for the new setting. 


## Howto
- convert README.Rmd to README.md
knit("README.Rmd")


## poppk_reporting_latex

### Template text and figures
 - [] Merging in the code from R markdown acalabrutinib to latex example? Or to workflow?  
 - [] Update the template with help from Johanna and Dinko

### Latex class files
	- [] Update to new AZ housestyle
	- [] Generate non AZ style (with functions but without the formatting)
	- [] Check again if humannat is working. Write own bib style?
