library(here)
library(tidyverse)
library(gridExtra)

here()

### Load Data

yrbs <- read_csv(here("data", "1_1_prep_yrbs_data.csv"), guess_max = 70000)
glimpse(yrbs)

# numerical coded variable for TV_use
# lower the value, less TV use on average school day
yrbs$q80_n
## Only one variable on TV use

# Make recoded suicide related outcome variables
#During the past 12 months, did you ever feel so sad or hopeless almost every day for two weeks or more in a row that you stopped doing some usual activities?
#1 = yes, 2 = no
yrbs$q25_n
#During the past 12 months, did you ever seriously consider attempting suicide?
yrbs$q26_n
#During the past 12 months, did you make a plan about how you would attempt suicide?
yrbs$q27_n
#During the past 12 months, how many times did you actually attempt suicide?
yrbs$q28_nd
## Four variables related to committing suicide


###### Question to be studied: relationship between school day TV use and suicide attempt

##### Control variables

### use of computer
# On an average school day, how many hours do you play video or computer games or use a computer for
# something that is not school work? (Count time spent on things such as Xbox, PlayStation, an iPad or other
#                                     tablet, a smartphone, texting, YouTube, Instagram, Facebook, or other social media.)
yrbs$q81_n

### physically active
# During the past 7 days, on how many days were you physically active for a total of at least 60 minutes per day?
# (Add up all the time you spent in any kind of physical activity that increased your heart rate and made you
#   breathe hard some of the time.)
# higher the number more active
yrbs$q79


### recent alcohol consumption
# During the past 30 days, on how many days did you have at least one drink of alcohol?
# higher the number more alcohol
yrbs$q42


### Illegal drugs at school
# During your life, how many times have you used hallucinogenic drugs, such as LSD, acid, PCP, angel
# dust, mescaline, or mushrooms?
# higher the number more times
yrbs$qhallucdrug


##### model form
## logit (response variable yrbs$q25_n; yrbs$q26_n; yrbs$q27_n)
## linear model (response variable yrbs$q25_n; yrbs$q26_n; yrbs$q27_n; response variable yrbs$q28_nd)


##### INTERACTION TERMS
## one for each control variables

##### Implement
y <- list("q28_nd", "q25_n", "q26_n", "q27_n")
x <- "q80_n"
control <- list("q81_n + q79", 
                "q81_n + q79 + q42", 
                "q81_n + q79 + qhallucdrug", 
                "q81_n + q79 + q42 + qhallucdrug", 
                "q81_n + q79 + q80_n * q81_n", 
                "q81_n + q79 + q80_n * q79", 
                "q81_n + q79 + q42 + q80_n * q81_n", 
                "q81_n + q79 + qhallucdrug + q80_n * q81_n", 
                "q81_n + q79 + q42 + qhallucdrug + q80_n * q81_n", 
                "q81_n + q79 + q42 + q80_n * q79", 
                "q81_n + q79 + qhallucdrug + q80_n * q79", 
                "q81_n + q79 + q42 + qhallucdrug + q80_n * q79", 
                "q81_n + q79 + q42 + q80_n * q42", 
                "q81_n + q79 + q42 + qhallucdrug + q80_n * q42", 
                "q81_n + q79 + qhallucdrug + q80_n * qhallucdrug", 
                "q81_n + q79 + q42 + qhallucdrug + q80_n * qhallucdrug")

formulas <- list()
logit_models <- list()
linear_models <- list()
for(i in 1:4){
  for(j in 1:length(control)){
    k = (i - 1) * length(control) + j
    formulas[[k]] <- paste(y[i], "~", x, "+", control[j])
    logit_models[[k]] <- glm(data = yrbs, formulas[[k]], family = "binomial")
    linear_models[[k]] <- lm(data = yrbs, formulas[[k]])
  }
}
logit_summary <- lapply(logit_models, summary)
logit_coef <- lapply(logit_summary, function(x) x$coefficients[2,1])
logit_pvalues <- lapply(logit_summary, function(x) x$coefficients[2,4])
linear_summary <- lapply(linear_models, summary)
linear_coef <- lapply(linear_summary, function(x) x$coefficients[2,1])
linear_pvalues <- lapply(linear_summary, function(x) x$coefficients[2,4])
mean(linear_coef > 0)
mean(linear_pvalues < 0.05)
mean(linear_coef < 0 & linear_pvalues < 0.05)

