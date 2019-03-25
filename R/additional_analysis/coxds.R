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
coxdspfs <- data.frame(matrix(rep(NA, 1), nrow=nrow(ptdata)))
# 症例番号
coxdspfs$SUBJID <- ptdata$SUBJID
coxdspfs <- coxdspfs[-1]
# PFS時間変数
coxdspfs$years <- pfs[["time"]]
# PFS打ち切り変数
coxdspfs$censor <- pfs[["n.censor"]]
# 年齢
coxdspfs$age <- df_age_sex$age
# 性別
coxdspfs$sex <- ifelse(df_age_sex$field4 == "male", "男性", "女性")
# PS
coxdspfs$ps <- ptdata$in_qsorres_ps
# stage
coxdspfs$ipi <- df_ipi$score
# Marrow involvement
coxdspfs$marrow <- temp_marrow_involvement$lesions
# Bulky disease
coxdspfs$bulky <- ptdata$in_bulky_yn
# 肝_病変の有無
coxdspfs$liver <- ptdata$in_liver_yn
# 脾_病変の有無
coxdspfs$spleen <- ptdata$in_spleen_yn
# 腎_病変の有無
coxdspfs$kidney <- ptdata$in_renal_yn
# B symptoms
coxdspfs$bsymptom <- ptdata$in_b_yn
# Weight loss
coxdspfs$weight <- ptdata$in_b_select_3
# Night sweats
coxdspfs$nsweats <- ptdata$in_b_select_2
# Fever
coxdspfs$fever <- ptdata$in_b_select_1
# LDH IU/L
coxdspfs$ldh <- temp_ldh$ldh_f
# β2MG(mg/L)
coxdspfs$b2mg <- ifelse(ptdata$in_lborres_b2mg == kNA_lb, NA, ptdata$in_lborres_b2mg)
# 血清sIL-2R
coxdspfs$sil2r <- ifelse(ptdata$in_lborres_sil2r == kNA_lb, NA, ptdata$in_lborres_sil2r)
# output csv
write.csv(coxdspfs, paste0(output_path, "/coxdspfs.csv"), row.names=F, fileEncoding = "cp932", na="")
# output dataset
save(coxdspfs, file=str_c(output_path, "/coxdspfs.Rda"))
# return the working directory
setwd(save_wd)
