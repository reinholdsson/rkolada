library(httr)
library(plyr)
library(data.table)

pc <- function(...) paste(..., collapse = ',')

fix_data <- function(x) {
  suppressWarnings({
    x <- colwise(function(col) {
      # return if all na
      if (all(is.na(col))) col
      # char -> numeric
      else if (all(is.na(col) | !is.na(as.numeric(col)))) as.numeric(col)
      # char -> date
      else if (all(is.na(col) | grepl("^\\d\\d\\d\\d-\\d\\d-\\d\\d", col))) as.Date(col)
      # if no match, return as is
      else col
    })(x)
  })
  return(data.table(x))
}

# max 5000 per request, use next_page

fetch <- function(url, ...) {
  x <- content(GET(sprintf(url, ...)))
  x <- rbindlist(lapply(x$values, function(i) data.table(t(unlist(i)))), fill = T)
  fix_data(x)
}

K <- fetch('http://api.kolada.se/v2/kpi')
M <- fetch('http://api.kolada.se/v2/municipality')

kpi <- c('N15033', 'N00945')
year <- 2000:2012
municipality <- 1860

x <- fetch('http://api.kolada.se/v2/data/kpi/%s/municipality/%s/year/%s', pc(head(K$id)), pc(head(M$id)), pc(year))
x
