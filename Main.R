# Load required libraries
library(tidyverse)

# Source all R scripts from the "RCode" directory
script_files <- dir("RCode", full.names = TRUE)  # Get full paths of scripts
walk(script_files, source)  # Source each script

# Define the file path for the dataset
file_path <- "Data/citations.txt"

# Load the citations dataset using a custom function
citations_raw <- LoadCitations(file_path) 

# Step 1: Clean and structure the dataset
citations_cleaned <- citations_raw |> CleanStep1Df()  

# Step 2: Convert data to a wider format
citations_wide <- citations_cleaned |> WiderCitations()  

# Step 3: Generate a list with new references
citations_list <- citations_wide |> GenID_Df()  

# Step 4: Save the final results as a text file
final_results <- PrintRefDf(citations_list)  

# Optional: Print a message to indicate completion
message("Citations processing completed successfully!")


library(targets) 
library(tarchetypes)
use_targets()

tar_manifest()
  tar_visnetwork()

tar_make()
  tar_visnetwork()
  tar_visnetwork(targets_only = TRUE)

tar_meta(fields = "error") |> drop_na() |> pull()

#tar_destroy()
library(tidyverse)
tar_source("RCode")
CitationsList <- tar_read(CitationsList)

PrintRef(CitationsList[17,])
cat(PrintRef(CitationsList[17,]))

ResFinal <- tar_read(ResFinal)


#Txt_File |> filter(str_detect(ID,"[a-zA-Z]+[Cc]hen")) |> View()
