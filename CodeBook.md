# This Code book describes all the variables, the data, and any transformations or work that was performed during the analysis

##### Working Directories
train_path = path to the folder, where the train data are located
test_path = path to the folder, where the test data are located
feature_names = path to folder, where the feature_names data are located
activity_labels = path to folder, where the activity_labels data are located

##### Train Data
subject_train = reads the .txt file "subject_train" in a specified folder "train_path" using functioon read.table
x_train = reads the .txt file "x_train" in a specified folder "train_path" using functioon read.table
y_train = reads the .txt file "y_train" in a specified folder "train_path" using functioon read.table

##### Test Data
subject_test = reads the .txt file "subject_test" in a specified folder "train_path" using functioon read.table
x_test = reads the .txt file "x_test" in a specified folder "test_path" using functioon read.table
y_test = reads the .txt file "y_test" in a specified folder "test_path" using functioon read.table

##### Feature Names
feature_names = reads the .txt file "features" in a specified folder "feature_names" using functioon read.table

##### Activity Labels
activity_names = reads the .txt file "activity_labels" in a specified folder "activity_labels" using functioon read.table. Beacuse default .txt file does not have the heades for the columns, I added them separately --> "Activity" and "Activity_names"

##### Merging 
train_data = combines all the files for train data that which was read before with function "cbind" (column wise)
test_data  = combines all the files for test data that which was read before with function "cbind" (column wise)

##### Combining datasets
merged_data = includes train and test data, merging those two datasets row wise with function "rbind" 
colnames(merged_data) = Naming the columns in dataset merged_data ("Subject", "Activity", feature_names)
mean_std_data = extracting only columns containing mean and standard deviation

##### Replacing numbers with category names
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

###### Selecting columns for mean calculation
columns_to_average = extracts columns 3:81, so the calculation of mean works

###### Creating a subset that calculates the mean
average_data = subset for mean calculation, grouped by Subject and Activity columns

