source("libraries.R")
source('src/collect_schools.R')
schools <- collectSchoolInformation()

unambiguous_schools <- schools[!str_detect(school, ';') & !str_detect(city, ';')] %>% 
    .[order(school)] %>% 
    .[, address := NULL] %>% 
    rbind(
        data.table(
            school = c("Bolyai János Gimnázium", "Koch Valéria Iskolaközpont, Pécs", "Nyíregyházi Eötvös József Gimnázium"),
            city = c("Kecskemét", "Pécs", "Nyíregyháza"),
            region = c("DA", "DD", "ÉA")
        )
    ) %>% 
    unique()

schools_for_db <- attachAmbiguousSchools(schools, unambiguous_schools) %>% 
    .[, .(school, city)] %>% 
    unique() %>% 
    .[, n_city := .N, by = school] %>% 
    .[n_city == 1 | (city != '' & !is.na(city))] %>% 
    .[school != ''] %>% 
    .[, n_city := NULL] %>% 
    .[order(school)]

durer_db <- dbConnect(RSQLite::SQLite(), "data/durer-stat.sqlite")
dbWriteTable(durer_db, 'schools', schools_for_db, overwrite = T)

cities <- fread('raw_data/cities_w_region.csv')
dbWriteTable(durer_db, 'cities', cities)
dbDisconnect(durer_db)
