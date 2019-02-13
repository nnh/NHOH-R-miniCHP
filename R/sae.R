# '
# ' Created date: 2019/2/12
# ' author: mariko ohtsuka
# ' output:
# '   html_document:
#' # 重篤な有害事象発生割合
#' ## n=`r all_treatment`
#' # 死亡の詳細
#' ## n=`r all_qualification`
sae_death <- subset(sae_report, AEOUT == "死亡")
#' ### 死亡例数
kable(nrow(sae_death), format = "markdown")
#' ### 死因
option_cause_of_death <- subset(option_csv, Option.name== "死因")
ptdata_death <- subset(ptdata, SUBJID %in% sae_death$SUBJID)
output_cause_of_death <- data.frame(option_cause_of_death$Option..Value.name)
output_cause_of_death$count <- 0
for (i in 1:nrow(ptdata_death)) {
  for (j in 1:nrow(output_cause_of_death)) {
    if (ptdata_death$DDORRES == output_cause_of_death[j, 1]){
      output_cause_of_death[j, "count"] <- output_cause_of_death[j, "count"] + 1
    }
  }
}
for (i in 1:nrow(output_cause_of_death)) {
  if (output_cause_of_death[i, "count"] > 0) {
    temp_per <- round(output_cause_of_death[i, "count"] / all_qualification * 100, digits=1)
    output_cause_of_death[i, "count"] <- paste0(output_cause_of_death[i, "count"], " (", temp_per, "%)")
  }
}
kable(output_cause_of_death, format = "markdown")
