## rmkl

The `rmkl` package aims to empower R with Intel MKL like Microsoft R Open (MRO) by leveraging the conda packages, `mkl`, `mkl-include` and `intel-openmp`. However, it does not like MRO or `ropenblas` to directly affect R functions. `rmkl` aims to act like a plug-in for R users and support dynamic linkage for Rcpp users. `rmkl` supports windows/OS X/Linux.

### License

The rmkl package is made available under the [GPLv3](https://www.gnu.org/licenses/gpl-3.0.html) license.

The Intel MKL Library is licensed under the (Intel Simplified Software License)[https://www.intel.com/en-us/license/intel-simplified-software-license], as described at (Intel MKL License FAQ)[https://www.intel.com/content/www/us/en/developer/articles/license/onemkl-license-faq.html].
