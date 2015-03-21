---
title: "README.md"
author: "IRFAN ELAHI"
date: "Saturday, March 21, 2015"
output: html_document
---

This is an R Markdown document for GETTING & CLEANING DATA (getdata-012) course's project. This markdown document is meant to explicate how the accompanying script (run_analysis.R) for producing the required tidy data set works.

Parts of Script:
----------------
The script is logically segmented into X parts/modules which are described as follows:
1. Loading the required packages in R
2. Reading & loading train & test data-sets in R
3. Reshaping the dataframe
4. Extracting the mean & std columns
5. Substituting descriptive activity names in the data frame
6. Lbeling the data frame appropriately
7. Creating tidy Dataset


### 1.Loading the Required Packages in R:
The script starts off by loading the following three packages in R:
1. dplyr
2. plyr
3. reshape2

to avoid discrepancy if the user hasn't already loaded them before running the script. The reason for loading these packages is basically because the script makes use of a number of functions from these packages. If these packages aren't loaded, the script is prone to generate errors.

## 2.Reading & Loading train & test data-sets in R:
The next logical step is to read the provided train and test data-sets in R. This part assumes that your working directory has UCI HAR Dataset folder present in it. It also assumes that the names of the files are intact and the user hasn't tempered it. Otherwise this script will generate errors. 
The scripts loads 8 files in R that will be used in reshaping the data frame & creating the tidy data-set.
<pre> <code>
x_train<-read.table("UCI HAR Dataset/train/X_train.txt")
x_test<-read.table("UCI HAR Dataset/test/X_test.txt")
subject_train<-read.table("UCI HAR Dataset/train/subject_train.txt")
subject_test<-read.table("UCI HAR Dataset/test/subject_test.txt")
x_features<-read.table("UCI HAR Dataset/features.txt")
activity_train<-read.table("UCI HAR Dataset/train/y_train.txt")
activity_test<-read.table("UCI HAR Dataset/test/y_test.txt")
activity_label<-read.table("UCI HAR Dataset/activity_labels.txt")
</code></pre>

## 3. Reshaping the Data-frame.
After all the raw data-sets are loaded in R, the script proceeds as follows:
1. It concatenates the subject_test & subject_train data-sets together by combining their columns (using cbind)
2. Then it concatenates the combined column in step-1 with the X_train.txt data-set thus forming a data-frame which has columns as follows: subjects, activity, features[1]...features[561]
3. The script does the same for train dataset.
4. At the end, to comply with the principles of tidy data set, i.e. each observation in each row and each variable in one column, the scripts combines the data frame in step-2 and step-3 using r-bind thus the upper portion of the data frame contains the train data set and the lower portion has test data set.

## 4. Extracting the mean & std columns
At this step, the script extracts the required columns out of the intially formed data frame that contains only mean & std values. The snippet of code for this task is as follows:
<pre><code>
regms<-"mean\\(\\)|std\\(\\)"
col_mean_std<-grep(regms,x_features$V2)
#now use this to subset the dataframe.
#mdf_test_train<-select(mdf_test_train,col_mean_std)
#^ may not be working thus try:
col_mean_std_a<-col_mean_std+2
mdf_test_train<-mdf_test_train[,c(1,2,col_mean_std_a)]
#till now, you have a data frame that has subject column + mean/std features.
mdf_test_train$V1.1<-as.character(mdf_test_train$V1.1)

</code></pre>

firstly, a regular expression is formed to select only those columns which have mean() or std() in their names.
Then using grep, such names are extracted out of the features.txt file (imported as features dataframe). 
As our dataframe's first two columns are subject & activity, so to subset the actual columns from our data frame, I added two to the output of grep. Then used that vector to subset the original dataframe. Now this extracted data frame contains subject, activity & those columns out of 561 feature variables which have mean() and std() in them.



## 5. Substituting descriptive activity names in the data frame
At this point, the data frame has numeric values in the activity column of the dataframe. Then the script proceeds with substituting those numeric variables with the descriptive variables:
<pre><code>


i<-1
al<-activity_label$V2
al<-as.character(al)
#k<-c(1,2,3,4,5,6)
while(i<=6){
  mdf_test_train[which(mdf_test_train$V1.1==i),"V1.1"]<-al[i]
  i=i+1
}
</code></pre>

