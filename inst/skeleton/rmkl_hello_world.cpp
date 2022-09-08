// Copyright (C) 2010 - 2013 Dirk Eddelbuettel, Romain Francois and Douglas Bates
// Copyright (C) 2014        Dirk Eddelbuettel
// Copyright (C) 2017        Ching-Chuan Chen
// This file is part of rmkl.

// we only include rmkl.h which pulls Rcpp.h in for us
#include <rmkl.h>
#include <string>

// via the depends attribute we tell Rcpp to create hooks for
// rmkl so that the build process will know what to do
//
// [[Rcpp::depends(rmkl)]]

// simple example of creating two matrices and
// returning the result of an operatioon on them
//
// via the exports attribute we tell Rcpp to make this function
// available from R
//
// [[Rcpp::export]]
std::string rmkl_hello_world() {
  int len=198;
  char buf[198];
  mkl_get_version_string(buf, len);
  std::string mklVersionString(buf);
  return(mklVersionString);
}
