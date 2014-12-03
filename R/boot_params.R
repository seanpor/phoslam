# a function to perform bootstrapping of
# the Bowes and Greene coefficients along with Qe etc.
#' @title Calculate the Bowes and Greene parameters for a given set of paired Q and P
#' @name boot.params
#' @param Q the measured water flow rate in cubic metres per second
#' @param P the Total Reactive Phostphate - units- TBD
#' @param Qhi the high-frequency Q values in cubic metres per second
#' @param N the number of bootstrap replications - defaults to 50 for a reasonable size for estimating the mean.
#' @export
boot.params <- function(Q, P, Qhi=NULL, N=50) {
  L <- length(Q)
  stopifnot(L > 1)
  stopifnot(L == length(P))
  # not efficient and potentially very slow, but let's just
  # append the results using rbind - it will definitely work...
  for (i in 1:N) {
    s1 <- sample(L, size=L, replace=TRUE)
    if (i==1) {
      bdf <- calc.params(Q[s1], P[s1], Qhi)
    } else {
      bdf <- rbind(bdf, calc.params(Q[s1], P[s1], Qhi))
    }
  }
  print(summary(bdf))
  bdf
}

