## The purpose of this project is to demonstrate your ability to collect, work with, and clean a 
## data set. The goal is to prepare tidy data that can be used for later analysis.

## Load necessary libraries
library(downloader)
library(dplyr)
library(data.table)
library(reshape2)

## download the data file zip
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
              mode = "wb",
              destfile = "./GetData.zip")

## extract the data
unzip("GetData.zip", exdir=".")

## read the labels for the data into a data table
labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

## read the features of the data set into a data table
features <- read.table("./UCI HAR Dataset/features.txt")

## read the test text files into data table
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")

## read the train text files into a data table
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")

## add names to the data tables



###################################
## merge the data files together ##
names(features) <- c("subject","measurement")
x_data <- rbind(x_test, X_train)
names(x_data) <- features$measurement
y_data <- rbind(y_test, y_train)
subject_data <- rbind(subject_test, subject_train)



#######################################################
## Extracts mean and standard deviation measurements ##
## into a data table                                 ##


## identifies with features have mean or std dev in them
index_features <- grep("-mean\\(\\)|-std\\(\\)", features$measurement)

measurements <- x_data[,index_features]



#########################################################################
## Uses descriptive activity names to name the activities in           ##
## the data set and Appropriately labels the data set with descriptive ##
## variable names.                                                     ##

## give the label columns valid names
names(labels) <- c("subject","activity")

## change y data values into their activity name
y_data[,1] <- labels[y_data[,1],2]

## assign names to y data and subject data
names(y_data) <- c("activity")
names(subject_data) <- c("subject")

## combine data tables into one table
complete_data <- cbind(subject_data,y_data, measurements)



##################################################################
## create an independent tidy data set from complete data       ##
## with the average of each variable for each activity and each ##
## subject                                                      ##

tidy_data <- aggregate(complete_data[,3:dim(complete_data)[2]], list(complete_data$subject,complete_data$activity), mean)
names(tidy_data)[1]<-c("subject")
names(tidy_data)[2]<-c("activity")

## Export the tidy data set
write.table(tidy_data, file = "./tidy_data.txt", row.names = FALSE)