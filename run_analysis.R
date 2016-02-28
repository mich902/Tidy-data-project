########
# Get and Clean data project
######
library(httr) 
library(plyr)

###########
# Prepare dataset for analysis: Retieve data from url and unzip
###########
###
# Download Data
###
setwd("~/Desktop/Data science Course/Get and Clean Data Project/Project Download Data")
data_url <- c("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip")
download.file(data_url, "project_dataset.zip", method = "curl")

##
# Unzip downloaded data set
# the unzip function applied to the zip file creates UCI HAR Dataset folder in 
# the current working directory
###
unzip("project_dataset.zip", list = FALSE, overwrite = TRUE)
###
# Read in features.txt
###
features <- read.table("~/Desktop/Data science Course/Get and Clean Data Project/Project Download Data/UCI HAR Dataset/features.txt", quote="\"")

###
# Read in activity_labels.txt
###
activity_labels <- read.table("~/Desktop/Data science Course/Get and Clean Data Project/Project Download Data/UCI HAR Dataset/activity_labels.txt", quote="\"")

###
# Prepare Train data
### 
train_X <- read.table("~/Desktop/Data science Course/Get and Clean Data Project/Project Download Data/UCI HAR Dataset/train/X_train.txt", quote="\"")
# Update to descriptive feature names
colnames(train_X) <- features$V2

# Read in the train subject id info
train_subject_id <- read.table("~/Desktop/Data science Course/Get and Clean Data Project/Project Download Data/UCI HAR Dataset/train/subject_train.txt", quote="\"")
# Read in the train activity info
train_y <- read.table("~/Desktop/Data science Course/Get and Clean Data Project/Project Download Data/UCI HAR Dataset/train/y_train.txt", quote="\"")

###
# Combine training data
###
data_train <- cbind(train_subject_id,
                    train_y,
                    train_X)
colnames(data_train)[c(1:2)] <- c("id", "activity")

###
# Prepare Test data
###
test_X <- read.table("~/Desktop/Data science Course/Get and Clean Data Project/Project Download Data/UCI HAR Dataset/test/X_test.txt", quote="\"")
# Update to descriptive feature names
colnames(test_X) <- features$V2

# Read in the test subject id info
test_subject_id <- read.table("~/Desktop/Data science Course/Get and Clean Data Project/Project Download Data/UCI HAR Dataset/test/subject_test.txt", quote="\"")
# Read in the test activity info
test_y <- read.table("~/Desktop/Data science Course/Get and Clean Data Project/Project Download Data/UCI HAR Dataset/test/y_test.txt", quote="\"")

###
# Combine test data
###
data_test <- cbind(test_subject_id,
                   test_y,
                   test_X)
colnames(data_test)[c(1:2)] <- c("id", "activity")

###
# Combine test and training data
###
data <- rbind(data_test, data_train)
data <- data[order(data$id, decreasing = F), ]
rownames(data) <- 1:nrow(data)

###
# Change activity to descriptive names
###
data$activity <- factor(data$activity, levels = activity_labels$V1, labels = activity_labels$V2)

###
# Determine features related to 'mean'
###
mean.features <- colnames(data)[grep("mean", colnames(data))]

### 
# Determine features related to 'std'
###
std.features <- colnames(data)[grep("std", colnames(data))]

###
# Generate dataset subset including id, activity and features related to 'mean' and 'std'
###
data_mean_std <- data[, colnames(data) %in% c("id", "activity", mean.features, std.features)]

###
# Generate Tidy data from only 'mean' and 'std' features
###
tidy_data <- ddply(data_mean_std, .variables = c("id", "activity"), .fun = function(x){colMeans(x[, -c(1:2)])})

###
# Output tidy data of mean and std only data
###
setwd("~/Desktop/Data science Course/Get and Clean Data Project/Project Output")
write.table(tidy_data, "Get and Clean Data Project Tidy data output.txt", row.names = F)



