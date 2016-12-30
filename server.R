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
        leaflet() %>% 
            addTiles() %>% 
            addMarkers(lng = 19, lat = 47.5) %>% 
            addMarkers(lng = 23.62, lat = 46.77) %>% 
            addMarkers(lng = 17.8, lat = 46.36) %>% 
            addMarkers(lng = 20.78, lat = 48.1)
    })
})
