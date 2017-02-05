purrr::walk(
    list.files('raw_data', full.names = TRUE),
    ~ {
        dt <- read_csv(.) %>% 
            translateColName() %>% 
            tidyr::separate(members, paste0('member_', 1:3), sep = '\n') %>% 
            tidyr::separate(class, paste0('class_', 1:3), sep = '\n')
        
        write_csv(dt, file.path('data', str_replace(., 'raw_data/', '')))
    }
)
