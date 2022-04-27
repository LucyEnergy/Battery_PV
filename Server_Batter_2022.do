

xtreg he p1-p24 i.yr i.mo i.hour price weekend holiday2 hdd_s1-hdd_s5 cdd_s1-cdd_s5 if summer==1 & ((DorR=="D") , fe vce(cluster BILACCT_K_ENC)


