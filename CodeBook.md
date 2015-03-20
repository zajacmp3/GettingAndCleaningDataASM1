# CodeBook
Mateusz Zajac  
20.03.2015  

##Reading labels for files:

```r
labels <- read.csv("UCI HAR Dataset/features.txt", sep="", header = FALSE)
str(labels)
```

```
## 'data.frame':	561 obs. of  2 variables:
##  $ V1: int  1 2 3 4 5 6 7 8 9 10 ...
##  $ V2: Factor w/ 477 levels "angle(tBodyAccJerkMean),gravityMean)",..: 309 310 311 316 317 318 290 291 292 306 ...
```

#Reading original data files
##Traning
###Read traning data and assign labels

```r
dataTrain <- read.csv("UCI HAR Dataset/train/X_train.txt", sep = "", header = FALSE, col.names = labels[,2])
```
###load and assign test subjects

```r
testSubjects <- read.csv(file = "UCI HAR Dataset/train/subject_train.txt", sep = "", header = FALSE, col.names = "subject")
dataTrain$subject <- testSubjects[,1]
```
###load and assign traning type labels

```r
traningType <- read.csv(file = "UCI HAR Dataset/train/y_train.txt", sep = "", header = FALSE, col.names = "label")
dataTrain$label <- traningType[,1]
```

##Test
###Read traning data and assign labels

```r
dataTest <- read.csv("UCI HAR Dataset/test/X_test.txt", sep = "", header = FALSE, col.names = labels[,2])
```
###load and assign test subjects

```r
testSubjects <- read.csv(file = "UCI HAR Dataset/test/subject_test.txt", sep = "", header = FALSE, col.names = "subject")
dataTest$subject <- testSubjects[,1]
```
###load and assign traning type labels

```r
traningType <- read.csv(file = "UCI HAR Dataset/test/y_test.txt", sep = "", header = FALSE, col.names = "label")
dataTest$label <- traningType[,1]
```

#Description of progress
At this point files are loaded into R. They are labeled properly. Next is merging and cleaning enviroment variables.



##Merge - add rows

```r
names <- seq(from = nrow(dataTrain) + 1, length.out = nrow(dataTest))
rownames(dataTest) <- make.names(names, unique = TRUE)
names <- seq(from = nrow(dataTrain), length.out = nrow(dataTrain))
rownames(dataTrain) <- make.names(names, unique = TRUE)
data <- rbind(dataTrain, dataTest)
```



#Build sequence of columns to extract

```r
nseq <- c()
for(i in seq(as.integer(563 / 40))) { 
  nseq <- c(nseq, seq(from = ((i - 1) * 40 + 1), length.out = 6))
}

selectedData <- data[,c(nseq,562,563)]
selectedData$label <- as.character(selectedData$label)
```

#load activity labels

```r
activityLabels <- read.csv(file = "UCI HAR Dataset/activity_labels.txt", header = FALSE, sep = "")
activityLabels$V2 <- as.character(activityLabels$V2)
```

#replace label numbers with names

```r
apply(activityLabels, 1, function(row) {selectedData$label[selectedData$label == as.character(row[1])] <<- row[2]})
```

```
## [1] "WALKING"            "WALKING_UPSTAIRS"   "WALKING_DOWNSTAIRS"
## [4] "SITTING"            "STANDING"           "LAYING"
```


##Calculate the average of each variable for each activity and each subject.


```r
calculatedData <- selectedData[0,]
for(i in 1:30) {
  temp <- selectedData[selectedData$subject == i,]
  for(j in activityLabels$V2) {
    tempj <- temp[temp$label == j,]
    if(nrow(tempj) > 0) {
      tempj <- tempj[,1:84]
      tempj <- colMeans(x = tempj)
      tempj$label <- j; tempj$subject <- i;
      calculatedData <- rbind(calculatedData, tempj)
      calculatedData$label <- as.character(calculatedData$label)
    }
  }
}
```

##Save to file


#Calculated fields
At the end we get a mean for each observation for each subject and its activity type.


