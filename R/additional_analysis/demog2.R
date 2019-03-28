# demog2.R
# Created date: 2019/3/28
# Author: mariko ohtsuka
cox_demog_agec <- AggregateLength(coxds$agec, "age")
kable(cox_demog_agec, format = "markdown")
cox_demog_psc <- AggregateLength(coxds$ps, "ps")
kable(cox_demog_psc, format = "markdown")
cox_demog_stagec <- AggregateLength(coxds$stagec, "stage")
kable(cox_demog_stagec, format = "markdown")
