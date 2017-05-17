# Getting and Cleaning Data Course Project



# 1. Download the data file and unzip it to "project" folder.



```r
library(data.table)
library(plyr)

if( !file.exists("./Data") ) { dir.create("./Data") }

if( !file.exists("UCI_HAR_Dataset.zip")) {
      fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
      download.file(fileUrl, destfile="./UCI_HAR_Dataset.zip")
}

unzip(zipfile="./UCI_HAR_Dataset.zip", exdir = "./Data")
dataPath <- file.path("./Data", "UCI HAR Dataset")
```

# 2.Merge the training and the test sets to create one data set.
## 2.1 Read the data files 


```r
# read the train and test data set, each row is a 561-element vector 
xTrain <- data.frame(fread(file.path(dataPath, "train", "X_train.txt")))
xTest<- data.frame(fread(file.path(dataPath, "test", "X_test.txt")))

#read the subject data, the data range of is from 1 to 30
subjectTrain <- data.frame(fread(file.path(dataPath , "train", "subject_train.txt")))
subjectTest <- data.frame(fread(file.path(dataPath , "test" , "subject_test.txt" )))

#read the activity data, the data range is from 1 to 6
activityTrain <- data.frame(fread(file.path(dataPath , "train", "Y_train.txt")))
activityTest  <-data.frame( fread(file.path(dataPath , "test" , "Y_test.txt" )))

#read feature names
featureNames <- fread(file.path(dataPath, "features.txt"))
```

## 2.2 Merge train and test data


```r
subjectData <- rbind(subjectTrain, subjectTest)
activityData <- rbind(activityTrain, activityTest)
featureData <- rbind(xTrain, xTest)
```
## 2.3 Set column names 


```r
setnames(subjectData, "V1", "subject")
setnames(activityData, "V1", "activity")

#Appropriately labels the data set with descriptive variable names.
setnames(featureData, names(featureData), featureNames$V2)
```
## 2.4 Merge the subject data, activity data and feature data into one big data set


```r
mergedData <- cbind(cbind(subjectData, activityData), featureData)
str(mergedData)
```

