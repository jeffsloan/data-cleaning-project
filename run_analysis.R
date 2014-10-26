## My approach is weird but works! I merge the associated data for both test and train sets individually,
## adding the variable names, adding the exercise and subject associated with each observation.
## I do this to create stackable dataframes. Then, I stack them!
## Next, I pull out the data that has "mean" or "std" in the variable name.
## Finally, I create our "tidydata" set using the dplyr package. If you haven't checked out the dplyr package,
## give a try through swirl! It saves so much headache.

## Merge Test Set Data into a dataframe, adding names to the variables,
## assigning exercise and subject to each observation.

X_test <- read.table("/Users/Jeff/Desktop/Summer2014/CleaningData/UCI HAR DATASET/test/X_test.txt")
names(X_test) <- read.table("/Users/Jeff/Desktop/Summer2014/CleaningData/UCI HAR DATASET/features.txt")[,2]
datatest <- cbind(read.table("/Users/Jeff/Desktop/Summer2014/CleaningData/UCI HAR DATASET/test/subject_test.txt"),
                  read.table("/Users/Jeff/Desktop/Summer2014/CleaningData/UCI HAR DATASET/test/y_test.txt"),
                  X_test)
names(datatest)[1:2] <- c("subject","activity")

## Merge Train Set Data into a dataframe. Same thing as above.

X_train <- read.table("/Users/Jeff/Desktop/Summer2014/CleaningData/UCI HAR DATASET/train/X_train.txt")
names(X_train) <- read.table("/Users/Jeff/Desktop/Summer2014/CleaningData/UCI HAR DATASET/features.txt")[,2]
datatrain <- cbind(read.table("/Users/Jeff/Desktop/Summer2014/CleaningData/UCI HAR DATASET/train/subject_train.txt"),
                  read.table("/Users/Jeff/Desktop/Summer2014/CleaningData/UCI HAR DATASET/train/y_train.txt"),
                  X_train)
names(datatrain)[1:2] <- c("subject","activity")

## Combine Train and Test Sets by stacking their rows.
## Easy enough, since the datasets have the same variables.

alldata <- rbind(datatrain,datatest)

## Relabel activity variables

alldata$activity[alldata$activity==1] = "WALKING"
alldata$activity[alldata$activity==2] = "WALKING_UPSTAIRS"
alldata$activity[alldata$activity==3] = "WALKING_DOWNSTAIRS"
alldata$activity[alldata$activity==4] = "SITTING"
alldata$activity[alldata$activity==5] = "STANDING"
alldata$activity[alldata$activity==6] = "LAYING"

## Extract data pertaining only to means and std deviations

data_means_std <- alldata[,grep("subject|activity|mean|std", names(alldata))]

## Create new data frame with summary data only using "dplyr" package

library(dplyr)
data_tbl <- tbl_df(data_means_std) # creates a 'tbl' for use by dplyr commands
by_subject_activity <- group_by(data_tbl, subject, activity) # groups data into categories by subject # and activity 
tidydata <- summarise_each(by_subject_activity, funs(mean)) # puts the mean of each combo of subject # and activity into a new 'tbl'

## Write Text File with the tidydata
write.table(tidydata, file = "/Users/Jeff/Desktop/tidydata.txt",row.name=FALSE)
