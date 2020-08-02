## Clear working directory
rm(list = ls())

## Load dplyr for cleaning data.
library(dplyr)

## Ste working directory
setwd("G:/My Drive/R/Module3/Week4/project/Getting-and-Cleaning-Data")

## Url to zip  file containg the data
zipURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

## downloading the data
if(!file.exists("./data/project_data.zip") == T){download.file(zipURL, "./data/project_data.zip")}

## Unzipping the zip file
if(!file.exists("./data/UCI HAR Dataset") == T){unzip("./data/project_data.zip", exdir = "./data")}

## Reading the features, subject numbers , x values and y values
## for the test and train data sets
features <- read.table("./data/UCI HAR Dataset/features.txt")

subjecttest <- read.table("./data/UCI HAR Dataset/test/subject_test.txt", col.names = "subject number")
test_x <- read.table("./data/UCI HAR Dataset/test/X_test.txt", col.names = features[,2])
test_y <- read.table("./data/UCI HAR Dataset/test/y_test.txt", col.names = "activity")
test_df <- cbind(subjecttest, test_y, test_x)

subjecttrain <- read.table("./data/UCI HAR Dataset/train/subject_train.txt", col.names = "subject number")
train_x <- read.table("./data/UCI HAR Dataset/train/X_train.txt", col.names = features[,2])
train_y <- read.table("./data/UCI HAR Dataset/train/y_train.txt", col.names = "activity")
train_df <- cbind(subjecttrain, train_y, train_x)

activities <- read.table("./data/UCI HAR Dataset/activity_labels.txt")

## Merge test and training data set
merged_df <- rbind(test_df,train_df) 
        
## Select subject, activity and variables containing mean 
## and standard deviation
tidy_df <- select(merged_df,
                  subject.number, 
                  activity,
                  contains(".mean.."), 
                  contains(".std.."))

## Labelling the activities
tidy_df$activity <- activities[tidy_df$activity, 2]

## Renaming the variables
names(tidy_df) <- gsub("^t", "Time", names(tidy_df))
names(tidy_df) <- gsub("^f", "Frequency", names(tidy_df))
names(tidy_df) <- gsub("Acc", "Accelerometer", names(tidy_df))
names(tidy_df) <- gsub("Gyro", "Gyroscope", names(tidy_df))
names(tidy_df) <- gsub("\\.", "", names(tidy_df))
names(tidy_df) <- gsub("mean", "Mean", names(tidy_df))
names(tidy_df) <- gsub("std", "StandardDeviation", names(tidy_df))
names(tidy_df) <- gsub("tBody", "TimeBody", names(tidy_df))
names(tidy_df) <- gsub("BodyBody", "Body", names(tidy_df))
names(tidy_df) <- gsub("angle", "Angle", names(tidy_df))
names(tidy_df) <- gsub("gravity", "Gravity", names(tidy_df))
names(tidy_df) <- gsub("Mag", "Magnitude", names(tidy_df))

## Calculating the mean by subject number and activity for 
## all the variables
final_df <- group_by(tidy_df, subjectnumber, activity)%>%
        summarise_all(mean)

## Exporting the tidy data set as text file.
write.table(final_df, "final_df.txt", row.names = FALSE)

