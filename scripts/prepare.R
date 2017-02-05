purrr::walk(
    list.files('raw_data', full.names = TRUE),
    ~ {
        read_csv(.) %>% 
            translateColName() %>% 
            separateMembers() %>% 
            separateClasses() %>% 
            write_csv(file.path('data', str_replace(.x, 'raw_data/', '')))
    }
)
