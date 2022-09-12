## Copyright (C) 2022             Ching-Chuan Chen
##
## This file is part of rmkl.
##
## rmkl is free software: you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 2 of the License, or
## (at your option) any later version.
##
## rmkl is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with rmkl. If not, see <http://www.gnu.org/licenses/>.

#' @importFrom utils package.skeleton packageDescription
#' @importFrom Rcpp compileAttributes
#' @export
rmkl.package.skeleton <- function(
    name = "anRpackage",
    path = "."
) {
  if(!requireNamespace("pkgKitten")) {
    stop("You need to install R package pkgKitten before using rmkl.package.skeleton!")
  }

  if(!requireNamespace("roxygen2")) {
    stop("You need to install R package roxygen2 before using rmkl.package.skeleton!")
  }

  tryCatch(
    pkgKitten::kitten(name, path),
    error = function(e) {
      cat(paste(e, "\n")) # print error
      stop(paste("error while calling `", skelFunName, "`", sep=""))
    }
  )

  ## clean up
  root <- file.path(path, name)
  unlink(file.path(root, "man"), recursive = TRUE)
  file.remove(file.path(root, "R", "hello.R"))

  message("\nAdding rmkl settings")

  ## Add Rcpp to the DESCRIPTION
  DESCRIPTION <- file.path(root, "DESCRIPTION")
  if (file.exists(DESCRIPTION)) {
    x <- cbind(
      read.dcf(DESCRIPTION),
      "Imports" = sprintf("Rcpp (>= %s), rmkl",
                          packageDescription("Rcpp")[["Version"]],
                          packageDescription("rmkl")[["Version"]]),
      "LinkingTo" = "Rcpp, rmkl"
    )
    write.dcf(x, file = DESCRIPTION)
    message(" >> added Imports: Rcpp, rmkl")
    message(" >> added LinkingTo: Rcpp, rmkl")
  }

  ## Add package document
  pkgDoc <- file.path(root, "R", paste0(name, "-package.R"))
  message("\n >> Adding package document")
  lines <- c(
    "#' anRpackage-package",
    "#' @docType package",
    "#' @name rmkl-package",
    paste0("#' @useDynLib ", name),
    "#' @importFrom Rcpp evalCpp",
    "#' @importFrom rmkl CxxFlags",
    "#' @importFrom rmkl LdFlags",
    "NULL"
  )
  writeLines(lines, con = pkgDoc)
  message(" >> added useDynLib, importFrom and flags directives to NAMESPACE")

  ## lay things out in the src directory
  src <- file.path(root, "src")
  if (!file.exists(src)) {
    dir.create(src)
  }
  skeleton <- system.file("skeleton", package = "rmkl")

  ## add Makevars
  message(" >> added src/Makevars")
  Makevars <- file.path(src, "Makevars")
  lines <- c(
    'PKG_CXXFLAGS += $(shell "${R_HOME}/bin/Rscript" -e "rmkl::CxxFlags()")',
    'PKG_LIBS += $(shell "${R_HOME}/bin/Rscript" -e "rmkl::LdFlags()")'
  )
  writeLines(lines, con = Makevars)

  ## copy example codes
  file.copy(file.path(skeleton, "rmkl_hello_world.cpp"), src)
  message(" >> added example src file using Intel MKL")

  ## call Rcpp::compileAttributes to output cpp functions
  compileAttributes(root)
  message(" >> inoked Rcpp::compileAttributes to create wrappers")

  ## call roxygen2::roxygenize to output cpp functions
  roxygen2::roxygenize(root)
  message(" >> inoked roxygen2::roxygenize to generate documents")
  file.remove(file.path(root, "NAMESPACE"))
  roxygen2::roxygenize(root)

  invisible(NULL)
}
