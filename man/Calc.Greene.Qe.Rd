% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/calc_greene_qe.R
\name{Calc.Greene.Qe}
\alias{Calc.Greene.Qe}
\title{Calculate the Greene Qe value using numerical methods}
\usage{
Calc.Greene.Qe(Greene, adf, sDEBUG = NULL)
}
\arguments{
\item{Greene}{a Greene object XXX}

\item{adf}{a dataframe containing XXX}

\item{sDEBUG}{a parameter not normally used except in debugging, set to be an
integer >5 for maximum debug information printed.}
}
\description{
Calculate the Greene Qe value using numerical methods
}
\details{
Here Qe has to be calculated numerically - so the flow value at which
Point is bigger than (Diffuse + Hysteresis)

So to figure out Qe, need to find the first zero point of
d1$GreeneDH.L-d1$GreenePoint.L
in the Q range that is actually there, i.e. Qe > 0 and Qe<max(Q)
but we can get this from the function itself... by substituting
the coefficients we have into the function itself...
i.e. we want to find the zero for the function
(B*Q + C*Q^2) - A/Q in the range 0, to max(d1$Q)
nb. should limit Q to be in the range
0, Q value of min(d1$GreenePoint.L-d1$GreeneDH.L)
}
