library("DBI")
library("RSQLite")

durer_db <- dbConnect(RSQLite::SQLite(), "data/durer-stat.sqlite")

