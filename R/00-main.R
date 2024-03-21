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

frota_2020 <- read_sheet(
  "https://docs.google.com/spreadsheets/d/1hxwGECZwO5BZ3ykeA8uQXxCsAFTgaz-EoTqVx8uAg6o/edit#gid=655637544",
  sheet = 3,
  range = "A1:F28",
  .name_repair = "universal"
)

condutores_2020 <- read_sheet(
  "https://docs.google.com/spreadsheets/d/1hxwGECZwO5BZ3ykeA8uQXxCsAFTgaz-EoTqVx8uAg6o/edit#gid=655637544",
  sheet = 4,
  range = "A1:F28",
  .name_repair = "universal"
)

infracoes_2020 <- read_sheet(
  "https://docs.google.com/spreadsheets/d/1hxwGECZwO5BZ3ykeA8uQXxCsAFTgaz-EoTqVx8uAg6o/edit#gid=655637544",
  sheet = 5,
  range = "A32:J60",
  .name_repair = "universal"
)

cfc_2020 <- read_sheet(
  "https://docs.google.com/spreadsheets/d/1hxwGECZwO5BZ3ykeA8uQXxCsAFTgaz-EoTqVx8uAg6o/edit#gid=655637544",
  sheet = 6,
  range = "A1:D28",
  .name_repair = "universal"
)

educ_2020 <- read_sheet(
  "https://docs.google.com/spreadsheets/d/1hxwGECZwO5BZ3ykeA8uQXxCsAFTgaz-EoTqVx8uAg6o/edit#gid=655637544",
  sheet = 7,
  range = "A1:E28",
  .name_repair = "universal"
)

sinistros_2020 <- read_sheet(
  "https://docs.google.com/spreadsheets/d/1hxwGECZwO5BZ3ykeA8uQXxCsAFTgaz-EoTqVx8uAg6o/edit#gid=655637544",
  sheet = 9,
  range = "A32:J60",
  .name_repair = "universal"
)

atendimento_2020 <- read_sheet(
  "https://docs.google.com/spreadsheets/d/1hxwGECZwO5BZ3ykeA8uQXxCsAFTgaz-EoTqVx8uAg6o/edit#gid=655637544",
  sheet = 10,
  range = "A1:E28",
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

df_revisao_2024 <- 
  rename_with(revisao_2024, string_parser_2024) |> 
  mutate(ano = 2024)

df_frota_2020 <-
  frota_2020 |>
  rename_with(string_parser_2024) |> 
  rename_with(~ paste("frota", ., sep = "_")) |> 
  mutate(across(where(is.list), as.numeric))

df_condutores_2020 <-
  condutores_2020 |>
  rename_with(string_parser_2024) |>
  fill(regiao) |>
  rename_with(~ paste("condutores", ., sep = "_"))

df_infracoes_2020 <-
  infracoes_2020 |>
  slice(-1) |>
  rename_with(string_parser_2024) |>
  mutate(across(.fns = ~ replace(., . %in% c("NULL", "N.D."), NA)),
         desagreg_qntd = as.numeric(desagreg_qntd)) |>
  fill(regiao) |> 
  rename_with(~ paste("infracoes", ., sep = "_"))

df_cfc_2020 <-
  cfc_2020 |>
  rename_with(string_parser_2024) |>
  mutate(across(.fns = ~ replace(., . %in% c("NULL", "N.D."), NA))) |>
  fill(regiao) |> 
  rename_with(~ paste("cfc", ., sep = "_"))

df_educ_2020 <-
  educ_2020 |>
  rename_with(string_parser_2024) |>
  mutate(across(.fns = ~ replace(., . %in% c("NULL", "N.D."), NA))) |>
  fill(regiao) |> 
  rename_with(~ paste("educ", ., sep = "_"))

df_sinistros_2020 <-
  sinistros_2020 |>
  slice(-1) |>
  rename_with(string_parser_2024) |>
  mutate(across(.fns = ~ replace(., . %in% c("NULL", "N.D."), NA)),
         desagreg_qntd = as.numeric(desagreg_qntd)) |>
  fill(regiao) |> 
  rename_with(~ paste("sinistros", ., sep = "_"))

df_atendimento_2020 <-
  atendimento_2020 |>
  rename_with(string_parser_2024) |>
  mutate(across(.fns = ~ replace(., . %in% c("NULL", "N.D."), NA))) |>
  fill(regiao) |> 
  rename_with(~ paste("atendimento", ., sep = "_"))
  
df_list <- list(
  df_atendimento_2020,
  df_cfc_2020,
  df_condutores_2020,
  df_educ_2020,
  df_frota_2020,
  df_infracoes_2020,
  df_sinistros_2020
)

df_revisao_2020_raw <-
  df_list |>
  lapply(function(x) {
    rename_with(x, .cols = ends_with("uf"), .fn = ~ "uf")
  }) |>
  reduce(left_join, by = "uf") |>
  select(-ends_with("regiao"))

df_revisao_2020 <-
  df_revisao_2020_raw |>
  select(
    uf,
    frota_period,
    frota_inter,
    frota_desagreg,
    condutores_period,
    condutores_inter,
    condutores_desagreg,
    infracoes_period_classificacao,
    infracoes_inter_classificacao,
    infracoes_desagreg_classificacao,
    sinistros_period_classificacao,
    sinistros_inter_classificacao,
    sinistros_desagreg_classificacao,
    atendimento_estatistica,
    atendimento_canais,
    educ_conteudos.disponiveis,
    educ_divulgacao,
    cfc_classificacao
  ) |>
  rename_with( ~ str_replace_all(
    .x,
    c(
      "_classificacao" = "",
      "sinistros" = "acidentes",
      ".disponiveis" = "",
      "cfc" = "CFCs"
    )
  )) |>
  mutate(across(
    where(is.character) & !uf,
    ~ case_match(
      .x,
      "PRÁTICA INICIAL" ~ 10 / 3,
      c("PRÁTICA INTERMEDIÁRIA", "PRÁTICA INTERM.") ~ 10 * 2 / 3,
      "MELHOR PRÁTICA" ~ 10,
      .default = NA
    )
  )) |>
  mutate(across(everything(), ~ replace_na(.x, 0))) |> 
  mutate(nota.final =
           (
             rowMeans(across(starts_with("frota"))) +
               rowMeans(across(starts_with("condutores"))) +
               rowMeans(across(starts_with("infracoes"))) +
               rowMeans(across(starts_with("acidentes"))) +
               rowMeans(across(starts_with("atendimento"))) +
               rowMeans(across(starts_with("educ"))) +
               CFCs
           ) / 7,
         ano = 2020)


df_revisoes <-
  rbind(df_revisao_2020, df_revisao_2024) |> 
  rename_with(~ str_to_lower(str_replace(.x, "\\.", "_")))

view(df_revisoes)

save(df_revisoes, file = "data/revisoes.rda")
