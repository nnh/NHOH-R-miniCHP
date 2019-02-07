# '
# ' Created date: 2019/2/7
# ' author: mariko ohtsuka
# ' output:
# '   html_document:
CountTreatment <- function(input_variable, input_variable_head, input_variable_foot, column_name, param){
  course_list <- NULL
  for (i in course_count) {
    if (!is.na(input_variable)) {
      temp_input_variable <- input_variable
    } else {
      temp_input_variable <- paste0(input_variable_head, i, input_variable_foot)
    }
    temp_output_variable <- paste0("temp_", i)
    assign(temp_output_variable, length(na.omit(ptdata[ ,temp_input_variable])))
    course_list <- append(course_list, get(temp_output_variable))
  }
  df <- data.frame(course_count, course_list)
  colnames(df) <- c(column_name, "count")
  df$per <- df$count / param * 100
  return(df)
}
kMaxcourse <- 6
course_count <- c(1:6)
#' ## R−mini CHP治療コース数
df_treatment_course <- CountTreatment(NA, "fs", "_ECRFTDTC", "course", all_qualification)
kable(df_treatment_course, format = "markdown")
#' ## R−mini CHP中止したコース数
df_cancel_course <- AggregateLength(as.numeric(ptdata$ds_epoch), "course")
df_cancel_course$per <- df_cancel_course$count / all_qualification * 100
sum_cancel <- sum(df_cancel_course$count)
df_cancel_course <- rbind(df_cancel_course, c("中止例合計", sum_cancel, sum_cancel / all_qualification * 100))
kable(df_cancel_course, format = "markdown")
#' ## 中止理由一覧
df_cancel_term <- AggregateLength(ptdata$DSTERM, "reason")
kable(df_cancel_term, format = "markdown")
