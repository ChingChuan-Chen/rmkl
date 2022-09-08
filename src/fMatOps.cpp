#include <rmkl.h>
#include <RcppArmadillo.h>

//' Functions to use MKL to do the matrix calculations
//'
//' @param x,y matrices
//' @return The result matrices
//'
//' @examples
//' x <- matrix(rnorm(1e4), 100)
//' y <- matrix(rnorm(1e2), 100)
//' XtX <- fMatProd(x, t(x))
//' invXtX <- fMatInv(XtX)
//' invXtXy <- fMatSolve(XtX, y)
//' @name fast_matrix_ops
//' @export
// [[Rcpp::export]]
arma::mat fMatProd(const arma::mat & x, const arma::mat & y) {
  return x * y;
}

//' @name fast_matrix_ops
//' @export
// [[Rcpp::export]]
arma::mat fMatSolve(const arma::mat & x, const arma::mat & y) {
  return arma::solve(x, y);
}

//' @name fast_matrix_ops
//' @export
// [[Rcpp::export]]
arma::mat fMatInv(const arma::mat & x) {
  return arma::inv(x);
}
