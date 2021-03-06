# ' demog.R
# ' Created date: 2019/2/5
# ' author: mariko ohtsuka
# ' output:
# '   html_document:
# Constant section ------
kIpi_scores <- c("low risk", "low intermediate risk", "high intermediate risk", "high risk")
# Main section ------
#' ## Number of patients (%)
number_of_patients <- paste0("n=", all_qualification, " (", all_qualification / all_qualification * 100, "%)")
#' ### `r number_of_patients`
#' ## Median age [IQR] (range), years *1
df_age_sex <- merge(ptdata, birth_date_sex[ ,c("症例登録番号", "生年月日", "field4")],
                    all=F, by.x="SUBJID", by.y="症例登録番号")
df_age_sex$age <- NA
for (i in 1:nrow(df_age_sex)) {
  if (!is.na(df_age_sex[i, "reg_day"])) {
    df_age_sex[i, "age"] <- length(seq(df_age_sex[i,"生年月日"], df_age_sex[i, "reg_day"], "year")) - 1
  }
}
age_summary <- SummaryValue(df_age_sex$age)
kable(age_summary, format = "markdown")
#' ## Male sex,n(%)
df_age_sex$field4 <- factor(df_age_sex$field4, levels=c(0, 1), labels=c("male", "female"))
sex <- AggregateLength(df_age_sex$field4, "sex")
kable(sex, format = "markdown")
# PS 0, 1, over 2
ps <- AggregateLength(ptdata$in_qsorres_ps, "grade")
#' ## PS
kable(ps, format = "markdown")
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
  } else if (df_ipi[i,"ipi"] == 4) {
    df_ipi[i, "score"] <- 4
  } else if (df_ipi[i,"ipi"] == 5) {
    df_ipi[i, "score"] <- 5
  } else {
    df_ipi[i, "score"] <- NA
  }
}
# df_ipi$score <- factor(df_ipi$score, levels=c(1, 2, 3, 4), labels=kIpi_scores)
ipi_scores <- AggregateLength(df_ipi$score, "ipi_scores")
#' ## IPI scores
kable(ipi_scores, format = "markdown")
# Stage
stage <- AggregateLength(ptdata$in_patholo_ctg, "stage")
#' ## Stage
kable(stage, format = "markdown")
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
marrow_involvement <- AggregateLength(temp_marrow_involvement$lesions, "Marrow_involvement")
kable(marrow_involvement, format = "markdown")
#' ## Bulky disease,n(%)
bulky_disease <- AggregateLength(ptdata$in_bulky_yn, "Bulky disease")
kable(bulky_disease, format = "markdown")
#' ## Extra nodal disease,n(%)
#' ### liver
extra_nodal_disease_liver <- AggregateLength(ptdata$in_liver_yn, "liver")
kable(extra_nodal_disease_liver, format = "markdown")
#' ### spleen
extra_nodal_disease_spleen <- AggregateLength(ptdata$in_spleen_yn, "spleen")
kable(extra_nodal_disease_spleen, format = "markdown")
#' ### renal
extra_nodal_disease_renal <- AggregateLength(ptdata$in_renal_yn, "renal")
kable(extra_nodal_disease_renal, format = "markdown")
#' ## B symptoms
b_symptoms <- AggregateLength(ptdata$in_b_yn, "B_symptoms")
kable(b_symptoms, format = "markdown")
#' ### 3:weight loss / 2:night sweats / 1:fever
temp_b_symptoms <- subset(ptdata, !is.na(in_b_select))
temp_b_symptoms$in_b_select <- factor(temp_b_symptoms$in_b_select, levels = c(1,2,3),
                                      labels = c("fever", "night sweats", "weight loss"))