```
## 'data.frame':	10299 obs. of  563 variables:
##  $ subject                             : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ activity                            : int  5 5 5 5 5 5 5 5 5 5 ...
##  $ tBodyAcc-mean()-X                   : num  0.289 0.278 0.28 0.279 0.277 ...
##  $ tBodyAcc-mean()-Y                   : num  -0.0203 -0.0164 -0.0195 -0.0262 -0.0166 ...
##  $ tBodyAcc-mean()-Z                   : num  -0.133 -0.124 -0.113 -0.123 -0.115 ...
##  $ tBodyAcc-std()-X                    : num  -0.995 -0.998 -0.995 -0.996 -0.998 ...
##  $ tBodyAcc-std()-Y                    : num  -0.983 -0.975 -0.967 -0.983 -0.981 ...
##  $ tBodyAcc-std()-Z                    : num  -0.914 -0.96 -0.979 -0.991 -0.99 ...
##  $ tBodyAcc-mad()-X                    : num  -0.995 -0.999 -0.997 -0.997 -0.998 ...
##  $ tBodyAcc-mad()-Y                    : num  -0.983 -0.975 -0.964 -0.983 -0.98 ...
##  $ tBodyAcc-mad()-Z                    : num  -0.924 -0.958 -0.977 -0.989 -0.99 ...
##  $ tBodyAcc-max()-X                    : num  -0.935 -0.943 -0.939 -0.939 -0.942 ...
##  $ tBodyAcc-max()-Y                    : num  -0.567 -0.558 -0.558 -0.576 -0.569 ...
##  $ tBodyAcc-max()-Z                    : num  -0.744 -0.818 -0.818 -0.83 -0.825 ...
##  $ tBodyAcc-min()-X                    : num  0.853 0.849 0.844 0.844 0.849 ...
##  $ tBodyAcc-min()-Y                    : num  0.686 0.686 0.682 0.682 0.683 ...
##  $ tBodyAcc-min()-Z                    : num  0.814 0.823 0.839 0.838 0.838 ...
##  $ tBodyAcc-sma()                      : num  -0.966 -0.982 -0.983 -0.986 -0.993 ...
##  $ tBodyAcc-energy()-X                 : num  -1 -1 -1 -1 -1 ...
##  $ tBodyAcc-energy()-Y                 : num  -1 -1 -1 -1 -1 ...
##  $ tBodyAcc-energy()-Z                 : num  -0.995 -0.998 -0.999 -1 -1 ...
##  $ tBodyAcc-iqr()-X                    : num  -0.994 -0.999 -0.997 -0.997 -0.998 ...
##  $ tBodyAcc-iqr()-Y                    : num  -0.988 -0.978 -0.965 -0.984 -0.981 ...
##  $ tBodyAcc-iqr()-Z                    : num  -0.943 -0.948 -0.975 -0.986 -0.991 ...
##  $ tBodyAcc-entropy()-X                : num  -0.408 -0.715 -0.592 -0.627 -0.787 ...
##  $ tBodyAcc-entropy()-Y                : num  -0.679 -0.501 -0.486 -0.851 -0.559 ...
##  $ tBodyAcc-entropy()-Z                : num  -0.602 -0.571 -0.571 -0.912 -0.761 ...
##  $ tBodyAcc-arCoeff()-X,1              : num  0.9293 0.6116 0.273 0.0614 0.3133 ...
##  $ tBodyAcc-arCoeff()-X,2              : num  -0.853 -0.3295 -0.0863 0.0748 -0.1312 ...
##  $ tBodyAcc-arCoeff()-X,3              : num  0.36 0.284 0.337 0.198 0.191 ...
##  $ tBodyAcc-arCoeff()-X,4              : num  -0.0585 0.2846 -0.1647 -0.2643 0.0869 ...
##  $ tBodyAcc-arCoeff()-Y,1              : num  0.2569 0.1157 0.0172 0.0725 0.2576 ...
##  $ tBodyAcc-arCoeff()-Y,2              : num  -0.2248 -0.091 -0.0745 -0.1553 -0.2725 ...
##  $ tBodyAcc-arCoeff()-Y,3              : num  0.264 0.294 0.342 0.323 0.435 ...
##  $ tBodyAcc-arCoeff()-Y,4              : num  -0.0952 -0.2812 -0.3326 -0.1708 -0.3154 ...
##  $ tBodyAcc-arCoeff()-Z,1              : num  0.279 0.086 0.239 0.295 0.44 ...
##  $ tBodyAcc-arCoeff()-Z,2              : num  -0.4651 -0.0222 -0.1362 -0.3061 -0.2691 ...
##  $ tBodyAcc-arCoeff()-Z,3              : num  0.4919 -0.0167 0.1739 0.4821 0.1794 ...
##  $ tBodyAcc-arCoeff()-Z,4              : num  -0.191 -0.221 -0.299 -0.47 -0.089 ...
##  $ tBodyAcc-correlation()-X,Y          : num  0.3763 -0.0134 -0.1247 -0.3057 -0.1558 ...
##  $ tBodyAcc-correlation()-X,Z          : num  0.4351 -0.0727 -0.1811 -0.3627 -0.1898 ...
##  $ tBodyAcc-correlation()-Y,Z          : num  0.661 0.579 0.609 0.507 0.599 ...
##  $ tGravityAcc-mean()-X                : num  0.963 0.967 0.967 0.968 0.968 ...
##  $ tGravityAcc-mean()-Y                : num  -0.141 -0.142 -0.142 -0.144 -0.149 ...
##  $ tGravityAcc-mean()-Z                : num  0.1154 0.1094 0.1019 0.0999 0.0945 ...
##  $ tGravityAcc-std()-X                 : num  -0.985 -0.997 -1 -0.997 -0.998 ...
##  $ tGravityAcc-std()-Y                 : num  -0.982 -0.989 -0.993 -0.981 -0.988 ...
##  $ tGravityAcc-std()-Z                 : num  -0.878 -0.932 -0.993 -0.978 -0.979 ...
##  $ tGravityAcc-mad()-X                 : num  -0.985 -0.998 -1 -0.996 -0.998 ...
##  $ tGravityAcc-mad()-Y                 : num  -0.984 -0.99 -0.993 -0.981 -0.989 ...
##  $ tGravityAcc-mad()-Z                 : num  -0.895 -0.933 -0.993 -0.978 -0.979 ...
##  $ tGravityAcc-max()-X                 : num  0.892 0.892 0.892 0.894 0.894 ...
##  $ tGravityAcc-max()-Y                 : num  -0.161 -0.161 -0.164 -0.164 -0.167 ...
##  $ tGravityAcc-max()-Z                 : num  0.1247 0.1226 0.0946 0.0934 0.0917 ...
##  $ tGravityAcc-min()-X                 : num  0.977 0.985 0.987 0.987 0.987 ...
##  $ tGravityAcc-min()-Y                 : num  -0.123 -0.115 -0.115 -0.121 -0.122 ...
##  $ tGravityAcc-min()-Z                 : num  0.0565 0.1028 0.1028 0.0958 0.0941 ...
##  $ tGravityAcc-sma()                   : num  -0.375 -0.383 -0.402 -0.4 -0.4 ...
##  $ tGravityAcc-energy()-X              : num  0.899 0.908 0.909 0.911 0.912 ...
##  $ tGravityAcc-energy()-Y              : num  -0.971 -0.971 -0.97 -0.969 -0.967 ...
##  $ tGravityAcc-energy()-Z              : num  -0.976 -0.979 -0.982 -0.982 -0.984 ...
##  $ tGravityAcc-iqr()-X                 : num  -0.984 -0.999 -1 -0.996 -0.998 ...
##  $ tGravityAcc-iqr()-Y                 : num  -0.989 -0.99 -0.992 -0.981 -0.991 ...
##  $ tGravityAcc-iqr()-Z                 : num  -0.918 -0.942 -0.993 -0.98 -0.98 ...
##  $ tGravityAcc-entropy()-X             : num  -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 ...
##  $ tGravityAcc-entropy()-Y             : num  -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 ...
##  $ tGravityAcc-entropy()-Z             : num  0.114 -0.21 -0.927 -0.596 -0.617 ...
##  $ tGravityAcc-arCoeff()-X,1           : num  -0.59042 -0.41006 0.00223 -0.06493 -0.25727 ...
##  $ tGravityAcc-arCoeff()-X,2           : num  0.5911 0.4139 0.0275 0.0754 0.2689 ...
##  $ tGravityAcc-arCoeff()-X,3           : num  -0.5918 -0.4176 -0.0567 -0.0858 -0.2807 ...
##  $ tGravityAcc-arCoeff()-X,4           : num  0.5925 0.4213 0.0855 0.0962 0.2926 ...
##  $ tGravityAcc-arCoeff()-Y,1           : num  -0.745 -0.196 -0.329 -0.295 -0.167 ...
##  $ tGravityAcc-arCoeff()-Y,2           : num  0.7209 0.1253 0.2705 0.2283 0.0899 ...
##  $ tGravityAcc-arCoeff()-Y,3           : num  -0.7124 -0.1056 -0.2545 -0.2063 -0.0663 ...
##  $ tGravityAcc-arCoeff()-Y,4           : num  0.7113 0.1091 0.2576 0.2048 0.0671 ...
##  $ tGravityAcc-arCoeff()-Z,1           : num  -0.995 -0.834 -0.705 -0.385 -0.237 ...
##  $ tGravityAcc-arCoeff()-Z,2           : num  0.996 0.834 0.714 0.386 0.239 ...
##  $ tGravityAcc-arCoeff()-Z,3           : num  -0.996 -0.834 -0.723 -0.387 -0.241 ...
##  $ tGravityAcc-arCoeff()-Z,4           : num  0.992 0.83 0.729 0.385 0.241 ...
##  $ tGravityAcc-correlation()-X,Y       : num  0.57 -0.831 -0.181 -0.991 -0.408 ...
##  $ tGravityAcc-correlation()-X,Z       : num  0.439 -0.866 0.338 -0.969 -0.185 ...
##  $ tGravityAcc-correlation()-Y,Z       : num  0.987 0.974 0.643 0.984 0.965 ...
##  $ tBodyAccJerk-mean()-X               : num  0.078 0.074 0.0736 0.0773 0.0734 ...
##  $ tBodyAccJerk-mean()-Y               : num  0.005 0.00577 0.0031 0.02006 0.01912 ...
##  $ tBodyAccJerk-mean()-Z               : num  -0.06783 0.02938 -0.00905 -0.00986 0.01678 ...
##  $ tBodyAccJerk-std()-X                : num  -0.994 -0.996 -0.991 -0.993 -0.996 ...
##  $ tBodyAccJerk-std()-Y                : num  -0.988 -0.981 -0.981 -0.988 -0.988 ...
##  $ tBodyAccJerk-std()-Z                : num  -0.994 -0.992 -0.99 -0.993 -0.992 ...
##  $ tBodyAccJerk-mad()-X                : num  -0.994 -0.996 -0.991 -0.994 -0.997 ...
##  $ tBodyAccJerk-mad()-Y                : num  -0.986 -0.979 -0.979 -0.986 -0.987 ...
##  $ tBodyAccJerk-mad()-Z                : num  -0.993 -0.991 -0.987 -0.991 -0.991 ...
##  $ tBodyAccJerk-max()-X                : num  -0.985 -0.995 -0.987 -0.987 -0.997 ...
##  $ tBodyAccJerk-max()-Y                : num  -0.992 -0.979 -0.979 -0.992 -0.992 ...
##  $ tBodyAccJerk-max()-Z                : num  -0.993 -0.992 -0.992 -0.99 -0.99 ...
##  $ tBodyAccJerk-min()-X                : num  0.99 0.993 0.988 0.988 0.994 ...
##  $ tBodyAccJerk-min()-Y                : num  0.992 0.992 0.992 0.993 0.993 ...
##  $ tBodyAccJerk-min()-Z                : num  0.991 0.989 0.989 0.993 0.986 ...
##  $ tBodyAccJerk-sma()                  : num  -0.994 -0.991 -0.988 -0.993 -0.994 ...
##  $ tBodyAccJerk-energy()-X             : num  -1 -1 -1 -1 -1 ...
##   [list output truncated]
```
#3. Extracts only the measurements on the mean and standard deviation for each measurement


