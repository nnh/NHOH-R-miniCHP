# '
# ' Created date: 2019/2/12
# ' author: mariko ohtsuka
# ' output:
# '   html_document:
# 全治療例を分母とし、試験中に記録される全有害事象について頻度と割合、および全コースの最悪のgrade（CTCAE v4.0日本語訳JCOG/JSCO版）の頻度と割合を求める。
#・コース毎の表と、全コースとで最悪のgradeで合計７表で作成

SummaryAE <- function(df){
  temp_df <- df[!duplicated(df[ ,kAE_trm]), ]
  temp_df[ , kAE_trm_num] <- as.numeric(temp_df[ , kAE_trm])
  temp_df <- temp_df[ , c(kAE_trm_num, kAE_trm)]
  for (i in kCTCAEGrade) {
    sv_colnames <- colnames(temp_df)
    temp_col <- paste0(kAEGrade_Head, kCTCAEGrade[i])
    temp_df <- transform(temp_df, x=kAE_value)
    colnames(temp_df) <- c(sv_colnames, temp_col)
  }
  # 有害事象毎に集計
  for (i in 1:nrow(df)) {
    temp_trm_num <-as.numeric(df[i, kAE_trm])
    for (j in 1:nrow(temp_df)) {
      if (temp_trm_num == temp_df[j, kAE_trm_num]) {
        temp_grade <- paste0(kAEGrade_Head, df[i, kAE_grd])
        temp_df[j, temp_grade] <- temp_df[j, temp_grade] + 1
        break
      }
    }
  }
  temp_df <- temp_df[ , -1]
  rownames(temp_df) <- NULL
  return(temp_df)
}
kAEGrade_Head <- "Grade"
kAE_value <- 0
kAE_trm <- "AETERM_trm"
kAE_grd <- "AETERM_grd"
kAE_trm_num <- paste0("num_", kAE_trm)
#' ## n=`r all_treatment`
df_ae_all <- SummaryAE(ae)
kable(df_ae_all, format = "markdown")
for (i in kCourse_count) {
  temp_df_course <- subset(treatment_course, Option..Value.code == i)
  temp_course <- temp_df_course$Option..Value.name
  temp_output <- paste0("output_ae_", i)
  assign(temp_output, SummaryAE(subset(ae, ae_epoch == temp_course)))
}
kable(output_ae_1, format = "markdown")
kable(output_ae_2, format = "markdown")
kable(output_ae_3, format = "markdown")
kable(output_ae_4, format = "markdown")
kable(output_ae_5, format = "markdown")
kable(output_ae_6, format = "markdown")
