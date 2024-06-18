library(tidyverse)
library(here)
library(leaflet)
library(flextable)
library(onsvplot)
library(scales)
library(geobr)
library(sf)
library(reactable)
library(gt)
library(plotly)
library(leafsync)
library(ggiraph)
library(knitr)
source(here("R", "02-utils.R"))

estados <- read_state()
load(here("data", "revisoes.rda"))

font_families <- "-apple-system, BlinkMacSystemFont, Segoe UI, Helvetica, Arial, sans-serif"

tbl_red <- "#D7191C"
tbl_orange <- "#f05f22"
tbl_yellow <- "#f7951d"
tbl_green <- "#1fa149"
pal <- c(tbl_red, tbl_orange, tbl_yellow, tbl_green)
col_func <- function(x) rgb(colorRamp(c(pal))(x), maxColorValue = 255)

binned_pal <-
  colorBin(
    palette = pal,
    domain = seq(0, 10, 0.5),
    bins = c(0, 2.5, 5, 7.5, 10)
  )