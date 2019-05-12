# a function to perform bootstrapping of
# the Bowes and Greene coefficients along with Qe etc.
#' @title Calculate the Bowes and Greene parameters for a given set of paired Q and P
#' @name boot.params
#' @param Q the measured water flow rate in cubic metres per second
#' @param P the Total Reactive Phostphate - units- TBD
#' @param Qhi the high-frequency Q values in cubic metres per second
#' @param N the number of bootstrap replications - defaults to 50 for a reasonable size for estimating the mean.
#' @param ConstrainBzero Do we constrain B to be zero - default FALSE
#' @export
boot.params <- function(Q, P, Qhi=NULL, N=50, ConstrainBzero=FALSE) {
  variable <- NULL # to appease the checking gods... sort of...
  L <- length(Q)
  stopifnot(L > 1)
  stopifnot(L == length(P))
  # not efficient and potentially very slow, but let's just
  # append the results using rbind - it will definitely work...
  for (i in 1:N) {
    s1 <- sample(L, size=L, replace=TRUE)
    if (i==1) {
      bdf <- calc.params(Q[s1], P[s1], Qhi, ConstrainBzero)
    } else {
      bdf <- rbind(bdf, calc.params(Q[s1], P[s1], Qhi,ConstrainBzero))
    }
  }
  # print(summary(bdf))
  # instead of printing the summary, we'll print the 2.5%ile, mean and 97.5%ile
  # of each column of bdf

  # library(reshape2) # in the DESCRIPTION file
  # calling melt with id.vars=NULL because we want it to melt ALL columns
  # and not print a message
  jdf <- reshape2::melt(bdf, id.vars=NULL)
  # head(jdf) # variable value...
  # library(plyr)
  # phoslam.summary <- function(sdf) {
  #   c(CI=quantile(sdf$value, 0.025), Mean=mean(sdf$value), CI=quantile(sdf$value, 0.975))
  # }
  # print(plyr::ddply(jdf, variable, phoslam.summary))

  # now for each of the variables, e.g. Bowes.A etc. do some summary stats
  jdf %>%
    group_by(variable) %>%
    summarise(CI025=stats::quantile(value, 0.025, na.rm=TRUE),
      Mean=base::mean(value, na.rm=TRUE),
      Median=stats::median(value, na.rm=TRUE),
      Sd=stats::sd(value, na.rm=TRUE),
      Se=stats::sd(value, na.rm=TRUE)/sqrt(L),
      CI975=stats::quantile(value, 0.975, na.rm=TRUE)) %>%
    print(n=Inf)

  bdf
}

