phoslam
=======

The phoslam R package has been designed to use either the algorithm developed by Bowes et al. (2008), hereafter known as BM, or an adjustment of the algorithm by Greene et al. (2011), hereafter known as GM, to apportion the phosphorus load in a river to point and diffuse sources. Outcomes include the percentage of the load apportioned to point and diffuse sources, the percentage of time flow is dominated by point sources (based on flow data provided either low or high frequency) and total phosphorus load. The package is currently under development with future improvements to include automated bootstrapping to provide confidence intervals of outcomes.

Bowes, M.J., Smith, J.T., Jarvie, H.P., Neal, C., 2008. Modelling of phosphorus inputs to rivers from
diffuse and point sources. Sci Total Environ 395 (2-3), 125-138.

Greene, S., Greene, S., Taylor, D., McElarney, Y.R., Foy, R.H., Jordan, P., 2011. An evaluation of catchment-scale phosphorus mitigation using load apportionment modelling. Sci Total Environ 409(11), 2211-2221. 10.1016/j.scitotenv.2011.02.016. 

# Installation


### Pre-requisites
If you don't already have the "plyr" and "reshape2" packages, then you will also need to install these first.
```
install.packages(c('plyr','reshape2','dplyr',
    'magrittr', 'minpack.lm'))
```
### Linux / Mac
If you are using R on Linux or a Mac the simplest thing is to install Hadley Wickham's devtools package from CRAN and then you should be able to install `phoslam` directly from Github by saying:
```
install.packages("devtools")
devtools::install_github("seanpor/phoslam")
```

### MS-Windows
If you're using R on MS-Windows, then goto https://github.com/seanpor/phoslam/releases and grap the latest version of the zip file phoslam_0.X.zip which you should then be able to install by going to the "Packages" menu in R for Windows and then selecting "Install package(s) from local zip files..." and following the instructions.

If you're using RStudio on MS-Windows, go to the "Tools" menu and select "Install Packages...". In the "Install from:" dropdown box select "Package Archive File (.zip; .tar.gz)" and use the "Browse..." button to find the downloaded ".zip" file and click on "Install".

# Basic Usage

You have a low-frequency flow (Q) and phosphorus (P) dataset and would like to apportion the load to either point or diffuse sources by obtaining the best fit line using either the Bowes or Greene model.  Note that Q is in cubic metres per second and P is in microgrammes per litre.
```
library(phoslam)
calc.params(Q, P)
```
Of course Q and P must be the same length and must be numeric vectors or equivalently the columns of a data.frame, e.g. if they are in the data.frame d2, I can say

```
calc.params(d2$Q, d2$P)
```
Will print out the results as a single row data.frame without confidence intervals for model parameters.

# Bootstrapping for confidence intervals
If you also have a high-frequency dataset for the flow, Qhi (again cubic metres per second), you can now bootstrap... N=50 is enough for the mean, but you'll need at least N=2000 for a reasonable estimate of the 2.5%ile and 97.5%ile quantiles.  Obviously the values of the 95%ile range will be highly suspect if you use an N of as low as 50.  Bootstrapping with a low frequency dataset is technically possible but similarly, the fewer resamples you have the less robust your quantiles are. Dataframe named d1 is the high frequency Q dataset while d2 is the low frequency Q and P dataset.
```
kdf <- boot.params(d2$Q, d2$P, d1$Q, N=2000) # warning this might take quite some time!
```
This will print a 2.5%ile, the mean and the 97.5%ile values for each of the parameters.

### Plotting results
If `kdf` is the data.frame with the bootstrapped values of the parameters from above, you can look at histograms of all of these using the wonderful `ggplot2` graphics package, which you can install if you haven't already using `install.packages('ggplot2', dep=T)`.
```
library(ggplot2)
plot1 <- qplot(value, data=jdf, geom='histogram') + facet_wrap(~variable, scales='free_x')
suppressMessages(print(plot1))
```

This awkward form: `plot1 <- qplot(); print(plot1)` is used to suppress the 29 un-necessary complaints:
```
stat_bin: binwidth defaulted to range/30. Use 'binwidth = x' to adjust this.
```
However, this is just an over-zealous complaint message because we are using the defaults and it is not a warning, so it is safe to ignore.

# Output description

TO DO, including a detailed description of each parameter output with the units involved.

I also need to remove the dependancy on `plyr` since I have in some places replaced it with `dplyr` which is better and faster!

### Output Params
  - **Bowes.A** - Bowes model A parameter
  - **Bowes.B** - Bowes model B parameter (constrained <1)
  - **Bowes.C** - Bowes model C parameter
  - **Bowes.D** - Bowes model D parameter (constrained >1)
  - **Bowes.Qe** - Qe for the Bowes Model
  - **Bowes.PropQeGQ** - the proportion of the flow measurements that are less than Bowes.Qe above
  - **Bowes.PointApportionment** - the proportion of the load apportioned to point sources using the Bowes model
  - **Bowes.Point.L** -  Estimate of the point load using the Bowes model
  - **Bowes.Diffuse.L** - Estimate of the diffuse load using the Bowes model
  - **Greene.A** - Greene model A parameter
  - **Greene.B** - Greene model B parameter
  - **Greene.C** - Greene model C parameter
  - **Greene.Qe** - Qe for the Greene Model
  - **Greene.PropQeGQ** - the proportion of the flow measurements that are less than Greene.Qe above
  - **Greene.PointApportionment** - the proportion of the load apportioned to point sources using the Greene model
  - **Greene.Point.L** - Estimate of the point load using the Greene model
  - **Greene.Diffuse.L** - Estimate of the diffuse load using the Greene model
  - **Greene.Hysteresis.L** - Estimate of the hysteresis load using the Greene model
  - **Greene.DH.L** - Estimate of the diffuse and hysteresis load using the Greene model
  - **Bowes.Qe.1** - Qe for the Bowes Model (this does not change with high-frequency flow data)
  - **Bowes.PropQeGQ.1** - the proportion of flows collected at high-frequency that are less than Bowes.Qe.Qhi
  - **Bowes.PointApportionment.1** - 
  - **Bowes.TotalLoad** -
  - **Greene.Qe.1** -
  - **Greene.PropQeGQ.1** -
  - **Greene.PointApportionment.1** -
  - **Greene.PointApportionmentNeg** -
  - **Greene.TotalLoad** -
  - **Greene.TotalLoadNeg** -
