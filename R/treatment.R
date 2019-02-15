# ' treatment.R
# ' Created date: 2019/2/7
# ' author: mariko ohtsuka
# ' output:
# '   html_document:
#' ## R−mini CHP治療コース数
course_list <- NULL
for (i in kCourse_count) {
  temp_input_variable <- paste0("fs", i, "_ECRFTDTC")
  temp_output_variable <- paste0("temp_", i)
  assign(temp_output_variable, length(na.omit(ptdata[ , temp_input_variable])))
  course_list <- append(course_list, get(temp_output_variable))
}
# Get treatment course name
output_treatment_course <- sapply(kCourse_count, function(x){df = subset(treatment_course, Option..Value.code == x)
                                                              return(df$Option..Value.name)})
df_treatment_course <- data.frame(output_treatment_course, course_list)
colnames(df_treatment_course) <- c("course", "count")
df_treatment_course$per <- round(df_treatment_course$count / all_qualification * 100, digits=1)
kable(df_treatment_course, format = "markdown")
#' ## R−mini CHP中止したコース数
df_cancel_course <- AggregateLength(ptdata$ds_epoch, "course")
df_cancel_course$course <- as.character(df_cancel_course$course)
df_cancel_course$per <- round(df_cancel_course$count / all_qualification * 100, digits=1)
sum_cancel <- sum(df_cancel_course$count)
df_cancel_course <- rbind(df_cancel_course, c("中止例合計", sum_cancel,
                                              round(sum_cancel / all_qualification * 100, digits=1)))
kable(df_cancel_course, format = "markdown")
#' ## 中止理由一覧
df_cancel_term <- AggregateLength(ptdata$DSTERM, "reason")
kable(df_cancel_term, format = "markdown")
