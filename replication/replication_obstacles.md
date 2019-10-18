## Replication Obstacles

### MTF

- Data
    - Failed to find data files in the same format. The original study used `.sav` data file, but only successfully obtained `.rda` files
    - The obtained data have same set of variables, however, all variables have different values. All variables in the dataset used in Orben's code have numerical values, however, the dataset obtained had all characterstic values. Each value is a combination of the numerical value same as what Orben had, and a characteristic value that was the original survey answer. eg "(1) Strongly disagree". Wrangled data to convert all values to numeric values. 

- Code
    - After data wrangling, successful in running the SCA code and permutation code (permutation test takes very long to do); succesful in running code to generate the SCA plot
    
- Replication
    - Failed to produce same result as in the paper. Had a slight positive effect instead of a slight negative effect. Yet to be determine the reason. Need to first make sure the data wrangling was correct. 

### MCS

- Data
    - Failed to find data files in the same format. The original study used `.csv` data file, but only successfully obtained `.sav` files
    - The obtained data have same set of variables, however, all variables have character values. Successfully replaced all (used) variables' values with the numerical values indicated in the original questionare. (About 500 ~ 600 extra lines of code and took about 8 ~ 9 hours to do). 
    - Failed to obtain two variables, one related to the family income and one related to siblings. Both have all NA values. Both were used as control variables, thus removed for now.
    
- Code
    - After data wrangling, successful in running the SCA code and permutation code. 

- Replication
    - Successful in obtaining the result as shown in the paper (difference less than 0.0008, consider two control variables were removed, this *seems* (yet to be verified) reasonable). Not yet replicate the permutation test results. 

### YRBS

- Data
    - Failed to find data files in the same format. The original study used `.sav` data file, but only successfully obtained Microsoft Access files. Too large to be directly extracted and imported to RStudio. Currently working on importing the dataset
    
- Code

- Replication