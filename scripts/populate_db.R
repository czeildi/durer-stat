library("DBI")
library("RSQLite")

durer_db <- dbConnect(RSQLite::SQLite(), "data/durer-stat.sqlite")

dt <- read_csv(file.path('data', '8H-cdfk-scores.csv')) %>% data.table()

schools <- unique(dt[, .(school = stringi::stri_trans_totitle(school), address = '', city, region)])

unambiguous_schools <- schools[!str_detect(school, '\n') & !str_detect(city, ',')] %>% 
    .[order(school)]

ambiguous_schools <- schools[str_detect(school, '\n') | str_detect(city, ',')]

dbWriteTable(durer_db, 'schools', unambiguous_schools, overwrite = T)

dbDisconnect(durer_db)