```
##   tBodyAcc.mean...X tBodyAcc.mean...Y tBodyAcc.mean...Z tBodyAcc.std...X
## 2         0.2773308       -0.01738382        -0.1111481       -0.2837403
##   tBodyAcc.std...Y tBodyAcc.std...Z tGravityAcc.mean...X
## 2        0.1144613       -0.2600279            0.9352232
##   tGravityAcc.mean...Y tGravityAcc.mean...Z tGravityAcc.std...X
## 2            -0.282165          -0.06810286          -0.9766096
##   tGravityAcc.std...Y tGravityAcc.std...Z tBodyAccJerk.mean...X
## 2           -0.971306          -0.9477172            0.07404163
##   tBodyAccJerk.mean...Y tBodyAccJerk.mean...Z tBodyAccJerk.std...X
## 2            0.02827211          -0.004168406           -0.1136156
##   tBodyAccJerk.std...Y tBodyAccJerk.std...Z tBodyGyro.mean...X
## 2            0.0670025           -0.5026998        -0.04183096
##   tBodyGyro.mean...Y tBodyGyro.mean...Z tBodyGyro.std...X
## 2        -0.06953005         0.08494482        -0.4735355
##   tBodyGyro.std...Y tBodyGyro.std...Z tBodyGyroJerk.mean...X
## 2       -0.05460777        -0.3442666            -0.08999754
##   tBodyGyroJerk.mean...Y tBodyGyroJerk.mean...Z tBodyGyroJerk.std...X
## 2            -0.03984287            -0.04613093            -0.2074219
##   tBodyGyroJerk.std...Y tBodyGyroJerk.std...Z tBodyAccMag.mean..
## 2            -0.3044685            -0.4042555         -0.1369712
##   tBodyAccMag.std.. tBodyAccMag.mad.. tBodyAccMag.max.. tBodyAccMag.min..
## 2        -0.2196886        -0.2974258        -0.1856229        -0.7231983
##   tBodyAccMag.sma.. tBodyGyroMag.std.. tBodyGyroMag.mad..
## 2        -0.1369712         -0.1869784        -0.06236237
##   tBodyGyroMag.max.. tBodyGyroMag.min.. tBodyGyroMag.sma..
## 2         -0.3506753         -0.5576393         -0.1609796
##   tBodyGyroMag.energy.. fBodyAcc.sma.. fBodyAcc.energy...X
## 2            -0.6116389    -0.03547449          -0.7392362
##   fBodyAcc.energy...Y fBodyAcc.energy...Z fBodyAcc.iqr...X
## 2          -0.3702795          -0.7166224       -0.1583662
##   fBodyAcc.iqr...Y fBodyAcc.bandsEnergy...33.40.1
## 2       -0.1852281                      -0.689348
##   fBodyAcc.bandsEnergy...41.48.1 fBodyAcc.bandsEnergy...49.56.1
## 2                      -0.667835                     -0.6713164
##   fBodyAcc.bandsEnergy...57.64.1 fBodyAcc.bandsEnergy...1.16.1
## 2                     -0.8374666                    -0.4001599
##   fBodyAcc.bandsEnergy...17.32.1 fBodyAccJerk.energy...X
## 2                     -0.5256044              -0.5996437
##   fBodyAccJerk.energy...Y fBodyAccJerk.energy...Z fBodyAccJerk.iqr...X
## 2              -0.4206677              -0.8687256           -0.1064999
##   fBodyAccJerk.iqr...Y fBodyAccJerk.iqr...Z
## 2           -0.3068448           -0.5351169
##   fBodyAccJerk.bandsEnergy...41.48.1 fBodyAccJerk.bandsEnergy...49.56.1
## 2                         -0.6623615                         -0.7474661
##   fBodyAccJerk.bandsEnergy...57.64.1 fBodyAccJerk.bandsEnergy...1.16.1
## 2                         -0.9196634                        -0.3829384
##   fBodyAccJerk.bandsEnergy...17.32.1 fBodyAccJerk.bandsEnergy...33.48.1
## 2                         -0.5416793                         -0.6529472
##   fBodyGyro.energy...Y fBodyGyro.energy...Z fBodyGyro.iqr...X
## 2            -0.549239           -0.7816626        -0.3363607
##   fBodyGyro.iqr...Y fBodyGyro.iqr...Z fBodyGyro.entropy...X
## 2        -0.2434215        -0.3567934             0.5558923
##   fBodyGyro.bandsEnergy...49.56.1 fBodyGyro.bandsEnergy...57.64.1
## 2                       -0.808213                      -0.8936583
##   fBodyGyro.bandsEnergy...1.16.1 fBodyGyro.bandsEnergy...17.32.1
## 2                     -0.5911579                      -0.7730722
##   fBodyGyro.bandsEnergy...33.48.1 fBodyGyro.bandsEnergy...49.64.1
## 2                      -0.8984006                      -0.8191374
##   fBodyBodyAccJerkMag.sma.. fBodyBodyAccJerkMag.energy..
## 2                -0.0571194                   -0.5588509
##   fBodyBodyAccJerkMag.iqr.. fBodyBodyAccJerkMag.entropy..
## 2                -0.2219935                     0.4782056
##   fBodyBodyAccJerkMag.maxInds fBodyBodyAccJerkMag.meanFreq..   label
## 2                  -0.8907268                     0.09382218 WALKING
##   subject
## 2       1
```

