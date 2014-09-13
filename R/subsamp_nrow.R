#' subsample from a data.frame
#'
#' @description sub-sample rows randomly from a data.frame
#' @param adf a data.frame to sample from
#' @param n number of rows to sample, default 1
#' @return rows from the input data.frame as a data.frame
#' @export
subsamp.nrow <- function(adf, n=1) {
  adf[sample(nrow(adf),n),]
}
