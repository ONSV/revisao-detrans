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

frota_2020 <- read_sheet(
  "https://docs.google.com/spreadsheets/d/1tG_UYboWijb_9B4Gfl4zMbbQS1n7JSFxdW1Z2Th3K_Q/edit?usp=sharing",
  sheet = 2,
  range = "A1:I29",
  .name_repair = "universal"
)

frota_2020 <- read_sheet(
  "https://docs.google.com/spreadsheets/d/1tG_UYboWijb_9B4Gfl4zMbbQS1n7JSFxdW1Z2Th3K_Q/edit?usp=sharing",
  sheet = 2,
  range = "A1:I29",
  .name_repair = "universal"
)

condutores_2020 <- read_sheet(
  "https://docs.google.com/spreadsheets/d/1tG_UYboWijb_9B4Gfl4zMbbQS1n7JSFxdW1Z2Th3K_Q/edit?usp=sharing",
  sheet = 3,
  range = "A1:I29",
  .name_repair = "universal"
)

infracoes_2020 <- read_sheet(
  "https://docs.google.com/spreadsheets/d/1tG_UYboWijb_9B4Gfl4zMbbQS1n7JSFxdW1Z2Th3K_Q/edit?usp=sharing",
  sheet = 4,
  range = "A1:I29",
  .name_repair = "universal"
)

cfc_2020 <- read_sheet(
  "https://docs.google.com/spreadsheets/d/1tG_UYboWijb_9B4Gfl4zMbbQS1n7JSFxdW1Z2Th3K_Q/edit?usp=sharing",
  sheet = 5,
  range = "A1:D28",
  .name_repair = "universal"
)

educacao_2020 <- read_sheet(
  "https://docs.google.com/spreadsheets/d/1tG_UYboWijb_9B4Gfl4zMbbQS1n7JSFxdW1Z2Th3K_Q/edit?usp=sharing",
  sheet = 6,
  range = "A1:E28",
  .name_repair = "universal"
)

sinistros_2020 <- read_sheet(
  "https://docs.google.com/spreadsheets/d/1tG_UYboWijb_9B4Gfl4zMbbQS1n7JSFxdW1Z2Th3K_Q/edit?usp=sharing",
  sheet = 7,
  range = "A1:I29",
  .name_repair = "universal"

)

atendimento_2020 <- read_sheet(
  "https://docs.google.com/spreadsheets/d/1tG_UYboWijb_9B4Gfl4zMbbQS1n7JSFxdW1Z2Th3K_Q/edit?usp=sharing",
  sheet = 8,
  range = "A1:E28",
  .name_repair = "universal"
)

frota_2020 <- frota_2020 |> 
  select(uf = UF, frota_period = ...5, frota_inter = ...7, frota_desagreg = ...9) |> 
  drop_na(uf) |> 
  mutate(
    across(starts_with("frota"), \(x) case_match(
      x,
      "MELHOR PRÁTICA" ~ 10,
      "PRÁTICA INTERM." ~ 6.7,
      "PRÁTICA INICIAL" ~ 3.3
    ))
  ) |> 
  replace_na(list(frota_period = 0, frota_inter = 0, frota_desagreg = 0))

cfc_2020 <- cfc_2020 |> 
  select(uf = UF, cfcs = Nota)

condutores_2020 <- condutores_2020 |> 
  select(
    uf = UF, 
    condutores_period = ...5,
    condutores_inter = ...7,
    condutores_desagreg = ...9
  ) |> 
  drop_na(uf) |>
  mutate(
    across(starts_with("condutores"), \(x) case_match(
      x,
      "MELHOR PRÁTICA" ~ 10,
      "PRÁTICA INTERM." ~ 6.7,
      "PRÁTICA INICIAL" ~ 3.3
    ))
  ) |>
  replace_na(
    list(condutores_period = 0, condutores_inter = 0, condutores_desagreg = 0)
  )

educacao_2020 <- educacao_2020 |> 
  select(
    uf = UF, 
    educ_conteudos = Conteúdos.Disponíveis, 
    educ_divulgacao = Divulgação.de.atividades
  ) |>
  mutate(
    across(starts_with("educ"), \(x) case_match(
      x,
      "MELHOR PRÁTICA" ~ 10,
      "PRÁTICA INTERM." ~ 6.7,
      "PRÁTICA INICIAL" ~ 3.3,
      "N.D" ~ 0
    ))
  ) |>
  replace_na(list(educ_conteudos = 0, educ_divulgacao = 0))

atendimento_2020 <- atendimento_2020 |> 
  select(
    uf = UF, 
    atendimento_estatistica = Estatística, 
    atendimento_canais = Canais.de.atendimento
  ) |>
  mutate(
    across(starts_with("atendimento"), \(x) case_match(
      x,
      "MELHOR PRÁTICA" ~ 10,
      "PRÁTICA INTERM." ~ 6.7,
      "PRÁTICA INICIAL" ~ 3.3,
      "N.D" ~ 0
    ))
  ) |>
  replace_na(list(atendimento_estatistica = 0, atendimento_canais = 0))

infracoes_2020 <- infracoes_2020 |> 
  select(
    uf = UF, 
    infracoes_period = ...5, 
    infracoes_inter = ...7, 
    infracoes_desagreg = ...9
  ) |>
  drop_na(uf) |>
  mutate(
    across(starts_with("infracoes"), \(x) case_match(
      x,
      "MELHOR PRÁTICA" ~ 10,
      "PRÁTICA INTERM." ~ 6.7,
      "PRÁTICA INICIAL" ~ 3.3
    ))
  ) |>
  replace_na(
    list(infracoes_period = 0, infracoes_inter = 0, infracoes_desagreg = 0)
  )

sinistros_2020 <- sinistros_2020 |> 
  select(
    uf = UF,
    sinistros_period = ...5,
    sinistros_inter = ...7,
    sinistros_desagreg = ...9
  ) |> 
  drop_na(uf) |>
  mutate(
    across(starts_with("sinistros"), \(x) case_match(
      x,
      "MELHOR PRÁTICA" ~ 10,
      "PRÁTICA INTERM." ~ 6.7,
      "PRÁTICA INICIAL" ~ 3.3
    ))
  ) |>
  replace_na(
    list(sinistros_period = 0, sinistros_inter = 0, sinistros_desagreg = 0)
  )

df_resultados_2020 <- left_join(
  frota_2020,
  condutores_2020,
  by = "uf"
) |> 
  left_join(
    educacao_2020,
    by = "uf"
  ) |> 
  left_join(
    atendimento_2020,
    by = "uf"
  ) |> 
  left_join(
    infracoes_2020,
    by = "uf"
  ) |> 
  left_join(
    sinistros_2020,
    by = "uf"
  ) |> 
  left_join(
    cfc_2020,
    by = "uf"
  ) |> 
  left_join(
    resultados_2020 |> select(uf = UF, nota_final = MÉDIA),
    by = "uf"
  ) |>
  mutate(ano = 2020)

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
# df_resultados_2020 <- 
#   rename_with(resultados_2020, string_parser_2024) |> 
#   mutate(ano = 2020) |> 
#   select(uf, ano, nota_final = media)

df_revisao_2024 <-
  rename_with(revisao_2024, string_parser_2024) |>
  mutate(ano = 2024) |> 
  rename_with(~ str_to_lower(str_replace(.x, "\\.", "_"))) |> 
  rename_with(~ str_replace(.x, "acidentes", "sinistros"))

df_revisoes <- df_revisao_2024 |> 
  bind_rows(df_resultados_2020)

save(df_revisoes, file = "data/revisoes.rda")