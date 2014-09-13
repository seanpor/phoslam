#' @title take a data.frame and label dates according to given ranges
#' @name label.date.range
#' @param dates vector of dates which are to be classifed
#' @param date.range.df data.frame specifying how to classify dates
#' @param else.label if a date isn't in a specified range then use this label
#' @details start a list of start months
#'   end a list of end months, nb the list must be the same length as start
#'   label a list of labels to be attached, nb the list must be the same length as start and end
#' @export
# a function to take a list of date pairs and labels such
# that it can be used to label a set of dates like 
# "Winter"/"Summer" or "Open"/"Closed"
# the date pairs and labels are passed in as a data.frame
# and if there are overlapping ranges then the outcome is
# undefined.
# There is also an "else.label" parameter so you can say that if
# a date isn't in a range, then it will use this range...
# the date.range.df is expected to have three columns,
# c('start', 'end', 'label'); e.g.
# NOTE that a year is given in the date range, and these are
#      merely transferred into day numbers in a year, e.g. Jan-1=1
# NOTE it is expected that this should be extended to take years
#      as some years might be expected to have a diferent date range
#      than other years...
# Example data.frame
# example.df <- data.frame(start=c('Jan-01', 'Apr-01', 'Oct-01'),
#                   end=c('Mar-31', 'Sep-30', 'Dec-31'),
#                   label=c('Winter', 'Summer', 'Winter'))
#
# ISSUE doesn't work properly in leap years!
label.date.range <- function(dates, date.range.df, else.label='Not Assigned') {
  N <- length(dates)
  ans <- rep(NA, N)
  for (i in 1:nrow(date.range.df)) {
    start <- rep(date.range.df[i, 'start'], N)
    start <- as.Date(paste(format(dates, '%Y'), start, sep='-'),
                     '%Y-%b-%d')
    end <- rep(date.range.df[i, 'end'], N)
    end <- as.Date(paste(format(dates, '%Y'), end, sep='-'),
                   '%Y-%b-%d')
    ans[(dates >= start) &
          (dates <= end)] <- date.range.df[i, 'label']
  }
  if(!is.null(else.label)) {
    ans <- ifelse(is.na(ans), else.label, ans)
  }
  ans
}
# debug(label.date.range)

#' test label date range
#' @name test.label.date.range
#' @param N testing number
#' @param random.seed just that - a random seed which defaults to 123
test.label.date.range <- function(N=40, random.seed=123) {
  date.df <- data.frame(start=c('Jan-01', 'Apr-01', 'Oct-01'),
                        end=c('Mar-31', 'Sep-30', 'Dec-25'),
                        label=c('Winter', 'Summer', 'Winter'),
                        stringsAsFactors=FALSE)
  # note that only classify as far as Dec-25... leaving a few
  # days blank to test for "Not Assigned" in case 21
  sample.date.range <- seq.Date(as.Date('2008-01-01'),
                                as.Date('2013-12-31'), by='day')
  set.seed(random.seed)
  sample.date.set <- sample(sample.date.range, N)
  label.date.range(sample.date.set, date.df, else.label="Not Assigned")
}
# debug(test.label.date.range)
