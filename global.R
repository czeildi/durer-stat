# source('scripts/install_used_packages.R')
library("tidyverse")
library("stringr")
library("data.table")
library("leaflet")
library("RSQLite")

invisible(sapply(list.files('src', full.names = TRUE), source))
source('scripts/prepare.R')
