read.csv("raw_data/9-cdfk-helyi-pontozo.csv", stringsAsFactors = F) %>% 
    translateColName() %>% 
    tidyr::separate(members, paste0('member_', 1:3), sep = '\n') %>% 
    tidyr::separate(class, paste0('class_', 1:3), sep = '\n') %>% 
    write.csv(file.path('data', '9H-cdfk-scores.csv'), row.names = F)

read.csv("raw_data/8-cdfk-helyi-pontozo.csv", stringsAsFactors = F) %>% 
    translateColName() %>% 
    tidyr::separate(members, paste0('member_', 1:3), sep = '\n') %>% 
    tidyr::separate(class, paste0('class_', 1:3), sep = '\n') %>% 
    write.csv(file.path('data', '8H-cdfk-scores.csv'), row.names = F)
