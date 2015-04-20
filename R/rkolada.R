Kolada <- R6Class("Kolada",
  public = list(
    initialize = function() {
      # do nothing
    },
    
    # max 5000 per request, use next_page
    fetch = function(url, ...) {
      res <- NULL
      url <- sprintf(url, ...)
      while (!is.null(url)) {
        message('fetching ', url, ' ...')
        x <- content(GET(url))
        url <- x$next_page
        res <- rbindlist(list(res, rbindlist(lapply(x$values, function(i) data.table(t(unlist(i)))), fill = T)), fill = T)
      }
      return(res)
    },
    
    fetch_meta_data = function(x) {
      D <- self$fetch('http://api.kolada.se/v2/%s', x)
      setnames(D, names(D), paste(x, names(D), sep = '.'))
      return(D)
    },
    
    kpi = function() {
      self$fetch_meta_data('kpi')
    },
    
    municipality = function() {
      self$fetch_meta_data('municipality')
    },
    
    values = function(kpi, municipality, year, all = F) {
      x <- self$fetch('http://api.kolada.se/v2/data/kpi/%s/municipality/%s/year/%s', pasteC(kpi), pasteC(municipality), pasteC(year))
      
      setnames(x, c('kpi', 'municipality'), c('kpi.id', 'municipality.id'))
      
      if (all) {
        x <- merge(x, self$kpi(), by = 'kpi.id', all.x = T)
        x <- merge(x, self$municipality(), by = 'municipality.id', all.x = T)
      }
      
      return(x)
    }
  )
)

#' rkolada
#' 
#' Access the Kolada API
#' 
#' @export
rkolada <- function(...) Kolada$new(...)
