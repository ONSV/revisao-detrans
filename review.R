library(tidyverse)
library(googlesheets4)

if(file.exists("data.rda")) {
  load("data.rda")
} else {
  df <- read_sheet(
    "https://docs.google.com/spreadsheets/d/1oNpc9VXaSiFcnH2f2RU_6jkWzOr4QXVYgFTnav8OAn0/edit#gid=1264866835",
    sheet = 3,
    range = "T1:AA28"
  )
  
  save(df, file = "data.rda")
}

df |> 
  mutate(nota = rowMeans(select(df, where(is.numeric)))) |> 
  view()

         
     