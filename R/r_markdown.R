#
# Created date: 2019/2/5
# Author: mariko ohtsuka
# install.packages("rmarkdown")

library(rmarkdown)
library(rstudioapi)
library(knitr)
knitr::opts_chunk$set(echo=F, comment=NA)
# Getting the path of this program path
this_program_path <- rstudioapi::getActiveDocumentContext()$path
source_path <- getwd()
if (this_program_path != "") {
  temp_path <- unlist(strsplit(this_program_path, "/"))
  source_path <- paste(temp_path[-length(temp_path)], collapse="/")
}
source(paste0(source_path, "/common.R"))
render("demog.R", output_dir=output_path )
render("treatment.R", output_dir=output_path )
