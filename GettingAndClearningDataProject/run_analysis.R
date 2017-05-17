library(data.table)
library(plyr)

setwd("C:\\Users\\flora\\Desktop\\DataScientist\\learning\\03Data-Cleaning\\project")

#1: download the file, unzip it, and read the data. The data is in "UCI HAR Dataset" folder
if( !file.exists("./Data") ) { dir.create("./Data") }

if( !file.exists("UCI_HAR_Dataset.zip")) {
      fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
      download.file(fileUrl, destfile="./UCI_HAR_Dataset.zip")
}

unzip(zipfile="./UCI_HAR_Dataset.zip", exdir = "./Data")
dataPath <- file.path("./Data", "UCI HAR Dataset")

#2. Merge the training and the test sets to create one data set.
#2.1 Read data files
#read the train and test data set, each row is a 561-element vector 
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

#2.2 Merge train and test data
subjectData <- rbind(subjectTrain, subjectTest)
activityData <- rbind(activityTrain, activityTest)
featureData <- rbind(xTrain, xTest)

#2.3 Set column names
setnames(subjectData, "V1", "subject")
setnames(activityData, "V1", "activity")

#Appropriately labels the data set with descriptive variable names.
setnames(featureData, names(featureData), featureNames$V2)

#2.4 Merge the subject data, activity data and feature data into one big data set
mergedData <- cbind(cbind(subjectData, activityData), featureData)
str(mergedData)

#3. Extracts only the measurements on the mean and standard deviation for each measurement
#extract features name with "mean()" or "std()"
selectedFeature <- featureNames$V2[grep("mean\\(\\)|std\\(\\)", featureNames$V2)]
selectedFeature
mergedData <- mergedData[,c("subject", "activity", selectedFeature[1:length(selectedFeature)])]
str(mergedData)

#4. Uses descriptive activity names to name the activities in the data set
activityNames <- fread(file.path(dataPath, "activity_labels.txt"))
mergedData$activity <- factor(mergedData$activity, levels=activityNames$V1, labels=activityNames$V2) 
head(mergedData$activity, 20)

#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#Group the data by subject and activity, and get the mean of each other variables
library(dplyr);
tidyDataSet <- ddply(mergedData, .(subject, activity), colwise(mean))

#Write the second tidy data set to txt file
write.table(tidyDataSet, file = "tidyDataSet.txt", row.names = FALSE)

#create the codebook
library(knitr)
knit("codeBook.Rmd", output="CodeBook.md", encoding="ISO8859-1", quiet=TRUE)
knit("README.Rmd", output="README.md", encoding="ISO8859-1", quiet=TRUE)