#' Internal Code to Build, Load, and Render the sa Template
#'
#' A non-exported function used by Kelli F. Johnson to
#' build and load \pkg{sa4all} and copy and render the template
#' for a stock assessment document.
#'
#' @param dirgit A file path to where the sa4all repository is cloned.
#' @template authors
#' @author Kelli Faye Johnson
#'
doit <- function (dirgit = "~/_myods/sa4all",
  authors = c("James N. Ianelli" )) {
  oldwd <- getwd()
  on.exit(setwd(oldwd), add = TRUE)
  setwd(dirgit)
  devtools::build()
  if ("package:sa4all" %in% search()) pkgload::unload(package = "sa4all")
  utils::install.packages(utils::tail(n = 1,
    dir(dirname(dirgit), pattern = "sa4all_[0-9\\.]+\\.tar.gz",
      full.names = TRUE)),
    type = "source")
  library(sa4all)
  unlink("doc", recursive = TRUE)
  sa4all::draft(
    authors = authors,
    create_dir = TRUE
    )
  setwd("doc")
  bookdown::render_book("00a.Rmd", clean = FALSE)
}
