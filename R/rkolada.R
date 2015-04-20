Kolada <- R6Class("Kolada",
  public = list(
    initialize = function() {
      
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
      D <- fetch('http://api.kolada.se/v2/%s', x)
      setnames(D, names(D), paste(x, names(D), sep = '.'))
      return(D)
    },
    
    kpi = function() {
      fetch_meta_data('kpi')
    },
    
    municipality = function() {
      fetch_meta_data('municipality')
    },
    
    data = function(kpi, municipality, year) {
      x <- fetch('http://api.kolada.se/v2/data/kpi/%s/municipality/%s/year/%s', pasteC(kpi), pasteC(municipality), pasteC(year))
      
      x[, c(
        'period',
        'kpi.publ_period',
        'values.count',
        'values.value',
        'kpi.prel_publication_date',
        'kpi.publication_date',
        'kpi.ou_publication_date'
      ) := list(
        as.integer(period),
        as.integer(kpi.publ_period),
        as.integer(values.count),
        as.double(values.value),
        as.Date(kpi.prel_publication_date),
        as.Date(kpi.publication_date),
        as.Date(kpi.ou_publication_date)
      )]
      
      return(x)
    }
  )
)

rkolada <- function(...) Kolada$new(...)

# # Join muncipalities
# setkey(x, municipality)
# setkey(M, municipality.id)
# x <- M[x]
# 
# # Join KPI
# setkey(x, kpi)
# setkey(K, kpi.id)
# x <- K[x]
