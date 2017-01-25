shinyUI(fluidPage(
    title = "durer stats",
    tabsetPanel(
        selected = 'unify schools',
        tabPanel(
            'scores',
            selectInput(
                'raw_data', label = 'select data',
                choices = file.path('data', str_c(8:9, 'H-cdfk-scores.csv'))
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
        ),
        tabPanel(
            'unify schools',
            column(
                7,
                dataTableOutput('school_ids')
            ),
            column(
                4,
                selectInput(
                    'school_name_to_change', 'name to change:', choices = collectSchoolNames()
                ),
                numericInput(
                    'target_name_id', 'Target school name id:', value = 1
                )
            ),
            column(
                1, actionButton('submit', 'submit'), uiOutput('dummy_submit')
            )
        )
    )
))
