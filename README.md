# GettingandCleaningData


1. Merges the training and the test sets to create one data set.
Before this part we read in every 
  This part of the analysis.R 
train <- cbind(df_train, df_train_activity, df_train_subject)
test <- cbind(df_test, df_test_activity, df_test_subject)
joined <- rbind(test,train)

2. Extracts only the measurements on the mean and standard deviation for each measurement.
In this line of code we are finding the indices that include the term "mean", "std" and the ".*"
means include all the terms that have something before or after the literal mean or std term.
keep_ind = grep(".*mean*|.*std.*",feature$V2)


3. Uses descriptive activity names to name the activities in the data set
In this section we have attempted to replace some of the obscure names with a bit more descriptive ones.
  replace_expr <- function(x,y,z) { gsub(x,y,z)}
- if the expression std is found, regardless of what it's preceded by it will be replaced by StdDev
  feature$V2[keep_ind] = sapply("-std",replace_expr,  y = "StdDev",z = feature$V2[keep_ind])

- if the expression mean is found, regardless of what it's preceded by it will be replaced by Mean
  feature$V2[keep_ind] = sapply("-mean",replace_expr,  y = "Mean",z = feature$V2[keep_ind])

- Any thing starting with t, will be replaced with Time
  feature$V2[keep_ind] = sapply("^(t)",replace_expr,  y = "Time",z = feature$V2[keep_ind])

- Any thing starting with f will be replaced with frequency
  feature$V2[keep_ind] = sapply("^(f)",replace_expr,  y = "Freq",z = feature$V2[keep_ind])

- This part any paranthesis will be replaced with nothing! basically omitted.
   feature$V2[keep_ind] = sapply("[-()]",replace_expr,  y = "",z = feature$V2[keep_ind])

4. Appropriately labels the data set with descriptive variable names.

  column_names = c("Subject_Train","Activity", feature$V2[keep_ind])
  names(joined) = column_names
  After joining test and train we assign the names we took from feature names we keep, from mean and standard deviation.


5. From the data set in step 4, creates a second, independent tidy data set with the average of each
    variable for each activity and each subject.
melt_data <- melt(joined, id = c("Subject_Train", "Activity"))
final_tidy_output <- dcast(melt_data, Subject_Train + Activity ~ variable, mean)

