# ' demog.R
# ' Created date: 2019/2/5
# ' author: mariko ohtsuka
# ' output:
# '   html_document:

#' ## Number of patients (%)
Number_of_patients <- paste0("n=", all_registration, " (", all_registration / all_registration * 100, "%)")
Number_of_patients
# Median age [IQR] (range), years *1
# Male sex,n(%)
# PS 0, 1, over 2
PS <- AggregateLength(ptdata$in_qsorres_ps, "grade")
#' ## PS
kable(PS, format = "markdown")
# IPI scores
IPI_scores <- AggregateLength(ptdata$in_patholo_ctg, "stage")
#' ## IPI scores
kable(IPI_scores, format = "markdown")
# Marrow involvement, n(%)
temp_marrow_involvement <- ptdata[ ,c("in_bmp_lesions", "in_bmb_lesions")]
temp_marrow_involvement$lesions <- "なし"
for (i in 1:nrow(temp_marrow_involvement)) {
  if (!is.na(ptdata[i, "in_bmp_lesions"])) {
    if (as.numeric(ptdata[i, "in_bmp_lesions"]) == 2) {
    temp_marrow_involvement[i, "lesions"] <- "あり"
    }
  }
  if (!is.na(ptdata[i, "in_bmb_lesions"])) {
    if (as.numeric(ptdata[i, "in_bmb_lesions"]) == 2) {
      temp_marrow_involvement[i, "lesions"] <- "あり"
    }
  }
  if (is.na(ptdata[i, "in_bmp_lesions"]) && is.na(ptdata[i, "in_bmb_lesions"])) {
    temp_marrow_involvement[i, "lesions"] <- NA
  }
}
#' ## Marrow involvement, n(%)
Marrow_involvement <- AggregateLength(temp_marrow_involvement$lesions, "Marrow_involvement")
kable(Marrow_involvement, format = "markdown")
#' ## Bulky disease,n(%)
Bulky_disease <- AggregateLength(ptdata$in_bulky_yn, "Bulky disease")
kable(Bulky_disease, format = "markdown")
#' ## Extra nodal disease,n(%)
#' ### liver
Extra_nodal_disease_liver <- AggregateLength(ptdata$in_liver_yn, "liver")
kable(Extra_nodal_disease_liver, format = "markdown")
#' ### spleen
Extra_nodal_disease_spleen <- AggregateLength(ptdata$in_spleen_yn, "spleen")
kable(Extra_nodal_disease_spleen, format = "markdown")
#' ### renal
Extra_nodal_disease_renal <- AggregateLength(ptdata$in_renal_yn, "renal")
kable(Extra_nodal_disease_renal, format = "markdown")
#' ## B symptoms
B_symptoms <- AggregateLength(ptdata$in_b_yn, "B_symptoms")
kable(B_symptoms, format = "markdown")
#' ### 3:weight loss / 2:night sweats / 1:fever
temp_b_symptoms <- subset(ptdata, !is.na(in_b_select))
temp_b_symptoms$in_b_select <- factor(temp_b_symptoms$in_b_select, levels = c(1,2,3),
                                      labels = c("fever", "night sweats", "weight loss"))
B_symptoms_details <- AggregateLength(temp_b_symptoms$in_b_select, "b_symptoms")
kable(B_symptoms_details, format = "markdown")
#' ## LDH IU/L
temp_ldh <- ptdata
temp_ldh$ldh_f <- ifelse(temp_ldh$in_lborres_ldh < 250, "<250", "250=<")
LDH <- AggregateLength(temp_ldh$ldh_f, "LDH")
kable(LDH, format = "markdown")
#' ## β2MG(mg/L)    (n=`r all_qualification`)
Beta2MG <- summary(ptdata$in_lborres_b2mg)
sd_Beta2MG <- sd(ptdata$in_lborres_b2mg)
names(sd_Beta2MG) <- "Sd."
Beta2MG <- c(Beta2MG, sd_Beta2MG)
Beta2MG
#' ## 血清sIL-2R    (n=`r all_qualification`)
sIL_2R <- summary(ptdata$in_lborres_sil2r)
sd_sIL_2R <- sd(ptdata$in_lborres_sil2r)
names(sd_sIL_2R) <- "Sd."
sIL_2R <- c(sIL_2R, sd_sIL_2R)
sIL_2R
