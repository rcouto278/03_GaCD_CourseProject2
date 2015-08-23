library(dplyr)

# Reading the data frames from the "UCI HAR Dataset"" folder.

features <- read.table("UCI HAR Dataset/features.txt")
train <- read.table("UCI HAR Dataset//train//X_train.txt")
test <- read.table("UCI HAR Dataset//test//X_test.txt")

# 1. Merges the training and the test sets to create one data set.

total <- rbind(train, test)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

feature <- read.table("UCI HAR Dataset/features.txt")
meanstdcols <- grep("mean|std", feature$V2)
total <- total[, meanstdcols]
names(total) <- feature$V2[meanstdcols]

# 3. Uses descriptive activity names to name the activities in the data set

train.y <- read.table("UCI HAR Dataset//train//y_train.txt")
train <- cbind(train.y, train)
test.y <- read.table("UCI HAR Dataset//test//y_test.txt")
test <- cbind(test.y, test)

total.y <- rbind(train.y, test.y)

activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
total.y <- merge(activity_labels, total.y)
total <- cbind(total.y$V2, total)
colnames(total)[1] <- "activity"

test.s <- read.table("UCI HAR Dataset//test//subject_test.txt")
train.s <- read.table("UCI HAR Dataset//train//subject_train.txt")
total.s <- rbind(train.s, test.s)
total <- cbind(total.s, total)
colnames(total)[1] <- "subject"


# 4. Appropriately labels the data set with descriptive variable names. 

# Done in 2 with the names function call.

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

tidy_dataset <- total %>% group_by(activity, subject) %>% summarise_each(funs(mean))

write.table(tidy_dataset, file = "tidy_dataset.txt", row.names = FALSE)
