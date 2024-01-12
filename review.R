library(tidyverse)
library(googlesheets4)
library(onsvplot)

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
  arrange(nota) |>
  mutate(UF = factor(UF, levels = UF)) |> 
  ggplot(aes(x = nota, y = UF)) +
    geom_point(aes(color = nota)) +
    geom_segment(aes(x = 0, xend = nota, y = UF, yend = UF, color = nota)) +
    scale_color_continuous(low = onsv_palette$red, high = onsv_palette$green) +
    theme(legend.position = "none") +
    xlab("Nota Final") + ylab("Estados")

ggsave("plots/plot1.png", height = 5, width = 7)
         
     