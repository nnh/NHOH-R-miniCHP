# coxds_main.R
# Created date: 2019/3/25
# Author: mariko ohtsuka
library(rprojroot)
library(stringr)
library(knitr)
knitr::opts_chunk$set(echo=F, comment=NA)
save_wd <- thisfile()
save_wd <- find_root(is_rstudio_project, save_wd)
source_path <- str_c(save_wd, "/R")
source(str_c(source_path, "/additional_analysis/coxds.R"))

