# a function to perform one iteration of a bootstrap or jackknife given a dataset
# intended to return the Bowes and Greene coefficients along with Qe etc.
#' @title Calculate the Bowes and Greene parameters for a given set of paired Q and P
#' @name calc.params
#' @param Q the measured water flow rate in cubic metres per second
#' @param P the Total Reactive Phostphate - units- TBD
#' @param Qhi the high-frequency Q values in cubic metres per second
#' @param ConstrainBzero if TRUE (default), then the Bowes model will constrain
#'   B to be zero instead of allowing it to be in the range 0.01 to 1
#' @export
calc.params <- function(Q, P, Qhi=NULL, ConstrainBzero=TRUE) {
  stopifnot(length(Q) > 1)
  stopifnot(length(Q) == length(P))

  b3 <- Bowes.calcs(data.frame(Q=Q, TRP=P), ConstrainBzero=ConstrainBzero)
  g3 <- Greene.calcs(data.frame(Q=Q, TRP=P))
  res <- data.frame(# Bowes Params
                    Bowes.A=b3$Bowes.coefficients[['A']],
                    Bowes.B=b3$Bowes.coefficients[['B']],
                    Bowes.C=b3$Bowes.coefficients[['C']],
                    Bowes.D=b3$Bowes.coefficients[['D']],
                    Bowes.Qe=b3$Bowes.Qe,
                    Bowes.PropQeGQ=b3$Bowes.PropQeGQ,
                    Bowes.PointApportionment=b3$Bowes.PointApportionment,
                    # Bowes Loads
                    Bowes.Point.L=sum(b3$results$BowesPoint.L),
                    Bowes.Diffuse.L=sum(b3$results$BowesDiffuse.L),
                    # Greene params
                    Greene.A=g3$Greene.coefficients[['A']],
                    Greene.B=g3$Greene.coefficients[['B']],
                    Greene.C=g3$Greene.coefficients[['C']],
                    Greene.Qe=g3$Greene.Qe,
                    Greene.PropQeGQ=g3$Greene.PropQeGQ,
                    Greene.PointApportionment=g3$Greene.PointApportionment,
                    # Greene Loads
                    Greene.Point.L=sum(g3$results$GreenePoint.L),
                    Greene.Diffuse.L=sum(g3$results$GreeneDiffuse.L),
                    Greene.Hysteresis.L=sum(g3$results$GreeneHysteresis.L),
                    Greene.DH.L=sum(g3$results$GreeneDH.L))
  # if there is a High-Frequency Q series supplied, then
  # use the information from the above to do the calculations for doing
  # calculations of Qe, PropQeGQ, Point Apportionment and Total Load
  if (!is.null(Qhi)) {
    Bq <- Bowes.ReCalc(data.frame(B.A=res$Bowes.A,
                       B.B=res$Bowes.B,
                       B.C=res$Bowes.C,
                       B.D=res$Bowes.D), Qhi)
    Gq <- Greene.ReCalc(data.frame(G.A=res$Greene.A,
                                   G.B=res$Greene.B,
                                   G.C=res$Greene.C), Qhi)
    res <- data.frame(res, Bq, Gq)
  }
  res
}
