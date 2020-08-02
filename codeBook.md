---
title: "Getting and Cleaning Data Peer Review Assignment"
author: "Graeme"
date: "01/08/2020"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## Introduction

This is a peer review assignment with the purpose of demonstrating the ability to collect, work with and clean data. In the assignment, activity tracking data from the Samsung Galaxy S is taken and processed as instructed.

## First Steps 
First, the global environment is cleared by using the first command below and then dplyr is loaded to clean the data later on.

The working directory is then set.
```{r 1steps}
rm(list = ls())

library(dplyr)

setwd("G:/My Drive/R/Module3/Week4/project/Getting-and-Cleaning-Data")
```

## Getting the Data
In the next step, the URL to the data in a zip file is stored in the global environment. Two if statements are the used, the one to download the file, if it has not yet been done, and the second to unzip the file, again only if this has not yet been done. 

```{r files}
zipURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

if(!file.exists("./data/project_data.zip") == T){download.file(zipURL, "./data/project_data.zip")}

if(!file.exists("./data/UCI HAR Dataset") == T){unzip("./data/project_data.zip", exdir = "./data")}
```

Next, the features, which are the varaible names, are are loaded with the read.table command and the subject numbers, variables (x values) and activity numbers (y values) are loaded for the test data set. The features are used to define the variable names as the x values are loaded. These three objects are then combined using the cbind command and stored as test_df.

```{r test}
features <- read.table("./data/UCI HAR Dataset/features.txt")

subjecttest <- read.table("./data/UCI HAR Dataset/test/subject_test.txt", col.names = "subject number")
test_x <- read.table("./data/UCI HAR Dataset/test/X_test.txt", col.names = features[,2])
test_y <- read.table("./data/UCI HAR Dataset/test/y_test.txt", col.names = "activity")
test_df <- cbind(subjecttest, test_y, test_x)
```

This is repeated for the training data set.

```{r train}
subjecttrain <- read.table("./data/UCI HAR Dataset/train/subject_train.txt", col.names = "subject number")
train_x <- read.table("./data/UCI HAR Dataset/train/X_train.txt", col.names = features[,2])
train_y <- read.table("./data/UCI HAR Dataset/train/y_train.txt", col.names = "activity")
train_df <- cbind(subjecttrain, train_y, train_x)
```

Finally the activity number and names are loaded, which will later be used to label the y variables.

```{r activity}
activities <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
```

## Merging the Data
The test and training data set are merged using the rbind command. 

```{r merge}
merged_df <- rbind(test_df,train_df) 
```

## Selecting Variables
To clean the data, only the measurements' mean and standard deviation are extracted using the select command from the dplyr package.

```{r clean}
tidy_df <- select(merged_df,
                  subject.number, 
                  activity,
                  contains(".mean.."), 
                  contains(".std.."))
```

## Labelling the Activities
The activities are then labled using the activity table created earlier.

```{r ylabel}
tidy_df$activity <- activities[tidy_df$activity, 2]
```

## Renaming the Variables
The feature are then renamed to be more descriptive using the gsub function. the following transformations are made:

* Variables starting with t and f are transformed to "Time" and "Frequency" using the "^" operator.
* Acc to Accelerometer
* Gyro to Gyroscope
* Spaces and brackets were automatically transformed to points when reading in the variable names. These dots are removed.
* mean to Mean
* std to StandardDeviation
* tBody to TimeBody
* BodyBody to Body
* gravity to Gravity
* Mag to Magnitude

A list describing the different variable names are given in the next section.

```{r rename}
names(tidy_df) <- gsub("^t", "Time", names(tidy_df))
names(tidy_df) <- gsub("^f", "Frequency", names(tidy_df))
names(tidy_df) <- gsub("Acc", "Accelerometer", names(tidy_df))
names(tidy_df) <- gsub("Gyro", "Gyroscope", names(tidy_df))
names(tidy_df) <- gsub("\\.", "", names(tidy_df))
names(tidy_df) <- gsub("mean", "Mean", names(tidy_df))
names(tidy_df) <- gsub("std", "StandardDeviation", names(tidy_df))
names(tidy_df) <- gsub("tBody", "TimeBody", names(tidy_df))
names(tidy_df) <- gsub("BodyBody", "Body", names(tidy_df))
names(tidy_df) <- gsub("gravity", "Gravity", names(tidy_df))
names(tidy_df) <- gsub("Mag", "Magnitude", names(tidy_df))
```

## Calculating Means and Exporting Data
Finally, the final tidy data set is created by calculating the mean of each varible per subject and activity. This is done by grouping by subject and activity using the group_by command from dplyr and then using summarise_all to calculate the mean. The object can then be exported as a text file by using the write.table command.

```{r tidy}
final_df <- group_by(tidy_df, subjectnumber, activity)%>%
        summarise_all(mean)

write.table(final_df, "final_df.txt", row.names = FALSE)
```

## Variable Names
Excluding the subjectnumber and activity colums, the varaibles can be described by a combination of:

