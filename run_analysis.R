#Read labels
labels <- read.csv("UCI HAR Dataset/features.txt", sep="", header = FALSE)

##Traning
#Read traning data and assign labels
dataTrain <- read.csv("UCI HAR Dataset/train/X_train.txt", sep = "", header = FALSE, col.names = labels[,2])
#load and assign test subjects
testSubjects <- read.csv(file = "UCI HAR Dataset/train/subject_train.txt", sep = "", header = FALSE, col.names = "subject")
dataTrain$subject <- testSubjects[,1]
#load and assign traning type labels
traningType <- read.csv(file = "UCI HAR Dataset/train/y_train.txt", sep = "", header = FALSE, col.names = "label")
dataTrain$label <- traningType[,1]

##Test
#Read traning data and assign labels
dataTest <- read.csv("UCI HAR Dataset/test/X_test.txt", sep = "", header = FALSE, col.names = labels[,2])
#load and assign test subjects
testSubjects <- read.csv(file = "UCI HAR Dataset/test/subject_test.txt", sep = "", header = FALSE, col.names = "subject")
dataTest$subject <- testSubjects[,1]
#load and assign traning type labels
traningType <- read.csv(file = "UCI HAR Dataset/test/y_test.txt", sep = "", header = FALSE, col.names = "label")
dataTest$label <- traningType[,1]

##Clean
rm(testSubjects)
rm(traningType)

##Merge - add rows
names <- seq(from = nrow(dataTrain) + 1, length.out = nrow(dataTest))
rownames(dataTest) <- make.names(names, unique = TRUE)
names <- seq(from = nrow(dataTrain), length.out = nrow(dataTrain))
rownames(dataTrain) <- make.names(names, unique = TRUE)
data <- rbind(dataTrain, dataTest)

##Clean
rm(names)
rm(dataTest)
rm(dataTrain)
rm(labels)

##Data Frame in variable "data" is provided by asm1.R

#Build sequence of columns to extract
nseq <- c()
for(i in seq(as.integer(563 / 40))) { 
  nseq <- c(nseq, seq(from = ((i - 1) * 40 + 1), length.out = 6))
}

selectedData <- data[,c(nseq,562,563)]
selectedData$label <- as.character(selectedData$label)

#load activity labels
activityLabels <- read.csv(file = "UCI HAR Dataset/activity_labels.txt", header = FALSE, sep = "")
activityLabels$V2 <- as.character(activityLabels$V2)

#replace label numbers with names
apply(activityLabels, 1, function(row) {selectedData$label[selectedData$label == as.character(row[1])] <<- row[2]})

##Clean
rm(nseq)
rm(i)

##Calculate the average of each variable for each activity and each subject.
calculatedData <- selectedData[0,]
for(i in 1:30) {
  temp <- selectedData[selectedData$subject == i,]
  for(j in activityLabels$V2) {
    tempj <- temp[temp$label == j,]
    if(nrow(tempj) > 0) {
      tempj <- tempj[,1:84]
      tempj <- colMeans(x = tempj)
      tempj$label <- j; tempj$subject <- i;
      calculatedData <- rbind(calculatedData, tempj)
      calculatedData$label <- as.character(calculatedData$label)
    }
  }
}

##Save to file
write.table(x = calculatedData, file = "data.txt", sep = " ", row.names = FALSE)