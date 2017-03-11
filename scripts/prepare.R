purrr::walk(
    list.files('raw_data', full.names = TRUE),
    ~ {
        read_csv(.x) %>% 
            translateColName() %>% 
            separateMembers() %>% 
            separateClasses() %>% 
            write_csv(file.path('data', str_replace(.x, 'raw_data/', '')))
    }
)
