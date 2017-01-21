shinyUI(fluidPage(
    title = "durer stats",
    tabsetPanel(
        selected = 'maps',
        tabPanel(
            'scores',
            selectInput(
                'raw_data', label = 'select data',
                choices = c(file.path('data', '9H-cdfk-scores.csv'),'bagoly')
            ),
            radioButtons(
                'category', 'Select category', choices = c('C', 'D', 'F', 'K'), inline = T
            ),
            plotOutput('effect_of_age'),
            dataTableOutput('scores')
        ),
        tabPanel(
            'maps',
            numericInput('year_for_map', 'Select competition: ', min = 1, max = 10, value = 9),
            leafletOutput('participants', height = 600)
        )
    )
))
