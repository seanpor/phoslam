#' @name Bowes.ReCalc
#' @title Do the recalculations necessary for re-analysing with a HiFrequency dataset.
#' @param arec is a record from the output files which have names like
# sCombo_5a_analysis.csv
#' @param Qsource is a numeric vector of flow rates in cubic metres per second

Bowes.ReCalc <- function(arec, Qsource=NULL) {
  stopifnot(!is.null(arec))    # must get a record
  stopifnot(!is.null(Qsource)) # must get Q!
  stopifnot(nrow(arec) == 1)   # can only cope with one record at a time
  
  # Bowes <- Bowes.fit(d1)
  # BowesPred <- predict(Bowes, Qsource)
  
  # extract the coefficients
  Bowes.A <- arec$B.A
  Bowes.B <- arec$B.B
  Bowes.C <- arec$B.C
  Bowes.D <- arec$B.D
  
  # now lets split the Bowe Point / Diffuse concentrations
  BowesPoint   <- Bowes.A*(Qsource^(Bowes.B-1))
  BowesDiffuse <- Bowes.C*(Qsource^(Bowes.D-1))
  
  # calculating the acual loads, multiply by Q
  LoadMultiplier <- 86400/1000000
  BowesPoint.L   <- BowesPoint*Qsource*LoadMultiplier
  BowesDiffuse.L <- BowesDiffuse*Qsource*LoadMultiplier
  
  #
  # Then get the actual Point/Diffuse concentrations for the values of Q given
  # then multiply by Q to get the actual loads
  # 
  # NB some people might only have rare TRP values and lots of Q values
  # and will want to know the apportionment between the Point/Diffuse
  
  # calculate the Qe value - which for Bowes
  # Qe=(A/C)^(1/(D-B))
  Bowes.Qe <- (Bowes.A/Bowes.C)^(1/(Bowes.D-Bowes.B))
  # this is wrong as it solves for the minimum of the curve 
  # which is not what we want...
  # Bowes.Qe <- ReCalcBowesMin(Bowes.A, Bowes.B, Bowes.C, Bowes.D)
  
  # Proportion of cases where of samples where Bowes.Qe > Q
  Bowes.PropQeGQ <- length(which(Bowes.Qe > Qsource))/length(Qsource)
  
  # What proportion of the Sample data was Point source?
  # based on the Bowes model?
  Bowes.TotalLoad <- sum(BowesPoint.L + BowesDiffuse.L)
  Bowes.PointApportionment <- sum(BowesPoint.L)/Bowes.TotalLoad
  
  # represents the Q value at which the Point load crosses over with
  # the Diffuse load value
  list(Bowes.Qe=Bowes.Qe,
       Bowes.PropQeGQ=Bowes.PropQeGQ,
       Bowes.PointApportionment=Bowes.PointApportionment,
       Bowes.TotalLoad=Bowes.TotalLoad)
}
# debug(Bowes.ReCalc)
