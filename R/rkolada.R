Kolada <- R6Class("Kolada",
  public = list(
    convert = T,
    initialize = function(convert) {
      if (!missing(convert)) self$convert <- convert
    },
    
    # max 5000 per request, use next_page
    fetch = function(url, ...) {
      res <- NULL
      url <- sprintf(url, ...)
      while (!is.null(url)) {
        message('fetching ', url, ' ...')
        x <- httr::content(GET(url))
        url <- x$next_page
        res <- rbindlist(list(
          res,
          rbindlist(lapply(x$values, function(i) {
            if (!is.null(i$values) && length(i$values) > 0) {
              
              # Fix: U01402 returns NULL as value (don't know why), which causes:
              # Error in rbindlist(i$value) : attempt to set an attribute on NULL
              vals <- lapply(i$values, function(j) {
                if (is.null(j$value)) j$value <- NA
                return(j)
              })
              data.table(kpi = i$kpi, municipality = i$municipality, period = i$period, rbindlist(vals))
            } else {
              data.table(t(unlist(i)))
            }
          }), fill = T)
        ), fill = T)
      }
      
      if (self$convert) {
        res <- self$convert_table(res)
      }
      
      return(res)
    },
    
    fetch_meta_data = function(x, y = NULL) {
      url <- if (is.null(y)) {
        'http://api.kolada.se/v2/%s'
      } else 'http://api.kolada.se/v2/%s/%s'
      
      D <- self$fetch(url, x, pasteC(y))
      setnames(D, names(D), paste(x, names(D), sep = '.'))
      return(D)
    },
    
    convert_table = function(x) {
      cast(x, as.Date, c('prel_publication_date', 'publication_date', 'ou_publication_date'))
      cast(x, as.numeric, 'value')
      cast(x, as.integer, c('count', 'publ_period', 'period'))
      cast(x, as.logical, 'has_ou_data')
      cast(x, binary_to_logical, 'is_divided_by_gender')
      return(x)
    },
    
    kpi = function(...) {
      self$fetch_meta_data('kpi', ...)
    },
    
    municipality = function(...) {
      self$fetch_meta_data('municipality', ...)
    },
    
    values = function(
      kpi,
      municipality = NULL,
      year = NULL,
      all.cols = F
    ) {
      
      if (is.null(kpi) || !is.character(kpi)) stop('Provide at least one or more kpi id:s (as character) ...')
      
      # Get all (default) if no values are provided
      if (is.null(municipality)) municipality <- self$municipality()$municipality.id
      if (is.null(year)) year <- 1970:(year(Sys.Date()))
      
      x <- self$fetch('http://api.kolada.se/v2/data/kpi/%s/municipality/%s/year/%s', pasteC(kpi), pasteC(municipality), pasteC(year))
      
      if (nrow(x) > 0) {
        setnames(x, c('kpi', 'municipality'), c('kpi.id', 'municipality.id'))
        
        if (all.cols) {
          x <- merge(x, self$kpi(kpi), by = 'kpi.id', all.x = T)
          x <- merge(x, self$municipality(municipality), by = 'municipality.id', all.x = T)
        }
      } else message('... no data found ...')
      
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
