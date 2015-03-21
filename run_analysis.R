#read the datasets accordingly:
library(dplyr)
library(plyr)
library(reshape2)
x_train<-read.table("UCI HAR Dataset/train/X_train.txt")
x_test<-read.table("UCI HAR Dataset/test/X_test.txt")
subject_train<-read.table("UCI HAR Dataset/train/subject_train.txt")
subject_test<-read.table("UCI HAR Dataset/test/subject_test.txt")
x_features<-read.table("UCI HAR Dataset/features.txt")
activity_train<-read.table("UCI HAR Dataset/train/y_train.txt")
activity_test<-read.table("UCI HAR Dataset/test/y_test.txt")
activity_label<-read.table("UCI HAR Dataset/activity_labels.txt")


#firstly combine the columns of x_train with subject_train. subject_train should be the first column.so
x1<-cbind(subject_train,activity_train)
x_train<-cbind(x1,x_train)
 #binded the activity train column in the dataframe.

x2<-cbind(subject_test,activity_test)

x_test<-cbind(x2,x_test)


#now combine the two dataframes by rbind:
mdf_test_train<-rbind(x_train,x_test)

#now we have a merged dataframe. with both test and train datasets combined.
#now is the time to formulate the regular expression to find out mean() and std() in our  dataframe.
regms<-"mean\\(\\)|std\\(\\)"
col_mean_std<-grep(regms,x_features$V2)
#now this is used to subset the dataframe.

col_mean_std_a<-col_mean_std+2
mdf_test_train<-mdf_test_train[,c(1,2,col_mean_std_a)]

mdf_test_train$V1.1<-as.character(mdf_test_train$V1.1)
i<-1
al<-activity_label$V2
al<-as.character(al)

while(i<=6){
  mdf_test_train[which(mdf_test_train$V1.1==i),"V1.1"]<-al[i]
  i=i+1
}

#now so far you have selected the required columns in the merged dataframe. now is the time to name them because

flist_a<-x_features$V2 #picked 561 feature list.
flist<-as.character(flist_a)

req_col<-flist[col_mean_std] #picking those which have mean/std in their names. as per the defined regexp before.
req_col<-c("subject","activity",req_col) #concatenated subject before it.
names(mdf_test_train)<-req_col
#now is the turn to make the column names more descriptive.
names_mdf<-names(mdf_test_train)
col_mean_std1<-gsub("[()]","",names_mdf)# remove () first
col_mean_std2<-gsub("-","",col_mean_std1) #remove the - in the names.
col_mean_std2<-gsub("^f","frequency",col_mean_std2)
col_mean_std2<-gsub("^t","time",col_mean_std2)
col_mean_std2<-gsub("Acc","Accelerometer",col_mean_std2)
col_mean_std2<-gsub("Gyro","Gyroscope",col_mean_std2)
col_mean_std2<-gsub("mean","Mean",col_mean_std2)
col_mean_std2<-gsub("std","Std",col_mean_std2)

#now rename the columns again.
names(mdf_test_train)<-col_mean_std2

#now  implementing the 5th part of assignment i.e. tidy data set
m2<-mdf_test_train
m2$subject<-as.factor(m2$subject)
mlist<-split(m2,m2$subject)

n1<-names(m2)
n2<-n1[c(-1,-2)]

j1<-lapply(mlist, function(x){
  
  melt2<-melt(x,id="activity",measure.vars=n2)
  dc1<-dcast(melt2,activity~variable,mean)
  dc1
})


d1<-data.frame()

i=1
while(i<=30){
  d1<-rbind(d1,j1[[i]])
  i=i+1
} 
l5<-list()
i3<-1
while(i3<=30){
  l5[[i3]]<-rep(i3,6)
  i3=i3+1
}
ul5<-unlist(l5)


tidy_dataset<-cbind(ul5,d1)
names(tidy_dataset)[1]<-"subject"
tidy_dataset