use "regression.dta", clear
***generate HDD and CDD spline functions
gen cdd=temp-65 if temp>=65
replace cdd=0 if missing(cdd) 
gen hdd=65-temp if temp<=65
replace hdd=0 if missing(hdd)
mkspline hdd_s 5 =hdd, pctile
mkspline cdd_s 5 =cdd, pctile

****regressions for overall, not by rate
xtset IDmeter date_hr

**no matching
xtreg he p1-p24 i.dy i.hour price hdd_s1-hdd_s5 cdd_s1-cdd_s5 if summer==1 & DorR=="D", fe vce(cluster BILACCT_K_ENC)
xtreg he p1-p24 i.dy i.hour price hdd_s1-hdd_s5 cdd_s1-cdd_s5 if summer==1 & DorR=="R", fe vce(cluster BILACCT_K_ENC)
xtreg he p1-p24 i.dy i.hour price hdd_s1-hdd_s5 cdd_s1-cdd_s5 if summer==0 & DorR=="D", fe vce(cluster BILACCT_K_ENC)
xtreg he p1-p24 i.dy i.hour price hdd_s1-hdd_s5 cdd_s1-cdd_s5 if summer==0 & DorR=="R", fe vce(cluster BILACCT_K_ENC)
*by rate
xtreg he p1-p24 i.dy i.hour price hdd_s1-hdd_s5 cdd_s1-cdd_s5 if rate==21 & summer==1 & DorR=="D", fe vce(cluster BILACCT_K_ENC)
xtreg he p1-p24 i.dy i.hour price hdd_s1-hdd_s5 cdd_s1-cdd_s5 if rate==21 & summer==1 & DorR=="R", fe vce(cluster BILACCT_K_ENC)
xtreg he p1-p24 i.dy i.hour price hdd_s1-hdd_s5 cdd_s1-cdd_s5 if rate==21 & summer==0 & DorR=="D", fe vce(cluster BILACCT_K_ENC)
xtreg he p1-p24 i.dy i.hour price hdd_s1-hdd_s5 cdd_s1-cdd_s5 if rate==21 & summer==0 & DorR=="R", fe vce(cluster BILACCT_K_ENC)

xtreg he p1-p24 i.dy i.hour price hdd_s1-hdd_s5 cdd_s1-cdd_s5 if rate==23 & summer==1 & DorR=="D", fe vce(cluster BILACCT_K_ENC)
xtreg he p1-p24 i.dy i.hour price hdd_s1-hdd_s5 cdd_s1-cdd_s5 if rate==23 & summer==1 & DorR=="R", fe vce(cluster BILACCT_K_ENC)
xtreg he p1-p24 i.dy i.hour price hdd_s1-hdd_s5 cdd_s1-cdd_s5 if rate==23 & summer==0 & DorR=="D", fe vce(cluster BILACCT_K_ENC)
xtreg he p1-p24 i.dy i.hour price hdd_s1-hdd_s5 cdd_s1-cdd_s5 if rate==23 & summer==0 & DorR=="R", fe vce(cluster BILACCT_K_ENC)

xtreg he p1-p24 i.dy i.hour price hdd_s1-hdd_s5 cdd_s1-cdd_s5 if rate==26 & summer==1 & DorR=="D", fe vce(cluster BILACCT_K_ENC)
xtreg he p1-p24 i.dy i.hour price hdd_s1-hdd_s5 cdd_s1-cdd_s5 if rate==26 & summer==1 & DorR=="R", fe vce(cluster BILACCT_K_ENC)
xtreg he p1-p24 i.dy i.hour price hdd_s1-hdd_s5 cdd_s1-cdd_s5 if rate==26 & summer==0 & DorR=="D", fe vce(cluster BILACCT_K_ENC)
xtreg he p1-p24 i.dy i.hour price hdd_s1-hdd_s5 cdd_s1-cdd_s5 if rate==26 & summer==0 & DorR=="R", fe vce(cluster BILACCT_K_ENC)

