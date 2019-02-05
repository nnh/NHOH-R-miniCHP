#
# Created date: 2019/2/5
# Author: mariko ohtsuka

# library, function section ------
# install.packages("rstudioapi")
library(rstudioapi)

# Getting the path of this program path
this_program_path <- rstudioapi::getActiveDocumentContext()$path
source_path <- getwd()
if (this_program_path != "") {
  temp_path <- unlist(strsplit(this_program_path, "/"))
  source_path <- paste(temp_path[-length(temp_path)], collapse="/")
}
source(paste0(source_path, "/common.R"))
# Number of patients (%)
# Median age [IQR] (range), years *1
# Male sex,n(%)
# PS 0, 1, over 2
PS <- AggregateLength(ptdata$in_qsorres_ps, "grade")
# IPI scores
IPI_scores <- AggregateLength(ptdata$in_patholo_ctg, "stage")
# Marrow involvement, n(%)
#Marrow_involvement <- ptdata[ ,c("in_bmp_lesions", "in_bmb_lesions")]
#in_bmp_lesions$per <- in_bmp_lesions$count / all_registration * 100
# Bulky disease,n(%)
