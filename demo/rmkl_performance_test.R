# Copyright (C) 2022        Ching-Chuan Chen
#
# This file is part of rmkl.
#
# rmkl is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# rmkl is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with rmkl. If not, see <http://www.gnu.org/licenses/>.

# require packages
require(Rcpp)
require(rmkl)

# install required package - RcppEigen
if (!require("RcppEigen")) {
  install.packages("RcppEigen")
}

# install required package - microbenchmark
if (!require("microbenchmark")) {
  install.packages("microbenchmark")
}
require(microbenchmark)

# compile a function to do matrix multiplication in RcppEigen
sourceCpp(code = "#include <RcppEigen.h>
// [[Rcpp::depends(RcppEigen)]]
// [[Rcpp::export]]
Eigen::MatrixXd eigenMatProd(const Eigen::Map<Eigen::MatrixXd> A, Eigen::Map<Eigen::MatrixXd> B){
  return A*B;
}")

# compile a function to do matrix multiplication in RcppArmadillo
sourceCpp(code = "#include <RcppArmadillo.h>
// [[Rcpp::depends(RcppArmadillo)]]
// [[Rcpp::export]]
arma::mat armaMatProd(const arma::mat & x, const arma::mat & y) {
  return x * y;
}")

# compile a function to do matrix multiplication in RcppArmadillo with cblas from rmkl
sourceCpp(code = "#include <rmkl.h>
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
}")

# generate data
x <- matrix(rnorm(1e5), 500, 200)
z <- matrix(rnorm(1e5), 200, 500)
all.equal(mkl_cblas_dgemm(x, z), x %*% z)
all.equal(mkl_cblas_dgemm(x, z), fMatProd(x, z))

# run benchmark
microbenchmark(
  `R Vanilla BLAS` = x %*% z,
  `RcppEigen` = eigenMatProd(x, z),
  `RcppArmadillo` = armaMatProd(x, z),
  `rmkl-RcppArmadillo` = fMatProd(x, z),
  `rmkl-cblas` = mkl_cblas_dgemm(x, z),
  times = 100L
)