xtreg he p1-p24 i.dy i.hour price hdd_s1-hdd_s5 cdd_s1-cdd_s5 if rate==27 & summer==1 & DorR=="D", fe vce(cluster BILACCT_K_ENC)
xtreg he p1-p24 i.dy i.hour price hdd_s1-hdd_s5 cdd_s1-cdd_s5 if rate==27 & summer==1 & DorR=="R", fe vce(cluster BILACCT_K_ENC)
xtreg he p1-p24 i.dy i.hour price hdd_s1-hdd_s5 cdd_s1-cdd_s5 if rate==27 & summer==0 & DorR=="D", fe vce(cluster BILACCT_K_ENC)
xtreg he p1-p24 i.dy i.hour price hdd_s1-hdd_s5 cdd_s1-cdd_s5 if rate==27 & summer==0 & DorR=="R", fe vce(cluster BILACCT_K_ENC)



**no matching, weekdays
xtreg he p1-p24 i.dy i.hour price hdd_s1-hdd_s5 cdd_s1-cdd_s5 if summer==1 & weekday==1 & DorR=="D", fe vce(cluster BILACCT_K_ENC)
xtreg he p1-p24 i.dy i.hour price hdd_s1-hdd_s5 cdd_s1-cdd_s5 if summer==1 & weekday==1 & DorR=="R", fe vce(cluster BILACCT_K_ENC)
xtreg he p1-p24 i.dy i.hour price hdd_s1-hdd_s5 cdd_s1-cdd_s5 if summer==0 & weekday==1 & DorR=="D", fe vce(cluster BILACCT_K_ENC)
xtreg he p1-p24 i.dy i.hour price hdd_s1-hdd_s5 cdd_s1-cdd_s5 if summer==0 & weekday==1 & DorR=="R", fe vce(cluster BILACCT_K_ENC)

**PSM & CEM
use "dataformatching.dta", clear
encode BILACCT_K_ENC, gen(ID_r)

psmatch2 EV he1 he2 he3 he4, quietly neighbor(1) ai(1) common caliper(0.25) ///
ties outcome(ID_r) logit
pstest he1 he2 he3 he4, both
psgraph

cem he1 he2 he3 he4, treatment(EV) showbreaks

keep BILACCT_K_ENC cem_strata cem_matched cem_weights _pscore _treated _support _weight _ID_r  _id _n1 _nn _pdif ///
_self_ID_r 

save "matching_weights_battery.dta", replace
sort BILACCT_K_ENC
save, replace

use "regression.dta", clear
sort BILACCT_K_ENC
merge BILACCT_K using "matching_weights_battery.dta"
drop _merge

gen cdd=temp-65 if temp>=65
replace cdd=0 if missing(cdd) 
gen hdd=65-temp if temp<=65
replace hdd=0 if missing(hdd)
mkspline hdd_s 5 =hdd, pctile
mkspline cdd_s 5 =cdd, pctile
xtset IDmeter date_hr

*PSM
xtreg he p1-p24 i.dy i.hour price hdd_s1-hdd_s5 cdd_s1-cdd_s5 [aweight=_weight] if summer==1 & DorR=="D", fe vce(cluster BILACCT_K_ENC)
xtreg he p1-p24 i.dy i.hour price hdd_s1-hdd_s5 cdd_s1-cdd_s5 [aweight=_weight] if summer==1 & DorR=="R", fe vce(cluster BILACCT_K_ENC)
xtreg he p1-p24 i.dy i.hour price hdd_s1-hdd_s5 cdd_s1-cdd_s5 [aweight=_weight] if summer==0 & DorR=="D", fe vce(cluster BILACCT_K_ENC)
xtreg he p1-p24 i.dy i.hour price hdd_s1-hdd_s5 cdd_s1-cdd_s5 [aweight=_weight] if summer==0 & DorR=="R", fe vce(cluster BILACCT_K_ENC)
* by rate
xtreg he p1-p24 i.dy i.hour price hdd_s1-hdd_s5 cdd_s1-cdd_s5 [aweight=_weight] if rate==21 & summer==1 & DorR=="D", fe vce(cluster BILACCT_K_ENC)
xtreg he p1-p24 i.dy i.hour price hdd_s1-hdd_s5 cdd_s1-cdd_s5 [aweight=_weight] if rate==21 & summer==1 & DorR=="R", fe vce(cluster BILACCT_K_ENC)
xtreg he p1-p24 i.dy i.hour price hdd_s1-hdd_s5 cdd_s1-cdd_s5 [aweight=_weight] if rate==21 & summer==0 & DorR=="D", fe vce(cluster BILACCT_K_ENC)
xtreg he p1-p24 i.dy i.hour price hdd_s1-hdd_s5 cdd_s1-cdd_s5 [aweight=_weight] if rate==21 & summer==0 & DorR=="R", fe vce(cluster BILACCT_K_ENC)

