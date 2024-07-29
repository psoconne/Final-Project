########################################
########      API File      #############
########################################

# Call necessary libraries
library(plumber)
library(tidyverse)
library(caret)
library(gbm)
library(rpart)

# Read in data
diabetes_data <- read_csv('diabetes_binary_health_indicators_BRFSS2015.csv')

# Convert necessary columns to factors
diabetes_data <- diabetes_data |>
  mutate(
    Diabetes_binary = factor(Diabetes_binary, levels = c(0, 1), labels = c("No_Diabetes", "Diabetes")),
    HighBP = factor(HighBP, levels = c(0, 1), labels = c("No", "Yes")),
    HighChol = factor(HighChol, levels = c(0, 1), labels = c("No", "Yes")),
    CholCheck = factor(CholCheck, levels = c(0, 1), labels = c("No", "Yes")),
    Smoker = factor(Smoker, levels = c(0, 1), labels = c("No", "Yes")),
    Stroke = factor(Stroke, levels = c(0, 1), labels = c("No", "Yes")),
    HeartDiseaseorAttack = factor(HeartDiseaseorAttack, levels = c(0, 1), labels = c("No", "Yes")),
    PhysActivity = factor(PhysActivity, levels = c(0, 1), labels = c("No", "Yes")),
    Fruits = factor(Fruits, levels = c(0, 1), labels = c("No", "Yes")),
    Veggies = factor(Veggies, levels = c(0, 1), labels = c("No", "Yes")),
    HvyAlcoholConsump = factor(HvyAlcoholConsump, levels = c(0, 1), labels = c("No", "Yes")),
    AnyHealthcare = factor(AnyHealthcare, levels = c(0, 1), labels = c("No", "Yes")),
    NoDocbcCost = factor(NoDocbcCost, levels = c(0, 1), labels = c("No", "Yes")),
    GenHlth = factor(GenHlth, levels = 1:5, labels = c("Excellent", "Very_Good", "Good", "Fair", "Poor")),
    DiffWalk = factor(DiffWalk, levels = c(0, 1), labels = c("No", "Yes")),
    Sex = factor(Sex, levels = c(0, 1), labels = c("Female", "Male")),
    Age =factor(Age, levels = 1:13, labels = c("18_24", "25_29", "30_34", "35_39", "40_44", "45_49", 
                                               "50_54", "55_59", "60_64", "65_69", "70_74", "75_79", "80_or_older")),
    Education = factor(Education, levels = 1:6, labels = c("Never_Attended", "Elementary", "Some_High_School", 
                                                           "High_School_Graduate", "Some_College", 
                                                           "College_Graduate")),
    Income = factor(Income, levels = 1:8, labels = c("Less_than_10k", "10k_to_15k", 
                                                     "15k_to_20k", "20k_to_25k", 
                                                     "25k_to_35k", "35k_to_50k", 
                                                     "50k_to_75k", "75k_or_more"))
  )

# Fit the best model
tree_model <- rpart(Diabetes_binary ~ BMI + Age + HighBP + HighChol, 
                    data = diabetes_data, 
                    control = rpart.control(cp = 0.001))


# API Title and Description
#* @apiTitle Diabetes API
#* @apiDescription Uses parameters to produce predictions based on best model.

#Take in predictors of best model
#* @param BMI 28.38
#* @param Age 9
#* @param HighBP 0
#* @param HighChol 0
#* @get /pred
function(BMI, Age, HighBP, HighChol){
  new_data <- data.frame(HighBP = factor(HighBP, levels = c("No", "Yes")),
                         HighChol = factor(HighChol, levels = c("No", "Yes")),
                         Age =factor(Age, levels = 1:13, labels = c("18_24", "25_29", "30_34", "35_39", "40_44", 
                                                                    "45_49", "50_54", "55_59", "60_64", "65_69", 
                                                                    "70_74", "75_79", "80_or_older")),
                         BMI = as.numeric(BMI))
  prediction <- predict(tree_model, new_data, type = "prob")[, 2]
  return(list(prediction = prediction))
}

#http://localhost:PORT/pred?BMI=28.38&Age=9&HighBP=0&HighChol=0

#Send a message
#* @get /info
function(){
  "Paige O'Connell https://github.com/psoconne/Final-Project/"
}
#http://localhost:PORT/info


# Example function calls
# http://localhost:PORT/pred?BMI=29&Age=11&HighBP=1&HighChol=1
# http://localhost:PORT/pred?BMI=25&Age=5&HighBP=0&HighChol=0
# http://localhost:PORT/pred?BMI=35&Age=14&HighBP=1&HighChol=1

