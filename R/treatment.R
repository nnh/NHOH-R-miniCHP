# '
# ' Created date: 2019/2/7
# ' author: mariko ohtsuka
# ' output:
# '   html_document:
kMaxCource <- 6
cource_count <- c(1:6)
#' ## R−mini CHP治療コース数
treatment_course <- NULL
for (i in cource_count) {
  temp_input_variable <- paste0("fs", i, "_ECRFTDTC")
  temp_output_variable <- paste0("temp_", i)
  assign(temp_output_variable, length(na.omit(ptdata[ ,temp_input_variable])))
  treatment_course <- append(treatment_course, get(temp_output_variable))
}
df_treatment_course <- data.frame(cource_count, treatment_course)
colnames(df_treatment_course) <- c("treatment", "count")
kable(df_treatment_course, format = "markdown")
