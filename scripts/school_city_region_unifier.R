schools <- schools_for_db[, .(school, city)] %>% 
    unique() %>% 
    .[, n_city := .N, by = school] %>% 
    .[n_city == 1 | (city != '' & !is.na(city))] %>% 
    .[school != ''] %>% 
    .[, n_city := NULL] %>% 
    .[order(school)]

cities <- schools_for_db[, .(city, region)] %>% 
    .[, region := toupper(region)] %>% 
    unique() %>% 
    .[, n_region := .N, by = city] %>% 
    .[n_region == 1 | (region != '' & !is.na(region))] %>% 
    .[city != ''] %>% 
    .[, n_region := NULL] %>% 
    .[order(city)] %>% 
    .[city == 'Kecskemét', region := 'DA'] %>% 
    .[city == 'Baja', region := 'DA'] %>% 
    .[city == 'Budapest', region := 'KM'] %>% 
    unique()
