translateColName <- function(df) {
    dt <- data.table(df) 
    rename_(
        dt, 
        c("Csapatnév", "Kategória", "Helyszín"), 
        c("team", "category", "venue")
    )
    rename_(dt, "Tagok", "members")
    rename_(dt, "Évfolyam", "class")
    rename_(
        dt,
        c("Iskola", "Város", "Régió"),
        c("school", "city", "region")
    )
    
    rename_(dt, paste0(1:5, '. feladat'), paste0('problem_', 1:5))    
    rename_(dt, as.character(1:5), paste0('problem_', 1:5))    
    rename_(dt, c("Összesen"), c("total"))
    
    rename_(dt,
        c("Felkészítő tanárok", "Megjegyzés"),
        c("teachers", "note")
    )
    dt
}

separateMembers <- function(dt) {
    if ('members' %in% names(dt)) {
        tidyr::separate(dt, members, paste0('member_', 1:3), sep = '\n')
    } else {
        dt
    }
}

separateClasses <- function(dt) {
    if ('class' %in% names(dt)) {
        tidyr::separate(dt, class, paste0('class_', 1:3), sep = '\n')
    } else {
        dt
    }
}

rename_ <- function(dt, from, to) {
    if (length(from) != length(to)) {
        stop('from and to must be vectors of the same length')
    }
    purrr::walk2(from, to, ~ {
        if (.x %in% names(dt)) {
            setnames(dt, .x, .y)
        }
    })
    invisible(dt)
}
