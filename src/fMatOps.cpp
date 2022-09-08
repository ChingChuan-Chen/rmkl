#include <rmkl.h>
#include <RcppArmadillo.h>

//' @export
// [[Rcpp::export]]
arma::mat fMatProd(const arma::mat & x, const arma::mat & y) {
  return x * y;
}

//' @export
// [[Rcpp::export]]
arma::mat fMatSolve(const arma::mat & x, const arma::mat & y) {
  return arma::solve(x, y);
}

//' @export
// [[Rcpp::export]]
arma::mat fMatInv(const arma::mat & x) {
  return arma::inv(x);
}
