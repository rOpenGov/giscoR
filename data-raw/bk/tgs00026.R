## code to prepare `tgs00026` dataset goes here

library(readxl)
t <- read_excel("data-raw/TGS000261603831362688.xlsx", range = "A10:M306")
t <- t[-1, ]


library(reshape2)
tmelt <- setNames(melt(t), c("geo", "time", "values"))
tmelt$time <- as.numeric(as.character(tmelt$time))

library(dplyr)

tgs00026 <- tmelt |> arrange(time, geo)

tgs00026 <- as.data.frame(tgs00026)

usethis::use_data(tgs00026, overwrite = TRUE)
