## rmkl

The `rmkl` package aims to empower R with Intel MKL like Microsoft R Open (MRO) by leveraging the conda packages, `mkl`, `mkl-include` and `intel-openmp`. However, it does not like MRO or `ropenblas` to directly affect R functions. `rmkl` aims to act like a plug-in for R users and support dynamic linkage for Rcpp users. `rmkl` supports windows/OS X/Linux.

### Speed-Up Performance for the Matrix Multiplication

You may get the following results by running `inst/example/link_mkl_cblas.cpp`.

```
Unit: milliseconds
    expr       min        lq      mean    median        uq     max neval
 default 22.616301 23.267201 26.608191 23.929550 31.239301 43.1686   100
    arma  2.156601  2.396401  2.801035  2.506151  2.643151 11.5749   100
   cblas  1.623601  1.848351  2.367477  1.951401  2.040700 12.0597   100
   
# This results are run on R-4.2.1 (Windows 11) with AMD 2990WX and 128 GB.
```

### Implementations in UNIX

Since MKL so files are unable to load in R with `dyn.load`, we use `.Renviron` to do the hacking. We will append `.Renviron` file every time when R starts to make R find the Intel MKL so files.

### Using with RStudio in UNIX

Since RStudio load the `LD_LIBRARY_PATH` before starting the R session used by user, you have to have the privilege of the system administrator to run the following command to append the `rsession-ld-library-path` in RStudio config, `/etc/rstudio/rserver.conf`.

```shell
rmklLibPath=$(Rscript -e 'cat(system.file("lib", package = "rmkl"))')
sudo tee -a /etc/rstudio/rserver.conf << EOF
rsession-ld-library-path=${rmklLibPath}:\$LD_LIBRARY_PATH
EOF
```

### License

The `rmkl` package is made available under the [GPLv3](https://www.gnu.org/licenses/gpl-3.0.html) license.

The Intel MKL Library is licensed under the (Intel Simplified Software License)[https://www.intel.com/en-us/license/intel-simplified-software-license], as described at (Intel MKL License FAQ)[https://www.intel.com/content/www/us/en/developer/articles/license/onemkl-license-faq.html].
