# cox.R
# Created date: 2019/3/26
# Author: mariko ohtsuka
#' @title
#' round2
#' @description
#' Customize round function
#' Reference URL
#' r - Round up from .5 - Stack Overflow
#' https://stackoverflow.com/questions/12688717/round-up-from-5
#' @param
#' x : Number to be rounded
#' digits : Number of decimal places
#' @return
#' Rounded number
#' @examples
#' round2(3.1415, 2)
round2 <- function(x, digits) {
  posneg = sign(x)
  z = abs(x) * 10^digits
  z = z + 0.5
  z = trunc(z)
  z = z / 10^digits
  return(z * posneg)
}
compare_df <- data.frame(matrix(rep(NA, 4), nrow=1))[numeric(0), ]
#' ## 年齢
#' ### 0:84歳未満、1:84歳以上
coxds$cox_age <- ifelse(coxds$agec == "<84", 0, 1)
x <- summary(coxph(Surv(years, censor) ~ cox_age, data=coxds), conf.int=0.95)
x
z <- c("age", round2(x$coefficients[2], digits=3),
       paste(round2(x$conf.int[3], digits=3), round2(x$conf.int[4], digits=3), sep=" - "),
       round2(x$coefficients[5], digits=4))
compare_df <- rbind(compare_df, z)
compare_df[,1] <- as.character(compare_df[,1])
compare_df[,2] <- as.character(compare_df[,2])
compare_df[,3] <- as.character(compare_df[,3])
compare_df[,4] <- as.character(compare_df[,4])
colnames(compare_df) <- c("項目", "ハザード比", "ハザード比95%信頼区間", "Pr")
#' ## 性別
#' ### 0:男性, 1:女性
coxds$cox_sex <- ifelse(coxds$sex == "男性", 0, 1)
x <- summary(coxph(Surv(years, censor) ~ cox_sex, data=coxds), conf.int=0.95)
x
z <- c("sex", round2(x$coefficients[2], digits=3),
       paste(round2(x$conf.int[3], digits=3), round2(x$conf.int[4], digits=3), sep=" - "),
       round2(x$coefficients[5], digits=4))
compare_df <- rbind(compare_df, z)
#' ## PS
#' ### 0:1以下, 1:2以上
coxds$cox_ps <- ifelse(coxds$ps == "=<1", 0, 1)
x <- summary(coxph(Surv(years, censor) ~ cox_ps, data=coxds), conf.int=0.95)
x
z <- c("ps", round2(x$coefficients[2], digits=3),
       paste(round2(x$conf.int[3], digits=3), round2(x$conf.int[4], digits=3), sep=" - "),
       round2(x$coefficients[5], digits=4))
compare_df <- rbind(compare_df, z)
#' ## stage
#' ### 0:II以下、1:III以上
coxds$cox_stage <- ifelse(coxds$stagec == "=<II", 0, 1)
x <- summary(coxph(Surv(years, censor) ~ cox_stage, data=coxds), conf.int=0.95)
x
z <- c("stage", round2(x$coefficients[2], digits=3),
       paste(round2(x$conf.int[3], digits=3), round2(x$conf.int[4], digits=3), sep=" - "),
       round2(x$coefficients[5], digits=4))
compare_df <- rbind(compare_df, z)
#' ## ipi
x <- summary(coxph(Surv(years, censor) ~ ipi, data=coxds))
x
z <- c("ipi", round2(x$coefficients[2], digits=3),
       paste(round2(x$conf.int[3], digits=3), round2(x$conf.int[4], digits=3), sep=" - "),
       round2(x$coefficients[5], digits=4))
compare_df <- rbind(compare_df, z)
#' ## Marrow involvement
#' ### 0:陽性、1:陰性
coxds$cox_marrow <- ifelse(coxds$marrow == "陰性", 0, 1)
x <- summary(coxph(Surv(years, censor) ~ cox_marrow, data=coxds), conf.int=0.95)
x
z <- c("marrow", round2(x$coefficients[2], digits=3),
       paste(round2(x$conf.int[3], digits=3), round2(x$conf.int[4], digits=3), sep=" - "),
       round2(x$coefficients[5], digits=4))
