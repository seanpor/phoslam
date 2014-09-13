#' @title Green calculations as far as apportionment
#' @name Greene.calcs
#' @param d1 a dataframe containing XXX
#' @param AltQ a numeric vector containing an alternative source of Q information which will be used for XXX
#' @export
#
#' @description lets do all the Greene calculations as far as apportionment
#' 
#' @details
#' nb AltQ is an alternative source of Q - typically High-Frequency Q
#' when we only have low frequency TRP
#' when AltQ is not supplied, then the Q values from d1 are used
#' NB. AltQ is assumed to be a numeric array identical to
#'   d1$Q, but possibly much much longer!
Greene.calcs <- function(d1, AltQ=NULL) {
  if(is.null(AltQ)) {
    Qsource <- d1$Q
  } else {
    Qsource <- AltQ
  }

  Greene <- Greene.fit(d1)
  Greene.A <- coef(Greene)[['A']]
  Greene.B <- coef(Greene)[['B']]
  Greene.C <- coef(Greene)[['C']]
  
  d1$GreenePred <- predict(Greene, Qsource)
  
  d1$GreenePoint <- Greene.A/Qsource
  d1$GreeneDiffuse <- Greene.B*Qsource
  d1$GreeneHysteresis <- Greene.C*Qsource^2
  d1$GreeneDH <- d1$GreeneDiffuse + d1$GreeneHysteresis 
  
  # Then get the actual Point/Diffuse concentrations for the values of Q given
  # then multiply by Q to get the actual loads (milligrammes per second)
  d1$GreenePred.L <- d1$GreenePred*Qsource
  d1$GreenePoint.L <- d1$GreenePoint*Qsource
  d1$GreeneDiffuse.L <- d1$GreeneDiffuse*Qsource
  d1$GreeneHysteresis.L <- d1$GreeneHysteresis*Qsource
  d1$GreeneDH.L <- d1$GreeneDiffuse.L + d1$GreeneHysteresis.L 
  
  Greene.Qe <- Calc.Greene.Qe(Greene, d1)
  
  # Proportion of cases where of samples where Qe > Q
  Greene.PropQeGQ <- length(which(Greene.Qe > Qsource))/length(Qsource)
  
  # What proportion of the Sample data was Point source?
  # based on the Greene model?
  Greene.PointApportionment <- sum(d1$GreenePoint.L)/
    sum(d1$GreenePoint.L + d1$GreeneDH.L)
  
  list(Greene=Greene,
       Greene.coefficients=coef(Greene),
       Greene.Qe=Greene.Qe,
       Greene.PropQeGQ=Greene.PropQeGQ,
       Greene.PointApportionment=Greene.PointApportionment,
       results=d1)
}
# debug(greene.calcs)
