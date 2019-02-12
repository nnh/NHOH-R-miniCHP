# '
# ' Created date: 2019/2/12
# ' author: mariko ohtsuka
# ' output:
# '   html_document:
# 全治療例を分母とし、試験中に記録される全有害事象について頻度と割合、および全コースの最悪のgrade（CTCAE v4.0日本語訳JCOG/JSCO版）の頻度と割合を求める。
#・コース毎の表と、全コースとで最悪のgradeで合計７表で作成

SubsetAE <- function(df){
  temp_df <- df
  for (i in kCTCAEGrade) {
    sv_colnames <- colnames(temp_df)
    temp_col <- paste0(kAEGrade_Head, kCTCAEGrade[i])
    temp_df <- transform(temp_df, x=kAE_value)
    colnames(temp_df) <- c(sv_colnames, temp_col)
  }
  return(temp_df)
}
# 有害事象毎に集計
SummaryAE <- function(input_df, output_df){
  for (i in 1:nrow(input_df)) {
    temp_trm_num <-as.numeric(input_df[i, kAE_trm])
    for (j in 1:nrow(output_df)) {
      if (temp_trm_num == output_df[j, kAE_trm_num]) {
        temp_grade <- paste0(kAEGrade_Head, input_df[i, kAE_grd])
        output_df[j, temp_grade] <- output_df[j, temp_grade] + 1
        break
      }
    }
  }
  output_df <- output_df[ , -1]
  rownames(output_df) <- NULL
  return(output_df)
}
kAEGrade_Head <- "Grade"
kAE_value <- 0
kAE_trm <- "AETERM_trm"
kAE_grd <- "AETERM_grd"
kAE_trm_num <- paste0("num_", kAE_trm)
df_ae <- ae[!duplicated(ae$AETERM_trm), ]
df_ae$num_AETERM_trm <- as.numeric(df_ae$AETERM_trm)
df_ae <- df_ae[ , c("num_AETERM_trm", "AETERM_trm")]
#' ## n=`r all_treatment`
temp_ae <- SubsetAE(df_ae)
df_ae_all <- SummaryAE(ae, temp_ae)
kable(df_ae_all, format = "markdown")
