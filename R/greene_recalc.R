# lets do all the Greene calculations as far as apportionment
# nb AltQ is an alternative source of Q - typically High-Frequency Q
# when we only have low frequency TRP
# when AltQ is not supplied, then the Q values from d1 are used
# NB. AltQ is assumed to be a numeric array identical to
#   Q, but possibly much much longer!
Greene.ReCalc <- function(arec, Qsource=NULL) {
  stopifnot(!is.null(arec))    # must get a record
  stopifnot(!is.null(Qsource)) # must get Q!
  stopifnot(nrow(arec) == 1)   # can only cope with one record at a time
  
  Greene.A <- arec$G.A
  Greene.B <- arec$G.B
  Greene.C <- arec$G.C
  
  # GreenePred <- predict(Greene, Qsource)
  # Greene TRP ~ A/Q + B*Q + C*Q^2
  GreenePoint <- Greene.A/Qsource
  GreeneDiffuse <- Greene.B*Qsource
  GreeneHysteresis <- Greene.C*Qsource^2
  GreeneDH <- GreeneDiffuse + GreeneHysteresis 
  GreenePredneg <- GreenePoint + GreeneDiffuse + GreeneHysteresis
  GreenePred <- GreenePoint + pmax(0, GreeneDiffuse + GreeneHysteresis)
  
  # Then get the actual Point/Diffuse concentrations for the values of Q given
  # then multiply by Q to get the actual loads (milligrammes per second)
  LoadMultiplier <- 86400/1000000
  GreenePredneg.L <- GreenePredneg*Qsource*LoadMultiplier
  GreenePred.L <- GreenePred*Qsource*LoadMultiplier
  GreenePoint.L <- GreenePoint*Qsource*LoadMultiplier
  GreeneDiffuse.L <- GreeneDiffuse*Qsource*LoadMultiplier
  GreeneHysteresis.L <- GreeneHysteresis*Qsource*LoadMultiplier
  GreeneDHneg.L <- GreeneDiffuse.L + GreeneHysteresis.L 
  
  Greene.Qe <- GreeneQe(Greene.A, Greene.B, Greene.C)
  
  # Proportion of cases where of samples where Bowes.Qe > Q
  Greene.PropQeGQ <- length(which(Greene.Qe > Qsource))/length(Qsource)
  
  # What proportion of the Sample data was Point source?
  # based on the Greene model?
  Greene.PointApportionmentNeg <- sum(GreenePoint.L)/
    sum(GreenePoint.L + GreeneDHneg.L)
  
  Greene.PointApportionment <- sum(GreenePoint.L)/
    sum(GreenePoint.L + pmax(0, GreeneDHneg.L))
  
  list(Greene.Qe=Greene.Qe,
       Greene.PropQeGQ=Greene.PropQeGQ,
       Greene.PointApportionment=Greene.PointApportionment,
       Greene.PointApportionmentNeg=Greene.PointApportionmentNeg,
       Greene.TotalLoad=sum(GreenePred.L),
       Greene.TotalLoadNeg=sum(GreenePredneg.L)
  )
}
# debug(Greene.ReCalc)