xtreg he p1-p24 i.dy i.hour price hdd_s1-hdd_s5 cdd_s1-cdd_s5 [aweight=_weight] if rate==23 & summer==1 & DorR=="D", fe vce(cluster BILACCT_K_ENC)
xtreg he p1-p24 i.dy i.hour price hdd_s1-hdd_s5 cdd_s1-cdd_s5 [aweight=_weight] if rate==23 & summer==1 & DorR=="R", fe vce(cluster BILACCT_K_ENC)
xtreg he p1-p24 i.dy i.hour price hdd_s1-hdd_s5 cdd_s1-cdd_s5 [aweight=_weight] if rate==23 & summer==0 & DorR=="D", fe vce(cluster BILACCT_K_ENC)
xtreg he p1-p24 i.dy i.hour price hdd_s1-hdd_s5 cdd_s1-cdd_s5 [aweight=_weight] if rate==23 & summer==0 & DorR=="R", fe vce(cluster BILACCT_K_ENC)

xtreg he p1-p24 i.dy i.hour price hdd_s1-hdd_s5 cdd_s1-cdd_s5 [aweight=_weight] if rate==26 & summer==1 & DorR=="D", fe vce(cluster BILACCT_K_ENC)
xtreg he p1-p24 i.dy i.hour price hdd_s1-hdd_s5 cdd_s1-cdd_s5 [aweight=_weight] if rate==26 & summer==1 & DorR=="R", fe vce(cluster BILACCT_K_ENC)
xtreg he p1-p24 i.dy i.hour price hdd_s1-hdd_s5 cdd_s1-cdd_s5 [aweight=_weight] if rate==26 & summer==0 & DorR=="D", fe vce(cluster BILACCT_K_ENC)
xtreg he p1-p24 i.dy i.hour price hdd_s1-hdd_s5 cdd_s1-cdd_s5 [aweight=_weight] if rate==26 & summer==0 & DorR=="R", fe vce(cluster BILACCT_K_ENC)

xtreg he p1-p24 i.dy i.hour price hdd_s1-hdd_s5 cdd_s1-cdd_s5 [aweight=_weight] if rate==27 & summer==1 & DorR=="D", fe vce(cluster BILACCT_K_ENC)
xtreg he p1-p24 i.dy i.hour price hdd_s1-hdd_s5 cdd_s1-cdd_s5 [aweight=_weight] if rate==27 & summer==1 & DorR=="R", fe vce(cluster BILACCT_K_ENC)
xtreg he p1-p24 i.dy i.hour price hdd_s1-hdd_s5 cdd_s1-cdd_s5 [aweight=_weight] if rate==27 & summer==0 & DorR=="D", fe vce(cluster BILACCT_K_ENC)
xtreg he p1-p24 i.dy i.hour price hdd_s1-hdd_s5 cdd_s1-cdd_s5 [aweight=_weight] if rate==27 & summer==0 & DorR=="R", fe vce(cluster BILACCT_K_ENC)

*CEM
xtreg he p1-p24 i.dy i.hour price hdd_s1-hdd_s5 cdd_s1-cdd_s5 [aweight=cem_weights] if summer==1 & DorR=="D", fe vce(cluster BILACCT_K_ENC)
xtreg he p1-p24 i.dy i.hour price hdd_s1-hdd_s5 cdd_s1-cdd_s5 [aweight=cem_weights]if summer==1 & DorR=="R", fe vce(cluster BILACCT_K_ENC)
xtreg he p1-p24 i.dy i.hour price hdd_s1-hdd_s5 cdd_s1-cdd_s5 [aweight=cem_weights] if summer==0 & DorR=="D", fe vce(cluster BILACCT_K_ENC)
xtreg he p1-p24 i.dy i.hour price hdd_s1-hdd_s5 cdd_s1-cdd_s5 [aweight=cem_weights] if summer==0 & DorR=="R", fe vce(cluster BILACCT_K_ENC)


