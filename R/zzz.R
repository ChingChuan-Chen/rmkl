## Copyright (C) 2014-2022        JJ Allaire, Romain Francois, Kevin Ushey, Gregory Vandenbrouck
## Copyright (C) 2022             Ching-Chuan Chen
##
## This file is based on zzz.R from RcppParallel.
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

.dllInfo               <- NULL
.iomp5DllInfo          <- NULL
.mklRtDllInfo          <- NULL
.mklCoreDllInfo        <- NULL
.mklIntelThreadDllInfo <- NULL
.mklIntelLp64DllInfo   <- NULL

loadMklLibrary <- function(name) {
  if (Sys.info()[["sysname"]] == "Windows" && name == "iomp5md") {
    name <- paste0("lib", name)
  }

  path <- mklLibraryPath(name)
  if (is.null(path))
    return(NULL)

  if (!file.exists(path)) {
    warning("Intel MKL library", shQuote(name), "not found.")
    return(NULL)
  }

  dyn.load(path, local = FALSE, now = TRUE)
}

.onLoad <- function(libname, pkgname) {
  is_windows <- Sys.info()[["sysname"]] == "Windows"

  # load dll files
  iomp5DllName <- ifelse(is_windows, "iomp5md", "iomp5")
  .iomp5DllInfo <<- loadMklLibrary(iomp5DllName)
  .mklRtDllInfo <<- loadMklLibrary("mkl_rt")

  if (!is_windows){
    # Append MKL so files path in Linux
    pkgLibPath <- system.file("lib", package = "rmkl")
    linuxLocalRenv <- paste0(normalizePath("~/"), "/.Renviron")
    if (!grepl(pkgLibPath, Sys.getenv("LD_LIBRARY_PATH"))) {
      Sys.setenv(LD_LIBRARY_PATH=paste0(pkgLibPath, ":", Sys.getenv("LD_LIBRARY_PATH")))
    }
    cat("If you want to use this package with RStudio in UNIX, please check the document at GitHub:\n")
    cat("\thttps://github.com/ChingChuan-Chen/rmkl/blob/main/README.md")
  } else {
    # Unable to load these files on Linux since the inter-dependency
    .mklCoreDllInfo        <<- loadMklLibrary("mkl_core")
    .mklIntelThreadDllInfo <<- loadMklLibrary("mkl_intel_thread")
    .mklIntelLp64DllInfo   <<- loadMklLibrary("mkl_intel_lp64")
  }

  .dllInfo <<- library.dynam("rmkl", pkgname, libname)
}

.onUnLoad <- function(libpath) {
  if (!is.null(.dllInfo))
    library.dynam.unload("rmkl", libpath)

  if (Sys.info()[["sysname"]] == "Windows") {
    if (!is.null(.mklIntelLp64DllInfo))
      dyn.unload(.mklIntelLp64DllInfo[["path"]])

    if (!is.null(.mklIntelThreadDllInfo))
      dyn.unload(.mklIntelThreadDllInfo[["path"]])

    if (!is.null(.mklCoreDllInfo))
      dyn.unload(.mklCoreDllInfo[["path"]])
  }

  if (!is.null(.mklRtDllInfo))
    dyn.unload(.mklRtDllInfo[["path"]])

  if (!is.null(.iomp5DllInfo))
    dyn.unload(.iomp5DllInfo[["path"]])
}