```r
#extract features name with "mean()" or "std()"
selectedFeature <- featureNames$V2[grep("mean\\(\\)|std\\(\\)", featureNames$V2)]
selectedFeature
```

```
##  [1] "tBodyAcc-mean()-X"           "tBodyAcc-mean()-Y"          
##  [3] "tBodyAcc-mean()-Z"           "tBodyAcc-std()-X"           
##  [5] "tBodyAcc-std()-Y"            "tBodyAcc-std()-Z"           
##  [7] "tGravityAcc-mean()-X"        "tGravityAcc-mean()-Y"       
##  [9] "tGravityAcc-mean()-Z"        "tGravityAcc-std()-X"        
## [11] "tGravityAcc-std()-Y"         "tGravityAcc-std()-Z"        
## [13] "tBodyAccJerk-mean()-X"       "tBodyAccJerk-mean()-Y"      
## [15] "tBodyAccJerk-mean()-Z"       "tBodyAccJerk-std()-X"       
## [17] "tBodyAccJerk-std()-Y"        "tBodyAccJerk-std()-Z"       
## [19] "tBodyGyro-mean()-X"          "tBodyGyro-mean()-Y"         
## [21] "tBodyGyro-mean()-Z"          "tBodyGyro-std()-X"          
## [23] "tBodyGyro-std()-Y"           "tBodyGyro-std()-Z"          
## [25] "tBodyGyroJerk-mean()-X"      "tBodyGyroJerk-mean()-Y"     
## [27] "tBodyGyroJerk-mean()-Z"      "tBodyGyroJerk-std()-X"      
## [29] "tBodyGyroJerk-std()-Y"       "tBodyGyroJerk-std()-Z"      
## [31] "tBodyAccMag-mean()"          "tBodyAccMag-std()"          
## [33] "tGravityAccMag-mean()"       "tGravityAccMag-std()"       
## [35] "tBodyAccJerkMag-mean()"      "tBodyAccJerkMag-std()"      
## [37] "tBodyGyroMag-mean()"         "tBodyGyroMag-std()"         
## [39] "tBodyGyroJerkMag-mean()"     "tBodyGyroJerkMag-std()"     
## [41] "fBodyAcc-mean()-X"           "fBodyAcc-mean()-Y"          
## [43] "fBodyAcc-mean()-Z"           "fBodyAcc-std()-X"           
## [45] "fBodyAcc-std()-Y"            "fBodyAcc-std()-Z"           
## [47] "fBodyAccJerk-mean()-X"       "fBodyAccJerk-mean()-Y"      
## [49] "fBodyAccJerk-mean()-Z"       "fBodyAccJerk-std()-X"       
## [51] "fBodyAccJerk-std()-Y"        "fBodyAccJerk-std()-Z"       
## [53] "fBodyGyro-mean()-X"          "fBodyGyro-mean()-Y"         
## [55] "fBodyGyro-mean()-Z"          "fBodyGyro-std()-X"          
## [57] "fBodyGyro-std()-Y"           "fBodyGyro-std()-Z"          
## [59] "fBodyAccMag-mean()"          "fBodyAccMag-std()"          
## [61] "fBodyBodyAccJerkMag-mean()"  "fBodyBodyAccJerkMag-std()"  
## [63] "fBodyBodyGyroMag-mean()"     "fBodyBodyGyroMag-std()"     
## [65] "fBodyBodyGyroJerkMag-mean()" "fBodyBodyGyroJerkMag-std()"
```

