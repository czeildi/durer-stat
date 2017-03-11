source('libraries.R')

if (is.null(gs_user())) {
    gs_auth()
}

sheets <- data.table(gs_ls())

durer_eredmenyek <- sheets[
    author %in% c('szgabbor', 'czeildi') &
        updated >= as.Date('2017-02-01') & 
        grepl('[[:digit:]]{1,2}[HDLK][_A-Z]{0,5}$', sheet_title)
    ]
