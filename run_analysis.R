# run_analysis.R

# Load required packages
library(dplyr)

# 1. Download and unzip the dataset if it hasn't been already
filename <- "UCI HAR Dataset"

if (!file.exists(filename)) {
  zip_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(zip_url, destfile = "dataset.zip", method = "curl")
  unzip("dataset.zip")
}

# 2. Read data
features <- read.table(file.path(filename, "features.txt"), col.names = c("index", "feature"))
activities <- read.table(file.path(filename, "activity_labels.txt"), col.names = c("code", "activity"))

# Training data
x_train <- read.table(file.path(filename, "train/X_train.txt"))
y_train <- read.table(file.path(filename, "train/y_train.txt"), col.names = "activity_code")
subject_train <- read.table(file.path(filename, "train/subject_train.txt"), col.names = "subject")

# Test data
x_test <- read.table(file.path(filename, "test/X_test.txt"))
y_test <- read.table(file.path(filename, "test/y_test.txt"), col.names = "activity_code")
subject_test <- read.table(file.path(filename, "test/subject_test.txt"), col.names = "subject")

# 3. Merge the training and test sets
x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
subject_data <- rbind(subject_train, subject_test)

# 4. Assign feature names to columns
colnames(x_data) <- features$feature

# 5. Extract only the measurements on the mean and standard deviation
mean_std_cols <- grep("mean\\(\\)|std\\(\\)", features$feature)
x_data <- x_data[, mean_std_cols]

# 6. Use descriptive activity names
y_data$activity <- activities[y_data$activity_code, 2]

# 7. Label the dataset with descriptive variable names
names(x_data) <- gsub("^t", "Time", names(x_data))
names(x_data) <- gsub("^f", "Frequency", names(x_data))
names(x_data) <- gsub("Acc", "Accelerometer", names(x_data))
names(x_data) <- gsub("Gyro", "Gyroscope", names(x_data))
names(x_data) <- gsub("Mag", "Magnitude", names(x_data))
names(x_data) <- gsub("-mean\\(\\)", "Mean", names(x_data), ignore.case = TRUE)
names(x_data) <- gsub("-std\\(\\)", "STD", names(x_data), ignore.case = TRUE)
names(x_data) <- gsub("[\\(\\)-]", "", names(x_data))

# 8. Combine data into one tidy dataset
tidy_data <- cbind(subject_data, activity = y_data$activity, x_data)

# 9. Create a second tidy data set with the average of each variable for each activity and subject
tidy_summary <- tidy_data %>%
  group_by(subject, activity) %>%
  summarise_all(mean)

# 10. Save the tidy dataset
write.table(tidy_summary, "tidy_data.txt", row.names = FALSE)
