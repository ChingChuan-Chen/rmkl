#include <rmkl.h>
#include <RcppArmadillo.h>
#include <string>

//' Functions to do the decomposition by leveraging Intel MKL
//'
//' @param upper A Boolean value to indicate the output matrix is a upper matrix. False will return a lower matrix.
//' @name fast_matrix_decomposition
//' @export
// [[Rcpp::export]]
arma::mat fMatChol(const arma::mat & x, bool upper = true){
  std::string layout = upper?"upper":"lower";
  return arma::chol(x, layout.c_str());
}

//' @param economical Whether to use economical SVD.
//' @name fast_matrix_decomposition
//' @export
// [[Rcpp::export]]
Rcpp::List fMatSvd(const arma::mat & x, bool economical = false){
  arma::vec d;
  arma::mat u, v;
  if (economical) {
    arma::svd_econ(u, d, v, x);
  } else {
    arma::svd(u, d, v, x);
  }
  return Rcpp::List::create(
    Rcpp::Named("d") = d, Rcpp::Named("u") = u, Rcpp::Named("v") = v
  );
}

//' @param is_symmetric Whether the matrix is symmetric.
//' @name fast_matrix_decomposition
//' @export
// [[Rcpp::export]]
Rcpp::List fMatEigen(const arma::mat & x, bool is_symmetric = false){
  if (is_symmetric) {
    arma::vec eigval;
    arma::mat eigvec;
    arma::eig_sym(eigval, eigvec, x);
    return Rcpp::List::create(
      Rcpp::Named("values") = eigval, Rcpp::Named("vectors") = eigvec
    );
  } else {
    arma::cx_vec eigval;
    arma::cx_mat eigvec;
    arma::eig_gen(eigval, eigvec, x);
    return Rcpp::List::create(
      Rcpp::Named("values") = eigval, Rcpp::Named("vectors") = eigvec
    );
  }
}

//' @param permutation_matrix Whether the permutation matrix is outputted.
//' @name fast_matrix_decomposition
//' @export
// [[Rcpp::export]]
Rcpp::List fMatLu(const arma::mat & x, bool permutation_matrix = false){
  if (permutation_matrix) {
    arma::mat L, U, P;
    arma::lu(L, U, P, x);
    return Rcpp::List::create(
      Rcpp::Named("L") = L, Rcpp::Named("P") = P, Rcpp::Named("U") = U
    );
  } else {
    arma::mat L, U;
    arma::lu(L, U, x);
    return Rcpp::List::create(
      Rcpp::Named("L") = L, Rcpp::Named("U") = U
    );
  }
}

//' @name fast_matrix_decomposition
//' @export
// [[Rcpp::export]]
Rcpp::List fMatSchur(const arma::mat & x){
  arma::mat U, S;
  arma::schur(U, S, x);
  return Rcpp::List::create(
    Rcpp::Named("U") = U, Rcpp::Named("S") = S
  );
}

//' @name fast_matrix_decomposition
//' @export
// [[Rcpp::export]]
Rcpp::List fMatQr(const arma::mat & x, bool permutation_matrix = false, bool economical = false){
  if (permutation_matrix) {
    arma::mat Q, R;
    arma::umat P;
    arma::qr(Q, R, P, x);
    return Rcpp::List::create(
      Rcpp::Named("Q") = Q, Rcpp::Named("P") = P, Rcpp::Named("R") = R
    );
  } else {
    arma::mat Q, R;
    if (economical) {
      arma::qr_econ(Q, R, x);
    } else {
      arma::qr(Q, R, x);
    }
    return Rcpp::List::create(
      Rcpp::Named("Q") = Q, Rcpp::Named("R") = R
    );
  }
}
