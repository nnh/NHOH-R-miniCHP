# ' demog.R
# ' Created date: 2019/2/5
# ' author: mariko ohtsuka
# ' output:
# '   html_document:
# '     output_path:

# library, function section ------
# install.packages("rstudioapi")
knitr::opts_chunk$set(echo=F, comment=NA)
library(rstudioapi)
#' # demog
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
#' ## PS
PS
# IPI scores
IPI_scores <- AggregateLength(ptdata$in_patholo_ctg, "stage")
#' ## IPI scores
IPI_scores
# Marrow involvement, n(%)
temp_marrow_involvement <- ptdata[ ,c("in_bmp_lesions", "in_bmb_lesions")]
temp_marrow_involvement$lesions <- "なし"
for (i in 1:nrow(temp_marrow_involvement)) {
  if (!is.na(ptdata[i, "in_bmp_lesions"])) {
    if (as.numeric(ptdata[i, "in_bmp_lesions"]) == 2 | as.numeric(ptdata[i, "in_bmp_lesions"]) == 3) {
    temp_marrow_involvement[i, "lesions"] <- "あり"
    }
  }
  if (!is.na(ptdata[i, "in_bmb_lesions"])) {
    if (as.numeric(ptdata[i, "in_bmb_lesions"]) == 2 | as.numeric(ptdata[i, "in_bmb_lesions"]) == 3) {
      temp_marrow_involvement[i, "lesions"] <- "あり"
    }
  }
  if (is.na(ptdata[i, "in_bmp_lesions"]) && is.na(ptdata[i, "in_bmb_lesions"])) {
    temp_marrow_involvement[i, "lesions"] <- NA
  }
}
Marrow_involvement <- AggregateLength(temp_marrow_involvement$lesions, "Marrow_involvement")
Marrow_involvement$per <- prop.table(Marrow_involvement$count)
#' ## Marrow involvement, n(%)
Marrow_involvement
#' ## Bulky disease,n(%)
Bulky_disease <- AggregateLength(ptdata$in_bulky_yn, "Bulky disease")
Bulky_disease$per <- prop.table(Bulky_disease$count)
Bulky_disease
#' ## Extra nodal disease,n(%)
#' ### liver
Extra_nodal_disease_liver <- AggregateLength(ptdata$in_liver_yn, "liver")
Extra_nodal_disease_liver$per <- prop.table(Extra_nodal_disease_liver$count)
Extra_nodal_disease_liver
#' ### spleen
Extra_nodal_disease_spleen <- AggregateLength(ptdata$in_spleen_yn, "spleen")
Extra_nodal_disease_spleen$per <- prop.table(Extra_nodal_disease_spleen$count)
Extra_nodal_disease_spleen
#' ### renal
Extra_nodal_disease_renal <- AggregateLength(ptdata$in_renal_yn, "renal")
Extra_nodal_disease_renal$per <- prop.table(Extra_nodal_disease_renal$count)
Extra_nodal_disease_renal
#' ## B symptoms
B_symptoms <- AggregateLength(ptdata$in_b_yn, "B_symptoms")
B_symptoms
#' ### 3:weight loss / 2:night sweats / 1:fever
temp_b_symptoms <- subset(ptdata, !is.na(in_b_select))
temp_b_symptoms$in_b_select <- factor(temp_b_symptoms$in_b_select, levels = c(1,2,3),
                                      labels = c("fever", "night sweats", "weight loss"))
B_symptoms_details <- AggregateLength(temp_b_symptoms$in_b_select, "b_symptoms")
B_symptoms_details
# '## LDH IU/L
temp_ldh <- ptdata
temp_ldh$ldh_f <- ifelse(temp_ldh$in_lborres_ldh < 250, "<250", "250=<")
LDH <- AggregateLength(temp_ldh$ldh_f, "LDH")
LDH
# '## β2MG(mg/L)
