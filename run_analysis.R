library(dplyr)


# Part1
## Get Data

### getting train data
X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

### getting test data
X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

### getting features and activity
df_features <- read.table("UCI HAR Dataset/features.txt")
df_activity <- read.table("UCI HAR Dataset/activity_labels.txt")


str(X_train)
str(y_train)
str(subject_train)

str(X_test)
str(y_test)
str(subject_test)

## 1. Merges the training and the test sets to create one data set.

df_x <- rbind(X_train, X_test)
df_y <- rbind(y_train, y_test)
df_subj <- rbind(subject_train, subject_test)


## 2. Extract only the measurements on the mean and standard deviation for each measurement.
f_index <- grep("mean\\(\\)|std\\(\\)", df_features[,2])
df_x_chosen <- df_x[,f_index]


## 3. Uses descriptive activity names to name the activities in the data set
df_y[,1] <- df_activity[df_y[,1],2]


## 4. Appropriately labels the data set with descriptive variable names
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

## 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
new_df <-aggregate(. ~ subjectID + activity, df, mean)

write.table(new_df, file = "tidydataset.txt",row.name=FALSE)