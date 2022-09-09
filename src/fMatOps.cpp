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
//' z <- matrix(rnorm(1e4), 100)
//' XtX <- fMatProd(t(x), x)
//' XtX2 <- fMatTransProd(x, x)
//' all.equal(XtX, XtX2) # TRUE
//' invXtX <- fMatInv(XtX)
//' invXtXy <- fMatSolve(XtX, y)
//' fMatAdd(x, z) # x + z
//' fMatSubtract(x, z) # x - z
//' fMatSumDiffSquared(x, z) # sum((x-z)^2)
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

//' @name fast_matrix_ops
//' @export
// [[Rcpp::export]]
arma::mat fMatInv(const arma::mat & x) {
  return arma::inv(x);
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
  return sum(sum(square(x-y)));
}
