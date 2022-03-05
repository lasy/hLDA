

.env <- new.env(parent = emptyenv())

# global reference to tomotopy (will be initialized in .onLoad)
sy <- NULL
tp <- NULL
np <- NULL

.onLoad <- function(libname, pkgname) {

  # use superassignment to update global reference
  if (reticulate::py_module_available("sys")) {
    sy <<- reticulate::import("sys", delay_load = TRUE)
  } else {
    packageStartupMessage("Python package 'sys' not found.")
  }
  if (reticulate::py_module_available("numpy")) {
    np <<- reticulate::import("numpy", delay_load = TRUE)
  } else {
    packageStartupMessage("Python package 'numpy' not found.")
  }
  if (reticulate::py_module_available("tomotopy")) {
    tp <<- reticulate::import("tomotopy", delay_load = TRUE)
  } else {
    packageStartupMessage("Python package 'tomotopy' not found.")
  }

  # Import utility functions
  fit_hLDA_path <- system.file("python", package = "hLDA")
  .env$fit_hLDA <- reticulate::import_from_path("fit_hLDA",
                                                fit_hLDA_path,
                                                delay_load = TRUE)

  # system.file("python", "fit_hLDA.py", package = "hLDA") %>%
  #   reticulate::source_python(., envir = .env)
}
