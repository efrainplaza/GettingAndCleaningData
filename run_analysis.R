## This script reads and merges data to create a Tidy Dataset
##Libraries
library(dplyr)
# Load data for test sets
setwd("C:/Data/R/Getting and Creating Data Week4/Week 4 Final Project/UCI HAR Dataset/test")
test_set <- read.csv("X_test.txt", sep = "",header = FALSE)
test_keys_set <- read.csv("y_test.txt", sep = "", header = FALSE)
test_subject_set <- read.csv("subject_test.txt", sep = "", header = FALSE )
dim(test_set)
dim(test_keys_set)
# Load data for train sets
setwd("C:/Data/R/Getting and Creating Data Week4/Week 4 Final Project/UCI HAR Dataset/train")
train_set <- read.csv("X_train.txt", sep = "",header = FALSE)
train_keys_set <- read.csv("y_train.txt", sep = "", header = FALSE)
train_subject_set <- read.csv("subject_train.txt", sep = "", header = FALSE)


# Assign each row of TEST set to the Activity performed and the Subject that performed it
test_set_act_key <- cbind(test_keys_set,test_set)
test_set_act_subject <- cbind(test_subject_set,test_set_act_key)
##View(test_set_act_subject)

# Assign each row of TRAIN set to the Activity performed and the Subject that performed it
train_set_act_key <- cbind(train_keys_set,train_set)
train_set_act_subject <- cbind(train_subject_set,train_set_act_key)
##View(train_set_act_subject)

# Load the Features and tag all columns
setwd("C:/Data/R/Getting and Creating Data Week4/Week 4 Final Project/UCI HAR Dataset")
features <- read.csv("features.txt", sep = "",header = FALSE, stringsAsFactors = FALSE)
features_line <- features$V2
features_add <- c("subject","activities",features_line)
names(test_set_act_subject) <- features_add
names(train_set_act_subject) <- features_add

#Load the Activities Labels 
activit_label <- read.csv("activity_labels.txt", sep = "",header = FALSE, stringsAsFactors = FALSE)

# Merge the test and train datasets
merged_data <- rbind(test_set_act_subject,train_set_act_subject)
dim(merged_data)
#Tag data with activities Descriptions (i.e. Walking, Standing, etd) 
merged_w_activ <- merge(merged_data,activit_label,by.x = "activities", by.y = "V1", all = TRUE)
#Choose only the MEAN and STD from the Dataset
match_mean_std <- grep("[Mm]ean|[Ss]td",names(merged_w_activ))
merged_data <- merged_w_activ[c(564,2,match_mean_std)]
names(merged_data)[1] <- "Activity"
##head(merged_data[1:5,])
merged_group <- group_by(merged_data, Activity, subject)

# Last group created calculating mean by Activity and subject
tidy_data <- summarise_all(merged_group,funs(mean)) 
setwd("C:/Data/R/Getting and Creating Data Week4/Week 4 Final Project")
##write.csv(tidy_data, file = "last_tidy.csv")
write.table(tidy_data, "tidy.txt", row.names = FALSE,sep="\t")
