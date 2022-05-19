library(tidyverse)
library(optparse)
library(caret)
library(party)
library(rpart)
library(rpart.plot)

options <- list(
  make_option(c("--test_data")),
  make_option(c("--model_folder"))  
)


opt_parser <- OptionParser(option_list = options)
opt <- parse_args(opt_parser)

print(paste0('Scoring File Path: ', file.path(opt$test_data, "test_data.csv")))

test_data <- read_csv(file.path(opt$test_data, "test_data.csv"))
summary(test_data)

test_data$Species <- as.factor(test_data$Species)

#Load the saved Model
print(paste0('File Path for Model: ', file.path(opt$model_folder, "model_dt.rds")))
model_dt <- readRDS(file.path(opt$model_folder, "model_dt.rds"))

#Predict Using the Model
predicted.penguin <- predict(model_dt, test_data[, 2:5], type=c("class"))

#performance metrics
print('Confusion Matrix: ')
print(table(predicted.penguin , test_data$Species))
misClassError <- mean(predicted.penguin != test_data$Species) 
print(paste('Accuracy =', 1-misClassError)) 