library(tidyverse)
library(optparse)

options <- list(
  make_option(c("-d", "--penguin_data")),
  make_option(c("--output_folder"))  
)


opt_parser <- OptionParser(option_list = options)
opt <- parse_args(opt_parser)

#paste(opt$penguin_data)
print(paste0('File Path: ', file.path(opt$penguin_data, "penguins_lter.csv")))


penguin_data <- read_csv(file.path(opt$penguin_data, "penguins_lter.csv"))
summary(penguin_data)

#Romove all the spaces from column names and replace with _
names(penguin_data) <- gsub(" ","_", names(penguin_data))

#Select Only the applicable columns and drop the NA rows
pen_mes <- penguin_data  %>% 
            dplyr::select(Species, "Culmen_Length_(mm)", "Culmen_Depth_(mm)", "Flipper_Length_(mm)", "Body_Mass_(g)") %>% 
            drop_na()

# make directory for output dir
output_dir = opt$output_folder
if (!dir.exists(output_dir)){
  dir.create(output_dir)
}

print(paste0('Output File Path: ', file.path(opt$output_folder, "validated_data.csv")))

#Write the Validated Data as CSV to O/P directory
write.csv(pen_mes, file.path(output_dir, "validated_data.csv"), row.names = FALSE)
