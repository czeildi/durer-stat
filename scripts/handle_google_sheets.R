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

walk(
    durer_eredmenyek$sheet_title,
    ~ {
        registered_sheet_obj <- gs_key(durer_eredmenyek[sheet_title == ., sheet_key])
        gs_download(
            registered_sheet_obj,
            ws = 'transformed_w_unique_scools',
            to = file.path('raw_data', str_c(., '.csv')),
            overwrite = TRUE
        )
    }
)
# 
# walk(
#     durer_eredmenyek$sheet_title,
#     ~ {
#         registered_sheet_obj <- gs_key(durer_eredmenyek[sheet_title == ., sheet_key])
#         gs_ws_new(
#             registered_sheet_obj,
#             ws_title = 'transformed_w_unique_scools',
#             input = read_csv(file.path('raw_data', str_c(., '.csv')))
#         )
#     }
# )
