library(tidyverse)
library(optparse)
library(caret)
library(party)
library(rpart)
library(rpart.plot)

options <- list(
  make_option(c("--train_data")),
  make_option(c("--model_folder"))  
)


opt_parser <- OptionParser(option_list = options)
opt <- parse_args(opt_parser)

print(paste0('Training File Path: ', file.path(opt$train_data, "train_data.csv")))

train_data <- read_csv(file.path(opt$train_data, "train_data.csv"))
summary(train_data)

train_data$Species <- as.factor(train_data$Species)

#Fit a decision tree model
rtree <- rpart(Species ~ ., data = train_data)

#Plot the Decision Tree
rpart.plot(rtree)

# make directory for output dir
model_dir = opt$model_folder
if (!dir.exists(model_dir)){
  dir.create(model_dir)
}

print(paste0('Output File Path for Model: ', file.path(opt$model_folder, "model_dt.rds")))

# save model
model_path = file.path(model_dir, "model_dt.rds")
saveRDS(rtree, file = model_path)
message("Model saved")