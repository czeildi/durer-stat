collectSchoolNames <- function() {
  school_names <- character(0)
  walk(
      list.files('raw_data', full.names = TRUE),
      ~ {
          suppressMessages(dt <- read_csv(.))
          if ('Iskola' %in% names(dt)) {
              school_names <<- sort(c(school_names, dt$Iskola))
          } else {
              print(.)
          }
      }
  )
  school_names
}

collectSchoolInformation <- function() {
    schools <- data.table()
    walk(
        list.files('data', '[[:digit:]]{1,2}[HDLK][_A-Z]{0,5}\\.csv$', full.names = TRUE),
        ~ {
            dt <- read_csv(.) %>% data.table()
            if (all(c('school', 'city', 'region') %in% names(dt))) {
                schools <<- rbind(schools, unique(dt[, .(school, address = '', city, region)]))
            } else if (all(c('school', 'city') %in% names(dt))) {
                schools <<- rbind(schools, unique(dt[, .(school, address = '', city, region = '')]))
            } else if ('school' %in% names(dt)) {
                 schools <<- rbind(schools, unique(dt[, .(school, address = '', city = '', region = '')]))
            }
        } 
    )
    unique(schools)
}

attachAmbiguousSchools <- function(schools, unambiguous_schools) {
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
  schools_for_db
}
