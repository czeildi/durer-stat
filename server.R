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
        cities_9 <- 'data/9H-cdfk-scores.csv' %>% 
            fread() %>% 
            .[, city] %>% 
            str_split(', |; ') %>% 
            unlist() %>% 
            unique() %>% 
            tolower() %>% 
            str_replace_all('á', 'a') %>% 
            str_replace_all('é', 'e') %>% 
            str_replace_all('í', 'i') %>% 
            str_replace_all('ú', 'u') %>% 
            str_replace_all('ü', 'u') %>% 
            str_replace_all('ű', 'u') %>% 
            str_replace_all('ó', 'o') %>% 
            str_replace_all('ö', 'o') %>%  
            str_replace_all('ő', 'o')
        
        maps::world.cities %>% 
            data.table() %>% 
            .[country.etc %in% participating_countries & tolower(name) %in% cities_9] %>% 
            leaflet() %>%
            addTiles() %>% 
            addMarkers(~ long, ~ lat, popup = ~ htmltools::htmlEscape(name))
    })
})
