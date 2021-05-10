#' Create a \pkg{sa4all} Draft Containing Directories and Files
#'
#' Create a directory with files needed for a stock assessment
#' document written with \pkg{sa4all}.
#' 
#' @details
#' Along with specifying some initial inputs, such as
#' authors and species, this code is a wrapper for \code{\link[rmarkdown]{draft}()}.
#' Users should focus on the input arguments that come before \code{type}
#' because these will be specific to your stock assessment and are used to
#' set up the initial file structure.
#'
#' @template authors
#' @template species
#' @template latin
#' @template coast
#' @param type The name of the template you want to copy from those available
#' within \pkg{sa4all}. See the function call for available options, where the
#' first listed will be used for the default. "sa" defaults to PFMC outline, "ak" defaults
#' that for the NPFMC SAFE report style.
#' @param create_dir code{FALSE} uses the current working directory for the template.
#' \code{TRUE} will create a new directory and \code{"default"}, which is the
#' default of \code{\link[rmarkdown]{draft}()}, leaves it up to the package to
#' determine.
#' @param edit A logical value, with a default of \code{FALSE}, specifyi tong if
#' you want the main file opened for editing by default. The software chosen
#' by R is normally not ideal and the file isn't one normally edited by users,
#' which is why \pkg{sa4all} doesn't use the default value of
#' \code{\link[rmarkdown]{draft}}.
#' @param ... Additional arguments that you wish to pass to
#' \code{\link[rmarkdown]{draft}}. See \code{args(rmarkdown::draft)}
#'
#' @return Invisibly returns the file name of the document,
#' which will be the main indexing file that links to the auxiliary files.
#' If \code{edit = TRUE}, this file will also be opened for editing.
#' @examples
#' \dontrun{
#' sa4all::draft()
#' }
#' @export
#' @seealso
#' See \code{\link[rmarkdown]{draft}}.
#' @author Kelli Faye Johnson
#'
draft <- function(
  authors,
  species="Walleye pollock",
  latin="Theragra chalcogrammus",
  coast="Eastern Bering Sea",
  type = c("sa","ak"),
  create_dir = FALSE,
  edit = FALSE,
  ...) {
  type <- match.arg(type, several.ok = FALSE)

  filename <- rmarkdown::draft("doc.Rmd",
  template = type,
  package = "sa4all",
  create_dir = create_dir,
  edit = edit,
  ...)

  newname <- gsub("doc.Rmd", "00a.Rmd", filename)
  file.rename(filename, newname)
  thedir <- dirname(newname)
  write_title(species = species, latin = latin, coast = coast,
    fileout = file.path(thedir, formals(write_title)$fileout))
  write_authors(authors,
    fileout = file.path(thedir, formals(write_authors)$fileout))
  spp <- species
  spp.sci <- latin
  save(spp, spp.sci, coast, authors,
    file = file.path(thedir, "00opts.Rdata"))

  return(invisible(newname))
}
