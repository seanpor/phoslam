#' Choose a subset of days and subsample from each of these days once
#' 
#' @description subsample rows from a data.frame that are
#' only from three randomly chosen working days, note it
#' is the days (i.e. Mon to Sun) that are randomly chosen.
#' @param adf the input data.frame
#' @param ndays the number of days to subsample from 1<= ndays <= 7
#' @export
subsamp.ndays <- function(adf, ndays=3) {
  stopifnot(ndays <= 7)
  dn <- sample(c('Mon','Tue','Wed','Thu','Fri'), ndays)
  adf[adf$day %in% dn,]
}
