## Copyright (C) 2022        Ching-Chuan Chen
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

#' `rmkl` Package
#'
#' The `rmkl` package aims to empower R with Intel MKL like Microsoft R Open (MRO)
#' by leveraging the conda packages, `mkl`, `mkl-include` and `intel-openmp`.
#' However, it does not like MRO or `ropenblas` to directly affect R functions.
#' `rmkl` aims to act like a plug-in for R users and support dynamic linkage for Rcpp users.
#' `rmkl` supports windows/OS X/Linux.
#'
#' @docType package
#' @name rmkl-package
#' @importFrom Rcpp evalCpp
NULL
