#' Bowes calculations
#' 
#' Takes a data.frame and performs a number of calculations related
#' to the Bowes formal
#' @param d1 a data.frame in a particular format - TBD
#' @param AltQ an optional numeric vector containing the flows to be used
#' for apportionment, nb. in m^3/sec
#' @return a list containing the results
#' @export
#
#' @details Does all the Bowes calculations as far as apportionment
#' nb AltQ is an alternative source of Q - typically High-Frequency Q
#' when we only have low frequency TRP
#' when AltQ is not supplied, then the Q values from d1 are used
#' NB. AltQ is assumed to be a numeric array identical to
#'   d1$Q, but possibly much much longer!
Bowes.calcs <- function(d1, AltQ=NULL) {
  if(is.null(AltQ)) {
    Qsource <- d1$Q
  } else {
    Qsource <- AltQ
  }
  Bowes <- Bowes.fit(d1)
  d1$BowesPred <- predict(Bowes, Qsource)
  
  # extract the coefficients
  Bowes.A <- coef(Bowes)[['A']]
  Bowes.B <- coef(Bowes)[['B']]
  Bowes.C <- coef(Bowes)[['C']]
  Bowes.D <- coef(Bowes)[['D']]
  
  # now lets split the Bowe Point / Diffuse concentrations
  d1$BowesPoint   <- Bowes.A*(Qsource^(Bowes.B-1))
  d1$BowesDiffuse <- Bowes.C*(Qsource^(Bowes.D-1))
  
  # calculating the acual loads, multiply by Q
  d1$BowesPoint.L   <- d1$BowesPoint*Qsource
  d1$BowesDiffuse.L <- d1$BowesDiffuse*Qsource
  
  #
  # Then get the actual Point/Diffuse concentrations for the values of Q given
  # then multiply by Q to get the actual loads
  # 
  # NB some people might only have rare TRP values and lots of Q values
  # and will want to know the apportionment between the Point/Diffuse
  
  # calculate the Qe value - which for Bowes
  # Qe=(A/C)^(1/(D-B))
  Bowes.Qe <- (Bowes.A/Bowes.C)^(1/(Bowes.D-Bowes.B))
  
  # Proportion of cases where of samples where Bowes.Qe > Q
  Bowes.PropQeGQ <- length(which(Bowes.Qe > Qsource))/length(Qsource)
  
  # What proportion of the Sample data was Point source?
  # based on the Bowes model?
  Bowes.PointApportionment <- sum(d1$BowesPoint.L)/
    sum(d1$BowesPoint.L + d1$BowesDiffuse.L)
  
  # represents the Q value at which the Point load crosses over with
  # the Diffuse load value
  list(Bowes=Bowes,
       Bowes.coefficients=coef(Bowes),
       Bowes.Qe=Bowes.Qe,
       Bowes.PropQeGQ=Bowes.PropQeGQ,
       Bowes.PointApportionment=Bowes.PointApportionment,
       results=d1)
}
# debug(bowes.calcs)
