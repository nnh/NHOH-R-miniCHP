# Common processing
# Created date: 2019/2/5
# Author: mariko ohtsuka
# library, function section ------
# install.packages('readxl')
library("readxl")
#' @title
AggregateLength <- function(target_column, column_name){
  df <- aggregate(target_column, by=list(target_column), length)
  colnames(df) <- c(column_name, "count")
  df$per <- round(prop.table(df$count) * 100, digits=1)
  return(df)
}
SummaryValue <- function(target_column){
  temp_summary <- summary(target_column)
  temp_sd <- sd(target_column)
  names(temp_sd) <- "Sd."
  return(c(temp_summary, temp_sd))
}
ConvNum <- function(target){
  if (is.na(target)) {
    temp_num <- -999
  } else {
    temp_num <- as.numeric(as.character(target))
  }
  return(temp_num)
}
# Constant section ------
kOption_csv_name <- "option.csv"
kOption_csv_fileEncoding <- "cp932"
kNA_lb <- -1
kMaxcourse <- 6
kCourse_count <- c(1:6)
kCTCAEGrade <- c(1:5)
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
# Input birth date and sex
birth_date_sex <- read_excel(paste0(external_path, "/R-mini CHP_生年月日 性別.xlsx"), sheet=1, col_names=T)
colnames(birth_date_sex) <- birth_date_sex[1, ]
birth_date_sex <- birth_date_sex[-1, ]
birth_date_sex$生年月日 <- as.Date(as.numeric(birth_date_sex$生年月日), origin="1899-12-30")
sortlist <- order(as.numeric(birth_date_sex$症例登録番号))
birth_date_sex <- birth_date_sex[sortlist, ]
# 全登録例
raw_ptdata <- ptdata
all_registration <- as.numeric(nrow(raw_ptdata))
# 全適格例
ptdata <- subset(ptdata, SUBJID != 6)
#+ {r}
all_qualification <- as.numeric(nrow(ptdata))
# 中央病理診断適格例
# 全治療例
all_treatment <- all_qualification
# option.csv$治療コース
treatment_course <- subset(option_csv, Option.name == "治療コース")
