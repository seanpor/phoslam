#' Solve the Greene equation for Qe
#'
#' @description Qe is when the larger contribution switches from
#' point to diffuse - there is always point contribution but at high flows it is
#' outweighed by the diffuse contribution.
#' \code{GreeneQe} takes a set of three Greene coefficient, A,B,C and solves
#' the Greene equation for the
#' $TRP = A/Q   + B*Q     + C*Q^2$, i.e. TRP = Point + Diffuse + Hysteresis
#' flow rate Q at which Point = Diffuse + Hysteresis
#' @param A Greene equation coefficient
#' @param B Greene equation coefficient
#' @param C Greene equation coefficient
#' @param rightedge The flow rate parameter which is expected to be greater than Qe
#' @param sDEBUG a parameter not normally used except in debugging, set to be an
#' integer >5 for maximum debug information printed.

#' @details
#' Note that sometimes this has problems converging hence
#' there is a further parater right edge which limits the range of Q at the
#' upper end.
#'
#' @export
GreeneQe <- function(A,B,C, rightedge=1, sDEBUG=NULL) {
  # this approach works by finding the root of the
  # equation A/Q == B*Q + C*Q^2
  d1 <- function(x) A/x - (B*x + C*x^2)
  # nb. occasionally get cases where the interval doesn't "trap"
  # the root...
  # lets make a big assumption that the max height of the diffuse+hysteresis
  # is to the right and zero is to the left...
  highpoint <- -B/(2*C)
  if (!is.null(sDEBUG) && sDEBUG > 4) {
    cat(' GreeneQe: A=', A, ' B=',B, ' C=', C, '  highpoint=', highpoint, '\n')
    # issue for  GreeneQe: A= 3.351263  B= 226.4885  C= 14.5105   highpoint= -7.804297
  }
  if (highpoint > 0) {
    rightedge <- min(highpoint, rightedge)
  }
  tmp <- stats::uniroot(d1, c(1e-9, rightedge))
  tmp$root
}
# debug((GreeneQe)
# GreeneQe(ADF[1,'G.A'], ADF[1,'G.B'], ADF[1,'G.C'])
