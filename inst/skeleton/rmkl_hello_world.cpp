// Copyright (C) 2010 - 2013 Dirk Eddelbuettel, Romain Francois and Douglas Bates
// Copyright (C) 2014        Dirk Eddelbuettel
// Copyright (C) 2022        Ching-Chuan Chen
// This file is part of rmkl.

#include <rmkl.h>
#include <string>

//' Hello World Function for rmkl
//'
//' @return The version of Intel MKL
//' @examples
//' rmkl_hello_world()
//' @export
// [[Rcpp::export]]
std::string rmkl_hello_world() {
  int len=198;
  char buf[198];
  mkl_get_version_string(buf, len);
  std::string mklVersionString(buf);
  return(mklVersionString);
}