b_symptoms_details <- AggregateLength(temp_b_symptoms$in_b_select, "b_symptoms")
b_symptoms_details$per <- round(b_symptoms_details$count / all_qualification * 100, digits=1)
kable(b_symptoms_details, format = "markdown")
#' ## LDH IU/L
temp_ldh <- ptdata
temp_ldh$ldh_f <- ifelse(temp_ldh$in_lborres_ldh < 250, "<250", "250=<")
ldh <- AggregateLength(temp_ldh$ldh_f, "LDH")
kable(ldh, format = "markdown")
# β2MG(mg/L)
# 欠測-1を除去
temp_in_lborres_b2mg <- subset(ptdata, in_lborres_b2mg != kNA_lb)$in_lborres_b2mg
#' ## β2MG(mg/L)
#' ### n=`r length(temp_in_lborres_b2mg)`
beta2MG <- SummaryValue(temp_in_lborres_b2mg)
kable(beta2MG, format = "markdown")
# 血清sIL-2R
# 欠測-1を除去
temp_in_lborres_sil2r <-  subset(ptdata, in_lborres_sil2r != kNA_lb)$in_lborres_sil2r
#' ## 血清sIL-2R
#' ### n=`r length(temp_in_lborres_sil2r)`
sIL_2R <- SummaryValue(temp_in_lborres_sil2r)
kable(sIL_2R, format = "markdown")
#' ## ALB  in_lborres_lab
alb <- SummaryValue(ptdata$in_lborres_lab)
kable(alb, format = "markdown")
alb_u <- nrow(subset(ptdata, in_lborres_lab >3.5))
alb_l <- nrow(subset(ptdata, in_lborres_lab <=3.5))
alb_u_per <- alb_u / nrow(ptdata) * 100
alb_l_per <- alb_l / nrow(ptdata) * 100
print(paste0(">3.5 : ", alb_u, "(", alb_u_per, "%)"))
print(paste0("<=3.5 : ", alb_l, "(", alb_l_per, "%)"))

