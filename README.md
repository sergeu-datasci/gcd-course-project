#Getting and Cleaning Data course project
This repo contains R scripts developed as a solution of [the programming assignment](https://class.coursera.org/getdata-014/human_grading/view/courses/973501/assessments/3) for the Coursera Getting and Cleaning Data course project.

##Prerequisites
1. Download `run_analysis.R` into your working directory.
2. Create `data` directory in your working directory.
3. Copy `UCI HAR Dataset` parent directory with raw data into the `data` directory.

##Usage
To get tiny dataset just run `second_dataset()` function. It returns a `tbl` data frame with tiny data specified by step 5 of the assignment. The function goes through all the steps from reading raw data to creating a tiny dataset.

Solution for each assignment step is presented as a separate function. Refer to comments in the `run_analysis.R` file to navigate through the programming code.