* Domain: Time domain, which are the measurements made over time or Frequncy domain which are values obtained by Fast Fourier transformation based on the time domain.
* Body/Gravity: Some of the measurements are not based on body based measurements, but gravity measurements.
* Plane: Denotes if the measurement is made in the x, y or z plane.
* Function: Mean or StandardDeviation of the measurements.
* Jerk: In some cases the jerk signal was calculated by deriving the acceleration or angular velocity measurements in time.
* Magnitude: For variables where the euclidian norm of the three axis varaiables were calculated.

The variables can be described as follows (variables with (XYZ) at the end denote three separate variables for each plane):

* subjectnumber, 1 - The number identifying the 30 individual subjects.
* activity, 2 - The activity labels
* TimeBodyAccelerometerMean(XYZ), 3-5 - Mean time body acceleration in the x, y and z plane.
* TimeGravityAccelerometerMean(XYZ), 6-8  - Mean time gravity acceleration in the x, y and z plane.
* TimeBodyAccelerometerJerkMean(XYZ), 9-11 - Mean time body acceleration Jerk signal in the x, y and z plane.
* TimeBodyGyroscopeMean(XYZ), 12-14 - Mean time body angular velocity in the x, y and z plane.
* TimeBodyGyroscopeJerkMean(XYZ), 15-17 - Mean time body angular velocity Jerk signal in the x, y and z plane.
* TimeBodyAccelerometerMagnitudeMean, 18 - Mean time body acceleration magnitude.
* TimeGravityAccelerometerMagnitudeMean, 19 - Mean time gravity acceleration magnitude.
* TimeBodyAccelerometerJerkMagnitudeMean, 20 - Mean time body acceleration Jerk signal magnitude.
* TimeBodyGyroscopeMagnitudeMean, 21 - Mean time body angular velocity magnitude.
* TimeBodyGyroscopeJerkMagnitudeMean, 22 - Mean time body angular velocity Jerk signal magnitude.
* FrequencyBodyAccelerometerMean(XYZ), 23-25 - Mean frequency body acceleration in the x, y and z plane.
* FrequencyBodyAccelerometerJerkMean(XYZ), 26-28 - Mean frequency body acceleration Jerk signal in the x, y and z plane.
* FrequencyBodyGyroscopeMean(XYZ), 29-31 - Mean frequency body angular velocity in the x, y and z planes.
* FrequencyBodyAccelerometerMagnitudeMean, 32 - Mean frequency body acceleration magnitude.
* FrequencyBodyAccelerometerJerkMagnitudeMean, 33 - Mean frequency body acceleration Jerk signal magnitude.
* FrequencyBodyGyroscopeMagnitudeMean, 34 - Mean frequency body angular velocity magnitude.
* FrequencyBodyGyroscopeJerkMagnitudeMean, 35 - Mean frequency body angular velocity Jerk signal magnitude.
* TimeBodyAccelerometerStandardDeviation(XYZ), 36-38 - Standard deviation of time body acceleration in the x, y and z plane.
* TimeGravityAccelerometerStandardDeviation(XYZ), 39-41 - Standard deviation of time gravity acceleration in the x, y and z plane.
* TimeBodyAccelerometerJerkStandardDeviation(XYZ), 42-44 - Standard deviation of time body acceleration Jerk signal in the x, y and z plane.
* TimeBodyGyroscopeStandardDeviation(XYZ), 45-47 - Standard deviation of time body angular velocity in the x, y and z plane.
* TimeBodyGyroscopeJerkStandardDeviation(XYZ), 48-50 - Standard deviation of time body angular velocity Jerk signal in the x, y and z plane.
* TimeBodyAccelerometerMagnitudeStandardDeviation, 51 - Standard deviation of time body acceleration magnitude.
* TimeGravityAccelerometerMagnitudeStandardDeviation, 52 - Standard deviation of time gravity acceleration magnitude.
* TimeBodyAccelerometerJerkMagnitudeStandardDeviation, 53 - Standard deviation of time body acceleration Jerk signal magnitude.
* TimeBodyGyroscopeMagnitudeStandardDeviation, 54 - Standard deviation of time body angular velocity magnitude.
* TimeBodyGyroscopeJerkMagnitudeStandardDeviation, 55 - Standard deviation of time body angular velocity Jerk Signal magnitude.
* FrequencyBodyAccelerometerStandardDeviation(XYZ), 56-58 - Standard deviation of frequency body acceleration in the x, y and z plane.
* FrequencyBodyAccelerometerJerkStandardDeviation(XYZ), 59-61 - Standard deviation of frequency body acceleration Jerk signal in the x, y and z plane. 
* FrequencyBodyGyroscopeStandardDeviation(XYZ), 62-64 - Standard deviation of frequency body angular velocity in the x, y and z plane.
* FrequencyBodyAccelerometerMagnitudeStandardDeviation, 65 - Standard deviation of frequency body acceleration magnitude.
* FrequencyBodyAccelerometerJerkMagnitudeStandardDeviation, 66 - Standard deviation of frequency body acceleration Jerk signal magnitude.
* FrequencyBodyGyroscopeMagnitudeStandardDeviation, 67 - Standard deviation of frequency body angular velocity magnitude.
* FrequencyBodyGyroscopeJerkMagnitudeStandardDeviation, 68 - Standard deviation of frequency body angular velocity Jerk signal magnitude.