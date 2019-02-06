# Common processing
# Created date: 2019/2/5
# Author: mariko ohtsuka
# library, function section ------
#' @title
AggregateLength <- function(target_column, column_name){
  df <- aggregate(target_column, by=list(target_column), length)
  colnames(df) <- c(column_name, "count")
  df$per <- prop.table(df$count) * 100
  return(df)
}
# Constant section ------
kOption_csv_name <- "option.csv"
kOption_csv_fileEncoding <- "cp932"
# ------
Sys.setenv("TZ" = "Asia/Tokyo")
parent_path <- "/Users/admin/Desktop/NHOH-R-miniCHP"
# log output path
log_path <- paste0(parent_path, "/log")
if (file.exists(log_path) == F) {
  dir.create(log_path)
}
# Setting of input/output path
input_path <- paste0(parent_path, "/input")
external_path <<- paste0(parent_path, "/external")
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
# Input option.csv
option_csv <- read.csv(paste0(external_path, "/", kOption_csv_name), as.is=T, fileEncoding=kOption_csv_fileEncoding,
                       stringsAsFactors=F)
# 全登録例
raw_ptdata <- ptdata
all_registration <- as.numeric(nrow(raw_ptdata))
# 全適格例
ptdata <- subset(ptdata, SUBJID != 6)
#+ {r}
all_qualification <- as.numeric(nrow(ptdata))
# 中央病理診断適格例
# 全治療例

