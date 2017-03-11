# on first run: source('scripts/install_used_packages.R')
source('libraries.R')

invisible(sapply(list.files('src', full.names = TRUE), source))
source('scripts/prepare.R')
