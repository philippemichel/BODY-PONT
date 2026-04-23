#  ------------------------------------------------------------------------
#
# Title : Import BodyPont
#    By : PhM
#  Date : 2026-04-23
#
#  ------------------------------------------------------------------------


library(baseph)
library(janitor)
library(readODS)
library(lubridate)
library(tidyverse)
library(labelled)

tt <- read_ods("datas/bodypont.ods", sheet = "data", na = c("", " ", "NA")) |>
  clean_names() |>
  #  mutate(across(is.character, as.factor)) |>
  mutate(across(starts_with("date"), mdy)) |>
  mutate(across(starts_with("heure"), hms)) |>
  mutate(
    delais_admission_scanner =
      (as.numeric((date_scanner + heure_scanner) - (date_admission + heure_admission))) / 60
  )

pp <- str_split(tt$pa, "/", simplify = TRUE)
tt$pa <- round((as.numeric(pp[, 1]) + as.numeric(pp[, 2]) * 2) / 3, 0)

bn <- read_ods("datas/bodypont.ods", sheet = "bnom", na = c("", " ", "NA"))
var_label(tt) <- bn$titre


# Save data ---------------------------------------------------------------
save(tt, file = "datas/bodypont.RData")
load("datas/bodypont.RData")
