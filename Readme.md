# Readme
Mateusz Zajac  
20.03.2015  

This project is a part of assigment on course getting and cleaning data on coursera.

Results here are a part of analysis of data from link: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

list of files:

```r
list.files()
```

```
##  [1] "CodeBook.html"                           
##  [2] "CodeBook.md"                             
##  [3] "CodeBook.Rmd"                            
##  [4] "data.txt"                                
##  [5] "getdata_projectfiles_UCI HAR Dataset.zip"
##  [6] "Readme.html"                             
##  [7] "Readme.md"                               
##  [8] "Readme.Rmd"                              
##  [9] "run_analysis.R"                          
## [10] "UCI HAR Dataset"
```

data.txt consists results of analysis.
run_analysis.R shows how the data science was made.  
Original dataset can be found in .zip and unpacked in folder.

Please look at CodeBook.md to see the details about how analysis was performed.

Analysis meant to read the data from files and merge train data (which is 70% of all) and test data (which is 30% of all) and then extract only mean and starndard deviation columns.

With this columns assigned for each activity type and subject a average for each observation was calculated on each column for each subject and its activity type.
Results shows average values for each subject and its activity.
