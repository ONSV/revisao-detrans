params <-
  c(
    "AC",
    "AL",
    "AP",
    "AM",
    "BA",
    "CE",
    "DF",
    "ES",
    "GO",
    "MA",
    "MT",
    "MS",
    "MG",
    "PA",
    "PB",
    "PR",
    "PE",
    "PI",
    "RJ",
    "RN",
    "RS",
    "RO",
    "RR",
    "SC",
    "SP",
    "SE",
    "TO"
  )

purrr::walk(
  params,
  ~ quarto::quarto_render(
    input = "report/params.qmd",
    execute_params = list("state" = .x),
    output_file = glue::glue("params_{.x}.pdf")
  )
)