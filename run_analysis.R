## This R script is a part of the Coursera Getting and Cleaning Data course
## project.
## Author: Sergei Uglitskikh <uglitskikh@mail.mipt.ru>
## Issued: May 24, 2015

library("dplyr")

data_dir <- file.path("data", "UCI HAR Dataset")

## Point 1 of the assignment. Function to create the dataset.
##
create_dataset <- function () {
    ## Load column names for Features data
    features_col_names <- read.table(file.path(data_dir, "features.txt"),
                                     header = FALSE,
                                     stringsAsFactors = FALSE)[,2]
    
    ## Load Features data.
    features_train <- read.table(file.path(data_dir, "train", "X_train.txt"),
                                 header = FALSE,
                                 col.names = features_col_names)
    features_test <- read.table(file.path(data_dir, "test", "X_test.txt"),
                                header = FALSE,
                                col.names = features_col_names)
    
    ## Load Subject data.
    subject_train <- read.table(file.path(data_dir,
                                          "train",
                                          "subject_train.txt"),
                                header = FALSE,
                                col.names = "SubjectID")
    subject_test <- read.table(file.path(data_dir, "test", "subject_test.txt"),
                               header = FALSE,
                               col.names = "SubjectID")
    
    ## Load Activity data.
    activity_train <- read.table(file.path(data_dir, "train", "y_train.txt"),
                                 header = FALSE,
                                 col.names = "ActivityID")
    activity_test <- read.table(file.path(data_dir, "test", "y_test.txt"),
                                header = FALSE,
                                col.names = "ActivityID")
    
    ## For each data set, test and training, combine data frames by columns:
    ## features, subject, activity.
    test_df <- bind_cols(features_test, subject_test, activity_test)
    train_df <- bind_cols(features_train, subject_train, activity_train)
    
    ## Merge test and training data sets, or combine them by rows.
    df <- bind_rows(test_df, train_df)
    return(df)
}

## Point 2 of the assignment. Function to extract only the measurements on
## the mean and standard deviation for each measurement. 
extract <- function(df) {
    if (!is.tbl(df)) df <- tbl_df(df)
    output <- select(df, contains("mean"), contains("std"),
                     SubjectID, ActivityID)
    return(output)
}

## Point 3 of the assignment. Function to add descriptive activity names.
add_activity_name <- function(df) {
    if (!is.tbl(df)) df <- tbl_df(df)
    ## Load activity names
    activity_df <- tbl_df(read.table(file.path(data_dir, "activity_labels.txt"),
                                     header = FALSE,
                                     col.names = c("ActivityID", "ActivityName")))
    ## Merge data set with acivity names
    df_upd <- left_join(df, activity_df, by = "ActivityID")
    df_upd <- select(df_upd, -ActivityID)
    return(df_upd)
}

## Point 4 of the assignment. Function to label the data set with descriptive
## variable names
update_var_names <- function(df) {
    names(df)<-gsub("^t", "time", names(df))
    names(df)<-gsub("^f", "frequency", names(df))
    names(df)<-gsub("Acc", "Accelerometer", names(df))
    names(df)<-gsub("Gyro", "Gyroscope", names(df))
    names(df)<-gsub("Mag", "Magnitude", names(df))
    names(df)<-gsub("BodyBody", "Body", names(df))
    return(df)
}

## Point 5 of the assignment. Function to creates a second, independent
## tidy data set with the average of each variable for each activity and each
## subject.
second_dataset <- function() {
    df <- create_dataset() %>%
        extract() %>%
        add_activity_name() %>%
        update_var_names() %>%
        group_by(SubjectID, ActivityName) %>%
        summarise_each(funs(mean))
    return(df)
}

## Write tidy dataset into file
write_tidy_data <- function(df) {
    write.table(df, file = "tidy_dataset.txt", row.name = FALSE)
}