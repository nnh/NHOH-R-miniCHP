# pfs, os CI95%
# Created date: 2019/3/11
# Author: mariko ohtsuka
#' # 無増悪生存率 Progression-free survival rate（PFS）
#' ## n=`r nrow(pfs_ptdata)`
Surv(pfs_ptdata$pfs_time, pfs_ptdata$pfs_cens)
surdata2<-survfit(Surv(pfs_time, pfs_cens)~treat, data=pfs_ptdata, conf.int=.95, conf.type="log-log")
summary(surdata2)
plot(surdata2, ylim=c(0, 1.0))
#' ## 追跡調査期間
pfs_summary <- SummaryValue(as.numeric(pfs_ptdata$pfs_time))
kable(pfs_summary, format = "markdown")
#' # 生存率 Overall survival rate（OS）
#' ## n=`r nrow(pfs_ptdata)`
Surv(pfs_ptdata$os_time, pfs_ptdata$os_cens)
surdata3<-survfit(Surv(os_time, os_cens)~treat, data=pfs_ptdata, conf.int=.95, conf.type="log-log")
summary(surdata3)
plot(surdata3, ylim=c(0, 1.0))
#' ## 追跡調査期間
os_summary <- SummaryValue(as.numeric(pfs_ptdata$os_time))
kable(os_summary, format = "markdown")
#' # DFS
#' ## n=`r nrow(dfs_ptdata)`
Surv(dfs_ptdata$dfs_time, dfs_ptdata$dfs_cens)
surdata4<-survfit(Surv(dfs_time, dfs_cens)~treat, data=dfs_ptdata, conf.int=.95, conf.type="log-log")
summary(surdata4)
plot(surdata4, ylim=c(0, 1.0))
#' ## 追跡調査期間
dfs_summary <- SummaryValue(as.numeric(dfs_ptdata$dfs_time))
kable(dfs_summary, format = "markdown")
