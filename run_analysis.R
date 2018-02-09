
#ReadIn All the Data 

actlabel = read.table("../Downloads/Coursera/Data Science Specialization/GettingCleaningData/Project/UCI HAR Dataset/activity_labels.txt",stringsAsFactors = FALSE)
actlabel$V2 = as.character(actlabel$V2)

feature = read.table("../Downloads/Coursera/Data Science Specialization/GettingCleaningData/Project/UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)
feature$V2 = as.character(feature$V2)
keep_ind = grep(".*mean*|.*std.*",feature$V2)

# Clean up the Naming A little bit 
feature$V2[keep_ind] = gsub("-std$","StdDev",feature$V2[keep_ind])
feature$V2[keep_ind] = gsub("-mean","Mean",feature$V2[keep_ind])
feature$V2[keep_ind] = gsub("^(t)","Time",feature$V2[keep_ind])
feature$V2[keep_ind] = gsub("^(f)","Freq",feature$V2[keep_ind])
feature$V2[keep_ind] = gsub("[-()]","",feature$V2[keep_ind])
feature$V2[keep_ind] = gsub("^(Mag)","Magnitude",feature$V2[keep_ind])


df_train <- read.table("../Downloads/Coursera/Data Science Specialization/GettingCleaningData/Project/UCI HAR Dataset/train/X_train.txt",stringsAsFactors = FALSE)[keep_ind]
df_train_activity <- read.table("../Downloads/Coursera/Data Science Specialization/GettingCleaningData/Project/UCI HAR Dataset/train/y_train.txt",stringsAsFactors = FALSE)  
df_train_subject <- read.table("../Downloads/Coursera/Data Science Specialization/GettingCleaningData/Project/UCI HAR Dataset/train/subject_train.txt",stringsAsFactors = FALSE)  

df_test <- read.table("../Downloads/Coursera/Data Science Specialization/GettingCleaningData/Project/UCI HAR Dataset/test/X_test.txt",stringsAsFactors = FALSE)[keep_ind]
df_test_activity <- read.table("../Downloads/Coursera/Data Science Specialization/GettingCleaningData/Project/UCI HAR Dataset/test/y_test.txt",stringsAsFactors = FALSE)  
df_test_subject <- read.table("../Downloads/Coursera/Data Science Specialization/GettingCleaningData/Project/UCI HAR Dataset/test/subject_test.txt",stringsAsFactors = FALSE)  

# Put each of the test and train data tables together
train <- cbind(df_train, df_train_activity, df_train_subject)
test <- cbind(df_test, df_test_activity, df_test_subject)

# join test and train
joined <- rbind(test,train)
column_names = c("Subject_Train","Activity", feature$V2[keep_ind])
names(joined) = column_names



joined$Activity <- factor(joined$Activity, levels = actlabel[,1], labels = actlabel[,2])
joined$Subject_Train <- as.factor(joined$Subject_Train)

melt_data <- melt(joined, id = c("Subject_Train", "Activity"))
final_tidy_output <- dcast(melt_data, Subject_Train + Activity ~ variable, mean)



write.table(final_tidy_output, "../Downloads/Coursera/Data Science Specialization/GettingCleaningData/Project/tidydata.txt",row.names = FALSE, quote = FALSE)










