#' @title Calculate the Greene Qe value using numerical methods
#' @name Calc.Greene.Qe
#' @param Greene an Greene object XXX
#' @param adf a dataframe containing XXX
#' @export
#
#' @details Here Qe has to be calculated numerically - so the X value at which
#' Point is bigger than (Diffuse + Hysteresis)
#'
#' So to figure out Qe, need to find the first zero point of
#' d1$GreeneDH.L-d1$GreenePoint.L
#' in the Q range that is actually there, i.e. Qe > 0 and Qe<max(Q)
#' but we can get this from the function itself... by substituting
#' the coefficients we have into the function itself...
#' i.e. we want to find the zero for the function
#' (B*Q + C*Q^2) - A/Q in the range 0, to max(d1$Q)
#
#' nb. should limit Q to be in the range
#' 0, Q value of min(d1$GreenePoint.L-d1$GreeneDH.L)
Calc.Greene.Qe <- function(Greene, adf) {
  qe.func <- function(x, GreeneFit) {
    A <- coef(GreeneFit)[['A']]
    B <- coef(GreeneFit)[['B']]
    C <- coef(GreeneFit)[['C']]
    (B*x + C*x^2) - A/x
  }
  # we need to range search for the location of the root from zero up
  # to a high point and this line has a stab at figuring out where that is
  q.range <- c(0, adf[which.min(adf$GreenePoint.L - adf$GreeneDH.L),'Q'])
  if (exists('sDEBUG')) {
    if (sDEBUG > 5) {
      cat('  in Calc.Greene.Qe(), the q.range is', q.range[[1]],
          ',', q.range[[2]], '\n')
    }
  }
  GQe <- uniroot(qe.func, interval=q.range, Greene)
  GQe$root
}