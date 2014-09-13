#' Fit the Greene parameters to data
#'
#' @description
#' \code{Greene.fit} takes a dataset and attempts to fit a Greene Model, i.e.
#' $Y = A/X   + B*X     + C*X^2$, i.e. Y = Point + Diffuse + Hysteresis
#' with   no constraints
#' @param d1 a data.frame XXX
#' @param iMax maximum number of iterations? XXX
#' @details
#' Note that sometimes this has problems converging hence
#' there is a loop and random start points
#'
#' @export
Greene.fit <- function(d1, iMax=100) {
  i <- 0
  repeat {
    tmp <- stats::nls(TRP ~ A/Q + B*Q + C*Q^2,
               nls.control(maxiter=500, warnOnly=TRUE),
               start=c(A=runif(1, 0.5, 3),
                       B=runif(1, 50, 500),
                       C=runif(1, -500, 500)),
               data=d1)
    i <- i + 1
    if ((class(tmp) != "try-error") || (i >= iMax)) {
      break;
    }
  } 
  if (class(tmp) == 'try-error')
    error(tmp)
  if (exists('sDEBUG')) {
    if (sDEBUG > 5) {
      cat('  in Greene.fit(), the iMax is', iMax, '\n')
      cat('  in Greene.fit(), the class of tmp is', class(tmp), '\n')
      cat('  in Greene.fit(), tmp is', tmp, '\n')
    }
  }
  tmp  
}
# debug(Greene.fit)