compare_df <- rbind(compare_df, z)
#' ## Bulky disease
#' ### 0:なし、1:あり
coxds$cox_bulky <- ifelse(coxds$bulky == "なし", 0, 1)
x <- summary(coxph(Surv(years, censor) ~ cox_bulky, data=coxds), conf.int=0.95)
x
z <- c("bulky", round2(x$coefficients[2], digits=3),
       paste(round2(x$conf.int[3], digits=3), round2(x$conf.int[4], digits=3), sep=" - "),
       round2(x$coefficients[5], digits=4))
compare_df <- rbind(compare_df, z)
#' ## Bulky mass
coxds$cox_bulkymass <- ifelse(coxds$bulkymass == "なし", 0, 1)
x <- summary(coxph(Surv(years, censor) ~ cox_bulkymass, data=coxds), conf.int=0.95)
x
z <- c("bulkymass", round2(x$coefficients[2], digits=3),
       paste(round2(x$conf.int[3], digits=3), round2(x$conf.int[4], digits=3), sep=" - "),
       round2(x$coefficients[5], digits=4))
compare_df <- rbind(compare_df, z)
#' ### 0:なし、1:あり
#' ## 肝_病変の有無
#' ### 0:なし、1:あり
coxds$cox_liver <- ifelse(coxds$liver == "なし", 0, 1)
x <- summary(coxph(Surv(years, censor) ~ cox_liver, data=coxds), conf.int=0.95)
x
z <- c("liver", round2(x$coefficients[2], digits=3),
       paste(round2(x$conf.int[3], digits=3), round2(x$conf.int[4], digits=3), sep=" - "),
       round2(x$coefficients[5], digits=4))
compare_df <- rbind(compare_df, z)
#' ## 脾_病変の有無
#' ### 0:なし、1:あり
coxds$cox_spleen <- ifelse(coxds$spleen == "なし", 0, 1)
x <- summary(coxph(Surv(years, censor) ~ cox_spleen, data=coxds), conf.int=0.95)
x
z <- c("spleen", round2(x$coefficients[2], digits=3),
       paste(round2(x$conf.int[3], digits=3), round2(x$conf.int[4], digits=3), sep=" - "),
       round2(x$coefficients[5], digits=4))
compare_df <- rbind(compare_df, z)
#' ## 腎_病変の有無
#' ### 0:なし、1:あり
coxds$cox_kidney <- ifelse(coxds$kidney == "なし", 0, 1)
x <- summary(coxph(Surv(years, censor) ~ cox_kidney, data=coxds), conf.int=0.95)
x
z <- c("kidney", round2(x$coefficients[2], digits=3),
       paste(round2(x$conf.int[3], digits=3), round2(x$conf.int[4], digits=3), sep=" - "),
       round2(x$coefficients[5], digits=4))
compare_df <- rbind(compare_df, z)
#' ## B symptoms
#' ### 0:なし、1:あり
coxds$cox_bsymptom <- ifelse(coxds$bsymptom == "なし", 0, 1)
x <- summary(coxph(Surv(years, censor) ~ cox_bsymptom, data=coxds), conf.int=0.95)
x
z <- c("bsymptoms", round2(x$coefficients[2], digits=3),
       paste(round2(x$conf.int[3], digits=3), round2(x$conf.int[4], digits=3), sep=" - "),
       round2(x$coefficients[5], digits=4))
compare_df <- rbind(compare_df, z)
#' ## Weight loss
#' ### 0:False、1:True
coxds$cox_weight <- ifelse(coxds$weight == F, 0, 1)
x <- summary(coxph(Surv(years, censor) ~ cox_weight, data=coxds), conf.int=0.95)
x
z <- c("weightloss", round2(x$coefficients[2], digits=3),
       paste(round2(x$conf.int[3], digits=3), round2(x$conf.int[4], digits=3), sep=" - "),
       round2(x$coefficients[5], digits=4))
