#
# Created date: 2019/2/13
# Author: mariko ohtsuka
# library, function section ------
df_crr <- subset(ptdata, RSORRES_best == "CR" | RSORRES_best == "CRu")
df_RSORRES_pr <- subset(ptdata, RSORRES_best == "PR")
df_orr <- rbind(df_crr, df_RSORRES_pr)
orr_count <- nrow(df_orr)
crr_count <- nrow(df_crr)
orr_95CI <- binom.test(orr_count, all_qualification)
crr_95CI <- binom.test(crr_count, all_qualification)
#' # ORR
#' ## n=`r all_qualification`
#' ### 対象症例数
paste0(orr_count, " (", round(orr_count / all_qualification * 100, digits=1), "%)")
#' ### 95%CI
orr_95CI
#' # CRR
#' ## n=`r all_qualification`
#' ### 対象症例数
paste0(crr_count, " (", round(crr_count / all_qualification * 100, digits=1), "%)")
#' ### 95%CI
crr_95CI
