installMKL <- function(mklVersion) {
  sysname <- Sys.info()[["sysname"]]
  rArch <- .Platform$r_arch

  repodataBaseUrl <- "https://conda-static.anaconda.org/anaconda/%s/repodata.json"
  if (sysname == "Windows") {
    condaArch <- paste0("win-", ifelse(rArch == "x64", 64, 32))
  } else if (sysname == "Linux") {
    condaArch <- paste0("linux-", ifelse(rArch == "x64", 64, 32))
  } else if (sysname == "Darwin") {
    condaArch <- "osx-64"
  } else {
    stop("Sorry, your system,", sysname, ", is unsupported!")
  }

  tempDir <- tempdir()
  repodataJson <- file.path(tempDir, "repodata.json")
  cat("Download repodata...")
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
    cat(sprintf("Download %s.tar.gz from Anaconda repo...", v[3]))
    download.file(sprintf(downloadFileBaseUrl, v[3], v[2], condaArch, v[1]), bzFile, quiet = TRUE)
    destDir <- paste0(tempDir, "/", v[3])
    cat(sprintf("Untar %s.tar.gz and copy...", v[3]))
    untar(bzFile, exdir = destDir)
    if (grepl("include", v[3])) {
      file.copy(paste0(destDir, "/Library/include/"), "inst/include", recursive = TRUE)
    } else {
      file.copy(paste0(destDir, "/Library/bin/"), "inst/lib", recursive = TRUE)
    }
  })

  libDir <- paste(c("inst", "lib", if (nzchar(rArch)) rArch), collapse = "/")
  incDir <- "inst/include/mkl"
  file.rename("inst/include/include", incDir)
  file.rename("inst/lib/bin", libDir)
}
