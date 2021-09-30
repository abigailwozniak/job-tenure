* read in SIPP data 1986 to 1989 panels

set trace off
set more 1 
capture log close
clear
clear matrix
set linesize 200
set maxvar 30000

log using sipp8689ten.log, replace

use ~/scratch3/tempsipp80, clear

rename sc1000 worked
rename sc1656 enrold
rename ws1_2002 empid1
rename ws1_2012 emptype1
rename ws1_2014 employed1
rename ws1_2023 leftemp1
rename ws1_2024 reasleft1
rename ws1_2025 hrswk1
rename ws2_2102 empid2
rename ws2_2112 emptype2
rename ws2_2114 employed2
rename ws2_2123 leftemp2
rename ws2_2124 reasleft2
rename ws2_2125 hrswk2
rename sc1714 selfemp

rename ws1_2016 mbeg1
rename ws2_2116 mbeg2
rename sc1716 njobs

replace emptype2 = ws2_2012 if panel<=1987 & wave==1

* apparently only asked in wave 2
rename tm8214 empidten
rename tm8218 mstartemp
rename tm8220 ystartemp
quietly for var empidten mstartemp ystartemp: replace X = . if wave~=2

* it turns out that these fields are for the previous job held, not a concurently-held job
*rename tm8268 mstartemp2
*rename tm8270 ystartemp2

* in_af = in armed forces


keep suseqnum su_id su_rot state h1_wgt fnlwgt* h1_state u1ccwave esr_* leftemp* reasleft* age* sex race ethnicty enrold higrade grd_cmpl in_af ws1_occ ws1_ind ws2_occ ws2_ind selfemp mstartemp* ystartemp* h*_month h*_year wave pp_pnum rrp* panel worked emptype* employed* pp_intvw hrswk* empid* mbeg* selfemp enrold njobs
egen test = count(h4_month), by(panel su_id pp_pnum wave)
tab test
drop if test>=2
drop test

keep if age_1>=22 & age_1<=64

tab empidten
tab empidten if empidten==empid1
tab empidten if empidten==empid2
tab empid1 if empid1==empid2

rename mstartemp mstartemp1
rename ystartemp ystartemp1

tab ystartemp if ystartemp~=0
tab mstartemp if ystartemp~=0

gen month = h4_month 
gen year = h4_year +1900


quietly for var ystartemp1 mstartemp1 : replace X = . if X==0

keep panel su_id pp_pnum wave year month ystartemp* mstartemp* empid* age_1 sex race ethnicty enrold higrade grd_cmpl mbeg* fnlwgt_4 selfemp enrold emptype* njobs
reshape long ystartemp mstartemp empid mbeg emptype, i(panel su_id pp_pnum wave) j(job)
drop if empid==-9
sum ystartemp mstartemp, det
replace ystartemp = . if ystartemp<1900
replace mstartemp = . if mstartemp>12
tab month year if ystartemp~=.
tab month year if wave==2
sort panel su_id pp_pnum empid year month
quietly by panel su_id pp_pnum empid: replace ystartemp = ystartemp[_n-1] if ystartemp==.
quietly by panel su_id pp_pnum empid: replace mstartemp = mstartemp[_n-1] if mstartemp==.
tab month year if ystartemp~=.
gen time = year+month/12-1/24
gen starttime = ystartemp+mstartemp/12-1/24
gen tenyr = time - starttime
sum tenyr, det
replace tenyr = . if tenyr<0
table month year [pw=fnlwgt_4], c(m tenyr)

replace mbeg = . if mbeg==0
replace mbeg = . if wave==1

gen tenyrb = (month - mbeg)/12 if mbeg~=. & month>=4
replace tenyrb = 3/12 if mbeg~=. & month==1 & mbeg==10
replace tenyrb = 2/12 if mbeg~=. & month==1 & mbeg==11
replace tenyrb = 1/12 if mbeg~=. & month==1 & mbeg==12
replace tenyrb = 0 if mbeg~=. & month<=3 & month==mbeg
replace tenyrb = 3/12 if mbeg~=. & month==2 & mbeg==11
replace tenyrb = 2/12 if mbeg~=. & month==2 & mbeg==12
replace tenyrb = 1/12 if mbeg~=. & month==2 & mbeg==1
replace tenyrb = 3/12 if mbeg~=. & month==3 & mbeg==12
replace tenyrb = 2/12 if mbeg~=. & month==3 & mbeg==1
replace tenyrb = 1/12 if mbeg~=. & month==3 & mbeg==2
sum tenyrb
sort panel su_id pp_pnum empid year month
quietly by panel su_id pp_pnum empid: replace tenyrb = tenyrb[_n-1]+4/12 if tenyrb==.
sum tenyrb


* about half of the cases of tenyrb would replace an existing value of tenyr
sum tenyrb tenyr if tenyr~=. & tenyrb~=. & wave==2 & tenyr~=tenyrb
sum tenyrb  if tenyr==. & wave==2
sum tenyr  if tenyrb==. & wave==2

replace tenyr = tenyrb if tenyr==.
sum tenyr, det
table month year [pw=fnlwgt_4], c(m tenyr)
table month year if selfemp==1 & enrold==3 [pw=fnlwgt_4], c(m tenyr)

gen tenmiss = tenyr==. if selfemp==1 & enrold==3 

tab emptype if selfemp==1 & enrold==3
table month year if selfemp==1 & enrold==3 & emptype>=1 & emptype<=6 [pw=fnlwgt_4], c(m tenyr)
table month year if selfemp==1 & enrold==3 & emptype>=1 & emptype<=6 [pw=fnlwgt_4], c(m tenmiss)
* number of employers is never <=0
tab njobs if selfemp==1 & enrold==3

keep if selfemp==1 & enrold==3 & emptype>=1 & emptype<=6 & wave==2
gen tenlt1q = tenyr<.25 if tenyr~=.
gen ten1q = tenyr<=.25 if tenyr~=.
gen ten1q1y = tenyr>.25 & tenyr<=1 if tenyr~=.
gen tenlt1y = tenyr<1 if tenyr~=.
gen ten1y = tenyr<=1 if tenyr~=.
gen ten13 = tenyr>=1 & tenyr<3 if tenyr~=.
preserve
collapse (mean) mtensipp=tenyr tenlt1q ten1q ten1q1y ten1y tenlt1y ten13 (median) medtensipp=tenyr [pw=fnlwgt_4], by(year)
save fig1sipp8689, replace

quietly log close
