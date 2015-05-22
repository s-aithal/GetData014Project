# This script assumes the current working directory to be "UCI HAR Dataset" 
# that gets created when the zip file contianing the data is unzipped.
# Contents of this folder are
# test          (folder with test data)
# train         (folder with training data)
# activity_labels.txt
# features.txt
# features_info.txt
# README.txt
# 
# Objectives (from the project guidelines in Coursera)
# 1    Merges the training and the test sets to create one data set.
# 2    Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3    Uses descriptive activity names to name the activities in the data set
# 4    Appropriately labels the data set with descriptive variable names. 
# 5    From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
################################################################################

##################
# Step 1: 
# *  Read the "features.txt" file to get a list of feature names
# *  Prune the list to contain only the columns relating to mean and standard deviation
# *  Convert the feature names to match variable naming convention of R
# Step 2:
# *  Combine test data, activity, and subject files.
# *  Retain only the feature columns that contain mean and std values
# Step 3:
# *  Repeat the previous step with training data
# Step 4:
# *  Combine both test and training data to create one dataframe.
# *  Change column names to meaningful names
# Step 5:
# *  Read Activity label file
# *  Merge activity label file with the combined data from Step 4 to assign activity label to each measurement
# *  Remove ActivityID column from the data frame
# *  Rearrange columns such that SubjectID and Activity are followed by feature columns
# Step 6:
# *  Group the data by SubjectID and Activity
# *  Compute mean for each feature column
# *  Convert "wide format data" to "narrow format data" by converting feature columns
#    to rows with name-value pair
# *  Order the data by SubjectID and Activity
# *  Write the data to "tidydata.txt" file
##################

runAnalysis <- function()
{
    ## Step 1 ##
    # Read features.txt and find out which columns contain mean and std.
    featurecols <- read.table("features.txt", sep = " ", stringsAsFactors = F, col.names = c("ColIndex", "FeatureName"))
    # Retain only the rows that contain "mean" and "std" features
    featurecols <- featurecols[grep("-mean|-std", featurecols$FeatureName, ignore.case = T),]
    # Rename feature names to standard R variable syntax
    #  Replace () with "" and replace - with _
    featurecols$FeatureName <- gsub("-", "_", gsub("\\(\\)", "", featurecols$FeatureName))
    ## End of Step 1 ##
    
    ## Step 2 ##
    # Read test data
    testx <- readAndCombine("test\\X_test.txt", "test\\subject_test.txt", "test\\y_test.txt", featurecols)
    ## End of Step 2 ##
    
    ## Step 3 ##
    # Read training data
    trainx <- readAndCombine("train\\X_train.txt", "train\\subject_train.txt", "train\\y_train.txt", featurecols)
    ## End of Step 3 ##
    
    ## Step 4 ##
    # Concatenate (merge) Training and Test datasets 
    combinedData <- rbind(testx, trainx)
    # Remove "uncombined" data from memory.
    rm("testx", "trainx")
    # Rename columns
    colnames(combinedData) <- c("SubjectID", "ActivityID", featurecols$FeatureName)
    ## End of Step 4 ##
    
    ## Step 5 ##
    # Read activity labels file
    actLabel <- read.table("activity_labels.txt", col.names = c("ID", "Activity"))
    
    # Merge Activity label data with the feature-measurement data, remove ActivityID column
    combinedData <- merge(combinedData, actLabel, by.x = "ActivityID", by.y = "ID")[, -1]
    
    # Reorder columns
    combinedData <- combinedData[, c(1, 81, 2:80)]
    ## End of Step 5 ##
    
    ## Step 6 ##
    # Load dplyr and tidyr packages
    library(dplyr)
    library(tidyr)
    
    # Group data by SubjectID and Activity, 
    #    compute the mean for each feature, 
    #    convert "wide" form to "narrow" form, and
    #    sort by SubjectID, Activity, and Feature
    
    combinedData <- combinedData %>% group_by(SubjectID, Activity) %>% summarise_each("mean") %>% gather(Feature, Value, -c(SubjectID, Activity)) %>% arrange(SubjectID, Activity, Feature)
    
    # Write the final data
    write.table(combinedData, "tidydata.txt", sep = "\t", row.names = F)
    ## End of Step 6 ##
}

# Function readAndCombine takes 4 arguments
# 1:3 - Paths of feature-measurement, subject, and activity files, respectively
# 4   - Dataframe containing the columns required in the output

# The function reads the files, removes unneeded columns from feature-measurement data,
# combines subject, activity, and feature-measurement data and returns the combined data
readAndCombine <- function(featurePath, subjectPath, activityPath, featurecols)
{
    # Explicitly specify column classes to make read faster.
    colCls <- rep("numeric", 561)
    
    # Read feature data
    meas <- read.table(featurePath, sep = "", colClasses = colCls)
    
    # Remove all columns except mean and std columns
    meas <- meas[, featurecols[,"ColIndex"]]
    
    # Read subject data
    sub <- read.table(subjectPath)
    
    # Read activity data
    activity <- read.table(activityPath)
    
    # Combine the above three datasets and assign the result back to meas
    # First column in the resulting data frame is Subject ID, followed by activity ID, followed by feature-measurements
    meas <- cbind(sub, activity, meas)
    
    meas
}
