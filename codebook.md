---
title: "codebook.md"
author: "IRFAN ELAHI"
date: "Saturday, March 21, 2015"
output: html_document
---


Setup: We are provided with the training & test data-sets of Human Activity recognition using smartphone data-set. I was tasked to clean, reshape the data set and create a tidy dataset comprising of mean of each feature against each activity and subject.

Raw data: test & train subjects, features list, activity labels


Codebook: The Tidy data set is created by firstly combining the subject & activity columns in train and test data sets. Then the two were merged together (using rbind) to form one compact dataset. Then only those columns were extracted which corresponded to mean and standard deviation.
Then the activity field, which was initially numeric, was substituted with corresponding descriptive name. The data-set was then properly labelled using the features list provided. The names were further modified to become more clean and comply to the best practices (i.e. brackets,- were removed etc)

Then in the end a tidy data set is created. The first column of this data-set corresponds to subject. The subject column was transformed to appear consistent for corresponding data for each activity (i.e. for each measurement of mean of each activity, the subject column repeats to have the subject ID in it)
The activity column was transformed from numeric to character type and comprise of descriptive names.
All of the columns after subject, activity are summarized to compute of means of each activity. 
The units are unchanged for each of these columns. No other summarization is applied.

It is advised to follow README.md in the repo to understand how the script works.