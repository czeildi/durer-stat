filterForCategory <- function(scores, category_param) {
    long_category_name <- paste(category_param, 'kategória')
    scores[category %in% c(long_category_name, category_param), ]
}
