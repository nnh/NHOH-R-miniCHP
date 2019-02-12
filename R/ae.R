# '
# ' Created date: 2019/2/12
# ' author: mariko ohtsuka
# ' output:
# '   html_document:
# 全治療例を分母とし、試験中に記録される全有害事象について頻度と割合、および全コースの最悪のgrade（CTCAE v4.0日本語訳JCOG/JSCO版）の頻度と割合を求める。
#・コース毎の表と、全コースとで最悪のgradeで合計７表で作成
kGrade <- c(1:5)
df_ae <- ae[!duplicated(ae$AETERM_trm), ]
df_ae$num_AETERM_trm <- as.numeric(df_ae$AETERM_trm)
df_ae <- df_ae[ , c("num_AETERM_trm", "AETERM_trm")]
for (i in kGrade) {
  save_colnames <- colnames(df_ae)
  temp_col <- paste0("Grade", kGrade[i])
  df_ae <- transform(df_ae, x=0)
  colnames(df_ae) <- c(save_colnames, temp_col)
}
# 有害事象毎に集計
for (i in 1:nrow(ae)) {
  temp_trm_num <- as.numeric(ae[i, "AETERM_trm"])
  for (j in 1:nrow(df_ae)) {
    if (temp_trm_num == df_ae[j,"num_AETERM_trm"]) {
      df_ae[j, paste0("Grade", ae[i, "AETERM_grd"])] <- df_ae[j, paste0("Grade", ae[i, "AETERM_grd"])] + 1
      break
    }
  }
}
df_ae <- df_ae[ ,-1]
rownames(df_ae) <- NULL
#' ## n=`r all_treatment`
kable(df_ae, format = "markdown")
