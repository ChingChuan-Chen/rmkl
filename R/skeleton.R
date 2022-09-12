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
#' @export
rmkl.package.skeleton <- function(name = "anRpackage",
                                        list = character(),
                                        environment = .GlobalEnv,
                                        path = ".",
                                        force = FALSE,
                                        code_files = character(),
                                        example_code = TRUE) {

  env <- parent.frame(1)

  if (!length(list)) {
    fake <- TRUE
    assign("Rcpp.fake.fun", function() {}, envir = env)
  } else {
    fake <- FALSE
  }

  haveKitten <- requireNamespace("pkgKitten", quietly=TRUE)
  skelFunUsed <- ifelse(haveKitten, pkgKitten::kitten, package.skeleton)
  skelFunName <- ifelse(haveKitten, "kitten", "package.skeleton")
  message("\nCalling ", skelFunName, " to create basic package.")

  ## first let the traditional version do its business
  call <- match.call()
  call[[1]] <- skelFunUsed
  if (! haveKitten) {                 # in the package.skeleton() case
    if ("example_code" %in% names(call)) {
      call[["example_code"]] <- NULL    # remove the example_code argument
    }
    if (fake) {
      call[["list"]] <- "Rcpp.fake.fun"
    }
  }

  tryCatch(eval(call, envir = env),
           error = function(e) {
             cat(paste(e, "\n")) # print error
             stop(paste("error while calling `", skelFunName, "`", sep=""))
           })

  message("\nAdding rmkl settings")

  ## now pick things up
  root <- file.path(path, name)

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

  ## add a useDynLib to NAMESPACE,
  NAMESPACE <- file.path(root, "NAMESPACE")
  lines <- readLines(NAMESPACE)
  if (! grepl("useDynLib", lines)) {
    lines <- c(sprintf("useDynLib(%s)", name),
               "importFrom(Rcpp, evalCpp)",        ## ensures Rcpp instantiation
               lines)
    writeLines(lines, con = NAMESPACE)
    message(" >> added useDynLib and importFrom directives to NAMESPACE")
  }

  ## lay things out in the src directory
  src <- file.path(root, "src")
  if (!file.exists(src)) {
    dir.create(src)
  }
  man <- file.path(root, "man")
  if (!file.exists(man)) {
    dir.create(man)
  }
  skeleton <- system.file("skeleton", package = "rmkl")
  Makevars <- file.path(src, "Makevars")
  if (!file.exists(Makevars)) {
    file.copy(file.path(skeleton, "Makevars"), Makevars)
    message(" >> added Makevars file with rmkl settings")
  }

  if (example_code) {
    file.copy(file.path(skeleton, "rmkl_hello_world.cpp"), src)
    message(" >> added example src file using Intel MKL")
    file.copy(file.path(skeleton, "rmkl_hello_world.Rd"), man)
    message(" >> added example Rd file for using Intel MKL")

    Rcpp::compileAttributes(root)
    message(" >> invoked Rcpp::compileAttributes to create wrappers")
  }

  if (fake) {
    rm("Rcpp.fake.fun", envir = env)
    unlink(file.path(root, "R"  , "Rcpp.fake.fun.R"))
    unlink(file.path(root, "man", "Rcpp.fake.fun.Rd"))
  }

  invisible(NULL)
}
