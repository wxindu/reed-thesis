## Replication Obstacles

### MTF

- Data
    - Failed to find data files in the same format. The original study used `.sav` data file, but only successfully obtained `.rda` files
    - Orben used a merged MTF data file, however, I failed in finding a merged data file of MTF data 2008 - 2016. The separate datasets have been obtained, however, the survey questions are all encoded differently each year. Modifying the variables to be consistent across year can be difficult and time-consuming. 
- Code
    
- Replication

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
    - The dataset was successfully imported, however, the variables in the obtained dataset are slightly different than variables in the dataset used by Orben. All variables used by Orben, formated as q*n* for some integer *n*, which refers to the *n*th question in the survey, are off by 1 in the dataset obtained. For example, the q81 used in the dataset obtained by Orban should be changed to q80 in mine so that they actually refer to the same variable. 

- Replication
     - Successfully replicated Orben's results in SCA. 
