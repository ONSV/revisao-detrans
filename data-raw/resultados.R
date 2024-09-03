library(tidyverse)
library(googlesheets4)
library(stringi)

# baixar os dados
revisao_2024 <- read_sheet(
  "https://docs.google.com/spreadsheets/d/1oNpc9VXaSiFcnH2f2RU_6jkWzOr4QXVYgFTnav8OAn0/edit#gid=1264866835",
  sheet = 3,
  range = "A1:S28",
  .name_repair = "universal"
)

resultados_2020 <- read_sheet(
  "https://docs.google.com/spreadsheets/d/1tG_UYboWijb_9B4Gfl4zMbbQS1n7JSFxdW1Z2Th3K_Q/edit?usp=sharing",
  sheet = 9,
  range = "A1:I28",
  .name_repair = "universal"
)

# parser de strings
string_parser_2024 <- function(string) {
  string |>
    stri_trans_general(id = "Latin-ASCII") |>
    str_to_lower() |>
    str_replace("\\.\\.\\.", "_") |>
    str_replace_all(
      c(
        "condutores.habilitados" = "condutores",
        "nivel.de.desagregacao" = "desagreg",
        "periodicidade" = "period",
        "interatividade" = "inter",
        "atendimento.ao.publico" = "atendimento",
        "canais.de.atendimento" = "canais",
        "educacao.no.transito" = "educ",
        "conteudos.didaticos" = "conteudos",
        "divulgacao.de.atividades" = "divulgacao",
        "lista.sobre.os.cfc.credenciados" = "CFCs"
      )
    )
}

# tratamento dos dados
df_resultados_2020 <- 
  rename_with(resultados_2020, string_parser_2024) |> 
  mutate(ano = 2020) |> 
  select(uf, ano, nota_final = media)

df_revisao_2024 <-
  rename_with(revisao_2024, string_parser_2024) |>
  mutate(ano = 2024) |> 
  rename_with(~ str_to_lower(str_replace(.x, "\\.", "_"))) |> 
  rename_with(~ str_replace(.x, "acidentes", "sinistros"))

df_revisoes <- df_revisao_2024 |> 
  bind_rows(df_resultados_2020)

save(df_revisoes, file = "data/revisoes.rda")