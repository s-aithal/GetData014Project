# Getting and Cleaning Data - Course Project

This repository contains the script for the course project of Getting and Cleaning Data course on Coursera

The code to clean and prepare the data is in _run\_analysis.R_ file. This file contains two functions:

1. runAnalysis()
2. readAndCombine()

###Function: readAndCombine()
This function takes four arguments:

1. featurePath: Path to the file that contains measurement data of features. Ex: test\\X_test.txt
2. subjectPath: Path to the file that contains subject ID. Ex: test\\subject_test.txt
3. activityPath: Path to the file that contains activity ID. Ex: test\\y_test.txt
4. featurecols: A dataframe that contains column index and column name of the columns that are required for the purpose of this project.

The function does the following:

1. Reads feature-measurement data and retains only mean and std related columns.
2. Reads subject and activity data
3. Adds subject and activity data as columns to the feature-measurement data
4. Returns the complete data

###Function: runAnalysis()
This is the function that a user calls in order to prepare the data. This function has six steps each of which do certain activities as described below.
 
Step 1: 
* Read the "features.txt" file to get a list of feature names
* Prune the list to contain only the columns relating to mean and standard deviation
* Convert the feature names to match variable naming convention of R
 
 
Step 2:
* Combine test data, activity, and subject files.
* Retain only the feature columns that contain mean and std values

 
Step 3:
* Repeat the previous step with training data

 
Step 4:
* Combine both test and training data to create one dataframe.
* Change column names to meaningful names
 
 
Step 5:
* Read Activity label file
* Merge activity label file with the combined data from Step 4 to assign activity label to each measurement
* Remove ActivityID column from the data frame
* Rearrange columns such that SubjectID and Activity are followed by feature columns
 
 
Step 6:
* Group the data by SubjectID and Activity
* Compute mean for each feature column
* Convert "wide format data" to "narrow format data" by converting feature columns
  to rows with name-value pair
* Order the data by SubjectID, Activity, and Feature
* Write the data to "tidydata.txt" file
 