shinyServer(function(input, output) {
    scores <- reactive({
        read_csv(str_c('data/', input$raw_data, '.csv')) %>% 
            data.table()
    })
    
    output$scores <- renderDataTable({
        scores() %>% 
            filterForCategory(input$category)
    })
    
    output$effect_of_age <- renderPlot({
        scores() %>% 
            filterForCategory(input$category) %>% 
            classDataForTeams() %>% 
            plotEffectOfClass()
    })
    
    output$participants <- renderLeaflet({
        participating_countries <- c(
            'Hungary', 'Croatia', 'Austria', 'Ukraine', 'Slovakia',
            'Slovenia', 'Romania', 'Serbia and Montenegro'
        )
        prepared_dt <- read_csv(str_c('data/', input$data_for_map, '.csv')) %>% 
            data.table()
        if ('city' %in% names(prepared_dt)) {
            raw_cities <- prepared_dt[, city]
        } else {
            raw_cities <- 'Miskolc'
        }
        cities <- str_split(raw_cities, ', |; ') %>% 
            unlist() %>% 
            unique() %>% 
            tolower() %>% 
            stringi::stri_trans_general("latin-ascii")
        
        maps::world.cities %>% 
            data.table() %>% 
            .[country.etc %in% participating_countries & tolower(name) %in% cities] %>% 
            leaflet() %>%
            addTiles() %>% 
            addMarkers(~ long, ~ lat, popup = ~ htmltools::htmlEscape(name))
    })
    
    school_ids <- reactive({
        school_names <- collectSchoolNames()
        data.table(
            name = str_split(school_names, "; ") %>% unlist() %>% unique() %>% sort()
        )
    })
    
    output$school_ids <- renderDataTable({
        school_ids()
    })
    
    renameSchool <- eventReactive(input$submit, {
        from <- input$school_name_to_change 
        to <- input$target_school_name
        walk(
            list.files('raw_data', full.names = TRUE),
            ~ {
                suppressMessages(dt <- read_csv(.))
                dt <- data.table(dt)
                dt[Iskola %in% from, Iskola := to]
                fwrite(dt, .)
            }
        )
        return(character(0))
    })
    
    output$dummy_submit <- renderUI({
        renameSchool()
    })
})