model_spec <- data.frame(unlist(formulas)) %>%
  mutate(plan_suicide = grepl("q27_n", unlist.formulas., fixed = TRUE), 
         serious_consid_suicide = grepl("q26_n", unlist.formulas., fixed = TRUE), 
         felt_hopeless = grepl("q25_n", unlist.formulas., fixed = TRUE), 
         attempt_suicide = grepl("q28_nd", unlist.formulas., fixed = TRUE), 
         recent_alcohol = grepl("q42", unlist.formulas., fixed = TRUE), 
         halluc_drug  = grepl("qhallucdrug ", unlist.formulas., fixed = TRUE), 
         int_hours_computer = grepl("* q81_n", unlist.formulas., fixed = TRUE), 
         int_physical_activity = grepl("* q79", unlist.formulas., fixed = TRUE),
         int_recent_alcohol = grepl("* q42", unlist.formulas., fixed = TRUE),
         int_halluc_drug = grepl("* qhallucdrug", unlist.formulas., fixed = TRUE))%>%
  rename(formula = unlist.formulas.)
results %>% full_join(model_spec) %>% filter(sig < 0.05) %>% 
  summarize(mean_plan_suicide = mean(plan_suicide), 
            mean_serious_consid_suicide = mean(serious_consid_suicide), 
            mean_hopeless = mean(felt_hopeless), 
            mean_attempt_suicide = mean(attempt_suicide), 
            mean_recent_alcohol = mean(recent_alcohol), 
            mean_halluc_drug = mean(halluc_drug), 
            mean_int_computer = mean(int_hours_computer), 
            mean_int_physical_active = mean(int_physical_activity), 
            mean_int_recent_alcohol = mean(int_recent_alcohol), 
            mean_int_halluc_drug = mean(int_halluc_drug))
results %>% full_join(model_spec) %>% filter(int_halluc_drug == TRUE) %>% 
  summarize(pos = mean(coef > 0), sig = mean(p < 0.05), pos_sig = mean(coef >0 & p < 0.05))
results %>% full_join(model_spec) %>% filter(int_physical_activity == TRUE)
mean(results$coef > 0)
mean(results$p < 0.05)
mean(results$coef > 0 & results$p < 0.05)

length(unlist(logit_coef))
unlist(logit_pvalues)

unlist(formulas)
unlist(linear_coef)
unlist(linear_pvalues)

results <- data.frame(coef = c(unlist(logit_coef), unlist(linear_coef)), 
           p = c(unlist(logit_pvalues), unlist(linear_pvalues)), 
           model = c(rep("logit", 64), rep("linear", 64)), 
           formula = unlist(formulas)) %>%
             mutate(formula = paste(formula, model)) %>%
  arrange(coef) %>%
  mutate(model_number = 1:128) %>%
  mutate(sig = ifelse(p < 0.05, TRUE, FALSE))
write_csv(results, here("data", "yrbs_SCA_results.csv"))      

curve <- results %>% ggplot(aes(x = model_number, y = coef, color = sig)) + geom_point() +
  theme_classic() +
  theme(axis.line.x = element_line(colour = "grey", 
                                   size = 0.5, linetype = "solid"),
        axis.line.y = element_line(colour = "grey", 
                                   size = 0.5, linetype = "solid")) + 
  geom_hline(yintercept=0, linetype="dashed", color = "grey") +
  theme(legend.position = "left") +
  labs(color = "P-value < 0.05               ", 
       x = "Model Number", 
       y = "Estimated Coefficients") +
  scale_x_continuous(breaks = seq(0, 128, by = 10)) +
  scale_y_continuous(breaks = c(-0.03, 0, 0.03, 0.06, 0.09))