firstly, the script fetches the names of activity labels from the activity_labels.txt file (imported as activity_labels dataframe) and stores it in al variable. Then using a loop, the script finds in the 2nd column of the dataframe (i.e. the activity column) for values that match from 1 to 6 and substitute the descriptive name accordingly and accurately.

## 6.Labeling the data frame appropriately
At this stage/phase, the script now turns to renaming the variable names or column names of the data frame. For that, the following code snippet is used:
<pre><code>
flist_a<-x_features$V2 #picked 561 feature list.
flist<-as.character(flist_a)
#flist<-c("subjects",as.character(flist_a)) #concatenated subject before the 562 list.
req_col<-flist[col_mean_std] #picking those which have mean/std in their names. as per the defined regexp before.
req_col<-c("subject","activity",req_col) #concatenated subject before it.
names(mdf_test_train)<-req_col
</code></pre>

Which firstly fetches all the features list from the features.txt file (imported as features dataframe), converts it as character (because initially its type is factor), then subsets it to select only those which has mean and std in it, adds "subject","activity" before that vector and then assigns that vector as "names" of the dataframe. Thus at this point, the dataframe has column names equivalent to the ones specified in features.txt.

The script then turns to making the variable names more appropriate to comply with the best practices. Thus the following series of expressions remove unnecessary characters from variable names:
<pre><code>
names_mdf<-names(mdf_test_train)
col_mean_std1<-gsub("[()]","",names_mdf)# removes ()
col_mean_std2<-gsub("-","",col_mean_std1) #removes -
col_mean_std2<-gsub("^f","frequency",col_mean_std2) #converts f at the start of names to frequency
col_mean_std2<-gsub("^t","time",col_mean_std2) #converts t at the start of names to time
col_mean_std2<-gsub("Acc","Accelerometer",col_mean_std2) #converts Acc to Accelerometer
col_mean_std2<-gsub("Gyro","Gyroscope",col_mean_std2) #converts Gyro to Gyroscope
col_mean_std2<-gsub("mean","Mean",col_mean_std2) #Makes the first letter of mean in names capital
col_mean_std2<-gsub("std","Std",col_mean_std2) #Makes the first letter of mean in names capital

#now rename the columns again.
names(mdf_test_train)<-col_mean_std2 #rename the dataframe with "clean" names.
</code></pre>
the comments in the above code explains what is being done by each statement.

## 7. Creating Tidy Data set:

Now, at the last step, the script creates the tidy data set. Firstly, it converts the "subject" column of the dataset into factors to be used in split function afterwards to split the dataframe based on "subjects"
<pre><code>
m2<-mdf_test_train
m2$subject<-as.factor(m2$subject)
mlist<-split(m2,m2$subject)
</code></pre>
at this point, we have a list of dataframes against each subject i.e. a list of 30 elements where each element is a list. 
The following code then uses lapply to iteratively melt and dcast each dataframe in the list to find out mean for each activity:
<pre><code>
n1<-names(m2)
n2<-n1[c(-1,-2)]

j1<-lapply(mlist, function(x){
  
  melt2<-melt(x,id="activity",measure.vars=n2)
  dc1<-dcast(melt2,activity~variable,mean)
  dc1
})

</code></pre>
#Xd1<-dc1[1] #picked first dataframe

Then to create the tidy data set, the script binds each dataframe in the list using rbind so that we may have each observation in individual row and each variable in individual column.
d1<-data.frame()
<pre><code>
i=1
while(i<=30){
  d1<-rbind(d1,j1[[i]])
  i=i+1
} 
</code></pre>
It makes sense to add subjects in the dataframe as well for which each  activity's mean is calculated. So this code generates a vector to be added as the first column of the dataframe.
<pre><code>
l5<-list()
i3<-1
while(i3<=30){
  l5[[i3]]<-rep(i3,6)
  i3=i3+1
}
ul5<-unlist(l5)



tidy_dataset<-cbind(ul5,d1)
names(tidy_dataset)[1]<-"subject"

</code></pre>
In the end, we have a tidy data set which has:
1. 180 observations (6 activities for 30 subjects)
2. First two columns are subject and activity respectively
3. Subsequent column comprise of mean of each activity for each subject.
4. The data set is properly labeled.