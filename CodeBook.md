### This Code book describes all the variables, the data, and any transformations or work that was performed during the analysis

### Working Directories
train_path = path to the folder, where the train data are located
test_path = path to the folder, where the test data are located
feature_names = path to folder, where the feature_names data are located
activity_labels = path to folder, where the activity_labels data are located

### Train Data
subject_train = reads the .txt file "subject_train" in a specified folder "train_path" using functioon read.table
x_train = reads the .txt file "x_train" in a specified folder "train_path" using functioon read.table
y_train = reads the .txt file "y_train" in a specified folder "train_path" using functioon read.table

### Test Data
subject_test = reads the .txt file "subject_train" in a specified folder "train_path" using functioon read.table
x_test = reads the .txt file "x_test" in a specified folder "test_path" using functioon read.table
y_test = reads the .txt file "y_test" in a specified folder "test_path" using functioon read.table

# Reading the features names
feature_names <- read.table(file.path(feature_names, "features.txt"))[, 2]

# Reading the activity labels file, so I can left join in later for descriptive names to Activity 1-6
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

