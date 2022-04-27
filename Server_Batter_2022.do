

xtreg he p1-p24 i.dy i.hour price hdd_s1-hdd_s5 cdd_s1-cdd_s5 if summer==1 & DorR=="D", fe vce(cluster BILACCT_K_ENC)
xtreg he p1-p24 i.dy i.hour price hdd_s1-hdd_s5 cdd_s1-cdd_s5 if summer==1 & DorR=="R", fe vce(cluster BILACCT_K_ENC)
xtreg he p1-p24 i.dy i.hour price hdd_s1-hdd_s5 cdd_s1-cdd_s5 if summer==0 & DorR=="D", fe vce(cluster BILACCT_K_ENC)
xtreg he p1-p24 i.dy i.hour price hdd_s1-hdd_s5 cdd_s1-cdd_s5 if summer==0 & DorR=="R", fe vce(cluster BILACCT_K_ENC)


 eventdd he i.dy i.hour price hdd_s1-hdd_s5 cdd_s1-cdd_s5 if DorR=="D", fe timevar(timeToTreat)  vce(cluster BILACCT_K_ENC) graph_op(ytitle("Average hourly kWh") xtitle("Time"))

 eventdd he i.dy i.hour price hdd_s1-hdd_s5 cdd_s1-cdd_s5 if DorR=="R", fe timevar(timeToTreat)  vce(cluster BILACCT_K_ENC) graph_op(ytitle("Average hourly kWh") xtitle("Time"))