spec_plot <- results %>%
  mutate(plan_suicide = grepl("q27_n", formula, fixed = TRUE), 
         serious_consid_suicide = grepl("q26_n", formula, fixed = TRUE), 
         felt_hopeless = grepl("q25_n", formula, fixed = TRUE), 
         attempt_suicide = grepl("q28_nd", formula, fixed = TRUE), 
         recent_alcohol = grepl("q42", formula, fixed = TRUE), 
         halluc_drug  = grepl("qhallucdrug ", formula, fixed = TRUE), 
         int_hours_computer = grepl("* q81_n", formula, fixed = TRUE), 
         int_physical_activity = grepl("* q79", formula, fixed = TRUE),
         int_recent_alcohol = grepl("* q42", formula, fixed = TRUE),
         int_halluc_drug = grepl("* qhallucdrug", formula, fixed = TRUE), 
         logit = grepl("logit", formula, fixed = TRUE), 
         linear = grepl("linear", formula, fixed = TRUE)) %>%
  mutate(No_add_control = (recent_alcohol == FALSE & halluc_drug == FALSE), 
         No_int = (int_hours_computer == FALSE & 
                     int_physical_activity == FALSE &
                     int_recent_alcohol == FALSE & 
                     int_halluc_drug == FALSE)) %>%
  gather(key = "spec", value = "T_F", plan_suicide:No_int) %>% 
  filter(T_F == TRUE) %>%
  full_join(spec_name) %>%
  mutate(specification = factor(specification, levels = c("TV use * hours of computer", 
                                                          "TV use * days of physical active", 
                                                          "TV use * recent alcohol consumption", 
                                                          "TV use * hallucinogenic drug consumption", 
                                                          "No interaction term",
                                        "INTERACTION TERMS", 
                                        "Recent alcohol consumption", 
                                        "Recent hallucinogenic drug consumption", 
                                        "No additional control variables",
                                        "ADDITIONAL CONTROL VARIABLES", 
                                        "Planned on suicide", 
                                        "Seriously considered suicide", 
                                        "Felt hopeless and stopped usual activities", 
                                        "Actual attempt on suicide", 
                                        "ALTERNATIVE RESPONSE VARIABLES", 
                                        "Linear Regression", "Logit Regression", "MODEL FORM"))) %>%
  mutate(sig = p < 0.05) %>%
  ggplot(aes(x = model_number, y = specification, col = sig)) + geom_point() +
  theme_classic() +
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank(), 
        axis.line.x=element_blank(), 
        axis.line.y = element_line(colour = "grey", 
                                 size = 0.5, linetype = "solid"), 
        axis.title.y = element_blank(), 
        legend.position='none')

spec_name <- data.frame(spec = c("int_hours_computer", "int_physical_activity", 
                    "int_recent_alcohol", "int_halluc_drug", 
                    "recent_alcohol", "halluc_drug",
                    "plan_suicide", "serious_consid_suicide", "felt_hopeless", "attempt_suicide", 
                    "ADDITIONAL CONTROL VARIABLES", 
                    "ALTERNATIVE RESPONSE VARIABLES", 
                    "INTERACTION TERMS", 
                    "logit", 
                    "linear",
                    "MODEL FORM", 
                    "No_add_control", 
                    "No_int"), 
           specification = c("TV use * hours of computer", 
                             "TV use * days of physical active", 
                             "TV use * recent alcohol consumption", 
                             "TV use * hallucinogenic drug consumption", 
                             "Recent alcohol consumption", 
                             "Recent hallucinogenic drug consumption", 
                             "Planned on suicide", 
                             "Seriously considered suicide", 
                             "Felt hopeless and stopped usual activities", 
                             "Actual attempt on suicide", 
                             "ADDITIONAL CONTROL VARIABLES", 
                             "ALTERNATIVE RESPONSE VARIABLES", 
                             "INTERACTION TERMS", 
                             "Logit Regression", "Linear Regression", "MODEL FORM", 
                             "No additional control variables", 
                             "No interaction term"))
SCA_yrbs <- grid.arrange(curve, spec_plot, ncol = 1)
ggsave(here("replication", "SCA_yrbs_TV_suicide.jpg"), SCA_yrbs, width = 12, height = 8)