```
##     tBodyAcc.mean...X tBodyAcc.mean...Y tBodyAcc.mean...Z tBodyAcc.std...X
## 180         0.2810339       -0.01944941        -0.1036582       -0.9763625
##     tBodyAcc.std...Y tBodyAcc.std...Z tGravityAcc.mean...X
## 180       -0.9542018       -0.9670442           -0.3447378
##     tGravityAcc.mean...Y tGravityAcc.mean...Z tGravityAcc.std...X
## 180            0.7326612            0.6814592          -0.9795639
##     tGravityAcc.std...Y tGravityAcc.std...Z tBodyAccJerk.mean...X
## 180          -0.9889307          -0.9832745            0.07521967
##     tBodyAccJerk.mean...Y tBodyAccJerk.mean...Z tBodyAccJerk.std...X
## 180            0.01076802         -0.0003741897           -0.9774638
##     tBodyAccJerk.std...Y tBodyAccJerk.std...Z tBodyGyro.mean...X
## 180           -0.9710498           -0.9795179        -0.02678122
##     tBodyGyro.mean...Y tBodyGyro.mean...Z tBodyGyro.std...X
## 180        -0.07614764         0.09384722        -0.9736628
##     tBodyGyro.std...Y tBodyGyro.std...Z tBodyGyroJerk.mean...X
## 180        -0.9660417        -0.9688892             -0.1022774
##     tBodyGyroJerk.mean...Y tBodyGyroJerk.mean...Z tBodyGyroJerk.std...X
## 180            -0.03848759            -0.05957368            -0.9837758
##     tBodyGyroJerk.std...Y tBodyGyroJerk.std...Z tBodyAccMag.mean..
## 180            -0.9803571            -0.9807689           -0.96983
##     tBodyAccMag.std.. tBodyAccMag.mad.. tBodyAccMag.max..
## 180        -0.9601679        -0.9663015        -0.9533547
##     tBodyAccMag.min.. tBodyAccMag.sma.. tBodyGyroMag.std..
## 180        -0.9869426          -0.96983         -0.9512644
##     tBodyGyroMag.mad.. tBodyGyroMag.max.. tBodyGyroMag.min..
## 180         -0.9491043         -0.9578473         -0.9709424
##     tBodyGyroMag.sma.. tBodyGyroMag.energy.. fBodyAcc.sma..
## 180         -0.9622849            -0.9969916     -0.9679738
##     fBodyAcc.energy...X fBodyAcc.energy...Y fBodyAcc.energy...Z
## 180          -0.9992797          -0.9958675          -0.9975343
##     fBodyAcc.iqr...X fBodyAcc.iqr...Y fBodyAcc.bandsEnergy...33.40.1
## 180       -0.9750468       -0.9770463                     -0.9987837
##     fBodyAcc.bandsEnergy...41.48.1 fBodyAcc.bandsEnergy...49.56.1
## 180                      -0.998653                      -0.998771
##     fBodyAcc.bandsEnergy...57.64.1 fBodyAcc.bandsEnergy...1.16.1
## 180                     -0.9991275                    -0.9955445
##     fBodyAcc.bandsEnergy...17.32.1 fBodyAccJerk.energy...X
## 180                      -0.999288              -0.9991587
##     fBodyAccJerk.energy...Y fBodyAccJerk.energy...Z fBodyAccJerk.iqr...X
## 180              -0.9987816              -0.9991946           -0.9734889
##     fBodyAccJerk.iqr...Y fBodyAccJerk.iqr...Z
## 180           -0.9786701             -0.97578
##     fBodyAccJerk.bandsEnergy...41.48.1 fBodyAccJerk.bandsEnergy...49.56.1
## 180                         -0.9986732                         -0.9993145
##     fBodyAccJerk.bandsEnergy...57.64.1 fBodyAccJerk.bandsEnergy...1.16.1
## 180                         -0.9995981                        -0.9986784
##     fBodyAccJerk.bandsEnergy...17.32.1 fBodyAccJerk.bandsEnergy...33.48.1
## 180                         -0.9992428                          -0.998654
##     fBodyGyro.energy...Y fBodyGyro.energy...Z fBodyGyro.iqr...X
## 180           -0.9985357           -0.9980222        -0.9846051
##     fBodyGyro.iqr...Y fBodyGyro.iqr...Z fBodyGyro.entropy...X
## 180        -0.9755537        -0.9757447            -0.6682249
##     fBodyGyro.bandsEnergy...49.56.1 fBodyGyro.bandsEnergy...57.64.1
## 180                      -0.9995116                      -0.9996503
##     fBodyGyro.bandsEnergy...1.16.1 fBodyGyro.bandsEnergy...17.32.1
## 180                     -0.9984309                      -0.9997137
##     fBodyGyro.bandsEnergy...33.48.1 fBodyGyro.bandsEnergy...49.64.1
## 180                      -0.9995228                      -0.9995053
##     fBodyBodyAccJerkMag.sma.. fBodyBodyAccJerkMag.energy..
## 180                -0.9699493                   -0.9982959
##     fBodyBodyAccJerkMag.iqr.. fBodyBodyAccJerkMag.entropy..
## 180                -0.9725432                    -0.9035831
##     fBodyBodyAccJerkMag.maxInds fBodyBodyAccJerkMag.meanFreq..  label
## 180                  -0.9038549                      0.1721211 LAYING
##     subject
## 180      30
```
