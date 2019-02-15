# pfs, os
# Created date: 2019/2/13
# Author: mariko ohtsuka
# library, function section ------
library(survival)
#' @title
#' ConvDate
#' @description
#' Compare the two dates and return the past
#' @param
#' sv_date : The most past date at that time
#' df : Target data frame
#' idx_row : Target row number
#' flag_col : Flag column name
#' date_col : date column name
#' const_T : string(ex:"あり")
#' @return
#' date
ConvDate <- function(sv_date, df, idx_row, flag_col, date_col, const_T){
  res_date <- sv_date
  if (!is.na(df[idx_row, flag_col]) && df[idx_row, flag_col] == const_T) {
    temp_date <- df[i, date_col]
    if (temp_date < sv_date) {
      res_date <- temp_date
    }
  }
  return(res_date)
}
# Constant section ------
kBaseDate <- "2100-01-01"
kCensoring <- 0
kEvent <- 1
# main section ------
pfs_ptdata <- ptdata
pfs_ptdata$pfs_date <- NA
pfs_ptdata$os_date <- NA
pfs_ptdata$pfs_cens <- kEvent
pfs_ptdata$os_cens <- kEvent
for (i in 1:nrow(pfs_ptdata)) {
  temp_pfs_date <- kBaseDate
  temp_os_date <- kBaseDate
  # Get cancel data
  temp_dsterm <- pfs_ptdata[i, "DSTERM"]
  if (!is.na(temp_dsterm)) {
    if (temp_dsterm == "3コース後の中間効果判定でPD(増悪)であった") {
      cancel_course <- 3
    } else if (temp_dsterm == "治療開始後、原病のPD(増悪)/またはRD(再発)が認められた") {
      cancel_course <- subset(treatment_course, Option..Value.name == pfs_ptdata[i, "ds_epoch"])$Option..Value.code
    } else {
      cancel_course <- NA
    }
    if (!is.na(cancel_course)) {
      temp_ECENDTC_col <- paste0("fs", cancel_course, "_ECENDTC")
      temp_pfs_date <- pfs_ptdata[i, temp_ECENDTC_col]
    }
  }
  # pfs:First relapse
  temp_pfs_date <- ConvDate(temp_pfs_date, pfs_ptdata, i, "prog_yn", "rprog_dy", "あり")
  # pfs:First exacerbation
  temp_pfs_date <- ConvDate(temp_pfs_date, pfs_ptdata, i, "rec1_yn", "rec1_dy", "あり")
  # pfs,os:Death
  temp_pfs_date <- ConvDate(temp_pfs_date, pfs_ptdata, i, "dd_flg", "DDDTC", 1)
  temp_os_date <- ConvDate(temp_os_date, pfs_ptdata, i, "dd_flg", "DDDTC", 1)
  # pfs,os:If not applicable, the date of final survival confirmation
  if (temp_pfs_date == kBaseDate) {
    temp_pfs_date <- pfs_ptdata[i, "surv_dy"]
    pfs_ptdata[i, "pfs_cens"] <- kCensoring
  }
  if (temp_os_date == kBaseDate) {
    temp_os_date <- pfs_ptdata[i, "surv_dy"]
    pfs_ptdata[i, "os_cens"] <- kCensoring
  }
  pfs_ptdata[i, "pfs_date"] <- temp_pfs_date
  pfs_ptdata[i, "os_date"] <- temp_os_date
}
# The start date is the treatment start date of course 1
pfs_ptdata <- subset(pfs_ptdata, !is.na(pfs_ptdata$pfs_date))
pfs_ptdata$pfs_time <- difftime(as.Date(pfs_ptdata$pfs_date, origin="1970-01-01"), pfs_ptdata$fs1_ECRFTDTC,
                                tz="", units="days")
pfs_ptdata$os_time <- difftime(as.Date(pfs_ptdata$os_date, origin="1970-01-01"), pfs_ptdata$fs1_ECRFTDTC,
                               tz="", units="days")
pfs_ptdata$treat <- factor("R-mini-CHP")
#' # 無増悪生存率 Progression-free survival rate（PFS）
#' ## n=`r nrow(pfs_ptdata)`
Surv(pfs_ptdata$pfs_time, pfs_ptdata$pfs_cens)
surdata2<-survfit(Surv(pfs_time, pfs_cens)~treat, data=pfs_ptdata, conf.int=.90)
summary(surdata2)
plot(surdata2, ylim=c(0, 1.0))
#' # 生存率 Overall survival rate（OS）
#' ## n=`r nrow(pfs_ptdata)`
Surv(pfs_ptdata$os_time, pfs_ptdata$os_cens)
surdata3<-survfit(Surv(os_time, os_cens)~treat, data=pfs_ptdata, conf.int=.90)
summary(surdata3)
plot(surdata3, ylim=c(0, 1.0))
