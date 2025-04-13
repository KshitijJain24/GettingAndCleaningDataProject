
---

## 📘 `CodeBook.md`

```markdown
# CodeBook

This code book summarizes the tidy dataset created for the Getting and Cleaning Data course project.

## Source Data

The original data was collected from the accelerometers of the Samsung Galaxy S smartphone and is available from:

[UCI HAR Dataset](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

## Data Files Used

- `train/X_train.txt`, `train/y_train.txt`, `train/subject_train.txt`
- `test/X_test.txt`, `test/y_test.txt`, `test/subject_test.txt`
- `features.txt`
- `activity_labels.txt`

## Transformations Performed

1. **Merged** training and test datasets using `rbind()`.
2. **Extracted** only the measurements on the mean and standard deviation using `grep("mean\\(\\)|std\\(\\)")`.
3. **Used descriptive activity names** by joining with `activity_labels.txt`.
4. **Labeled** the dataset with descriptive variable names:
   - `t` and `f` prefixes were expanded to `Time` and `Frequency`.
   - `Acc`, `Gyro`, `Mag` renamed to `Accelerometer`, `Gyroscope`, `Magnitude`.
   - `mean()` and `std()` renamed to `Mean` and `STD`.
5. **Created a tidy dataset** with the average of each variable for each activity and each subject using `group_by()` and `summarise_all()`.

## Variables in Final Tidy Data Set

The tidy dataset contains the following variables:

- `subject`: The ID of the subject (1 to 30)
- `activity`: Descriptive activity name (WALKING, WALKING_UPSTAIRS, etc.)
- For each measurement, the average value across each activity and subject, e.g.:
  - `TimeBodyAccelerometerMeanX`
  - `TimeBodyAccelerometerMeanY`
  - `TimeBodyAccelerometerSTDZ`
  - `FrequencyBodyGyroscopeMeanX`
  - etc.

There are 180 rows (30 subjects × 6 activities), and 68 columns (1 subject + 1 activity + 66 features).
# Extract mean and standard deviation measurements
mean_std_columns <- grep("mean|std", features$V2)
X <- X[, mean_std_columns]
