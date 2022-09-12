// Copyright (C) 2022        Ching-Chuan Chen
//
// This file is part of rmkl.
//
// rmkl is free software: you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 2 of the License, or
// (at your option) any later version.
//
// rmkl is distributed in the hope that it will be useful, but
// WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with rmkl. If not, see <http://www.gnu.org/licenses/>.

#include <rmkl.h>
#include <mkl_cblas.h>
#include <RcppArmadillo.h>

// [[Rcpp::depends(rmkl)]]
// [[Rcpp::depends(RcppArmadillo)]]
// [[Rcpp::export]]
arma::mat mkl_cblas_dgemm(const arma::mat & x, const arma::mat & y) {
  double alpha = 1, beta = 0.0;
  arma::mat output(x.n_rows, y.n_cols, arma::fill::zeros);
  cblas_dgemm(
    CblasColMajor, CblasNoTrans, CblasNoTrans,
    x.n_rows, y.n_cols, x.n_cols, alpha, x.memptr(), x.n_rows, y.memptr(), y.n_rows,
    beta, output.memptr(), x.n_rows
  );
  return output;
}

/* R Testing Script
sourceCpp("link_mkl_cblas.cpp")
x <- matrix(rnorm(1e5), 500, 200)
z <- matrix(rnorm(1e5), 200, 500)
all.equal(mkl_cblas_dgemm(x, z), x %*% z)
all.equal(mkl_cblas_dgemm(x, z), fMatProd(x, z))

if (require("microbenchmark")) {
  library(microbenchmark)
  microbenchmark(
    default = x %*% z,
    arma = fMatProd(x, z),
    cblas = mkl_cblas_dgemm(x, z),
    times = 100L
  )
}
*/
