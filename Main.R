#Txt_File |> filter(str_detect(ID,"[a-zA-Z]+[Cc]hen")) |> View()
library(tidyverse)

source(str_c("RCode\\",dir("RCode"),sep=""))

FileName <- "Data\\citations.txt"
Citations <- LoadCitations(FileName) 
Citations2 <- Citations |> CleanStep1Df() 
CitationsW <- Citations2 |> WiderCitations() 
CitationsList <-  CitationsW |> GenID_Df() 

ResFinal <- PrintRefDf(CitationsList)

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
