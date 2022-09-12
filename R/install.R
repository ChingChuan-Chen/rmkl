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

installMKL <- function(mklVersion) {
  sysname <- Sys.info()[["sysname"]]
  rArch <- .Platform$r_arch

  if (file.exists("inst/include/mkl/mkl.h")) {
    if (sysname == "Windows" && file.exists("inst/lib/x64/mkl_core.2.dll") &&
        file.exists("inst/lib/x64/libiomp5md.dll")) {
      return(NULL)
    } else if (sysname != "Windows" && file.exists("inst/lib/libmkl_core.so.2") &&
               file.exists("inst/lib/libiomp5.so")) {
      return("mkl libraries are downloaded.")
    }
  }

  repodataBaseUrl <- "https://conda-static.anaconda.org/anaconda/%s/repodata.json"
  if (sysname == "Windows") {
    condaArch <- paste0("win-", ifelse(rArch == "x64", 64, 32))
    if (!dir.exists("inst/lib")) {
      dir.create("inst/lib")
    }
  } else if (sysname == "Linux") {
    condaArch <- "linux-64"
  } else if (sysname == "Darwin") {
    condaArch <- "osx-64"
  } else {
    stop("Sorry, your system,", sysname, ", is unsupported!")
  }

  tempDir <- tempdir()
  repodataJson <- file.path(tempDir, "repodata.json")
  cat("Download repodata...\n")
  download.file(sprintf(repodataBaseUrl, condaArch), repodataJson, quiet = TRUE)

  extractSubstring <- function(str, pattern, general=FALSE) {
    if (general) {
      regmatches(str, gregexpr(pattern, str))[[1]]
    } else {
      regmatches(str, regexpr(pattern, str))
    }
  }

  repodata <- paste0(readLines(repodataJson), collapse = "\n")
  mklPkg <- extractSubstring(repodata, sprintf('"mkl-%s[^"]+":\\s+\\{[^\\}]+\\}', mklVersion), TRUE)
  mklIncPkg <- extractSubstring(repodata, sprintf('"mkl-include-%s[^"]+":\\s+\\{[^\\}]+\\}', mklVersion), TRUE)
  intelOmpPkg <- extractSubstring(repodata, sprintf('"intel-openmp-%s[^"]+":\\s+\\{[^\\}]+\\}', mklVersion), TRUE)

  fnPattern <- '"[^:]+'
  versionPattern <- '"version":\\s+"[^"]+"'
  pkgMat <- do.call(rbind, lapply(c(mklPkg, mklIncPkg, intelOmpPkg), function(i) {
    gsub('version|:|"| ', "", c(extractSubstring(i, fnPattern), extractSubstring(i, versionPattern)))
  }))

  if (nrow(pkgMat) > 3) {
    versionCnts <- tapply(rep(1, nrow(pkgMat)), pkgMat[,2], sum)
    downloadVersion <- max(names(versionCnts[versionCnts == 3]))
  } else {
    downloadVersion <- pkgMat[1, 2]
  }

  downloadFns <- pkgMat[pkgMat[,2] == downloadVersion, ]
  downloadFns <- cbind(downloadFns, gsub("-[0-9\\.]+-[^\\.]+.tar.bz2", "", downloadFns[, 1]))

  downloadFileBaseUrl <- "https://anaconda.org/anaconda/%s/%s/download/%s/%s"
  apply(downloadFns, 1, function(v){
    bzFile <- file.path(tempDir, paste0(v[3], ".tar.bz2"))
    cat(sprintf("Download %s from Anaconda repo...\n", v[1]))
    download.file(sprintf(downloadFileBaseUrl, v[3], v[2], condaArch, v[1]), bzFile, quiet = TRUE)
    destDir <- paste0(tempDir, "/", v[3])
    cat(sprintf("Untar %s and copy...\n", v[1]))
    untar(bzFile, exdir = destDir)
    if (sysname != "Windows") {
      Sys.chmod(list.dirs(destDir), "777")
      f <- list.files(destDir, all.files = TRUE, full.names = TRUE, recursive = TRUE)
      Sys.chmod(f, (file.info(f)$mode | "664"))
    }
    if (grepl("include", v[3])) {
      if (sysname == "Windows") {
        file.copy(paste0(destDir, "/Library/include/"), "inst/include", recursive = TRUE)
      } else {
        file.copy(paste0(destDir, "/include/"), "inst/include", recursive = TRUE)
      }
    } else {
      if (sysname == "Windows") {
        file.copy(paste0(destDir, "/Library/bin/"), "inst/lib", recursive = TRUE)
      } else {
        file.copy(paste0(destDir, "/lib"), "inst", recursive = TRUE)
      }
    }
  })

  cat("Copy and rename include folder...\n")
  incDir <- "inst/include/mkl"
  unlink(incDir, recursive = TRUE)
  file.rename("inst/include/include", incDir)

  if (sysname == "Windows") {
    cat("Copy and rename lib folder...\n")
    libDir <- paste(c("inst", "lib", if (nzchar(rArch)) rArch), collapse = "/")
    unlink(libDir, recursive = TRUE)
    file.rename("inst/lib/bin", libDir)
  }
}