****************individual consumers
keep if !missing(B_CommissioningDate)

statsby p1=_b[p1] se_p1=_se[p1] p2=_b[p2] se_p2=_se[p2] p3=_b[p3] se_p3=_se[p3] p4=_b[p4] se_p4=_se[p4] p5=_b[p5] se_p5=_se[p5] p6=_b[p6] se_p6=_se[p6] p7=_b[p7] se_p7=_se[p7] p8=_b[p8] se_p8=_se[p8] p9=_b[p9] se_p9=_se[p9] p10=_b[p10] se_p10=_se[p10] p11=_b[p11] se_p11=_se[p11] p12=_b[p12] se_p12=_se[p12] p13=_b[p13] se_p13=_se[p13] p14=_b[p14] se_p14=_se[p14] p15=_b[p15] se_p15=_se[p15] p16=_b[p16] se_p16=_se[p16] p17=_b[p17] se_p17=_se[p17] p18=_b[p18] se_p18=_se[p18] p19=_b[p19] se_p19=_se[p19] p20=_b[p20] se_p20=_se[p20] p21=_b[p21] se_p21=_se[p21] p22=_b[p22] se_p22=_se[p22] p23=_b[p23] se_p23=_se[p23] p24=_b[p24] se_p24=_se[p24], by(IDmeter) nodots saving(coeff_p24_DZ0Sum.dta, replace) : ///
areg he p1-p24  price hdd_s1-hdd_s5 cdd_s1-cdd_s5 i.dy i.hour if  summer==1 & DorR=="D", absorb(IDmeter)

statsby p1=_b[p1] se_p1=_se[p1] p2=_b[p2] se_p2=_se[p2] p3=_b[p3] se_p3=_se[p3] p4=_b[p4] se_p4=_se[p4] p5=_b[p5] se_p5=_se[p5] p6=_b[p6] se_p6=_se[p6] p7=_b[p7] se_p7=_se[p7] p8=_b[p8] se_p8=_se[p8] p9=_b[p9] se_p9=_se[p9] p10=_b[p10] se_p10=_se[p10] p11=_b[p11] se_p11=_se[p11] p12=_b[p12] se_p12=_se[p12] p13=_b[p13] se_p13=_se[p13] p14=_b[p14] se_p14=_se[p14] p15=_b[p15] se_p15=_se[p15] p16=_b[p16] se_p16=_se[p16] p17=_b[p17] se_p17=_se[p17] p18=_b[p18] se_p18=_se[p18] p19=_b[p19] se_p19=_se[p19] p20=_b[p20] se_p20=_se[p20] p21=_b[p21] se_p21=_se[p21] p22=_b[p22] se_p22=_se[p22] p23=_b[p23] se_p23=_se[p23] p24=_b[p24] se_p24=_se[p24], by(IDmeter) nodots saving(coeff_p24_DZ0Win.dta, replace) : ///
areg he p1-p24  price hdd_s1-hdd_s5 cdd_s1-cdd_s5 i.dy i.hour if  summer==0 & DorR=="D", absorb(IDmeter)