```r
mergedData <- mergedData[,c("subject", "activity", selectedFeature[1:length(selectedFeature)])]
str(mergedData)
```

```
## 'data.frame':	10299 obs. of  68 variables:
##  $ subject                    : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ activity                   : int  5 5 5 5 5 5 5 5 5 5 ...
##  $ tBodyAcc-mean()-X          : num  0.289 0.278 0.28 0.279 0.277 ...
##  $ tBodyAcc-mean()-Y          : num  -0.0203 -0.0164 -0.0195 -0.0262 -0.0166 ...
##  $ tBodyAcc-mean()-Z          : num  -0.133 -0.124 -0.113 -0.123 -0.115 ...
##  $ tBodyAcc-std()-X           : num  -0.995 -0.998 -0.995 -0.996 -0.998 ...
##  $ tBodyAcc-std()-Y           : num  -0.983 -0.975 -0.967 -0.983 -0.981 ...
##  $ tBodyAcc-std()-Z           : num  -0.914 -0.96 -0.979 -0.991 -0.99 ...
##  $ tGravityAcc-mean()-X       : num  0.963 0.967 0.967 0.968 0.968 ...
##  $ tGravityAcc-mean()-Y       : num  -0.141 -0.142 -0.142 -0.144 -0.149 ...
##  $ tGravityAcc-mean()-Z       : num  0.1154 0.1094 0.1019 0.0999 0.0945 ...
##  $ tGravityAcc-std()-X        : num  -0.985 -0.997 -1 -0.997 -0.998 ...
##  $ tGravityAcc-std()-Y        : num  -0.982 -0.989 -0.993 -0.981 -0.988 ...
##  $ tGravityAcc-std()-Z        : num  -0.878 -0.932 -0.993 -0.978 -0.979 ...
##  $ tBodyAccJerk-mean()-X      : num  0.078 0.074 0.0736 0.0773 0.0734 ...
##  $ tBodyAccJerk-mean()-Y      : num  0.005 0.00577 0.0031 0.02006 0.01912 ...
##  $ tBodyAccJerk-mean()-Z      : num  -0.06783 0.02938 -0.00905 -0.00986 0.01678 ...
##  $ tBodyAccJerk-std()-X       : num  -0.994 -0.996 -0.991 -0.993 -0.996 ...
##  $ tBodyAccJerk-std()-Y       : num  -0.988 -0.981 -0.981 -0.988 -0.988 ...
##  $ tBodyAccJerk-std()-Z       : num  -0.994 -0.992 -0.99 -0.993 -0.992 ...
##  $ tBodyGyro-mean()-X         : num  -0.0061 -0.0161 -0.0317 -0.0434 -0.034 ...
##  $ tBodyGyro-mean()-Y         : num  -0.0314 -0.0839 -0.1023 -0.0914 -0.0747 ...
##  $ tBodyGyro-mean()-Z         : num  0.1077 0.1006 0.0961 0.0855 0.0774 ...
##  $ tBodyGyro-std()-X          : num  -0.985 -0.983 -0.976 -0.991 -0.985 ...
##  $ tBodyGyro-std()-Y          : num  -0.977 -0.989 -0.994 -0.992 -0.992 ...
##  $ tBodyGyro-std()-Z          : num  -0.992 -0.989 -0.986 -0.988 -0.987 ...
##  $ tBodyGyroJerk-mean()-X     : num  -0.0992 -0.1105 -0.1085 -0.0912 -0.0908 ...
##  $ tBodyGyroJerk-mean()-Y     : num  -0.0555 -0.0448 -0.0424 -0.0363 -0.0376 ...
##  $ tBodyGyroJerk-mean()-Z     : num  -0.062 -0.0592 -0.0558 -0.0605 -0.0583 ...
##  $ tBodyGyroJerk-std()-X      : num  -0.992 -0.99 -0.988 -0.991 -0.991 ...
##  $ tBodyGyroJerk-std()-Y      : num  -0.993 -0.997 -0.996 -0.997 -0.996 ...
##  $ tBodyGyroJerk-std()-Z      : num  -0.992 -0.994 -0.992 -0.993 -0.995 ...
##  $ tBodyAccMag-mean()         : num  -0.959 -0.979 -0.984 -0.987 -0.993 ...
##  $ tBodyAccMag-std()          : num  -0.951 -0.976 -0.988 -0.986 -0.991 ...
##  $ tGravityAccMag-mean()      : num  -0.959 -0.979 -0.984 -0.987 -0.993 ...
##  $ tGravityAccMag-std()       : num  -0.951 -0.976 -0.988 -0.986 -0.991 ...
##  $ tBodyAccJerkMag-mean()     : num  -0.993 -0.991 -0.989 -0.993 -0.993 ...
##  $ tBodyAccJerkMag-std()      : num  -0.994 -0.992 -0.99 -0.993 -0.996 ...
##  $ tBodyGyroMag-mean()        : num  -0.969 -0.981 -0.976 -0.982 -0.985 ...
##  $ tBodyGyroMag-std()         : num  -0.964 -0.984 -0.986 -0.987 -0.989 ...
##  $ tBodyGyroJerkMag-mean()    : num  -0.994 -0.995 -0.993 -0.996 -0.996 ...
##  $ tBodyGyroJerkMag-std()     : num  -0.991 -0.996 -0.995 -0.995 -0.995 ...
##  $ fBodyAcc-mean()-X          : num  -0.995 -0.997 -0.994 -0.995 -0.997 ...
##  $ fBodyAcc-mean()-Y          : num  -0.983 -0.977 -0.973 -0.984 -0.982 ...
##  $ fBodyAcc-mean()-Z          : num  -0.939 -0.974 -0.983 -0.991 -0.988 ...
##  $ fBodyAcc-std()-X           : num  -0.995 -0.999 -0.996 -0.996 -0.999 ...
##  $ fBodyAcc-std()-Y           : num  -0.983 -0.975 -0.966 -0.983 -0.98 ...
##  $ fBodyAcc-std()-Z           : num  -0.906 -0.955 -0.977 -0.99 -0.992 ...
##  $ fBodyAccJerk-mean()-X      : num  -0.992 -0.995 -0.991 -0.994 -0.996 ...
##  $ fBodyAccJerk-mean()-Y      : num  -0.987 -0.981 -0.982 -0.989 -0.989 ...
##  $ fBodyAccJerk-mean()-Z      : num  -0.99 -0.99 -0.988 -0.991 -0.991 ...
##  $ fBodyAccJerk-std()-X       : num  -0.996 -0.997 -0.991 -0.991 -0.997 ...
##  $ fBodyAccJerk-std()-Y       : num  -0.991 -0.982 -0.981 -0.987 -0.989 ...
##  $ fBodyAccJerk-std()-Z       : num  -0.997 -0.993 -0.99 -0.994 -0.993 ...
##  $ fBodyGyro-mean()-X         : num  -0.987 -0.977 -0.975 -0.987 -0.982 ...
##  $ fBodyGyro-mean()-Y         : num  -0.982 -0.993 -0.994 -0.994 -0.993 ...
##  $ fBodyGyro-mean()-Z         : num  -0.99 -0.99 -0.987 -0.987 -0.989 ...
##  $ fBodyGyro-std()-X          : num  -0.985 -0.985 -0.977 -0.993 -0.986 ...
##  $ fBodyGyro-std()-Y          : num  -0.974 -0.987 -0.993 -0.992 -0.992 ...
##  $ fBodyGyro-std()-Z          : num  -0.994 -0.99 -0.987 -0.989 -0.988 ...
##  $ fBodyAccMag-mean()         : num  -0.952 -0.981 -0.988 -0.988 -0.994 ...
##  $ fBodyAccMag-std()          : num  -0.956 -0.976 -0.989 -0.987 -0.99 ...
##  $ fBodyBodyAccJerkMag-mean() : num  -0.994 -0.99 -0.989 -0.993 -0.996 ...
##  $ fBodyBodyAccJerkMag-std()  : num  -0.994 -0.992 -0.991 -0.992 -0.994 ...
##  $ fBodyBodyGyroMag-mean()    : num  -0.98 -0.988 -0.989 -0.989 -0.991 ...
##  $ fBodyBodyGyroMag-std()     : num  -0.961 -0.983 -0.986 -0.988 -0.989 ...
##  $ fBodyBodyGyroJerkMag-mean(): num  -0.992 -0.996 -0.995 -0.995 -0.995 ...
##  $ fBodyBodyGyroJerkMag-std() : num  -0.991 -0.996 -0.995 -0.995 -0.995 ...
```
#4. Uses descriptive activity names to name the activities in the data set


