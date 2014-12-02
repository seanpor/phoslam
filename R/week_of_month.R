#' subsample once from a particular day on the fourth week of the month
#'
#' @description subsample rows from a data.frame that are
#' on a particular day (Monday by default) on the fourth week of the month
#' and they could be at anytime, working hours by default,
#  one sample per day
#' @param adf the input data.frame
#' @param which.day - 'Mon' by default, three letter day in locale (I presume)
#' @param which.week - 4 (th) week of the month by default - an integer
#' @param only.workinghours - default TRUE
#' @export
week.of.month <- function(adf, which.day='Mon', which.week=4,
                          only.workinghours=TRUE) {
  if (only.workinghours) {
    # d1b <- subset(adf, workinghours & day==which.day)
    d1b <- adf[adf$workinghours & adf$day==which.day,]
  } else {
    # d1b <- subset(adf, day==which.day)
    d1b <- adf[adf$day==which.day,]
  }
  # d1b <- subset(d1b, as.integer(week) %% which.week == 0)
  d1b <- d1b[as.integer(d1b$week) %% which.week == 0,]
  # now we can just pull one random record from this day
  tmp <- plyr::ddply(d1b, date, subsamp.nrow)
  tmp[order(tmp$datetime),]
}
