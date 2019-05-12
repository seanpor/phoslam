#' @title Fit the Bowes A,B,C,D parameters to data
#' @param d1 dataframe containing a column "Q" and a column "TRP"
#' @param bf.iMax maximum number of iterations of XXX defaulting to a million
#' @param ConstrainBzero if TRUE (default), then the Bowes model will constrain
#'   B to be zero instead of allowing it to be in the range 0.01 to 1
#' @name Bowes.fit
#' @export
#
# Assuming that Q and TRP have been rationalised into SI units
#
# X is the Q value - cubic metres/second
# Y is the TRP value - microgrammes per litre
#
# Bowes model
# Y = A*(X^(B-1)) + C*(X^(D-1))
# Y = Point       + Diffuse
#   constraints:
#     B < 1
#     D > 1
#   using Least-Squares...
#
#
# figure out the A, B, C, D
# which are all in microgrammes per litre per cubic metre per second
#    which is equal to milligrammes per second
#
# WARNING:  occasionally this seems to fail to converge
# so we need to trap for this as it causes an error
# and re-start, possibly using different starting values
# sometimes this can take a long time to converge
# someone referred to this as coming down the valley onto an
# ice lake and trying to find the lowest point
# eventually it will find a tiny pit in the ice
Bowes.fit <- function(d1, bf.iMax=1e4, ConstrainBzero=FALSE) {
  # it is possible that this just might not converge at all!
  # the following is some insurance albeit expensive!
  # and some statistics
  bowes.ivec <- integer(bf.iMax)

  bf.i <- 0 # how many times have we run nls() ?
  if (ConstrainBzero) {
    Formula <- TRP ~ A*(Q^(-1)) + C*(Q^(D-1))
  } else {
    Formula <- TRP ~ A*(Q^(B-1)) + C*(Q^(D-1))
  }
  repeat {
    bf.opt <- options(warn=-1) # temporarily turn off warnings completely!
    # this is because nls.control() can't do it... unfortunately
    #tmp.bf <- try( stats::nls(Formula,
    tmp.bf <- try( minpack.lm::nlsLM(Formula,
                       start=c(A=stats::runif(1, 1, 100),
                               B=stats::runif(1, 0.01, 1),
                               C=stats::runif(1, 3, 200),
                               D=stats::runif(1, 1, 5)),
                       jac = NULL, # Jacobian
                       # start=c(A=0, B=0.1, C=0.1, D=9),
                       control = stats::nls.control(maxiter=500, warnOnly=TRUE),
                       # following prints out a trace of each iteration if TRUE (default FALSE)
                       # trace=TRUE,
                       algorithm='port',
                       lower=c(0,0,0,1),
                       upper=c(1e5, 1, 1e5, 1e5),
                       data=d1) )
    options(warn=bf.opt$warn) # turn warnings back on again
    if(!inherits(tmp.bf, 'try-error')) {
      # cat('got somewhere... but still might be a rubbish convergence!\n')
      # cat(tmp.bf$message, '\n')
      # nb an explanation of these stop codes is on page 3 of the PORT library
      # documentation which can be found at
      #  http://netlib.bell-labs.com/cm/cs/cstr/153.pdf
      # in short "The desirable return codes are 3,4,5 and sometimes 6."
      bowes.ivec[bf.i] <- tmp.bf$convInfo$stopCode
      if (tmp.bf$convInfo$isConv) { # we have convergence!!!
        break;
      }
    } else {
      bowes.ivec[bf.i] <- -1
    }
    if(bf.i >= bf.iMax) break; # no convergence what so ever OH DEAR!!!
    bf.i <- bf.i + 1
  }
  if (class(tmp.bf) == 'try-error')
    stop(tmp.bf)
  # add in the info from attempts
  tmp.bf$attempt.table <- table(bowes.ivec)
  tmp.bf
}
# debug(Bowes.fit)
