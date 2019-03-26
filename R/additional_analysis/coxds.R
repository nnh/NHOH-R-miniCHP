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
# 症例番号
coxds$SUBJID <- ptdata$SUBJID
coxds <- coxds[-1]
# PFS時間変数
coxds$years_pfs <- pfs_ptdata$pfs_time
# PFS打ち切り変数
coxds$censor_pfs <- pfs_ptdata$pfs_cens
# OS時間変数
coxds$years_os <- pfs_ptdata$os_time
# OS打ち切り変数
coxds$censor_os <- pfs_ptdata$os_cens
# DFS時間変数
coxds$years_dfs <- dfs_ptdata$dfs_time
# DFS打ち切り変数
coxds$censor_dfs <- dfs_ptdata$dfs_cens
# 年齢
coxds$age <- df_age_sex$age
# 性別
coxds$sex <- ifelse(df_age_sex$field4 == "male", "男性", "女性")
# PS
coxds$ps <- ptdata$in_qsorres_ps
# stage
coxds$stage <- ptdata$in_patholo_ctg
# ipi
coxds$ipi <- df_ipi$score
# Marrow involvement
coxds$marrow <- ifelse(temp_marrow_involvement$lesions == "あり", "陽性", "陰性")
# Bulky disease
coxds$bulky <- ptdata$in_bulky_yn
# 肝_病変の有無
coxds$liver <- ptdata$in_liver_yn
# 脾_病変の有無
coxds$spleen <- ptdata$in_spleen_yn
# 腎_病変の有無
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
# 血清sIL-2R
coxds$sil2r <- ifelse(ptdata$in_lborres_sil2r == kNA_lb, NA, ptdata$in_lborres_sil2r)
# output csv
write.csv(coxds, paste0(output_path, "/coxds.csv"), row.names=F, fileEncoding = "cp932", na="")
# output dataset
save(coxds, file=str_c(output_path, "/coxds.Rda"))
# return the working directory
setwd(save_wd)
