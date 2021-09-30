set more off


log using read_gss_jobtenure.log, replace

qui do GSS.do

drop if age < 22 | age > 64
*drop if age < 18 | age > 64
drop if wrkstat > 4
* exclude black oversamples
drop if inlist(sample,4,5,7)==1

summ age wrkstat

tab1 year

gen ageg=.
replace ageg=1 if age < 25
replace ageg=2 if age>=25 & age < 35
replace ageg=3 if age>=35 & age < 45
replace ageg=4 if age>=45 & age < 55
replace ageg=5 if age >= 55

label define ageglbl 1 "Less than 25" 2 "25 to 34" 3 "35 to 44" 4 "45 to 54" 5 "55 plus"
label values ageg ageglbl

gen ageg4=.
replace ageg4=1 if age < 25
replace ageg4=2 if age>=25 & age < 35
replace ageg4=3 if age>=35 & age < 55
replace ageg4=4 if age >= 55

tab1 ageg ageg4

gen edg=.
replace edg=1 if educ>=0 & educ<=12
replace edg=2 if educ > 12 & educ < 98
label define edglbl 1 "HS or less" 2 "Some college or more"
label values edg edglbl

tab1 edg

gen female=(sex==2)

* For 2004 on, need to use a weight. Using wtsall. Prior to 2004 is self-weighting but appears reflected in wtsall.


* Plot joblose and jobfind over time, also mobile16. These are the long series.

* dummy for likely or very likely to lose job or be laid off in next 12 months
gen djoblose=.
replace djoblose=1 if joblose==1 | joblose==2
replace djoblose=0 if joblose==3 | joblose==4

* dummy for easy or somewhat easy to find equally good job - only one other cat, which is not easy
gen djobfind=.
replace djobfind=1 if jobfind==1 | jobfind==2
replace djobfind=0 if jobfind==3 

gen djobfind_very=.
replace djobfind_very=1 if jobfind==1 
replace djobfind_very=0 if jobfind==2 | jobfind==3 

* dummy for living in different city or state vs age 16 
gen dmobile=.
replace dmobile=1 if mobile16==2 | mobile16==3
replace dmobile=0 if mobile16==1

preserve
collapse (mean) djoblose djobfind dmobile [pw=wtssall], by(year)
summ

sort year
corr djobfind djoblose
graph twoway connect djoblose year || connect djobfind year
*graph twoway connect dmobile year

restore
preserve
collapse (mean) djoblose djobfind dmobile [pw=wtssall], by(year ageg4)

* Could do two-axis plot with unemp rate
sort year ageg
merge m:1 year using annual_UNRATE.dta
*tab1 year if _merge < 3
drop if _merge < 3
drop _merge

gr twoway line djoblose year if ageg4==1, lwidth(medthick) yaxis(1) || line djoblose year if ageg4==2, lwidth(medthick) yaxis(1) || line djoblose year if ageg4==3, lwidth(medthick) yaxis(1) || line djoblose year if ageg4==4, lwidth(medthick) yaxis(1) ///
  legend(label(1 "Less than 25") label(2 "25 to 34") label(3 "35 to 54") label(4 "55 plus")) ///
  bgcolor(white) ytitle("Share likely/v. likely to lose job in next year") xtitle("Survey Year") ///
  saving(djoblose_age, replace)
*gr twoway connect djoblose year if ageg==1, yaxis(1) || connect djoblose year if ageg==2, yaxis(1) || connect djoblose year if ageg==3, yaxis(1) || connect djoblose year if ageg==4, yaxis(1) || connect djoblose year if ageg==5, yaxis(1) || connect UNRATE year, yaxis(2) ///
  legend(label(1 "Less than 25") label(2 "25 to 34") label(3 "35 to 44") label(4 "45 to 54") label(5 "55 plus")) ///
  saving(djoblose_age, replace)

keep djoblose year ageg4 UNRATE
save djoblose_age_graph.dta, replace

tsset ageg4 year
reg djoblose UNRATE
reg djoblose L1.UNRATE UNRATE F.UNRATE
*sort ageg4 year
*by ageg4: reg djoblose UNRATE
corr djoblose UNRATE

restore
preserve
collapse (mean) djoblose djobfind dmobile [pw=wtssall], by(year ageg)

gr twoway connect djobfind year if ageg==1 || connect djobfind year if ageg==2 || connect djobfind year if ageg==3 || connect djobfind year if ageg==4 || connect djobfind year if ageg==5, ///
  legend(label(1 "Less than 25") label(2 "25 to 34") label(3 "35 to 44") label(4 "45 to 54") label(5 "55 plus")) ///
  saving(djobfind_age, replace)
gr twoway connect dmobile year if ageg==1 || connect dmobile year if ageg==2 || connect dmobile year if ageg==3 || connect dmobile year if ageg==4 || connect dmobile year if ageg==5, ///
  legend(label(1 "Less than 25") label(2 "25 to 34") label(3 "35 to 44") label(4 "45 to 54") label(5 "55 plus")) ///
  saving(dmobile_age, replace)
* even within age groups, this measure of long run geo mobility does not show a downtrend
  
restore

* Replicating Raven's analysis in the Quality of Employment module for 200x and later

replace jobsecok=. if inlist(jobsecok,8,9,0)==1

gen yearsjobrec=yearsjob
recode yearsjobrec (0.25=1) (0.75=2) (1/2=3) (3/5=4) (6/10=5) (11/19=6) (20/67=7) (-1=.) (98/99=.)
tab1 yearsjobrec

label variable yearsjobrec "Years on current job"
label define yearsjoblbl 1 "Less than 6 mos" 2 "6 to 11.9 mos" 3 "1 or 2 years" 4 "3 to 5 years" 5 "6 to 10 years" 6 "11 to 19 years" 7 "20+ years"
label values yearsjobrec yearsjoblbl

