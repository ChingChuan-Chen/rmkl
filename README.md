# r-mkl

## Description

The `r-mkl` package aims to empower R with Intel MKL like Microsoft R Open (MRO) by leveraging the Anaconda packages, `mkl`, `mkl-include` and `intel-openmp`. However, it does not like MRO or `ropenblas` to directly affect R functions. `r-mkl` aims to act like a plug-in for R users and support dynamic linkage for Rcpp users. `r-mkl` supports windows/OS X/Linux. Besides, `r-mkl` provides the ability to use Intel MKL in `Rcpp`, so you can leverage MKL functions widely in `mkl_blas.h`, `mkl_cblas.h`, `mkl_spblas.h`, `mkl_lapack.h` and `mkl_lapacke.h`.

## Installation

You can use the following script to install `r-mkl`.

```r
remotes::install_github(repo = "ChingChuan-Chen/r-mkl", force = TRUE)
```

## Benchmark for the Matrix Multiplication

You may get the following results by running `inst/example/link_mkl_cblas.cpp`.

```
Unit: milliseconds
            expr       min        lq      mean    median        uq     max neval
       R default 22.616301 23.267201 26.608191 23.929550 31.239301 43.1686   100
 r-mkl-Armadillo  2.156601  2.396401  2.801035  2.506151  2.643151 11.5749   100
     r-mkl-cblas  1.623601  1.848351  2.367477  1.951401  2.040700 12.0597   100
   
# This results are run on R-4.2.1 (Windows 11) with AMD 2990WX and 128 GB.
```

## Running on Windows

You just need to import the package and leverage the functions to do what you would like to do.

## Running on UNIX

### Hacking on UNIX system

Since `.so` files from Intel MKL are unable to load in R with `dyn.load`, we use `.Renviron` to load `.so` files. In [line 53-60 of zzz.R](https://github.com/ChingChuan-Chen/r-mkl/blob/main/R/zzz.R#L53-L60), we append `lib` folder from `r-mkl` to `.Renviron` file every time when R starts to make R find the Intel MKL `.so` files from `r-mkl`.

### Using `r-mkl` with `RStudio` in UNIX

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

## License

The `r-mkl` package is made available under the [GPLv3](https://www.gnu.org/licenses/gpl-3.0.html) license.

To use Intel MKL, you should agree with the (Intel Simplified Software License)[https://www.intel.com/en-us/license/intel-simplified-software-license], as described at (Intel MKL License FAQ)[https://www.intel.com/content/www/us/en/developer/articles/license/onemkl-license-faq.html].
