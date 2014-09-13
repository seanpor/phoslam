#' subsample n samples per day
#'
#' @description subsample rows from a data.frame that are
#' only n samples per day
#' @param adf the input data.frame
#' @param n the number of samples to take per day
#' @export
subsamp.nperday <- function(adf, n=1) {
  stopifnot(require(plyr))
  
  tmp <- ddply(adf, .(date), subsamp.nrow, n)
  tmp[order(tmp$datetime),]
}
