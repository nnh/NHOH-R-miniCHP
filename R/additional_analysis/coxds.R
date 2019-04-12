# coxds.R
# Created date: 2019/3/25
# Author: mariko ohtsuka
source(str_c(source_path, "/common.R"))
# sort ptdata
sortlist <- order(as.numeric(ptdata$SUBJID))
ptdata <- ptdata[sortlist, ]
source(str_c(source_path, "/demog.R"))
source(str_c(source_path, "/pfs.R"))
# pfs
pfs <- surdata2
coxds <- data.frame(matrix(rep(NA, 1), nrow=nrow(ptdata)))
# SUBJID
coxds$SUBJID <- ptdata$SUBJID
coxds <- coxds[-1]
# PFS
coxds$years_pfs <- pfs_ptdata$pfs_time
coxds$censor_pfs <- ifelse(pfs_ptdata$pfs_cens == 0, 1, 0)
# OS
coxds$years_os <- pfs_ptdata$os_time
coxds$censor_os <- ifelse(pfs_ptdata$os_cens == 0, 1, 0)
# DFS
coxds$years_dfs <- dfs_ptdata$dfs_time
coxds$censor_dfs <- ifelse(dfs_ptdata$dfs_cens == 0, 1, 0)
# age
coxds$age <- df_age_sex$age
coxds$agec <- ifelse(df_age_sex$age < 84, "<84", "84=<")
# sex
coxds$sex <- ifelse(df_age_sex$field4 == "male", "男性", "女性")
# PS
coxds$ps <- ifelse(as.numeric(as.character(ptdata$in_qsorres_ps)) <= 1, "=<1", "2=<")
# stage
coxds$stage <- ptdata$in_patholo_ctg
coxds$stagec <- ifelse(as.numeric(ptdata$in_patholo_ctg) >= 5, "III=>", "=<II")
# ipi
coxds$ipi <- df_ipi$score
# Marrow involvement
coxds$marrow <- ifelse(temp_marrow_involvement$lesions == "あり", "陽性", "陰性")
# Bulky disease
coxds$bulky <- ptdata$in_bulky_yn
# Bulky mass
coxds$bulkymass <- ifelse(ptdata$in_liver_yn == "あり" |
                          ptdata$in_spleen_yn == "あり" |
                          ptdata$in_renal_yn == "あり", "あり", "なし")
# liver
coxds$liver <- ptdata$in_liver_yn
# spleen
coxds$spleen <- ptdata$in_spleen_yn
# kidney
coxds$kidney <- ptdata$in_renal_yn
# B symptoms
coxds$bsymptom <- ptdata$in_b_yn
# Weight loss
coxds$weight <- ptdata$in_b_select_3
# Night sweats
coxds$nsweats <- ptdata$in_b_select_2
# Fever
coxds$fever <- ptdata$in_b_select_1
# LDH IU/L
coxds$ldh <- temp_ldh$ldh_f
# β2MG(mg/L)
coxds$b2mg <- ifelse(ptdata$in_lborres_b2mg == kNA_lb, NA, ptdata$in_lborres_b2mg)
# sIL-2R
coxds$sil2r <- ifelse(ptdata$in_lborres_sil2r == kNA_lb, NA, ptdata$in_lborres_sil2r)
# output csv
write.csv(coxds, paste0(output_path, "/coxds.csv"), row.names=F, fileEncoding = "cp932", na="")
# output dataset
save(coxds, file=str_c(output_path, "/coxds.Rda"))
# return the working directory
setwd(save_wd)
