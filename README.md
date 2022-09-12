## rmkl

The `rmkl` package aims to empower R with Intel MKL like Microsoft R Open (MRO) by leveraging the conda packages, `mkl`, `mkl-include` and `intel-openmp`. However, it does not like MRO or `ropenblas` to directly affect R functions. `rmkl` aims to act like a plug-in for R users and support dynamic linkage for Rcpp users. `rmkl` supports windows/OS X/Linux.

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
