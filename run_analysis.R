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
names(datatest)[1:2] <- c("subject","exercise")

## Merge Train Set Data into a dataframe. Same thing as above.

X_train <- read.table("/Users/Jeff/Desktop/Summer2014/CleaningData/UCI HAR DATASET/train/X_train.txt")
names(X_train) <- read.table("/Users/Jeff/Desktop/Summer2014/CleaningData/UCI HAR DATASET/features.txt")[,2]
datatrain <- cbind(read.table("/Users/Jeff/Desktop/Summer2014/CleaningData/UCI HAR DATASET/train/subject_train.txt"),
                  read.table("/Users/Jeff/Desktop/Summer2014/CleaningData/UCI HAR DATASET/train/y_train.txt"),
                  X_train)
names(datatrain)[1:2] <- c("subject","exercise")

## Combine Train and Test Sets by stacking their rows.
## Easy enough, since the datasets have the same variables.

alldata <- rbind(datatrain,datatest)

## Relabel Exercise variables

alldata$exercise[alldata$exercise==1] = "WALKING"
alldata$exercise[alldata$exercise==2] = "WALKING_UPSTAIRS"
alldata$exercise[alldata$exercise==3] = "WALKING_DOWNSTAIRS"
alldata$exercise[alldata$exercise==4] = "SITTING"
alldata$exercise[alldata$exercise==5] = "STANDING"
alldata$exercise[alldata$exercise==6] = "LAYING"

## Extract data pertaining only to means and std deviations

data_means_std <- alldata[,grep("subject|exercise|mean|std", names(alldata))]

## Create new data frame with summary data only using "dplyr" package

library(dplyr)
data_tbl <- tbl_df(data_means_std) # creates a 'tbl' for use by dplyr commands
by_subject_exercise <- group_by(data_tbl, subject, exercise) # groups data into categories by subject # and exercise 
tidydata <- summarise_each(by_subject_exercise, funs(mean)) # puts the mean of each variable for each combo of subject # and exercise into a new 'tbl'

## Write Text File to save the tidydata we created! It has the means of each variable for every combination of subject # and exercise.
write.table(tidydata, file = "/Users/Jeff/Desktop/tidydata.txt",row.name=FALSE)
