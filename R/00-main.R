library(tidyverse)
library(googlesheets4)
library(stringi)

revisao_2024 <- read_sheet(
  "https://docs.google.com/spreadsheets/d/1oNpc9VXaSiFcnH2f2RU_6jkWzOr4QXVYgFTnav8OAn0/edit#gid=1264866835",
  sheet = 3,
  range = "A1:S28",
  .name_repair = "universal"
)

string_parser_2024 <- function(string) {
  string |> 
    stri_trans_general(id = "Latin-ASCII") |> 
    str_to_lower() |> 
    str_replace("\\.\\.\\.", "_") |> 
    str_replace_all(c("condutores.habilitados" = "condutores",
                      "nivel.de.desagregacao" = "desagreg",
                      "periodicidade" = "period",
                      "interatividade" = "inter",
                      "atendimento.ao.publico" = "atendimento",
                      "canais.de.atendimento" = "canais",
                      "educacao.no.transito" = "educ",
                      "conteudos.didaticos" = "conteudo",
                      "divulgacao.de.atividades" = "divulgacao",
                      "lista.sobre.os.cfc.credenciados" = "CFCs"))
}

df_revisao_2024 <- rename_with(revisao_2024, string_parser_2024)

frota_2020 <- read_sheet(
  "https://docs.google.com/spreadsheets/d/1hxwGECZwO5BZ3ykeA8uQXxCsAFTgaz-EoTqVx8uAg6o/edit#gid=655637544",
  sheet = 3,
  range = "A1:F28",
  .name_repair = "universal"
)

df_frota_2020 <-
  frota_2020 |> 
  rename_with(string_parser_2024)

condutores_2020 <- read_sheet(
  "https://docs.google.com/spreadsheets/d/1hxwGECZwO5BZ3ykeA8uQXxCsAFTgaz-EoTqVx8uAg6o/edit#gid=655637544",
  sheet = 4,
  range = "A1:F28",
  .name_repair = "universal"
)
  
df_condutores_2020 <-
  condutores_2020 |> 
  rename_with(string_parser_2024) |> 
  fill(regiao)

infracoes_2020 <- read_sheet(
  "https://docs.google.com/spreadsheets/d/1hxwGECZwO5BZ3ykeA8uQXxCsAFTgaz-EoTqVx8uAg6o/edit#gid=655637544",
  sheet = 5,
  range = "A32:J60",
  .name_repair = "universal"
)

df_infracoes_2020 <-
  infracoes_2020 |> 
  slice(-1) |> 
  rename_with(string_parser_2024) |> 
  mutate(across(.fns = ~replace(., . %in% c("NULL", "N.D."), NA)),
         desagreg_qntd = as.numeric(desagreg_qntd)) |> 
  fill(regiao)
  
cfc_2020 <- read_sheet(
  "https://docs.google.com/spreadsheets/d/1hxwGECZwO5BZ3ykeA8uQXxCsAFTgaz-EoTqVx8uAg6o/edit#gid=655637544",
  sheet = 6,
  range = "A1:D28",
  .name_repair = "universal"
)

df_cfc_2020 <-
  cfc_2020 |> 
  rename_with(string_parser_2024) |> 
  mutate(across(.fns = ~replace(., . %in% c("NULL", "N.D."), NA))) |> 
  fill(regiao)

educ_2020 <- read_sheet(
  "https://docs.google.com/spreadsheets/d/1hxwGECZwO5BZ3ykeA8uQXxCsAFTgaz-EoTqVx8uAg6o/edit#gid=655637544",
  sheet = 7,
  range = "A1:E28",
  .name_repair = "universal"
)

df_educ_2020 <-
  educ_2020 |> 
  rename_with(string_parser_2024) |> 
  mutate(across(.fns = ~replace(., . %in% c("NULL", "N.D."), NA))) |> 
  fill(regiao)

sinistros_2020 <- read_sheet(
  "https://docs.google.com/spreadsheets/d/1hxwGECZwO5BZ3ykeA8uQXxCsAFTgaz-EoTqVx8uAg6o/edit#gid=655637544",
  sheet = 9,
  range = "A32:J60",
  .name_repair = "universal"
)

df_sinistros_2020 <-
  sinistros_2020 |> 
  slice(-1) |> 
  rename_with(string_parser_2024) |> 
  mutate(across(.fns = ~replace(., . %in% c("NULL", "N.D."), NA)),
         desagreg_qntd = as.numeric(desagreg_qntd)) |> 
  fill(regiao)

atendimento_2020 <- read_sheet(
  "https://docs.google.com/spreadsheets/d/1hxwGECZwO5BZ3ykeA8uQXxCsAFTgaz-EoTqVx8uAg6o/edit#gid=655637544",
  sheet = 10,
  range = "A1:E28",
  .name_repair = "universal"
)

df_atendimento_2020 <-
  atendimento_2020 |>
  rename_with(string_parser_2024) |> 
  mutate(across(.fns = ~replace(., . %in% c("NULL", "N.D."), NA))) |> 
  fill(regiao)
  

# load("data/data.rda")
