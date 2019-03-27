# cox.R
# Created date: 2019/3/26
# Author: mariko ohtsuka
#' ## 年齢
#' ### 0:84歳以上、1:84歳より下
coxds$cox_age <- ifelse(coxds$agec == "84<", 0, 1)
summary(coxph(Surv(years, censor) ~ cox_age, data=coxds))
#' ## 性別
#' ### 0:男性, 1:女性
coxds$cox_sex <- ifelse(coxds$sex == "男性", 0, 1)
summary(coxph(Surv(years, censor) ~ cox_sex, data=coxds))
#' ## PS
coxds$cox_ps <- ifelse(as.numeric(as.character(coxds$ps)) <= 1, 0, 1)
summary(coxph(Surv(years, censor) ~ cox_ps, data=coxds))
#' ## stage
#' ### 0:=<II、1:=>III
coxds$cox_stage <- ifelse(coxds$stagec == "=<II", 0, 1)
summary(coxph(Surv(years, censor) ~ cox_stage, data=coxds))
#' ## ipi
summary(coxph(Surv(years, censor) ~ ipi, data=coxds))
#' ## Marrow involvement
#' ### 0:陽性、1:陰性
coxds$cox_marrow <- ifelse(coxds$marrow == "陰性", 0, 1)
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
#' ### 0:<250、1:250=<
coxds$cox_ldh <- ifelse(coxds$ldh == "<250", 0, 1)
summary(coxph(Surv(years, censor) ~ cox_ldh, data=coxds))
#' ## β2MG(mg/L)
summary(coxph(Surv(years, censor) ~ b2mg, data=coxds))
#' ## 血清sIL-2R
summary(coxph(Surv(years, censor) ~ sil2r, data=coxds))
