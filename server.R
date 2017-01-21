shinyServer(function(input, output) {
    scores <- reactive({
        fread(input$raw_data)
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
        cities <- str_c('data/', input$year_for_map, 'H-cdfk-scores.csv') %>% 
            fread() %>% 
            .[, city] %>% 
            str_split(', |; ') %>% 
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
})
