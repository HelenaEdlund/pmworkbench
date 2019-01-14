#directories at activity level
# do not remove the leading ".", it will cause problems with latex/knitr)

scripts_dir <- file.path(".", "scripts")
derived_data_dir <- file.path(".", "derived_data")
model_dir <- file.path(".", "models")
report_dir <- file.path(".", "report")
results_dir <- file.path(".", "results")
sim_dir <- file.path(".", "simulations")
source_data_dir <- file.path(".", "source_data")

##sub-directories
#script_dir
setup_dir <- file.path(scripts_dir, "setup")
functions_dir <- file.path(scripts_dir, "functions")

#model_dir
base_model_dir <- file.path(model_dir, "base_model")
covariate_model_dir <- file.path(model_dir, "covariate_model")

#result_dir
res_other_dir <- file.path(results_dir, "other")
res_eda_dir <- file.path(results_dir, "exploratory_data_analysis")
res_base_model_dir <- file.path(results_dir, "base_model")
res_cov_model_dir <- file.path(results_dir, "covariate_model")

#report_dir
rep_setup_dir <- file.path(report_dir, "setup")
rep_sections_dir <- file.path(report_dir, "sections")
rep_appendicies_dir <- file.path(report_dir, "appendices")
rep_images_dir <- file.path(report_dir, "images")

##list_all_directories
all_dir <-
  list(
    scripts_dir = scripts_dir,
    derived_data_dir = derived_data_dir,
    model_dir = model_dir,
    report_dir = report_dir,
    results_dir = results_dir,
    sim_dir = sim_dir,
    source_data_dir = source_data_dir,
    setup_dir = setup_dir,
    functions_dir = functions_dir,
    base_model_dir = base_model_dir,
    covariate_model_dir = covariate_model_dir,
    res_other_dir = res_other_dir,
    res_eda_dir = res_eda_dir,
    res_base_model_dir = res_base_model_dir,
    res_cov_model_dir = res_cov_model_dir,
    rep_setup_dir = rep_setup_dir,
    rep_sections_dir = rep_sections_dir,
    rep_appendicies_dir = rep_appendicies_dir,
    rep_images_dir = rep_images_dir
  )


lapply(all_dir, xpmworkbench::mkdirp)

# return all directories as the value 
all_dir
