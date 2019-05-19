ipak <- function(pkg.name) {
    new.pkg <- pkg.name[!(pkg.name %in% utils::installed.packages()[, 'Package'])]
    if (length(new.pkg))
        install.packages(new.pkg, dependencies = T, type = "source",
                         repos="http://cran.r-project.org")
    tryCatch({
        sapply(pkg.name, require, character.only = T)
    }, warning = function(w) {
        message(w)
    }, error = function(e) {
        message(e)
    })
}

list.of.packages <- c('shiny', 'shinydashboard', 'RColorBrewer', 
                      'spotifyr', 'GGally', 'dplyr')
ipak(list.of.packages)
