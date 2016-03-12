#Downloading the training sets
dataUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
temp <- tempfile()
download.file(dataUrl, temp, method = "curl")
tempDir <- tempdir()
unzip(temp, exdir = tempDir)
unlink(temp)

# Load the data sets
subdir <- "UCI\ HAR\ Dataset"
subjectsTrain = read.table(paste(tempDir, subdir, "train", "subject_train.txt", sep = "/"))
data2Train = read.table(paste(tempDir, subdir, "train", "X_train.txt", sep = "/"))
data3Train = read.table(paste(tempDir, subdir, "train", "y_train.txt", sep = "/"))

subjectsTest = read.table(paste(tempDir, subdir, "test", "subject_test.txt", sep = "/"))
data2Test = read.table(paste(tempDir, subdir, "test", "X_test.txt", sep = "/"))
data3Test = read.table(paste(tempDir, subdir, "test", "y_test.txt", sep = "/"))

# Merging the training and the test sets to create one data set.
subjects <- rbind(subjectsTrain, subjectsTest)
data2 <- rbind(data2Train, data2Test)
data3 <- rbind(data3Train, data3Test)

featureLabelNames = read.table(paste(tempDir, subdir, "features.txt", sep = "/"), row.names = 1)
names(data2) = featureLabelNames[,1]

# Extracting only the measurements on the mean and standard deviation for each measurement.
meanStdData <- data2[, grepl("-mean\\(\\)|-std\\(\\)", names(data2))]

# Using descriptive activity names to name the activities in the data set
activityLabelNames = read.table(paste(tempDir, subdir, "activity_labels.txt", sep = "/"))
activities <- merge(data3, labelNames, by = 1)[,2]

# Appropriately labelling the data set with descriptive variable names.
data <- cbind(Subjects = subjects$V1, Activities = activities, meanStdData)

# From the data set in step 4, creating a second, independent tidy data set
# with the average of each variable for each activity and each subject.
tidyData <- aggregate(data[, 3:ncol(data)], list(data$Subjects, data$Activities), mean)
names(tidyData) = sub("^", "average-", names(tidyData))
names(tidyData)[1:2]<- c("Subject", "Activity")

# Saving new data into a file.
write.table(tidyData, file="tidy_data.txt", row.name=FALSE)
