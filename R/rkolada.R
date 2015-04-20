Kolada <- R6Class("Kolada",
  public = list(
    convert = F,  # TRUE currently causes encoding issues (åäö)
    initialize = function(convert) {
      if (!missing(convert)) self$convert <- convert
    },
    
    # max 5000 per request, use next_page
    fetch = function(url, ...) {
      res <- NULL
      url <- sprintf(url, ...)
      while (!is.null(url)) {
        message('fetching ', url, ' ...')
        x <- content(GET(url))
        url <- x$next_page
        res <- rbindlist(list(
          res,
          rbindlist(lapply(x$values, function(i) data.table(t(unlist(i)))), fill = T)
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
      readr::type_convert(x)
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
      
      setnames(x, c('kpi', 'municipality'), c('kpi.id', 'municipality.id'))
      
      if (all.cols) {
        x <- merge(x, self$kpi(kpi), by = 'kpi.id', all.x = T)
        x <- merge(x, self$municipality(municipality), by = 'municipality.id', all.x = T)
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
