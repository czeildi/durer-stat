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
