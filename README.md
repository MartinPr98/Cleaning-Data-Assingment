# Cleaning-Data-Assingment
**Explanation of the code**


#### Firstly, I set up the working directories, so I do not have to specify the full path to the folder later**
train_path <- "/home/rstudio/Cleaning Data Assingement/UCI HAR Dataset/train"
test_path <- "/home/rstudio/Cleaning Data Assingement/UCI HAR Dataset/test"
feature_names <- "/home/rstudio/Cleaning Data Assingement/UCI HAR Dataset"
activity_labels <- "/home/rstudio/Cleaning Data Assingement/UCI HAR Dataset"

#### Then I read all the necessary files/data

###### Reading the test data
subject_train <- read.table(file.path(train_path, "subject_train.txt"))
x_train <- read.table(file.path(train_path, "X_train.txt"))
y_train <- read.table(file.path(train_path, "y_train.txt"))

###### Reading the test data
subject_test <- read.table(file.path(test_path, "subject_test.txt"))
x_test <- read.table(file.path(test_path, "X_test.txt"))
y_test <- read.table(file.path(test_path, "y_test.txt"))

###### Reading the features names
feature_names <- read.table(file.path(feature_names, "features.txt"))[, 2]

###### Reading the activity labels
activity_names <- read.table(file.path(activity_labels, "activity_labels.txt"), header = FALSE, col.names = c("Activity", "Activity_names"))

#### After reading the datasets, firstly, I merge all the files (columns) for training and test data data using cbind

###### Merging the columns for both datasets
train_data <- cbind(subject_train, y_train, x_train)
test_data <- cbind(subject_test, y_test, x_test)

#### After creating independent train and test datasets I merge them together, so I create a one dataset that includes training and test data. I only select the columns Subject, Activity and columns including "mean" and "std" as described in a assingment

###### Merging the train and test datasets
merged_data <- rbind(train_data, test_data)
colnames(merged_data) <- c("Subject", "Activity", feature_names)
tidy_data <- merged_data[, grep("mean|std|Subject|Activity", names(merged_data))]

###### Labeling the data set with descriptive variable names
names(tidy_data) <- gsub("^t", "Time", names(tidy_data))
names(tidy_data)<- gsub("^f", "Frequency", names(tidy_data))
names(tidy_data) <- gsub("Acc", "Accelerometer", names(tidy_data))
names(tidy_data) <- gsub("Gyro", "Gyroscope", names(tidy_data))
names(tidy_data)<- gsub("BodyBody", "Body", names(tidy_data))
names(tidy_data) <- gsub("Mag", "Magnitude", names(tidy_data))
              
library(dplyr)
tidy_data <- tidy_data %>%
mutate(Activity = case_when(
    Activity == 1 ~ "WALKING",
    Activity == 2 ~ "WALKING_UPSTAIRS",
    Activity == 3 ~ "WALKING_DOWNSTAIRS",
    Activity == 4 ~ "SITTING",
    Activity == 5 ~ "STANDING",
    Activity == 6 ~ "LAYING")
    )

###### Selecting columns for mean calculation
columns_to_average <- names(tidy_data)[3:81]

###### Creating a subset that calculates the mean for specified variables
final_data <- tidy_data %>%
  group_by(Subject, Activity) %>%
  summarise(across(all_of(columns_to_average), mean, na.rm = TRUE))
