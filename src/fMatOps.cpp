// Copyright (C) 2022             Ching-Chuan Chen
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
#include <RcppArmadillo.h>
#include <string>

//' Functions to use MKL to do the matrix calculations
//'
//' @param x,y matrices
//' @return The result matrices
//'
//' @examples
//' x <- matrix(rnorm(1e4), 100)
//' y <- matrix(rnorm(1e2), 100)
//' z <- matrix(rnorm(1e4), 100)
//' XtX <- fMatProd(t(x), x)
//' XtX2 <- fMatTransProd(x, x)
//' all.equal(XtX, XtX2) # TRUE
//' invXtX <- fMatInv(XtX)
//' invXtXy <- fMatSolve(XtX, y)
//' fMatAdd(x, z) # x + z
//' fMatSubtract(x, z) # x - z
//' fMatSumDiffSquared(x, z) # sum((x-z)^2)
//'
//' w <- matrix(sample(9, 9), 3)
//' fMatDet(w)
//' fMatSort(w)
//' fMatSort(w, 2)
//' fMatSort(w, 2, FALSE)
//' @rdname fast_matrix_ops
//' @name fast_matrix_ops
//' @export
// [[Rcpp::export]]
arma::mat fMatProd(const arma::mat & x, const arma::mat & y) {
  return x * y;
}

//' @name fast_matrix_ops
//' @export
// [[Rcpp::export]]
arma::mat fMatTransProd(const arma::mat & x, const arma::mat & y) {
  return x.t() * y;
}

//' @name fast_matrix_ops
//' @export
// [[Rcpp::export]]
arma::mat fMatSolve(const arma::mat & x, const arma::mat & y) {
  return arma::solve(x, y);
}

//' @param is_sym_pd Whether the input matrix is symmetric/hermitian positive definite.
//' @name fast_matrix_ops
//' @export
// [[Rcpp::export]]
arma::mat fMatInv(const arma::mat & x, bool is_sym_pd = false) {
  if (is_sym_pd) {
    return arma::inv_sympd(x);
  } else {
    return arma::inv(x);
  }
}

//' @name fast_matrix_ops
//' @export
// [[Rcpp::export]]
arma::mat fMatPseudoInv(const arma::mat & x) {
  return arma::pinv(x);
}

//' @name fast_matrix_ops
//' @export
// [[Rcpp::export]]
arma::mat fMatAdd(const arma::mat & x, const arma::mat & y){
  return x + y;
}

//' @name fast_matrix_ops
//' @export
// [[Rcpp::export]]
arma::mat fMatSubtract(const arma::mat & x, const arma::mat & y){
  return x - y;
}

//' @name fast_matrix_ops
//' @export
// [[Rcpp::export]]
double fMatSumDiffSquared(const arma::mat & x, const arma::mat & y){
  return arma::sum(arma::sum(arma::square(x-y)));
}

//' @name fast_matrix_ops
//' @export
// [[Rcpp::export]]
double fMatDet(const arma::mat & x){
  return arma::det(x);
}

//' @param dim The sorting dimention. 1 means row. 2 means column.
//' @param ascending Whether to sort by ascending order.
//' @name fast_matrix_ops
//' @export
// [[Rcpp::export]]
arma::mat fMatSort(const arma::mat & x, int dim = 1, bool ascending = true){
  std::string sort_direction = ascending?"ascend":"descend";
  return arma::sort(x, sort_direction.c_str(), dim - 1);
}
