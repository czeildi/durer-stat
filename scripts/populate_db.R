source("libraries.R")

durer_db <- dbConnect(RSQLite::SQLite(), "data/durer-stat.sqlite")

dt <- read_csv(file.path('data', '8H_CDFK.csv')) %>% data.table()

schools <- unique(dt[, .(school, address = '', city, region)])

unambiguous_schools <- schools[!str_detect(school, ';') & !str_detect(city, ';')] %>% 
    .[order(school)] %>% 
    rbind(
        data.table(
            school = c("Bolyai János Gimnázium", "Koch Valéria Iskolaközpont, Pécs", "Nyíregyházi Eötvös József Gimnázium"),
            address = "",
            city = c("Kecskemét", "Pécs", "Nyíregyháza"),
            region = c("DA", "DD", "ÉA")
        )
    ) %>% 
    unique()

ambiguous_schools <- schools[str_detect(school, ';') | str_detect(city, ';'), school] %>% 
    str_split('; ') %>% 
    unlist() %>% 
    unique() %>% 
    sort() %>% 
    .[!. %in% unambiguous_schools$school]

if (length(ambiguous_schools) >= 1) {
    dt_of_additional_schools <- data.table(
        school = ambiguous_schools,
        address = '',
        city = '',
        region = ''
    )
    schools_for_db <- rbind(unambiguous_schools, dt_of_additional_schools)
} else {
    schools_for_db <- unambiguous_schools
}

dbWriteTable(durer_db, 'schools', schools_for_db, overwrite = T)

dbDisconnect(durer_db)
