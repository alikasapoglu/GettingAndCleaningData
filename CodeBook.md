---
title: "CodeBook"
author: "alikasapoglu"
date: "March 7, 2019"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

# Project -- Getting and Cleaning Data
>The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.
One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
Here are the data for the project:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
You should create one R script called run_analysis.R that does the following. 
1. Merges the training and the test sets to create one data set. 
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.



Variable list and descriptions
------------------------------

Variable name    | Description
-----------------|------------
subjectID        | ID 
activity         | Name of the activity
Other Variables  | freq for frequence, Mag for Magnitude etc...



#### Get Data
getting train data:
```{a}
X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
```
getting test data:
```{a}
X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
```
getting features and activity:
```{a}
df_features <- read.table("UCI HAR Dataset/features.txt")
df_activity <- read.table("UCI HAR Dataset/activity_labels.txt")
```
checking values we read:
```{a}
str(X_train)
str(y_train)
str(subject_train)

str(X_test)
str(y_test)
str(subject_test)
```



#### 1. Merges the training and the test sets
```{a}
df_x <- rbind(X_train, X_test)
df_y <- rbind(y_train, y_test)
df_subj <- rbind(subject_train, subject_test)
```

#### 2. Extract only the the mean and standard deviation
```{a}
f_index <- grep("mean\\(\\)|std\\(\\)", df_features[,2])
df_x_chosen <- df_x[,f_index]
```

#### 3. Fix the activity names
```{a}
df_y[,1] <- df_activity[df_y[,1],2]
```

#### 4. Label variable names
```{r include=FALSE}
names(df_x_chosen) <- features[f_index,2] 
names(df_subj) <- "subjectID"
names(df_y) <- "activity"

df <-cbind(df_subj, df_y, df_x_chosen)
str(df)
head(df[,1:4])
backupnames <- names(df)

names(df) <- gsub('^t',"time_",names(df))
names(df) <- gsub('^f',"freq_",names(df))
names(df) <- gsub('\\()',"",names(df))

str(df)
``` 

#### 5. Create new data set for the average of each variable for each activity and each subject
```{a}
new_df <-aggregate(. ~ subjectID + activity, df, mean)
``` 

#### Save to file
```{a}
write.table(new_df, file = "TidyDataSet.txt",row.name=FALSE)
```