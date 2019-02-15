# ' ae.R
# ' Created date: 2019/2/12
# ' author: mariko ohtsuka
# ' output:
# '   html_document:
# library, function section ------
#' @title
#' SummaryAE
#' @param
#' df : AE dataframe (all courses or per course)
#' num_per : Parameter
#' @return
#' data frame
SummaryAE <- function(df, num_per){
  temp_df <- df[!duplicated(df[ ,kAE_trm]), ]
  temp_df[ , kAE_trm_num] <- as.numeric(temp_df[ , kAE_trm])
  temp_df <- temp_df[ , c(kAE_trm_num, kAE_trm)]
  for (i in kCTCAEGrade) {
    sv_colnames <- colnames(temp_df)
    temp_col <- paste0(kAEGrade_Head, kCTCAEGrade[i])
    temp_df <- transform(temp_df, x=kAE_value)
    colnames(temp_df) <- c(sv_colnames, temp_col)
  }
  # Aggregate for each adverse event
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
  # Add a total column of over Grade 3
  temp_df$over_Grade3 <- temp_df[paste0(kAEGrade_Head, 3)] + temp_df[paste0(kAEGrade_Head, 4)] + temp_df[paste0(kAEGrade_Head, 5)]
  # Percentage
  for (i in 1:nrow(temp_df)) {
    for (j in 3:ncol(temp_df)) {
      if (temp_df[i, j] > 0) {
        temp_per <- round(as.numeric(temp_df[i, j]) / num_per * 100, digits=1)
        temp_df[i, j] <- paste0(temp_df[i, j], " (", temp_per, "%)")
      } else {
        temp_df[i, j] <- " "
      }
    }
  }
  # Delete columns of Grade1, Grade2, working column
  temp_df <- temp_df[ , -4]
  temp_df <- temp_df[ , -3]
  temp_df <- temp_df[ , -1]
  rownames(temp_df) <- NULL
  return(temp_df)
}
# Constant section ------
kAEGrade_Head <- "Grade"
kAE_value <- 0
kAE_trm <- "AETERM_trm"
kAE_grd <- "AETERM_grd"
kAE_trm_num <- paste0("num_", kAE_trm)
# main section ------
# merge ae and sae_report
sae_ae <- sae_report[ , c("SUBJID", "AETERM_trm", "AETERM_grd", "ae_epoch")]
sae_ae$AEDUR <- NA
sae_ae$AESTDTC <- sae_report$AESTDTC
sae_ae$AEENDTC <- NA
sae_ae$AEREL <- sae_report$AEREL
sae_ae$AEOUT <- sae_report$AEOUT
sae_ae$aeout_dtc <- sae_report$aeout_dtc
merge_sae_ae <- rbind(ae, sae_ae)
# Grade3 or more only
ae_overG3 <- subset(merge_sae_ae, merge_sae_ae[kAE_grd] >=3)
#' # 全コース
#' ## n=`r all_treatment`
# Get the worst Grade for each patient, if there is more than one same AE in the same patient
sort_ae_overG3 <- ae_overG3[order(ae_overG3$SUBJID, ae_overG3$AETERM_trm, ae_overG3$AETERM_grd, decreasing=T), ]
sort_ae_overG3$del_f <- F
for (i in 2:nrow(sort_ae_overG3)) {
  if (sort_ae_overG3[i, "SUBJID"] == sort_ae_overG3[i - 1, "SUBJID"] &&
      sort_ae_overG3[i, kAE_trm] == sort_ae_overG3[i - 1, kAE_trm] &&
      sort_ae_overG3[i, kAE_grd] == sort_ae_overG3[i - 1, kAE_grd]) {
    sort_ae_overG3[i, "del_f"] <- T
  }
}
df_ae_all <- SummaryAE(subset(sort_ae_overG3, del_f == F), all_treatment)
kable(df_ae_all, format = "markdown")
for (i in kCourse_count) {
  temp_df_course <- subset(treatment_course, Option..Value.code == i)
  temp_course <- temp_df_course$Option..Value.name
  temp_output <- paste0("output_ae_", i)
  temp_course_per <- paste0("ae_per_", i)
  assign(temp_course_per, df_treatment_course[i, "count"])
  temp_df_ae <- subset(ae_overG3, ae_epoch == temp_course)
  if (nrow(temp_df_ae) > 0) {
    assign(temp_output, SummaryAE(temp_df_ae, get(temp_course_per)))
  } else {
    assign(temp_output, "該当なし")
  }
}
i <- 1
num_per <- get(paste0("ae_per_", i))
i <- i + 1
#' # `r treatment_course[i, "Option..Value.name"]`
#' ## n=`r num_per`
kable(output_ae_1, format = "markdown")
num_per <- get(paste0("ae_per_", i))
i <- i + 1
#' # `r treatment_course[i, "Option..Value.name"]`
#' ## n=`r num_per`
kable(output_ae_2, format = "markdown")
num_per <- get(paste0("ae_per_", i))
i <- i + 1
#' # `r treatment_course[i, "Option..Value.name"]`
#' ## n=`r num_per`
kable(output_ae_3, format = "markdown")
num_per <- get(paste0("ae_per_", i))
i <- i + 1
#' # `r treatment_course[i, "Option..Value.name"]`
#' ## n=`r num_per`
kable(output_ae_4, format = "markdown")
num_per <- get(paste0("ae_per_", i))
i <- i + 1
#' # `r treatment_course[i, "Option..Value.name"]`
#' ## n=`r num_per`
kable(output_ae_5, format = "markdown")
num_per <- get(paste0("ae_per_", i))
i <- i + 1
#' # `r treatment_course[i, "Option..Value.name"]`
#' ## n=`r num_per`
kable(output_ae_6, format = "markdown")
