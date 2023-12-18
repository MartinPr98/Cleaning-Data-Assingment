# Setting up the working directories, so I do not have to specify the full path to the folder later
train_path <- "/home/rstudio/Cleaning Data Assingement/UCI HAR Dataset/train"
test_path <- "/home/rstudio/Cleaning Data Assingement/UCI HAR Dataset/test"
feature_names <- "/home/rstudio/Cleaning Data Assingement/UCI HAR Dataset"
activity_labels <- "/home/rstudio/Cleaning Data Assingement/UCI HAR Dataset"

# Reading the training data
subject_train <- read.table(file.path(train_path, "subject_train.txt"))
x_train <- read.table(file.path(train_path, "X_train.txt"))
y_train <- read.table(file.path(train_path, "y_train.txt"))

# Reading the test data
subject_test <- read.table(file.path(test_path, "subject_test.txt"))
x_test <- read.table(file.path(test_path, "X_test.txt"))
y_test <- read.table(file.path(test_path, "y_test.txt"))

# Reading the features names
feature_names <- read.table(file.path(feature_names, "features.txt"))[, 2]

# Reading the activity labels
activity_names <- read.table(file.path(activity_labels, "activity_labels.txt"), header = FALSE, col.names = c("Activity", "Activity_names"))

# Merging the columns for both datasets
train_data <- cbind(subject_train, y_train, x_train)
test_data <- cbind(subject_test, y_test, x_test)

# Merging the train and test datasets
merged_data <- rbind(train_data, test_data)
colnames(merged_data) <- c("Subject", "Activity", feature_names)
mean_std_data <- merged_data[, grep("mean|std|Subject|Activity", names(merged_data))]

# Replacing numbers with descriptive categories in column "Activity"
installed.packages("dplyr")
library(dplyr)
mean_std_data <- mean_std_data %>%
  mutate(Activity = case_when(
    Activity == 1 ~ "WALKING",
    Activity == 2 ~ "WALKING_UPSTAIRS",
    Activity == 3 ~ "WALKING_DOWNSTAIRS",
    Activity == 4 ~ "SITTING",
    Activity == 5 ~ "STANDING",
    Activity == 6 ~ "LAYING")
  )

# Selecting only columns that I want to calculate the mean for
columns_to_average <- names(mean_std_data)[3:81]

# Creating a subset average_data that calculates the mean for variables specified in columns_to_average
average_data <- mean_std_data %>%
  group_by(Subject, Activity) %>%
  summarise(across(all_of(columns_to_average), mean, na.rm = TRUE))
