#' Subsample one sample each from fixed days of the week
#'
#' @description subsample rows from a data.frame that are
#' three days per week fixed days, but random time working hours
#  one sample per day
#' @param adf the input data.frame
#' @param sdays, the fixed days on which to take the samples,
#' by default c('Mon','Wed','Thu')
#' @export
subsamp.fixeddays <- function(adf, sdays=c('Mon','Wed','Thu')) {
  tmp <- adf[adf$day %in% sdays,]
  # tmp <- subset(tmp, workinghours)
  tmp <- tmp[tmp$workinghours,]
  plyr::ddply(tmp, date, subsamp.nrow)
}