alb_u_2 <- nrow(subset(ptdata, in_lborres_lab >=3.5))
alb_l_2 <- nrow(subset(ptdata, in_lborres_lab <3.5))
alb_u_per_2 <- alb_u_2 / nrow(ptdata) * 100
alb_l_per_2 <- alb_l_2 / nrow(ptdata) * 100
print(paste0(">=3.5 : ", alb_u_2, "(", alb_u_per_2, "%)"))
print(paste0("<3.5 : ", alb_l_2, "(", alb_l_per_2, "%)"))
#' # 輸血の有無:あり
#' ## 血小板
#' ### 1コース
fs1_cmoccur_plt <- AggregateLength(ptdata$fs1_cmoccur_plt, "fs1_cmoccur_plt")
kable(fs1_cmoccur_plt, format = "markdown")
#'  症例番号
subset(ptdata, fs1_cmoccur_plt == "あり")[,"SUBJID"]
#' ###  2コース
fs2_cmoccur_plt <- AggregateLength(ptdata$fs2_cmoccur_plt, "fs2_cmoccur_plt")
kable(fs2_cmoccur_plt, format = "markdown")
#'  症例番号
subset(ptdata, fs2_cmoccur_plt == "あり")[,"SUBJID"]
#' ###  3コース
fs3_cmoccur_plt <- AggregateLength(ptdata$fs3_cmoccur_plt, "fs3_cmoccur_plt")
kable(fs3_cmoccur_plt, format = "markdown")
#'  症例番号
subset(ptdata, fs3_cmoccur_plt == "あり")[,"SUBJID"]
#' ###  4コース
fs4_cmoccur_plt <- AggregateLength(ptdata$fs4_cmoccur_plt, "fs4_cmoccur_plt")
kable(fs4_cmoccur_plt, format = "markdown")
#'  症例番号
subset(ptdata, fs4_cmoccur_plt == "あり")[,"SUBJID"]
#' ###  5コース
fs6_cmoccur_plt <- AggregateLength(ptdata$fs6_cmoccur_plt, "fs6_cmoccur_plt")
kable(fs6_cmoccur_plt, format = "markdown")
#'  症例番号
subset(ptdata, fs6_cmoccur_plt == "あり")[,"SUBJID"]
#' ###  6コース
fs5_cmoccur_plt <- AggregateLength(ptdata$fs5_cmoccur_plt, "fs5_cmoccur_plt")
kable(fs5_cmoccur_plt, format = "markdown")
#'  症例番号
subset(ptdata, fs5_cmoccur_plt == "あり")[,"SUBJID"]
#' ##  赤血球
#' ###  1コース
fs1_cmoccur_rbc <- AggregateLength(ptdata$fs1_cmoccur_rbc, "fs1_cmoccur_rbc")
kable(fs1_cmoccur_rbc, format = "markdown")
#'  症例番号
subset(ptdata, fs1_cmoccur_rbc == "あり")[,"SUBJID"]
#' ###  2コース
fs2_cmoccur_rbc <- AggregateLength(ptdata$fs2_cmoccur_rbc, "fs2_cmoccur_rbc")
kable(fs2_cmoccur_rbc, format = "markdown")
#'  症例番号
subset(ptdata, fs2_cmoccur_rbc == "あり")[,"SUBJID"]
#' ###  3コース
fs3_cmoccur_rbc <- AggregateLength(ptdata$fs3_cmoccur_rbc, "fs3_cmoccur_rbc")
kable(fs3_cmoccur_rbc, format = "markdown")
#'  症例番号
subset(ptdata, fs3_cmoccur_rbc == "あり")[,"SUBJID"]
#' ###  4コース
fs4_cmoccur_rbc <- AggregateLength(ptdata$fs4_cmoccur_rbc, "fs4_cmoccur_rbc")
kable(fs4_cmoccur_rbc, format = "markdown")
#'  症例番号
subset(ptdata, fs4_cmoccur_rbc == "あり")[,"SUBJID"]
#' ###  5コース
fs6_cmoccur_rbc <- AggregateLength(ptdata$fs6_cmoccur_rbc, "fs6_cmoccur_rbc")
kable(fs6_cmoccur_rbc, format = "markdown")
#'  症例番号
subset(ptdata, fs6_cmoccur_rbc == "あり")[,"SUBJID"]
#' ###  6コース
fs5_cmoccur_rbc <- AggregateLength(ptdata$fs5_cmoccur_rbc, "fs5_cmoccur_rbc")
kable(fs5_cmoccur_rbc, format = "markdown")
#'  症例番号
subset(ptdata, fs5_cmoccur_rbc == "あり")[,"SUBJID"]
#' # 発熱性好中球減少症：グレード
#' ## 1コース
fs1_aetoxgr_fn_grd <- AggregateLength(ptdata$fs1_aetoxgr_fn_grd, "fs1_aetoxgr_fn_grd")
kable(fs1_aetoxgr_fn_grd, format = "markdown")
#'  症例番号
subset(ptdata, fs1_aetoxgr_fn_grd > 0)[,"SUBJID"]
#' ## 2コース
fs2_aetoxgr_fn_grd <- AggregateLength(ptdata$fs2_aetoxgr_fn_grd, "fs2_aetoxgr_fn_grd")
kable(fs2_aetoxgr_fn_grd, format = "markdown")
#'  症例番号
subset(ptdata, fs2_aetoxgr_fn_grd > 0)[,"SUBJID"]
#' ## 3コース
fs3_aetoxgr_fn_grd <- AggregateLength(ptdata$fs3_aetoxgr_fn_grd, "fs3_aetoxgr_fn_grd")
kable(fs3_aetoxgr_fn_grd, format = "markdown")
#'  症例番号
subset(ptdata, fs3_aetoxgr_fn_grd > 0)[,"SUBJID"]
#' ## 4コース
fs4_aetoxgr_fn_grd <- AggregateLength(ptdata$fs4_aetoxgr_fn_grd, "fs4_aetoxgr_fn_grd")
kable(fs4_aetoxgr_fn_grd, format = "markdown")
#'  症例番号
subset(ptdata, fs4_aetoxgr_fn_grd > 0)[,"SUBJID"]
#' ## 5コース
fs5_aetoxgr_fn_grd <- AggregateLength(ptdata$fs5_aetoxgr_fn_grd, "fs5_aetoxgr_fn_grd")
kable(fs5_aetoxgr_fn_grd, format = "markdown")
#'  症例番号
subset(ptdata, fs5_aetoxgr_fn_grd > 0)[,"SUBJID"]
#' ## 6コース
fs6_aetoxgr_fn_grd <- AggregateLength(ptdata$fs6_aetoxgr_fn_grd, "fs6_aetoxgr_fn_grd")
kable(fs6_aetoxgr_fn_grd, format = "markdown")
#'  症例番号
subset(ptdata, fs6_aetoxgr_fn_grd > 0)[,"SUBJID"]
