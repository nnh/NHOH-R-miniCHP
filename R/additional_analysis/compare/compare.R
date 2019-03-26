# compare.R
# Created date: 2019/3/26
# Author: mariko ohtsuka
#install.packages("sas7bdat")
library(sas7bdat)
sas_dat <- read.sas7bdat("/Users/admin/Desktop/NHOH-R-miniCHP/compare/coxds.sas7bdat", debug=T)
sas_dat$sex <- ifelse(sas_dat$sex == "\U3e32393cj\U3e30393c\U3e62613c", "男性", "女性")
r_dat <- read.csv("/Users/admin/Desktop/NHOH-R-miniCHP/compare/coxds.csv", as.is=T, fileEncoding="cp932",
                                stringsAsFactors=F)
col_sas <- colnames(sas_dat)
col_r <- colnames(r_dat)
col_r[1] <- "subjid"
r_dat$years_pfs <- round(r_dat$years_pfs, digits=3)
r_dat$censor_pfs <- ifelse(r_dat$censor_pfs == 0, 1, 0)
r_dat$years_os <- round(r_dat$years_os, digits=3)
r_dat$censor_os <- ifelse(r_dat$censor_os == 0, 1, 0)
r_dat$years_dfs <- round(r_dat$years_dfs, digits=3)
r_dat$censor_dfs <- ifelse(r_dat$censor_dfs == 0, 1, 0)
r_dat$ps <- ifelse(r_dat$ps == 0, 5, r_dat$ps)
r_dat$stage <- ifelse(r_dat$stage == "I E", 5 ,r_dat$stage)
r_dat$stage <- ifelse(r_dat$stage == "II", 2 ,r_dat$stage)
r_dat$stage <- ifelse(r_dat$stage == "II E", 6 ,r_dat$stage)
r_dat$stage <- ifelse(r_dat$stage == "III", 3 ,r_dat$stage)
r_dat$stage <- ifelse(r_dat$stage == "III E", 7 ,r_dat$stage)
r_dat$stage <- ifelse(r_dat$stage == "IV", 4 ,r_dat$stage)
for (i in 1:ncol(r_dat)) {
  r_dat[ ,i] <- ifelse(r_dat[ ,i] == "陰性", 1, r_dat[ ,i])
  r_dat[ ,i] <- ifelse(r_dat[ ,i] == "陽性", 2, r_dat[ ,i])
  r_dat[ ,i] <- ifelse(r_dat[ ,i] == "あり", 1, r_dat[ ,i])
  r_dat[ ,i] <- ifelse(r_dat[ ,i] == "なし", 2, r_dat[ ,i])
}
if (nrow(sas_dat) == nrow(r_dat)) {
  print("row_count_ok")
} else {
  print("row_count_ng")
}
if (length(col_sas) == length(col_r)) {
  print("col_count_ok")
  for (i in 1:ncol(sas_dat)) {
    if (col_sas[i] != col_r[i]) {
      print("col_name_ng") } else {}
      for (j in 1:nrow(sas_dat)) {
        if (!is.na(sas_dat[j,i]) && !is.na(r_dat[j,i])) {
          if(sas_dat[j,i] != r_dat[j, i]) {
            print(paste(col_r[i],j,i,sas_dat[j,i], r_dat[j,i]))
          }
        } else {
          print(paste(col_r[i],j,i,sas_dat[j,i], r_dat[j,i]))
        }
      }
    }
  } else {
  print("col_count_ng")
}
