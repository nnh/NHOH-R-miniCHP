#
# Created date: 2019/2/5
# Author: mariko ohtsuka
# library, function section ------
#' @title
AggregateLength <- function(target_column, column_name){
  df <- aggregate(target_column, by=list(target_column), length)
  colnames(df) <- c(column_name, "count")
  return(df)
}

Sys.setenv("TZ" = "Asia/Tokyo")
parent_path <- "/Users/admin/Desktop/NHOH-R-miniCHP"
# log output path
log_path <- paste0(parent_path, "/log")
if (file.exists(log_path) == F) {
  dir.create(log_path)
}
# Setting of input/output path
input_path <- paste0(parent_path, "/input")
# If the output folder does not exist, create it
output_path <- paste0(parent_path, "/output")
if (file.exists(output_path) == F) {
  dir.create(output_path)
}
# load dataset
dst_list <- list.files(input_path)
for (i in 1:length(dst_list)) {
  load(paste0(input_path, "/", dst_list[i]))
}
# 全登録例
all_registration <- as.numeric(nrow(ptdata))
# 全適格例

# 中央病理診断適格例
# 全治療例

