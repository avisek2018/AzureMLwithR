library(tidyverse)
library(caret)
library(class)
library(optparse)

options <- list(
  make_option(c("--validated_data")),
  make_option(c("--train_folder"))  ,
  make_option(c("--test_folder"))
)


opt_parser <- OptionParser(option_list = options)
opt <- parse_args(opt_parser)

print(paste0('Validated File Path: ', file.path(opt$validated_data, "validated_data.csv")))

#print('PRINTING WORKING DIRECTORY: ')
#print(getwd())
#print('PRINTING DIR LIST: ')
#print(list.dirs())
#print('PRINTING FILES LIST: ')
#print(list.files())


validated_data <- read_csv(file.path(opt$validated_data, "validated_data.csv"))
summary(validated_data)

#Converting the target column as factors
validated_data$Species <- as.factor(validated_data$Species)

#Split the data 80% Train, 20% Test
train.inv <- validated_data$Species %>% createDataPartition(p=0.8, list=FALSE)
train_cl <- validated_data[train.inv, ]
test_cl <- validated_data[-train.inv, ]


# make directory for output dir
train_dir = opt$train_folder
if (!dir.exists(train_dir)){
  dir.create(train_dir)
}

print(paste0('Output File Path for Training: ', file.path(opt$train_folder, "train_data.csv")))

#Write the Training Data as CSV to O/P directory
write.csv(train_cl, file.path(train_dir, "train_data.csv"), row.names = FALSE)

# make directory for output dir
test_dir = opt$test_folder
if (!dir.exists(test_dir)){
  dir.create(test_dir)
}

print(paste0('Output File Path for Training: ', file.path(opt$test_folder, "test_data.csv")))

#Write the Training Data as CSV to O/P directory
write.csv(test_cl, file.path(test_dir, "test_data.csv"), row.names = FALSE)