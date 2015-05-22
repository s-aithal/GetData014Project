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
# *  Read the "features.txt" file to get a list of measurement names
# *  Prune the list to contain only the columns relating to mean and std of measurements
# *  Convert the measurement names to match variable naming convention of R
# Step 2:
# *  Combine test data, labels, and subject files.
# *  Retain only the measurement columns that contain mean and std values
# Step 3:
# *  Repeat the previous step with training data
# Step 4:
# *  Combine both test and training data to create one dataframe.
# *  Change column names to meaningful names
# Step 5:
# *  Read Activity label file
# *  Merge activity label file with the merged data to assign activity label to each measurement
# *  Remove ActivityID column from the data frame
# *  Rearrange columns such that SubjectID and Activity are followed by measurement columns
# Step 6:
# *  Group the data by SubjectID and Activity
# *  Compute mean for each measurement column
# *  Convert "wide format data" to "narrow format data" by converting measurement columns
#    to rows with name-value pair
# *  Order the data by SubjectID and Activity
# *  Write the data to "tidydata.txt" file
##################

runAnalysis <- function()
{
    ## Step 1##
    # Read features.txt and find out which columns contain mean and std.
    featurecols <- read.table("features.txt", sep = " ", stringsAsFactors = F)
    colnames(featurecols) <- c("ColIndex", "FeatureName")
    # Retain only the rows that contain "mean" and "std" measurements
    featurecols <- featurecols[grep("-mean|-std", featurecols$FeatureName, ignore.case = T),]
    # Rename measurement names to standard R variable syntax
    #  Replace () with "" and replace - with _
    featurecols$FeatureName <- gsub("-", "_", gsub("\\(\\)", "", featurecols$FeatureName))
    ## End of Step 1##
    
    ## Step 2##
    # Read test data
    testx <- readAndCombine("test\\X_test.txt", "test\\subject_test.txt", "test\\y_test.txt", featurecols)
    ## End of Step 2##
    
    ## Step 3##
    # Read training data
    trainx <- readAndCombine("train\\X_train.txt", "train\\subject_train.txt", "train\\y_train.txt", featurecols)
    ## End of Step 3##
    
    ## Step 4##
    # Concatenate (merge) Training and Test datasets 
    combinedData <- rbind(testx, trainx)
    rm("testx", "trainx")
    colnames(combinedData) <- c("SubjectID", "ActivityID", as.character(featurecols$FeatureName))
    ## End of Step 4##
    
    ## Step 5##
    # Read activity labels file
    actLabel <- read.table("activity_labels.txt", col.names = c("ID", "Activity"))
    
    # Merge Activity label data with the measurement data, remove ActivityID column
    combinedData <- merge(combinedData, actLabel, by.x = "ActivityID", by.y = "ID")[, -1]
    
    # Reorder columns
    combinedData <- combinedData[, c(1, 81, 2:80)]
    ## End of Step 5##
    
    ## Step 6##
    # Load dplyr and tidyr packages
    library(dplyr)
    library(tidyr)
    
    # Group data by SubjectID and Activity, 
    #    compute the mean for each measurement, convert "wide" form to "narrow" form, and
    #    sort by SubjectID and Activity
    
    combinedData <- combinedData %>% group_by(SubjectID, Activity) %>% summarise_each("mean") %>% gather(Feature, Value, -c(SubjectID, Activity)) %>% arrange(SubjectID, Activity, Feature)
    
    write.table(combinedData, "tidydata.txt", sep = "\t", row.names = F)
    ## End of Step 6##
}

# Function readAndCombine takes 4 arguments
# 1:3 - Paths of measurement, subject, and activity files, respectively
# 4   - Dataframe containing the columns required in the output

# The function reads the files, removes unneeded columns from measurement data,
# combines subject, activity, and measurement data and returns the combined data
readAndCombine <- function(measurementPath, subjectPath, activityPath, featurecols)
{
    # Explicitly specify column classes to make read faster.
    colCls <- rep("numeric", 561)
    
    # Read measurement data
    meas <- read.table(measurementPath, sep = "", colClasses = colCls)
    
    # Remove all columns except mean and std columns
    meas <- meas[, featurecols[,"ColIndex"]]
    
    # Read subject data
    sub <- read.table(subjectPath)
    
    # Read activity data
    activity <- read.table(activityPath)
    
    # Combine the above three datasets and assign the result back to meas
    # First column in the resulting data frame is Subject ID, followed by activity ID, followed by measurements
    meas <- cbind(sub, activity, meas)
    
    meas
}
