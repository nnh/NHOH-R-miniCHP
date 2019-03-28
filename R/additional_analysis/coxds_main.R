# coxds_main.R
# Created date: 2019/3/25
# Author: mariko ohtsuka
library(rprojroot)
library(stringr)
library(rmarkdown)
library(knitr)
knitr::opts_chunk$set(echo=F, comment=NA)
save_wd <- thisfile()
save_wd <- find_root(is_rstudio_project, save_wd)
source_path <- str_c(save_wd, "/R")
source(str_c(source_path, "/additional_analysis/coxds.R"))
render(str_c(source_path, "/additional_analysis/demog2.R"), output_dir=output_path, output_file="demog2.html")
save_coxds <- coxds
coxds$years <- coxds$years_pfs
coxds$censor <- ifelse(coxds$censor_pfs == 1, 0, 1)
pfsos <- "pfs_"
render(str_c(source_path, "/additional_analysis/cox.R"), output_dir=output_path, output_file="cox_pfs.html")
rm(coxds)
coxds <- save_coxds
coxds$years <- coxds$years_os
coxds$censor <- ifelse(coxds$censor_os == 1, 0, 1)
pfsos <- "os_"
render(str_c(source_path, "/additional_analysis/cox.R"), output_dir=output_path, output_file="cox_os.html")
rm(coxds)
coxds <- save_coxds
coxds$years <- coxds$years_dfs
coxds$censor <- ifelse(coxds$censor_dfs == 1, 0, 1)
pfsos <- "dfs_"
render(str_c(source_path, "/additional_analysis/cox.R"), output_dir=output_path, output_file="cox_dfs.html")
