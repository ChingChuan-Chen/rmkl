## Copyright (C) 2010 - 2013 Dirk Eddelbuettel, Romain Francois and Douglas Bates
## Copyright (C) 2014        Dirk Eddelbuettel
## Copyright (C) 2022        Ching-Chuan Chen
##
## This file is based on flags.R and inline.R from RcppParallel, RcppArmadillo and RcppEigen.
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

mklCxxFlags <- function() {
  pkgIncDir <- system.file("include", package = "rmkl")
  paste0("-I", pkgIncDir, " -I", pkgIncDir, "/mkl")
}

mklLdFlags <- function() {
  linkLibs <- if(Sys.info()[["sysname"]] == "Windows") {
    "-lmkl_intel_thread.2 -lmkl_rt.2 -lmkl_core.2 -liomp5mp"
  } else {
    "-lmkl_intel_thread -lmkl_rt -lmkl_core -liomp5mp"
  }
  sprintf("-L%s %s", mklRoot(), linkLibs)
}

LdFlags <- function(){
  cat(mklLdFlags())
}

CxxFlags <- function(){
  cat(mklCxxFlags())
}

#' @importFrom Rcpp Rcpp.plugin.maker
inlineCxxPlugin <-  function() {
  getSettings <- Rcpp.plugin.maker(
    include.before = "#include <rmkl.h>",
    libs = "$(FLIBS)",
    package = c("rmkl", "Rcpp")
  )
  settings <- getSettings()
  settings$env$PKG_CXXFLAGS <- paste(settings$env$PKG_CXXFLAGS, mklCxxFlags())
  settings$env$PKG_LIBS <- paste(settings$env$PKG_LIBS, mklLdFlags())
  return(settings)
}
