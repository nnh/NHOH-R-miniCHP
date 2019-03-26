# cox.R
# Created date: 2019/3/26
# Author: mariko ohtsuka
# library, function section ------
#' @title
#' ConvertFactor
#' @description
#' Convert factor to numeric or string
#' @param
#' df : data frame
#' @return
#' converted data frame
ConvertFactor <- function(df){
  for (i in 1:ncol(df)) {
    if (class(df[ , i]) == "factor") {
      if (is.numeric(df[ , i])) {
        df[ , i] <- as.numeric(df[ , i])
      } else {
        df[ , i] <- as.character(df[ , i])
      }
    }
  }
  return(df)
}
#coxds <- ConvertFactor(coxdspfs)
coxds <-coxdspfs
#' ## 年齢
summary(coxph(Surv(years, censor) ~ age, data=coxds))
#' ## 性別
#' ### 0:男性, 1:女性
coxds$cox_sex <- ifelse(coxds$sex == "男性", 0, 1)
summary(coxph(Surv(years, censor) ~ cox_sex, data=coxds))
#' ## PS
#' ### 0,1,2
summary(coxph(Surv(years, censor) ~ ps, data=coxds))
#' ## stage
summary(coxph(Surv(years, censor) ~ ipi, data=coxds))
#' ## Marrow involvement
#' ### 0:陽性、1:陰性
coxds$cox_marrow <- ifelse(coxds$marrow == "陽性", 0, 1)
summary(coxph(Surv(years, censor) ~ cox_marrow, data=coxds))
#' ## Bulky disease
#' ### 0:なし、1:あり
coxds$cox_bulky <- ifelse(coxds$bulky == "なし", 0, 1)
summary(coxph(Surv(years, censor) ~ cox_bulky, data=coxds))
#' ## 肝_病変の有無
#' ### 0:なし、1:あり
coxds$cox_liver <- ifelse(coxds$liver == "なし", 0, 1)
summary(coxph(Surv(years, censor) ~ cox_liver, data=coxds))
#' ## 脾_病変の有無
#' ### 0:なし、1:あり
coxds$cox_spleen <- ifelse(coxds$spleen == "なし", 0, 1)
summary(coxph(Surv(years, censor) ~ cox_spleen, data=coxds))
#' ## 腎_病変の有無
#' ### 0:なし、1:あり
coxds$cox_kidney <- ifelse(coxds$kidney == "なし", 0, 1)
summary(coxph(Surv(years, censor) ~ cox_kidney, data=coxds))
#' ## B symptoms
#' ### 0:なし、1:あり
coxds$cox_bsymptom <- ifelse(coxds$bsymptom == "なし", 0, 1)
summary(coxph(Surv(years, censor) ~ cox_bsymptom, data=coxds))
#' ## Weight loss
#' ### 0:True、1:False
coxds$cox_weight <- ifelse(coxds$weight == T, 0, 1)
summary(coxph(Surv(years, censor) ~ cox_weight, data=coxds))
#' ## Night sweats
#' ### 0:True、1:False
coxds$cox_nsweats <- ifelse(coxds$nsweats == T, 0, 1)
summary(coxph(Surv(years, censor) ~ cox_nsweats, data=coxds))
#' ## Fever
#' ### 0:True、1:False
coxds$cox_fever <- ifelse(coxds$fever == T, 0, 1)
summary(coxph(Surv(years, censor) ~ cox_fever, data=coxds))
#' ## LDH IU/L
summary(coxph(Surv(years, censor) ~ ldh, data=coxds))
#' ## β2MG(mg/L)
summary(coxph(Surv(years, censor) ~ b2mg, data=coxds))
#' ## 血清sIL-2R
summary(coxph(Surv(years, censor) ~ sil2r, data=coxds))
