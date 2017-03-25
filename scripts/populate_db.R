source("libraries.R")
source('src/collect_schools.R')
schools <- collectSchoolInformation()

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

schools_for_db <- attachAmbiguousSchools(schools, unambiguous_schools)

durer_db <- dbConnect(RSQLite::SQLite(), "data/durer-stat.sqlite")
dbWriteTable(durer_db, 'schools', schools_for_db, overwrite = T)
dbDisconnect(durer_db)
