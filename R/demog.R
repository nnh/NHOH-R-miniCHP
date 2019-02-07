# ' demog.R
# ' Created date: 2019/2/5
# ' author: mariko ohtsuka
# ' output:
# '   html_document:
kIpi_scores <- c("low risk", "low intermediate risk", "high intermediate risk", "high risk")

#' ## Number of patients (%)
Number_of_patients <- paste0("n=", all_qualification, " (", all_qualification / all_qualification * 100, "%)")
kable(Number_of_patients, format = "markdown")
#' ## Median age [IQR] (range), years *1
df_age_sex <- merge(ptdata, birth_date_sex[ ,c("症例登録番号", "生年月日", "field4")],
                    all=F, by.x="SUBJID", by.y="症例登録番号")
df_age_sex$age <- NA
for (i in 1:nrow(df_age_sex)) {
  if (!is.na(df_age_sex[i, "reg_day"])) {
    df_age_sex[i, "age"] <- length(seq(df_age_sex[i,"生年月日"], df_age_sex[i, "reg_day"], "year")) - 1
  }
}
Age_smr <- SummaryValue(df_age_sex$age)
kable(Age_smr, format = "markdown")
#' ## Male sex,n(%)
df_age_sex$field4 <- factor(df_age_sex$field4, levels=c(0, 1), labels=c("male", "female"))
Sex <- AggregateLength(df_age_sex$field4, "sex")
kable(Sex, format = "markdown")
# PS 0, 1, over 2
PS <- AggregateLength(ptdata$in_qsorres_ps, "grade")
#' ## PS
kable(PS, format = "markdown")
# IPI scores
df_ipi <- df_age_sex
df_ipi$ipi <- NA
df_ipi$score <- NA
for (i in 1:nrow(df_ipi)) {
  temp_score <- 0
  temp_in_score <- 0
  if (df_ipi[i, "age"] >= 61) {
    temp_score <- temp_score + 1
  }
  if (df_ipi[i, "in_lborres_ldh"] >= 250) {
    temp_score <- temp_score + 1
  }
  if (df_ipi[i, "in_patholo_ctg"] == "III"| df_ipi[i, "in_patholo_ctg"] == "III E" | df_ipi[i, "in_patholo_ctg"] == "IV") {
    temp_score <- temp_score + 1
  }
  temp_in <- c(df_ipi[i, "in_liver_yn"], df_ipi[i, "in_spleen_yn"], df_ipi[i, "in_renal_yn"])
  for (j in 1:length(temp_in)) {
    if (temp_in[j] == 1) {
      temp_in_score <- temp_in_score + 0.5
    }
  }
  temp_score <- temp_score + trunc(temp_in_score)
  temp_ps <- as.numeric(as.character(df_ipi[i, "in_qsorres_ps"]))
  if (temp_ps >= 2) {
    temp_score <- temp_score + 1
  }
  df_ipi[i,"ipi"] <- temp_score
  if (df_ipi[i,"ipi"] <= 1) {
    df_ipi[i, "score"] <- 1
  } else if (df_ipi[i,"ipi"] == 2) {
    df_ipi[i, "score"] <- 2
  } else if (df_ipi[i,"ipi"] == 3) {
    df_ipi[i, "score"] <- 3
  } else if (df_ipi[i,"ipi"] >= 4) {
    df_ipi[i, "score"] <- 4
  } else {
    df_ipi[i, "score"] <- NA
  }
}
df_ipi$score <- factor(df_ipi$score, levels=c(1, 2, 3, 4), labels=kIpi_scores)
IPI_scores <- AggregateLength(df_ipi$score, "ipi_scores")
#' ## IPI scores
kable(IPI_scores, format = "markdown")
# Stage
Stage <- AggregateLength(ptdata$in_patholo_ctg, "stage")
#' ## Stage
kable(Stage, format = "markdown")
# Marrow involvement, n(%)
temp_marrow_involvement <- ptdata[ ,c("in_bmp_lesions", "in_bmb_lesions")]
temp_marrow_involvement$lesions <- "なし"
for (i in 1:nrow(temp_marrow_involvement)) {
  if (!is.na(ptdata[i, "in_bmp_lesions"]) && ptdata[i, "in_bmp_lesions"] == "陽性") {
    temp_marrow_involvement[i, "lesions"] <- "あり"
  }
  if (!is.na(ptdata[i, "in_bmb_lesions"]) && ptdata[i, "in_bmb_lesions"] == "陽性") {
    temp_marrow_involvement[i, "lesions"] <- "あり"
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
# β2MG(mg/L)
# 欠測-1を除去
temp_in_lborres_b2mg <- subset(ptdata, in_lborres_b2mg != kNA_lb)$in_lborres_b2mg
#' ## β2MG(mg/L)    (n=`r length(temp_in_lborres_b2mg)`)
Beta2MG <- SummaryValue(temp_in_lborres_b2mg)
kable(Beta2MG, format = "markdown")
# 血清sIL-2R
# 欠測-1を除去
temp_in_lborres_sil2r <-  subset(ptdata, in_lborres_sil2r != kNA_lb)$in_lborres_sil2r
#' ## 血清sIL-2R    (n=`r length(temp_in_lborres_sil2r)`)
sIL_2R <- SummaryValue(temp_in_lborres_sil2r)
kable(sIL_2R, format = "markdown")

