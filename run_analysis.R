setwd("D:/WY/DataScience/DataCleaning_Assignment/UCI HAR Dataset/")

# load test data
act.data.test <- read.table("test/Y_test.txt", header=FALSE)
sub.data.test <- read.table("test/subject_test.txt", header=FALSE)
feat.data.test <- read.table("test/X_test.txt", header=FALSE)

act.data.train <- read.table("train/Y_train.txt", header=FALSE)
sub.data.train <- read.table("train/subject_train.txt", header=FALSE)
feat.data.train <- read.table("train/X_train.txt", header=FALSE)

test.data <- cbind(cbind(feat.data.test, sub.data.test), act.data.test)
train.data <- cbind(cbind(feat.data.train, sub.data.train), act.data.train)

merged.data <- rbind(test.data, train.data)

feat.data <- read.table("features.txt", header=FALSE)
meanStdInd <- feat.data[grep("mean\\b|std\\b", feat.data$V2), 1:2]

ColIncl <- c(meanStdInd[,1], ncol(merged.data)-1, ncol(merged.data))

filter.data <- merged.data[,ColIncl]
filter.data <- setNames(filter.data, c(as.character(meanStdInd[,2]), "subject", "activity_names"))

# load activity labels
act.labels <- read.table("activity_labels.txt")
act.labels[,2] <- as.character(act.labels[,2])

# Clean data
clean.data <- filter.data
clean.data$activity_names <- act.labels[match(clean.data$activity_names, act.labels[,1]),2]

end.col <- ncol(clean.data)-2
new.clean.data <- aggregate(as.matrix(clean.data[,1:end.col])~ subject + activity_names, clean.data, mean)
new.clean.data