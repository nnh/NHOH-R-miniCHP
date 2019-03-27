# compare.R
# Created date: 2019/3/26
# Author: mariko ohtsuka
#install.packages("sas7bdat")
#library(sas7bdat)
#sas_dat <- read.sas7bdat("/Users/admin/Desktop/NHOH-R-miniCHP/compare/coxds.sas7bdat", debug=T)
#sas_dat$sex <- ifelse(sas_dat$sex == "\U3e32393cj\U3e30393c\U3e62613c", "男性", "女性")
#load("/Users/admin/Desktop/NHOH-R-miniCHP/output/coxds.Rda")
#r_dat <- coxds
raw_sas_dat <- read.csv("/Users/admin/Desktop/NHOH-R-miniCHP/compare/sas_coxds.csv", fileEncoding="cp932" )
sortlist <- order(raw_sas_dat$subjid)
sas_dat <- raw_sas_dat[sortlist, ]
#sas_dat <- sort_sas_dat[,c(1:12)]
#sas_dat <- cbind(sas_dat, sort_sas_dat[26])
#sas_dat <- cbind(sas_dat, sort_sas_dat[c(13:25)])
r_dat <- read.csv("/Users/admin/Desktop/NHOH-R-miniCHP/compare/r_coxds.csv", fileEncoding="cp932" )
col_sas <- colnames(sas_dat)
col_r <- colnames(r_dat)
col_r[1] <- "subjid"
r_dat$years_pfs <- round(r_dat$years_pfs, digits=10)
r_dat$years_os <- round(r_dat$years_os, digits=10)
r_dat$years_dfs <- round(r_dat$years_dfs, digits=10)
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
  print("!!! col_count_ng")
  print(col_sas)
  print(col_r)
}