gen yearsjobrec2=yearsjob
recode yearsjobrec2 (0.25/0.75=1) (1/2=2) (3/5=3) (6/10=4) (11/19=5) (20/67=6) (-1=.) (98/99=.)
tab1 yearsjobrec2

label variable yearsjobrec2 "Years on current job"
label define yearsjoblbl2 1 "Less than 1 year" 2 "1 or 2 years" 3 "3 to 5 years" 4 "6 to 10 years" 5 "11 to 19 years" 6 "20+ years"
label values yearsjobrec2 yearsjoblbl2

* Union status of r or spouse - this is a balloted question, so goes to random 2/3 of GSS respondents. 
* Did not find any info about adjusting weights for balloting.
gen union=.
replace union=1 if union_==1
replace union=0 if union_ >=2 & union_ <=9

gen unionfam=.
replace unionfam=1 if union_==1 | union_==2
replace unionfam=0 if union_ >=3 & union_ <=9
summ union unionfam

gen dtrynewjb=.
replace dtrynewjb=1 if trynewjb==1 | trynewjb==2 
replace dtrynewjb=0 if trynewjb==3

gen dtrynewjb_very=.
replace dtrynewjb_very=1 if trynewjb==1 
replace dtrynewjb_very=0 if trynewjb==2 | trynewjb==3

replace satjob1=. if inlist(satjob1,8,9,0)==1

gen dsatjob=.
replace dsatjob=1 if satjob1==1 | satjob1==2
replace dsatjob=0 if satjob1==3 | satjob1==4

gen djobsecok=.
replace djobsecok=1 if jobsecok==1 | jobsecok==2
replace djobsecok=0 if jobsecok==3 | jobsecok==4

*bys year: summ yearsjobrec jobsecok djobfind dtrynewjb satjob1

save gss_jobtenure.dta, replace

* limit to years where all five q of emp variables available
keep if inlist(year,2002,2006,2010,2014,2018)==1

tab1 year
tab1 yearsjobrec 

tabulate djobfind wrkstat

* Table 5 means

mean djobsec djobfind dsatjob dtrynewjb [pw=wtssall]
*table yearsjobrec [pw=wtssall], contents(mean djobsec mean djobfind mean dsatjob mean dtrynewjb n djobsec) 
table yearsjobrec2 [pw=wtssall], contents(mean djobsec mean djobfind mean dsatjob mean dtrynewjb n djobsec) 
mean djobsec djobfind dsatjob dtrynewjb if age>=50 & age <=64 & sex==1 [pw=wtssall]

* Unweighted
summ djobsec djobfind dsatjob dtrynewjb 
table yearsjobrec, contents(mean djobsec mean djobfind mean dsatjob mean dtrynewjb n djobsec) 
summ djobsec djobfind dsatjob dtrynewjb if age>=50 & age <=64 & sex==1 

/***

* weights on tabulate? need alt method. can do table contents(freq) but no row share
tabulate yearsjobrec jobsecok, row
table yearsjobrec [pw=wtssall], contents(mean djobfind mean djobfind_very mean dtrynewjb mean dtrynewjb_very) 
tabulate yearsjobrec satjob1, row

tabulate yearsjobrec jobsecok if year==2002 | year==2006, row
table yearsjobrec [pw=wtssall], contents(mean djobfind mean djobfind_very mean dtrynewjb mean dtrynewjb_very)
tabulate yearsjobrec satjob1 if year==2002 | year==2006, row

tabulate yearsjobrec jobsecok if year==2010 | year==2014, row
table yearsjobrec [pw=wtssall], contents(mean djobfind mean djobfind_very mean dtrynewjb mean dtrynewjb_very)
tabulate yearsjobrec satjob1 if year==2010 | year==2014, row

* By age
tabulate ageg jobsecok, row
table ageg [pw=wtssall], contents(mean djobfind mean djobfind_very mean dtrynewjb mean dtrynewjb_very) 
tabulate ageg satjob1, row

* By education group
tabulate edg jobsecok, row
table edg [pw=wtssall], contents(mean djobfind mean djobfind_very mean dtrynewjb mean dtrynewjb_very) 
tabulate edg satjob1, row

* By sex
tabulate sex jobsecok, row
table sex [pw=wtssall], contents(mean djobfind mean djobfind_very mean dtrynewjb mean dtrynewjb_very) 
tabulate sex satjob1, row

* By own union status
tabulate union jobsecok, row
table union [pw=wtssall], contents(mean djobfind mean djobfind_very mean dtrynewjb mean dtrynewjb_very) 
tabulate union satjob1, row

* By own or spouse (family) union status
tabulate unionfam jobsecok, row
table unionfam [pw=wtssall], contents(mean djobfind mean djobfind_very mean dtrynewjb mean dtrynewjb_very) 
tabulate unionfam satjob1, row

***/


/*
* Repeat limiting to those age 25 and up
preserve
drop if age < 25
tabulate yearsjobrec jobsecok, row
table yearsjobrec [pw=wtssall], contents(mean djobfind mean dtrynewjb) 
tabulate yearsjobrec satjob1, row
*/

restore

* Tabulate job sec by tenure and year - look for 2000's trend - using jobsecok from gss, NOTE there is a separate jobsec GSS variable
* This gives share saying statement job security is good is very true
summ jobsec
gen goodjobsec=.
replace goodjobsec=1 if jobsecok==1
replace goodjobsec=0 if jobsecok > 1 & jobsecok~=.
table yearsjobrec year [pw=wtssall], contents(mean goodjobsec n goodjobsec)

log close