statsby p1=_b[p1] se_p1=_se[p1] p2=_b[p2] se_p2=_se[p2] p3=_b[p3] se_p3=_se[p3] p4=_b[p4] se_p4=_se[p4] p5=_b[p5] se_p5=_se[p5] p6=_b[p6] se_p6=_se[p6] p7=_b[p7] se_p7=_se[p7] p8=_b[p8] se_p8=_se[p8] p9=_b[p9] se_p9=_se[p9] p10=_b[p10] se_p10=_se[p10] p11=_b[p11] se_p11=_se[p11] p12=_b[p12] se_p12=_se[p12] p13=_b[p13] se_p13=_se[p13] p14=_b[p14] se_p14=_se[p14] p15=_b[p15] se_p15=_se[p15] p16=_b[p16] se_p16=_se[p16] p17=_b[p17] se_p17=_se[p17] p18=_b[p18] se_p18=_se[p18] p19=_b[p19] se_p19=_se[p19] p20=_b[p20] se_p20=_se[p20] p21=_b[p21] se_p21=_se[p21] p22=_b[p22] se_p22=_se[p22] p23=_b[p23] se_p23=_se[p23] p24=_b[p24] se_p24=_se[p24], by(IDmeter) nodots saving(coeff_p24_RZ0Sum.dta, replace) : ///
areg he p1-p24  price hdd_s1-hdd_s5 cdd_s1-cdd_s5 i.dy i.hour if  summer==1 & DorR=="R", absorb(IDmeter)

statsby p1=_b[p1] se_p1=_se[p1] p2=_b[p2] se_p2=_se[p2] p3=_b[p3] se_p3=_se[p3] p4=_b[p4] se_p4=_se[p4] p5=_b[p5] se_p5=_se[p5] p6=_b[p6] se_p6=_se[p6] p7=_b[p7] se_p7=_se[p7] p8=_b[p8] se_p8=_se[p8] p9=_b[p9] se_p9=_se[p9] p10=_b[p10] se_p10=_se[p10] p11=_b[p11] se_p11=_se[p11] p12=_b[p12] se_p12=_se[p12] p13=_b[p13] se_p13=_se[p13] p14=_b[p14] se_p14=_se[p14] p15=_b[p15] se_p15=_se[p15] p16=_b[p16] se_p16=_se[p16] p17=_b[p17] se_p17=_se[p17] p18=_b[p18] se_p18=_se[p18] p19=_b[p19] se_p19=_se[p19] p20=_b[p20] se_p20=_se[p20] p21=_b[p21] se_p21=_se[p21] p22=_b[p22] se_p22=_se[p22] p23=_b[p23] se_p23=_se[p23] p24=_b[p24] se_p24=_se[p24], by(IDmeter) nodots saving(coeff_p24_RZ0Win.dta, replace) : ///
areg he p1-p24  price hdd_s1-hdd_s5 cdd_s1-cdd_s5 i.dy i.hour if  summer==0 & DorR=="R", absorb(IDmeter)


*************event study

 eventdd he i.dy i.hour price hdd_s1-hdd_s5 cdd_s1-cdd_s5 if DorR=="D", fe timevar(timeToTreat)  vce(cluster BILACCT_K_ENC) graph_op(ytitle("Average hourly kWh") xtitle("Time"))
 eventdd he i.dy i.hour price hdd_s1-hdd_s5 cdd_s1-cdd_s5 if DorR=="R", fe timevar(timeToTreat)  vce(cluster BILACCT_K_ENC) graph_op(ytitle("Average hourly kWh") xtitle("Time"))
  eventdd he i.dy i.hour price hdd_s1-hdd_s5 cdd_s1-cdd_s5 [aweight=_weight] if DorR=="D", fe timevar(timeToTreat)  vce(cluster BILACCT_K_ENC) graph_op(ytitle("Average hourly kWh") xtitle("Time"))
 eventdd he i.dy i.hour price hdd_s1-hdd_s5 cdd_s1-cdd_s5 [aweight=_weight] if DorR=="R", fe timevar(timeToTreat)  vce(cluster BILACCT_K_ENC) graph_op(ytitle("Average hourly kWh") xtitle("Time"))
   eventdd he i.dy i.hour price hdd_s1-hdd_s5 cdd_s1-cdd_s5 [aweight=cem_weights] if DorR=="D", fe timevar(timeToTreat)  vce(cluster BILACCT_K_ENC) graph_op(ytitle("Average hourly kWh") xtitle("Time"))
 eventdd he i.dy i.hour price hdd_s1-hdd_s5 cdd_s1-cdd_s5 [aweight=cem_weights] if DorR=="R", fe timevar(timeToTreat)  vce(cluster BILACCT_K_ENC) graph_op(ytitle("Average hourly kWh") xtitle("Time"))