compare_df <- rbind(compare_df, z)
#' ## Night sweats
#' ### 0:False、1:True
coxds$cox_nsweats <- ifelse(coxds$nsweats == F, 0, 1)
x <- summary(coxph(Surv(years, censor) ~ cox_nsweats, data=coxds), conf.int=0.95)
x
z <- c("nightsweats", round2(x$coefficients[2], digits=3),
       paste(round2(x$conf.int[3], digits=3), round2(x$conf.int[4], digits=3), sep=" - "),
       round2(x$coefficients[5], digits=4))
compare_df <- rbind(compare_df, z)
#' ## Fever
#' ### 0:False、1:True
coxds$cox_fever <- ifelse(coxds$fever == F, 0, 1)
x <- summary(coxph(Surv(years, censor) ~ cox_fever, data=coxds), conf.int=0.95)
x
z <- c("fever", round2(x$coefficients[2], digits=3),
       paste(round2(x$conf.int[3], digits=3), round2(x$conf.int[4], digits=3), sep=" - "),
       round2(x$coefficients[5], digits=4))
compare_df <- rbind(compare_df, z)
#' ## LDH IU/L
#' ### 0:<250、1:250=<
coxds$cox_ldh <- ifelse(coxds$ldh == "<250", 0, 1)
x <- summary(coxph(Surv(years, censor) ~ cox_ldh, data=coxds), conf.int=0.95)
x
z <- c("ldh", round2(x$coefficients[2], digits=3),
       paste(round2(x$conf.int[3], digits=3), round2(x$conf.int[4], digits=3), sep=" - "),
       round2(x$coefficients[5], digits=4))
compare_df <- rbind(compare_df, z)
#' ## β2MG(mg/L)
x <- summary(coxph(Surv(years, censor) ~ b2mg, data=coxds), conf.int=0.95)
x
z <- c("β2MG", round2(x$coefficients[2], digits=3),
       paste(round2(x$conf.int[3], digits=3), round2(x$conf.int[4], digits=3), sep=" - "),
       round2(x$coefficients[5], digits=4))
compare_df <- rbind(compare_df, z)
#' ## 血清sIL-2R
x <- summary(coxph(Surv(years, censor) ~ sil2r, data=coxds), conf.int=0.95)
x
z <- c("sIL-2R", round2(x$coefficients[2], digits=3),
       paste(round2(x$conf.int[3], digits=3), round2(x$conf.int[4], digits=3), sep=" - "),
       round2(x$coefficients[5], digits=4))
compare_df <- rbind(compare_df, z)
#' ## alb
coxds$cox_alb <- ifelse(coxds$alb == "3.5<=", 1, 0)
x <- summary(coxph(Surv(years, censor) ~ alb, data=coxds), conf.int=0.95)
x
z <- c("alb", round2(x$coefficients[2], digits=3),
       paste(round2(x$conf.int[3], digits=3), round2(x$conf.int[4], digits=3), sep=" - "),
       round2(x$coefficients[5], digits=4))
compare_df <- rbind(compare_df, z)
#' ## Sex  IPI scores    B symptoms    β2MG
#' ## 性別
#' ### 0:男性, 1:女性
#' ## B symptoms
#' ### 0:なし、1:あり
x <- summary(coxph(Surv(years, censor) ~ cox_sex + ipi + cox_bsymptom + b2mg, data=coxds), conf.int=0.95)
x
z <- c("Sex  IPI scores    B symptoms    β2MG", round2(x$coefficients[2], digits=3),
       paste(round2(x$conf.int[3], digits=3), round2(x$conf.int[4], digits=3), sep=" - "),
       round2(x$coefficients[5], digits=4))
compare_df <- rbind(compare_df, z)
# output csv
write.csv(compare_df, paste0(output_path, "/", pfsos, "cox_compare.csv"), row.names=F, fileEncoding = "cp932", na="")
