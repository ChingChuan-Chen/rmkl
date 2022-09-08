#include <rmkl.h>
#include <string>

//' Function to get the version of Intel MKL
//'
//' @return The version of Intel MKL
//' @examples
//' getMKLVersion()
//' @export
// [[Rcpp::export]]
std::string getMKLVersion() {
  int len=198;
  char buf[198];
  mkl_get_version_string(buf, len);
  std::string mklVersionString(buf);
  return(mklVersionString);
}

//' Function to get/set the number of threads used in Intel MKL
//'
//' @param nThreads The number of threads you want to use in Intel MKL.
//' @return The number of threads.
//'
//' @examples
//' \dontrun{
//' getMKLThreads() # Default is the number of cores your CPU has
//' setMKLThreads(1)
//' getMKLThreads() # 1
//' }
//' @name mkl_threads
//' @export
// [[Rcpp::export]]
int setMKLThreads(int nThreads) {
  mkl_set_num_threads(nThreads);
  return nThreads;
}

//' @name mkl_threads
//' @export
// [[Rcpp::export]]
int getMKLThreads() {
  return mkl_get_max_threads();
}

