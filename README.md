# rmkl

## Description

The `rmkl` package aims to empower R with Intel MKL like Microsoft R Open (MRO) by leveraging the Anaconda packages, `mkl`, `mkl-include` and `intel-openmp`. However, it does not like MRO or `ropenblas` to directly affect R functions. `rmkl` aims to act like a plug-in for R users and support dynamic linkage for Rcpp users. `rmkl` supports windows/Linux. Besides, `rmkl` provides the ability to use Intel MKL in `Rcpp`, so you can leverage MKL functions widely in `mkl_blas.h`, `mkl_cblas.h`, `mkl_spblas.h`, `mkl_lapack.h` and `mkl_lapacke.h`.

Please note that this package should be able to integrate with `RcppEigen`, you can try it by yourself.

## Installation

You can use the following script to install `rmkl`.

```r
remotes::install_github(repo = "ChingChuan-Chen/rmkl", force = TRUE)
```

## Benchmark for the Matrix Multiplication

You may use command `require(rmkl); demo(rmkl_performance_test)` to run.

```
Unit: milliseconds
               expr       min        lq      mean    median        uq     max neval
     R Vanilla BLAS 41.630801 53.005900 60.533677 60.992601 68.481651 85.4767   100
          RcppEigen 14.438801 19.114001 22.078276 21.167202 23.688201 41.7964   100
      RcppArmadillo 41.670801 54.793151 60.799787 59.428750 68.116602 82.6530   100
 rmkl-RcppArmadillo  2.706001  3.835351  5.027928  4.204651  4.607750 18.9791   100
         rmkl-cblas  2.465901  3.544251  4.386253  3.808152  4.210901 13.9841   100
```

Please note that this results are run on R-4.1.3 (Windows 11) with Intel i7-1065G7.

## Running on Windows

You just need to import the package and leverage the functions to do what you would like to do.

## Running on UNIX

### Hacking on UNIX system

Since `.so` files from Intel MKL are unable to load in R with `dyn.load`, we use `.Renviron` to load `.so` files. In [line 53-60 of zzz.R](https://github.com/ChingChuan-Chen/rmkl/blob/main/R/zzz.R#L53-L60), we append `lib` folder from `rmkl` to `.Renviron` file every time when R starts to make R find the Intel MKL `.so` files from `rmkl`.

### Using `rmkl` with `RStudio` in UNIX

Since `RStudio` loads the `LD_LIBRARY_PATH` before starting the R session used by user, you have to have the privilege of the system administrator to run the following command to append the `rsession-ld-library-path` in `RStudio` config which the path is `/etc/rstudio/rserver.conf`.

```shell
rmklLibPath=$(Rscript -e 'cat(system.file("lib", package = "rmkl"))')
sudo tee -a /etc/rstudio/rserver.conf << EOF
rsession-ld-library-path=${rmklLibPath}:\$LD_LIBRARY_PATH
EOF
```

## Roadmap

- [x] Support Windows.
- [x] Support Linux.
- [ ] Find an appropriate name for the package since there is an R package that is called `RMKL`.
- [ ] Include [MKL random library](https://anaconda.org/conda-forge/mkl_random).
- [ ] Have more customized functions to leverage Intel MKL.
- [ ] GitHub Actions to release binary packages.
- [ ] Support and validate on Mac OS X with Intel Processors.
- [ ] Test and validate on Mac OS X with Apple M1/M2 processors. (MKL is probably unsupported for M1/M2 processors.)
- [ ] On the CRAN (Probably not).
- [ ] Consider to drop support for i386 arch in Windows since it may cause a long installation time.

## License

The `rmkl` package is made available under the [GPLv3](https://www.gnu.org/licenses/gpl-3.0.html) license.

To use Intel MKL, you should agree with the (Intel Simplified Software License)[https://www.intel.com/en-us/license/intel-simplified-software-license], as described at (Intel MKL License FAQ)[https://www.intel.com/content/www/us/en/developer/articles/license/onemkl-license-faq.html].
