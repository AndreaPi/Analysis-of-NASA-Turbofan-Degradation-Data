---
title: "Exploratory Data Analysis of NASA Turbofan Engine Degradation Data"
author: "2018-03-15"
date: '_reading time: ? minutes_'
subtitle: Andrea Panizza
output:
  html_document:
    fig_caption: yes
    keep_md: yes
params:
  output_dir: ../output
---

<style>
p.caption {
  font-size: 0.8em;
}
</style>



## Read data

The data are taken from the [NASA Ames Prognostic Center](https://ti.arc.nasa.gov/tech/dash/groups/pcoe/prognostic-data-repository/). In particular, dataset 6 **Turbofan Engine Degradation Simulation Data Set** has been used. The description is

>Engine degradation simulation was carried out using C-MAPSS. Four different were sets simulated under different combinations of operational conditions and fault modes. Records several sensor channels to characterize fault evolution. The data set was provided by the Prognostics CoE at NASA Ames.

These data have been used in the PHM (Prognostic and Health Management) competition in 2008. A `readme.txt` file is provided with the data, containing the following information which clarifies the data format:

_Experimental Scenario_

_Data sets consists of multiple multivariate time series. Each data set is further divided into training and test subsets. Each time series is from a different engine – i.e., the data can be considered to be from a fleet of engines of the same type. Each engine starts with different degrees of initial wear and manufacturing variation which is unknown to the user. This wear and variation is considered normal, i.e., it is not considered a fault condition. There are three operational settings that have a substantial effect on engine performance. These settings are also included in the data. The data is contaminated with sensor noise._

_The engine is operating normally at the start of each time series, and develops a fault at some point during the series. In the training set, the fault grows in magnitude until system failure. In the test set, the time series ends some time prior to system failure. The objective of the competition is to predict the number of remaining operational cycles before failure in the test set, i.e., the number of operational cycles after the last cycle that the engine will continue to operate. Also provided a vector of true Remaining Useful Life (RUL) values for the test data._

_The data are provided as a zip-compressed text file with 26 columns of numbers, separated by spaces. Each row is a snapshot of data taken during a single operational cycle, each column is a different variable. The columns correspond to:_

 <i>
 
 1.	unit number
 2.	time, in cycles
 3.	operational setting 1
 4.	operational setting 2
 5.	operational setting 3
 6.	sensor measurement  1
 7.	sensor measurement  2
 .
 .
 .
 26. sensor measurement 21
 
 </i>

We will concentrate on data set `FD001` for now, which consist of a training set with 100 time series, a test set with the same number of time series and a file containing the 100 true Remaining Useful Life (RUL) values, that our algorithm should predict for each corresponding test time series. Let's read the data:


```r
data_filename <- "train_FD001.txt"
data_path <- file.path(data_dir, data_filename)
train_set <- read_table2(data_path, col_names = FALSE, col_types = cols(X27 = "_"))
data_filename <- "test_FD001.txt"
data_path <- file.path(data_dir, data_filename)
test_set <- read_table2(data_path, col_names = FALSE, col_types = cols(X27 = "_"))
data_filename <- "RUL_FD001.txt"
data_path <- file.path(data_dir, data_filename)
RUL_test_set <- read_table2(data_path, col_names = FALSE, col_types = cols(X2 = "_"))
```


## Exploratory Data Analysis
### Summary statistics

The training set has 20631 observations for 26 variables. The test set has 13096 observations for 26 variables. Let's name the variables for convenience, and then display a brief summary for the training set:




```
## Skim summary statistics  
##  n obs: 20631    
##  n variables: 27    
## 
## Variable type: integer
## 
## variable    missing   complete   n       mean     sd      median   iqr 
## ----------  --------  ---------  ------  -------  ------  -------  ----
## cycles      0         20631      20631   108.81   68.88   104      104 
## engine      0         20631      20631   51.51    29.23   52       51  
## sensor_17   0         20631      20631   393.21   1.55    393      2   
## sensor_18   0         20631      20631   2388     0       2388     0   
## 
## Variable type: numeric
## 
## variable       missing   complete   n       mean       sd        median    iqr   
## -------------  --------  ---------  ------  ---------  --------  --------  ------
## op_setting_1   0         20631      20631   -8.9e-06   0.0022    0         0.003 
## op_setting_2   0         20631      20631   2.4e-06    0.00029   0         5e-04 
## op_setting_3   0         20631      20631   100        0         100       0     
## sensor_1       0         20631      20631   518.67     0         518.67    0     
## sensor_10      0         20631      20631   1.3        0         1.3       0     
## sensor_11      0         20631      20631   47.54      0.27      47.51     0.35  
## sensor_12      0         20631      20631   521.41     0.74      521.48    0.99  
## sensor_13      0         20631      20631   2388.1     0.072     2388.09   0.1   
## sensor_14      0         20631      20631   8143.75    19.08     8140.54   15.07 
## sensor_15      0         20631      20631   8.44       0.038     8.44      0.051 
## sensor_16      0         20631      20631   0.03       0         0.03      0     
## sensor_19      0         20631      20631   100        0         100       0     
## sensor_2       0         20631      20631   642.68     0.5       642.64    0.67  
## sensor_20      0         20631      20631   38.82      0.18      38.83     0.25  
## sensor_21      0         20631      20631   23.29      0.11      23.3      0.14  
## sensor_3       0         20631      20631   1590.52    6.13      1590.1    8.12  
## sensor_4       0         20631      20631   1408.93    9         1408.04   12.19 
## sensor_5       0         20631      20631   14.62      0         14.62     0     
## sensor_6       0         20631      20631   21.61      0.0014    21.61     0     
## sensor_7       0         20631      20631   553.37     0.89      553.44    1.2   
## sensor_8       0         20631      20631   2388.1     0.071     2388.09   0.09  
## sensor_9       0         20631      20631   9065.24    22.08     9060.66   16.32 
## tte            0         20631      20631   107.81     68.88     103       104
```

and for the test set:
  

```
## Skim summary statistics  
##  n obs: 13096    
##  n variables: 27    
## 
## Variable type: integer
## 
## variable    missing   complete   n       mean     sd      median   iqr 
## ----------  --------  ---------  ------  -------  ------  -------  ----
## cycles      0         13096      13096   76.84    53.06   69       80  
## engine      0         13096      13096   51.54    28.29   52       48  
## sensor_17   0         13096      13096   392.57   1.23    393      1   
## sensor_18   0         13096      13096   2388     0       2388     0   
## 
## Variable type: numeric
## 
## variable       missing   complete   n       mean       sd        median    iqr   
## -------------  --------  ---------  ------  ---------  --------  --------  ------
## op_setting_1   0         13096      13096   -1.1e-05   0.0022    0         0.003 
## op_setting_2   0         13096      13096   4.2e-06    0.00029   0         5e-04 
## op_setting_3   0         13096      13096   100        0         100       0     
## sensor_1       0         13096      13096   518.67     0         518.67    0     
## sensor_10      0         13096      13096   1.3        0         1.3       0     
## sensor_11      0         13096      13096   47.42      0.2       47.41     0.27  
## sensor_12      0         13096      13096   521.75     0.56      521.78    0.77  
## sensor_13      0         13096      13096   2388.07    0.057     2388.07   0.08  
## sensor_14      0         13096      13096   8138.95    10.19     8138.39   12.05 
## sensor_15      0         13096      13096   8.43       0.029     8.42      0.039 
## sensor_16      0         13096      13096   0.03       0         0.03      0     
## sensor_19      0         13096      13096   100        0         100       0     
## sensor_2       0         13096      13096   642.48     0.4       642.46    0.54  
## sensor_20      0         13096      13096   38.89      0.14      38.9      0.19  
## sensor_21      0         13096      13096   23.34      0.084     23.34     0.11  
## sensor_3       0         13096      13096   1588.1     5         1587.99   6.76  
## sensor_4       0         13096      13096   1404.74    6.69      1404.44   9.1   
## sensor_5       0         13096      13096   14.62      0         14.62     0     
## sensor_6       0         13096      13096   21.61      0.0017    21.61     0     
## sensor_7       0         13096      13096   553.76     0.68      553.8     0.93  
## sensor_8       0         13096      13096   2388.07    0.057     2388.07   0.08  
## sensor_9       0         13096      13096   9058.41    11.44     9057.32   13.09 
## tte            0         13096      13096   75.84      53.06     68        80
```

Notes:
  
* **no missing data**, as it could be expected from simulated data
* 100 time series in the training set, and 100 time series in the test set
* the statistics on the number of cycles aren't relevant, because we should only look at the the statistics for the **maximum** number of cycles for each engine. However, the fact that the mean and median number of cycles for the training set are larger than for the test set, agrees with the fact that in the training set, the engines are followed until system failure. In the test set, the time series ends some time prior to system failure.  
* the following variables are constant, both in the training nd in the test set, meaning that the operating condition was fixed and/or the sensor was broken/inactive: op_setting_3, sensor_1, sensor_5, sensor_10, sensor_16, sensor_18, sensor_19. We can discard these variables from the analysis. We will also normalize data, based on the mean and standard deviation of the training set.
* __`sensor_6` is practically constant__ (`iqr=0`), even though it's not _exactly_ constant (the standard deviation is not 0). As a matter of fact, across all engines in the training set, it oscillates between 2  values which differ just for the last digit: 21.61, 21.6. It would probably make sense to get rid of this variable too, but we'll leave it in, in the extremely unlikely case that these oscillations carry any useful signal. If they don't, no harm is done because the signal is so simple that any decent time-to-event regression model won't have any difficulty learning to ignore it.   



Finally, we also __normalize__ data, because presumably the units of measurements (which are unknown anyway) don't carry any useful information about RUL. Also, normalizing features is usually a good idea when training Deep Neural Networks. __Normalization must be performed using only training set data__.



### The distribution of the time-to-event in the training set

 By looking at the distribution of the time-to-event for engines in the training set, we can make a few interesting observations:
<img src="C:\Users\105047~1\BOXSYN~1\PC\qui\ANALYS~1\output\NASA_E~1/figure-html/unnamed-chunk-3-1.png" style="display: block; margin: auto;" />

 * there are no "instant deaths": the minimum tte = 127 is not extremely smaller than the maximum tte = 361
 * the distribution is fairly right-skewed. With a sample mean of 205.31 and a sample sd of 46.3427492, we would expect the $2.5\%$ of the data to be close to 296.1417884, but the actual $97.5\%$-percentile is 324.075, hinting to a  fatter tail than for a normal distribution. In other words, we have quite a few "Highlanders" which manage to live 300 days or more. Of course, this is not a formal hypothesis test, but it's still quite suggestive.

### Plot all time series

Looking first of all at the operating settings shows that `op_setting_1` seems to randomly oscillate with a decreasing standard deviation, while `op_setting_2`,  averaged over all time series, gradually increases with time, slowly at first and then faster at some point in time. This might be related with the failure of the engines (all engines in the training set fail at some time). We also note that `op_setting_2` is fairly quantized.
<img src="C:\Users\105047~1\BOXSYN~1\PC\qui\ANALYS~1\output\NASA_E~1/figure-html/unnamed-chunk-4-1.png" style="display: block; margin: auto;" />

Next, we have a look at the sensors data.
<img src="C:\Users\105047~1\BOXSYN~1\PC\qui\ANALYS~1\output\NASA_E~1/figure-html/unnamed-chunk-5-1.png" style="display: block; margin: auto;" />

Given the large number of sensors and time series, the visualization is understandably complex, but we can get some insights:
  
  * there is a lot of signal in the sensors. For example, the sooner `sensor_11` starts increasing, the shorter the residual life of the engine.
* there is also quite a lot of noise (large oscillations), and correlation (for example, `sensor_11` and `sensor_4`, or `sensor_9` and `sensor_14`, seem to have the same trend, at least averaged across all engines).
* `sensor_17` measurements are fairly quantized, but they seem to carry some signal. As noted before, `sensor_6`  seems to oscillate randomly among 2 values, so it's probably useless.

### Plot a sample of time series
To have a look at the individual, instead than the global, trends, we can concentrate on a sample of engines:
<img src="C:\Users\105047~1\BOXSYN~1\PC\qui\ANALYS~1\output\NASA_E~1/figure-html/unnamed-chunk-6-1.png" style="display: block; margin: auto;" />

This suggests that some sensors are correlated not only at a population level, i.e., averaging the sensor signals across all engines, but even for a single engine (compare `sensor_11` with `sensor_4` and `sensor_9` with `sensor_14` for the yellow line).

This concludes our EDA. We can now save the normalized data, and estimate the RUL using some baseline models, which we will compare with the new model results.



## Remaining Useful Life Estimation

