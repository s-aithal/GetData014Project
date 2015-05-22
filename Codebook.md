#Codebook

The "tidydata.txt" file uploaded to Courseara website as a response to course project contains summarized and transformed data obtained from "Human Activity Recognition Using Smartphones" data set present in the machine learning repository of UCI. This codebook briefly describes the original data and the transformations applied to the original data.

The original data was collected by conducting an experiment involving 30 subjects. Each subject had a smartphone and performed six different activities. The accelerometer and gyroscope present in the smartphone captured linear accelaration and angular velocity in 3-dimensions. The data thus collected were processed to obtain 561 features in time and frequency domains, which were then split into two disjoint sets: training and test. Each set contains three files of interest: 

1. Actual measurements (containing 561 features)
2. Subject that generated each measurement
3. Activity pertaining to each measurement

The data obtained from UCI machine learning repository were subject to several transformations as described below.

1. The three files-of-interest in training were combined such that each row contains the subject, the activity, and the values of 561 features. The process was repeated for test data.
2. In the data obtained from the previous step only the features pertaining to mean and standard deviation were retained and the rest were removed.
3. The data were combined to form a single data set.
4. The data were then summarized to compute average of each feature, grouped by subject and activity, which resulted in one row for each subject-activity combination.
5. The data from the previous step is in "wide form" in the sense that each feature is in its own column. This was then transformed to a "feature name"-"value" pair, such that output contains only four columns: Subject, Activity, Feature, Value

##tidydata.txt
This file contains transformed data from "Human Activity Recognition Using Smartphones" dataset. It contains four columns:

1. SubjectID: ID of the subject that generated the data. Value ranges from 1 to 30
2. Activity: Activity during which the data was generated. Contains six distinct values: WALKING, WALKING\_UPSTAIRS, WALKING\_DOWNSTAIRS, SITTING, STANDING, LAYING
3. Feature: Name of the feature in time and frequency domain
4. Value: Average value of the feature for the given subject and activity