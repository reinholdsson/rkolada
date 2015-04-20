library(httr)
library(plyr)
library(data.table)

pc <- function(...) paste(..., collapse = ',')

# max 5000 per request, use next_page
fetch <- function(url, ...) {
  res <- NULL
  url <- sprintf(url, ...)
  while (!is.null(url)) {
    message('fetching ', url, ' ...')
    x <- content(GET(url))
    url <- x$next_page
    res <- rbindlist(list(res, rbindlist(lapply(x$values, function(i) data.table(t(unlist(i)))), fill = T)), fill = T)
  }
  return(res)
}

K <- fetch('http://api.kolada.se/v2/kpi')
M <- fetch('http://api.kolada.se/v2/municipality')
year <- 2000:2012
x <- fetch('http://api.kolada.se/v2/data/kpi/%s/municipality/%s/year/%s', pc(head(K$id,100)), pc(M$id), pc(year))

# Join muncipalities
setnames(M, names(M), paste('municipality', names(M), sep = '.'))
setkey(x, municipality)
setkey(M, municipality.id)
x <- M[x]

# Join KPI
setnames(K, names(K), paste('kpi', names(K), sep = '.'))
setkey(x, kpi)
setkey(K, kpi.id)
x <- K[x]

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
