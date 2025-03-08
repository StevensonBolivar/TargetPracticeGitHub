LoadCitations <- function(TxtFile){
  Df <- tibble(read_delim(TxtFile,"\t",col_names = FALSE))
}

CleanStep1Df <- function(Df){
  Df |> filter(!str_detect(X1,"^%"))
}

WiderCitations <- function(Df){
  Df |>
    mutate(
      X1 = str_replace(X1, "@([a-zA-Z0-9]+)\\{(.+),", "Type=\\1@\\2") # Replace @x2Name with Name
    ) |> 
    separate(X1, into = c("X1", "ID"), sep = "@") |>
    separate(X1, into = c("VarName", "Values"), sep = "=") |> 
    mutate(
      VarName=str_trim(VarName) |> 
        str_replace_all("[\\}\\{],?",""),
      Values=str_trim(Values) |> 
        str_replace_all("[\\}\\{],?","")
    ) |> 
    filter(!is.na(Values)) |> 
    fill(ID, .direction = "down") |> 
    distinct() |> 
    pivot_wider(id_cols=ID , names_from = VarName,values_from = Values,values_fn = list(value = first)) |> 
    select(ID, Type, title,author,journal,pages,year)
}

GenID <- function(Names,Year){
  if(str_detect(Names,",")){
    ID <- Names |> 
      str_split("and") |> 
      unlist() |> 
      str_trim() |> 
      map(~ .x |> str_split(",") |> unlist() |> head(-1) |> str_c(collapse = "")) |> 
      str_c(collapse = "") |> 
      str_c(Year, collapse = "")
  }else{
    ID <- Names |> 
      str_split("and") |> 
      unlist() |> 
      str_trim() |> 
      map(~ .x |> str_split(" ") |> unlist() |> tail(-1) |> str_c(collapse = "")) |> 
      str_c(collapse = "") |> 
      str_c(Year, collapse = "")
  }
  ID |> str_remove_all("[^a-zA-Z0-9]")
}

GenID_Df <- function(Df) {
  Df |> mutate(ID2=map2(author,year,~GenID(.x,.y)))
} 

PrintRef <- function(Df){
  TMP=str_glue("@{Df$Type}{{{Df$ID2}}},
    title={{{Df$title}}},
    author={{{Df$author}}},
    journal={{{Df$journal}}},
    pages={{{Df$pages}}},
    year={{{Df$year}}}
  }")
  TMP |> str_remove_all("NULL")
}

PrintRefDf <- function(Df,FileName="NewCitations.txt"){
  TMP= map(1:nrow(Df),~PrintRef(Df[.x,])) 
  dir.create("Results", showWarnings = FALSE)  # Ensure the folder exists
  full_path <- file.path("Results", FileName) 
  write_lines(TMP,full_path)
  return(full_path)
}

