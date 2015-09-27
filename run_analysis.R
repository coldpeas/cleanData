##read data
testSet<-read.table("test/X_test.txt")
testLabels<-read.table("test/y_test.txt")
subjectTest<-read.table("test/subject_test.txt")

trainingSet<-read.table("train/X_train.txt")
trainingLabels<-read.table("train/y_train.txt")
subjectTrain<-read.table("train/subject_train.txt")

##step 1: Merges the training and the test sets to create one data set.

##combine label data
label<-rbind(testLabels,trainingLabels)
names(label)<-"label"

##combine subject data
subject<-rbind(subjectTest,subjectTrain)
names(subject)<-"subject"

##combine features data
## use the data in features.txt to give column names 
## to the combined data
set<-rbind(testSet,trainingSet)
features<-read.table("features.txt")

##Uses descriptive activity names 
##to name the activities in the data set
setnames(set,names(set),as.character(features$V2))

#combine all into one dataset
all<-cbind(set,label,subject)

##Step2: Extracts only the measurements on the mean and 
##standard deviation for each measurement. 
pickFeatures<-as.character(features$V2[grep("mean\\(\\)|std\\(\\)", features$V2)])
filterData<-subset(all,select=c(pickFeatures,"subject","label"))

##setp 4: Labels the data set with descriptive variable names
names(filterData)<-gsub("Acc", "Accelerometer", names(filterData))
names(filterData)<-gsub("BodyBody", "Body", names(filterData))
names(filterData)<-gsub("^f", "frequency", names(filterData))
names(filterData)<-gsub("Gyro", "Gyroscope", names(filterData))
names(filterData)<-gsub("Mag", "Magnitude", names(filterData))
names(filterData)<-gsub("^t", "time", names(filterData))

##step5: From the data set in step 4, creates a second, independent 
##tidy data set with the average of each variable 
##for each activity and each subject.
library(plyr)
filterData2<-aggregate(. ~label+subject, filterData, mean)
write.table(filterData2, file = "tidydata.txt",row.name=FALSE)
