map_preproc <- function(df) {
  df |> 
    rename(abbrev_state = uf) |> 
    merge(estados) |> 
    mutate(
      nudge_y_text = case_match(
        abbrev_state,
        "DF" ~ 1,
        "RN" ~ 0.25,
        "SE" ~ -0.6,
        "AL" ~ -0.4,
        "RJ" ~ -1,
        "AC" ~ 0.5,
        .default = 0
      ),
      nudge_x_text = case_match(
        abbrev_state,
        "PB" ~ 3,
        "PE" ~ 3.9,
        "AL" ~ 1.75,
        "ES" ~ 1.60,
        "SE" ~ 1,
        "RJ" ~ 1,
        .default = 0
      ),
      fill = case_when(
        nota_final <= 2.5 ~ "0 - 2,5",
        nota_final <= 5 ~ "2,5 - 5",
        nota_final <= 7.5 ~ "5 - 7,5",
        nota_final <= 10 ~ "7,5 - 10"
      )
    ) |> 
    st_as_sf()
}

get_region <- function(acronyms) {
  region_map <- list(
    "Norte" = c("AC", "AM", "AP", "PA", "RO", "RR", "TO"),
    "Nordeste" = c("AL", "BA", "CE", "MA", "PB", "PE", "PI", "RN", "SE"),
    "Centro-Oeste" = c("GO", "MT", "MS", "DF"),
    "Sudeste" = c("ES", "MG", "RJ", "SP"),
    "Sul" = c("PR", "RS", "SC")
  )
  
  region <- sapply(acronyms, function(acronym) {
    for (r in names(region_map)) {
      if (acronym %in% region_map[[r]]) {
        return(r)
      }
    }
    return("Not found")
  })
  
  return(region)
}

binary_bg_func <- function(value) {
  if(value == "SIM") {
    color = tbl_green
  } else {
    color = tbl_red
  }
  list(background = color, color = "white")
}

continuous_bg_func <- function(value) {
  scale <- seq(0,10,0.5)
  
  normalized <- value / 10
  color <- col_func(normalized)
  list(background = color, color = "white")
}

quali_bg_func <- function(value) {
  color = case_match(
    value,
    "Melhor" ~ tbl_green,
    "Intermediário" ~ tbl_yellow,
    "Inicial" ~ tbl_orange,
    "Ausente" ~ tbl_red
  )
  list(background = color, color = "white")
}

make_reactable <- function(data, ...) {
  blue <- "#00496d"
  font_families <- "-apple-system, BlinkMacSystemFont, Segoe UI, Helvetica, Arial, sans-serif"
  
  data |> 
    reactable(
      pagination = F, 
      defaultColDef = colDef(
        align = "center",
        headerStyle = list(background = blue, color = "white"),
        minWidth = 50
      ),
      theme = reactableTheme(
        style = list(fontFamily = font_families, fontSize = "0.80rem"),
        searchInputStyle = list(color = blue)
      ),
      sortable = T,
      compact = T,
      resizable = T,
      wrap = F,
      bordered = T,
      highlight = T,
      searchable = T,
      ...
    )
}

get_state_name <- function(acronym) {
  state_map <- list(
    "AC" = "Acre",
    "AL" = "Alagoas",
    "AP" = "Amapá",
    "AM" = "Amazonas",
    "BA" = "Bahia",
    "CE" = "Ceará",
    "DF" = "Distrito Federal",
    "ES" = "Espírito Santo",
    "GO" = "Goiás",
    "MA" = "Maranhão",
    "MT" = "Mato Grosso",
    "MS" = "Mato Grosso do Sul",
    "MG" = "Minas Gerais",
    "PA" = "Pará",
    "PB" = "Paraíba",
    "PR" = "Paraná",
    "PE" = "Pernambuco",
    "PI" = "Piauí",
    "RJ" = "Rio de Janeiro",
    "RN" = "Rio Grande do Norte",
    "RS" = "Rio Grande do Sul",
    "RO" = "Rondônia",
    "RR" = "Roraima",
    "SC" = "Santa Catarina",
    "SP" = "São Paulo",
    "SE" = "Sergipe",
    "TO" = "Tocantins"
  )
  
  return(state_map[[acronym]])
}

get_state_names <- function(acronyms) {
  state_names <- sapply(acronyms, get_state_name)
  return(state_names)
}