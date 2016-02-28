Read analysis script via downloaded data set by specifying the URL
Download and unzip data set
Read in features (e.g., names of features) and activities labels (i.e. actual names) text files
Read in training data as subject_train.txt <- this is the subject ID
Read in training data as X_train.txt <- this is the training sensor readouts for features
Use features$V2 with the colnames function to give features detailed names
Read in training data as y_train.txt <- this is the activity data
Combine all training into data frame using cbind
Repeat steps above with test data
Combine test and training data using rbind
Update numeric acitivity values with detailed descriptions found in activity_labels df
Locate features related to mean and std using grep
Sub-set combined data to select only features related to mean and std
Use ddply found in plyr package to create a tidy data set that summarizes the mean and std data by id and activity
Write tidy data to working directory