#' Paste (collapse)
#' 
#' ...
pasteC <- function(...) paste(..., collapse = ',')

#' Convert 0/1 to logical
#' 
#' ...
binary_to_logical <- function(x) {
  sapply(x, function(i) {
    switch(as.character(i),
      '0' = F,
      '1' = T,
      NA
    )
  })
}


#' Cast column types in data.table
#' 
#' Function to change a column type for data.table columns.
#'
#' @param x data.table
#' @param fun type function (e.g. as.integer)
#' @param cols character vector with columns to convert
#' 
#' @examples \dontrun{
#' library(data.table)
#' dt <- data.table(mtcars)
#' cast(dt, as.character, c('vs', 'cyl'))
#' }
cast <- function(x, fun, cols) {
  cols <- cols[cols %in% names(x)]
  if (length(cols) > 0) {
    if (identical(fun, as.Date)) {
      for(j in cols) set(x, j = j, value = as.Date(lubridate::fast_strptime(x[[j]], "%Y-%m-%d")))
    } else {
      for(j in cols) set(x, j = j, value = fun(x[[j]]))
    }
  }
}
