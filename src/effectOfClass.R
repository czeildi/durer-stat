classDataForTeams <- function(scores_in_category) {
    if (!'class_1' %in% names(scores_in_category)) {
        stop('Nincs évfolyam információ a választott adathalmazban.')
    }
    scores_in_category %>% 
        melt(
            id.vars = c('team', 'total'),
            measure.vars = paste0('class_', 1:3),
            value.name = 'class'
        ) %>% 
         countMembersInLowerClass() %>% 
        .[, .(total = mean(as.numeric(total))), by = c('team', 'num_member_in_lower_class')]
} 

plotEffectOfClass <- function(class_data) {
    class_data %>% 
        .[, number_member_in_lower_class := as.integer(num_member_in_lower_class)] %>% 
        ggplot(aes(x = num_member_in_lower_class, y = total, group = num_member_in_lower_class)) +
        geom_jitter(aes(col = num_member_in_lower_class), alpha = 0.5, width = 0.1) +
        ggrepel::geom_text_repel(aes(label = team)) + 
        theme(legend.position = 'none')
}

countMembersInLowerClass <- function(dt) {
    dt[, lowest_class := min(as.integer(class)), by = 'team'] %>% 
        .[, num_member_in_lower_class := sum(class == lowest_class), by = 'team'] %>% 
        .[,lowest_class := NULL]
}
