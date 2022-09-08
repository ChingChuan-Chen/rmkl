## Copyright (C) 2014-2022        JJ Allaire, Romain Francois, Kevin Ushey, Gregory Vandenbrouck
## Copyright (C) 2022        Chingchuan Chen
##
## This file is based on install.libs.R from RcppParallel
## This file is part of rmkl.
##
## rmkl is free software: you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 2 of the License, or
## (at your option) any later version.
##
## rmkl is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with rmkl  If not, see <http://www.gnu.org/licenses/>.

# !diagnostics suppress=R_PACKAGE_DIR,SHLIB_EXT,R_ARCH
.install.libs <- function() {
  # copy default library
  files <- Sys.glob(paste0("*", SHLIB_EXT))
  dest <- file.path(R_PACKAGE_DIR, paste0("libs", R_ARCH))
  dir.create(dest, recursive = TRUE, showWarnings = FALSE)
  file.copy(files, dest, overwrite = TRUE)

  # copy symbols if available
  if (file.exists("symbols.rds"))
    file.copy("symbols.rds", dest, overwrite = TRUE)

  # also copy to package 'libs' folder, for devtools
  libsDest <- paste0("../libs", R_ARCH)
  dir.create(libsDest, recursive = TRUE, showWarnings = FALSE)
  file.copy(files, libsDest, overwrite = TRUE)
}

.install.libs()