```r
activityNames <- fread(file.path(dataPath, "activity_labels.txt"))
mergedData$activity <- factor(mergedData$activity, levels=activityNames$V1, labels=activityNames$V2) 
head(mergedData$activity, 30)
```

```
##  [1] STANDING STANDING STANDING STANDING STANDING STANDING STANDING
##  [8] STANDING STANDING STANDING STANDING STANDING STANDING STANDING
## [15] STANDING STANDING STANDING STANDING STANDING STANDING STANDING
## [22] STANDING STANDING STANDING STANDING STANDING STANDING SITTING 
## [29] SITTING  SITTING 
## 6 Levels: WALKING WALKING_UPSTAIRS WALKING_DOWNSTAIRS ... LAYING
```
#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
## 5.1 Create a second, independent tidy data set

```r
#Group the data by subject and activity, and get the mean of each other variables
tidyDataSet <- ddply(mergedData, .(subject, activity), colwise(mean))
str(tidyDataSet)
```

```
## 'data.frame':	180 obs. of  68 variables:
##  $ subject                    : int  1 1 1 1 1 1 2 2 2 2 ...
##  $ activity                   : Factor w/ 6 levels "WALKING","WALKING_UPSTAIRS",..: 1 2 3 4 5 6 1 2 3 4 ...
##  $ tBodyAcc-mean()-X          : num  0.277 0.255 0.289 0.261 0.279 ...
##  $ tBodyAcc-mean()-Y          : num  -0.01738 -0.02395 -0.00992 -0.00131 -0.01614 ...
##  $ tBodyAcc-mean()-Z          : num  -0.1111 -0.0973 -0.1076 -0.1045 -0.1106 ...
##  $ tBodyAcc-std()-X           : num  -0.284 -0.355 0.03 -0.977 -0.996 ...
##  $ tBodyAcc-std()-Y           : num  0.11446 -0.00232 -0.03194 -0.92262 -0.97319 ...
##  $ tBodyAcc-std()-Z           : num  -0.26 -0.0195 -0.2304 -0.9396 -0.9798 ...
##  $ tGravityAcc-mean()-X       : num  0.935 0.893 0.932 0.832 0.943 ...
##  $ tGravityAcc-mean()-Y       : num  -0.282 -0.362 -0.267 0.204 -0.273 ...
##  $ tGravityAcc-mean()-Z       : num  -0.0681 -0.0754 -0.0621 0.332 0.0135 ...
##  $ tGravityAcc-std()-X        : num  -0.977 -0.956 -0.951 -0.968 -0.994 ...
##  $ tGravityAcc-std()-Y        : num  -0.971 -0.953 -0.937 -0.936 -0.981 ...
##  $ tGravityAcc-std()-Z        : num  -0.948 -0.912 -0.896 -0.949 -0.976 ...
##  $ tBodyAccJerk-mean()-X      : num  0.074 0.1014 0.0542 0.0775 0.0754 ...
##  $ tBodyAccJerk-mean()-Y      : num  0.028272 0.019486 0.02965 -0.000619 0.007976 ...
##  $ tBodyAccJerk-mean()-Z      : num  -0.00417 -0.04556 -0.01097 -0.00337 -0.00369 ...
##  $ tBodyAccJerk-std()-X       : num  -0.1136 -0.4468 -0.0123 -0.9864 -0.9946 ...
##  $ tBodyAccJerk-std()-Y       : num  0.067 -0.378 -0.102 -0.981 -0.986 ...
##  $ tBodyAccJerk-std()-Z       : num  -0.503 -0.707 -0.346 -0.988 -0.992 ...
##  $ tBodyGyro-mean()-X         : num  -0.0418 0.0505 -0.0351 -0.0454 -0.024 ...
##  $ tBodyGyro-mean()-Y         : num  -0.0695 -0.1662 -0.0909 -0.0919 -0.0594 ...
##  $ tBodyGyro-mean()-Z         : num  0.0849 0.0584 0.0901 0.0629 0.0748 ...
##  $ tBodyGyro-std()-X          : num  -0.474 -0.545 -0.458 -0.977 -0.987 ...
##  $ tBodyGyro-std()-Y          : num  -0.05461 0.00411 -0.12635 -0.96647 -0.98773 ...
##  $ tBodyGyro-std()-Z          : num  -0.344 -0.507 -0.125 -0.941 -0.981 ...
##  $ tBodyGyroJerk-mean()-X     : num  -0.09 -0.1222 -0.074 -0.0937 -0.0996 ...
##  $ tBodyGyroJerk-mean()-Y     : num  -0.0398 -0.0421 -0.044 -0.0402 -0.0441 ...
##  $ tBodyGyroJerk-mean()-Z     : num  -0.0461 -0.0407 -0.027 -0.0467 -0.049 ...
##  $ tBodyGyroJerk-std()-X      : num  -0.207 -0.615 -0.487 -0.992 -0.993 ...
##  $ tBodyGyroJerk-std()-Y      : num  -0.304 -0.602 -0.239 -0.99 -0.995 ...
##  $ tBodyGyroJerk-std()-Z      : num  -0.404 -0.606 -0.269 -0.988 -0.992 ...
##  $ tBodyAccMag-mean()         : num  -0.137 -0.1299 0.0272 -0.9485 -0.9843 ...
##  $ tBodyAccMag-std()          : num  -0.2197 -0.325 0.0199 -0.9271 -0.9819 ...
##  $ tGravityAccMag-mean()      : num  -0.137 -0.1299 0.0272 -0.9485 -0.9843 ...
##  $ tGravityAccMag-std()       : num  -0.2197 -0.325 0.0199 -0.9271 -0.9819 ...
##  $ tBodyAccJerkMag-mean()     : num  -0.1414 -0.4665 -0.0894 -0.9874 -0.9924 ...
##  $ tBodyAccJerkMag-std()      : num  -0.0745 -0.479 -0.0258 -0.9841 -0.9931 ...
##  $ tBodyGyroMag-mean()        : num  -0.161 -0.1267 -0.0757 -0.9309 -0.9765 ...
##  $ tBodyGyroMag-std()         : num  -0.187 -0.149 -0.226 -0.935 -0.979 ...
##  $ tBodyGyroJerkMag-mean()    : num  -0.299 -0.595 -0.295 -0.992 -0.995 ...
##  $ tBodyGyroJerkMag-std()     : num  -0.325 -0.649 -0.307 -0.988 -0.995 ...
##  $ fBodyAcc-mean()-X          : num  -0.2028 -0.4043 0.0382 -0.9796 -0.9952 ...
##  $ fBodyAcc-mean()-Y          : num  0.08971 -0.19098 0.00155 -0.94408 -0.97707 ...
##  $ fBodyAcc-mean()-Z          : num  -0.332 -0.433 -0.226 -0.959 -0.985 ...
##  $ fBodyAcc-std()-X           : num  -0.3191 -0.3374 0.0243 -0.9764 -0.996 ...
##  $ fBodyAcc-std()-Y           : num  0.056 0.0218 -0.113 -0.9173 -0.9723 ...
##  $ fBodyAcc-std()-Z           : num  -0.28 0.086 -0.298 -0.934 -0.978 ...
##  $ fBodyAccJerk-mean()-X      : num  -0.1705 -0.4799 -0.0277 -0.9866 -0.9946 ...
##  $ fBodyAccJerk-mean()-Y      : num  -0.0352 -0.4134 -0.1287 -0.9816 -0.9854 ...
##  $ fBodyAccJerk-mean()-Z      : num  -0.469 -0.685 -0.288 -0.986 -0.991 ...
##  $ fBodyAccJerk-std()-X       : num  -0.1336 -0.4619 -0.0863 -0.9875 -0.9951 ...
##  $ fBodyAccJerk-std()-Y       : num  0.107 -0.382 -0.135 -0.983 -0.987 ...
##  $ fBodyAccJerk-std()-Z       : num  -0.535 -0.726 -0.402 -0.988 -0.992 ...
##  $ fBodyGyro-mean()-X         : num  -0.339 -0.493 -0.352 -0.976 -0.986 ...
##  $ fBodyGyro-mean()-Y         : num  -0.1031 -0.3195 -0.0557 -0.9758 -0.989 ...
##  $ fBodyGyro-mean()-Z         : num  -0.2559 -0.4536 -0.0319 -0.9513 -0.9808 ...
##  $ fBodyGyro-std()-X          : num  -0.517 -0.566 -0.495 -0.978 -0.987 ...
##  $ fBodyGyro-std()-Y          : num  -0.0335 0.1515 -0.1814 -0.9623 -0.9871 ...
##  $ fBodyGyro-std()-Z          : num  -0.437 -0.572 -0.238 -0.944 -0.982 ...
##  $ fBodyAccMag-mean()         : num  -0.1286 -0.3524 0.0966 -0.9478 -0.9854 ...
##  $ fBodyAccMag-std()          : num  -0.398 -0.416 -0.187 -0.928 -0.982 ...
##  $ fBodyBodyAccJerkMag-mean() : num  -0.0571 -0.4427 0.0262 -0.9853 -0.9925 ...
##  $ fBodyBodyAccJerkMag-std()  : num  -0.103 -0.533 -0.104 -0.982 -0.993 ...
##  $ fBodyBodyGyroMag-mean()    : num  -0.199 -0.326 -0.186 -0.958 -0.985 ...
##  $ fBodyBodyGyroMag-std()     : num  -0.321 -0.183 -0.398 -0.932 -0.978 ...
##  $ fBodyBodyGyroJerkMag-mean(): num  -0.319 -0.635 -0.282 -0.99 -0.995 ...
##  $ fBodyBodyGyroJerkMag-std() : num  -0.382 -0.694 -0.392 -0.987 -0.995 ...
```
## 5.2 Write the second tidy data set to txt file

```r
write.table(tidyDataSet, file = "tidyDataSet.txt", row.names = FALSE)
```