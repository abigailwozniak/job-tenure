set more off
clear
drop _all

*FOR CALCULATING LONG TENURE COHORT EFFECTS

local logpath="C:\Users\15099\Downloads\christopher_replicationcode\"
local datapath="C:\Users\15099\Downloads\christopher_replicationcode\processed\"
local outputpath="C:\Users\15099\Downloads\christopher_replicationcode\output\"
local dtapath="C:\Users\15099\Downloads\christopher_replicationcode\"

log using "`logpath'cohort-effects-longtenure.log", replace

use "`datapath'jan1983.dta", clear
keep if age>=55 & age<=64
keep if esr==1 | esr==2
keep if class>=1 & class<=2

gen married=(marst==1 | marst==2 | marst==3)

gen hsd=(grdatn<13) | (grdatn==13 & grdcomp==2)
gen hsg=(grdatn==13 & grdcomp==1)
gen sc=(grdatn>=14 & grdatn<17) | (grdatn==17 & grdcomp==2)
gen cg=(grdatn>17) | (grdatn==17 & grdcomp==1)

keep weightsupp age sex married monthwork yrswork year hsd hsg sc cg 

tempfile t1983
save `t1983', replace

use "`datapath'/jan1987.dta", clear
keep if age>=55 & age<=64
keep if esr==1 | esr==2
keep if class>=1 & class<=2

gen married=(marst==1 | marst==2 | marst==3)

gen hsd=(grdatn<13) | (grdatn==13 & grdcomp==2)
gen hsg=(grdatn==13 & grdcomp==1)
gen sc=(grdatn>=14 & grdatn<17) | (grdatn==17 & grdcomp==2)
gen cg=(grdatn>17) | (grdatn==17 & grdcomp==1)

keep weightsupp age sex married monthwork yrswork year hsd hsg sc cg 

tempfile t1987
save `t1987', replace

use "`datapath'/jan1991.dta", clear
keep if age>=55 & age<=64
keep if esr==1 | esr==2
keep if class>=1 & class<=4

gen married=(marst==1 | marst==2 | marst==3)

gen hsd=(grdatn<12) | (grdatn==12 & grdcomp==2)
gen hsg=(grdatn==12 & grdcomp==1)
gen sc=(grdatn>=13 & grdatn<16) | (grdatn==16 & grdcomp==2)
gen cg=(grdatn>16) | (grdatn==16 & grdcomp==1)

keep weight age sex married monthwork yrswork year hsd hsg sc cg 

tempfile t1991
save `t1991', replace

use "`dtapath'cps_00138.dta" if year>=1996, clear
keep if year>=1996
keep if age>=55 & age<=64
drop if jtyears>=90 
keep if (empstat==10 | empstat==12) 
keep if (classwkr>=21 & classwkr<=28) 

foreach yr in 1983 1987 1991 {
append using `t`yr''
}

gen tenure=.
gen w=.

***PROCESSING TENURE

*1983 and 1987
replace tenure=(monthwork)/12 if monthwork>=1 & monthwork<=12 & (year==1983 | year==1987)
replace tenure=yrswork if yrswork>=1 & yrswork<=75 & (year==1983 | year==1987)
replace w=weightsupp if (year==1983 | year==1987)

*1991
replace tenure=(monthwork)/12 if monthwork>=1 & monthwork<=12 & year==1991
replace tenure=yrswork if yrswork>=1 & yrswork<=75 & year==1991
replace w=weight if year==1991

*1996+
replace jtyears=. if jtyears>90 & year>=1996
replace jtyears=32 if jtyears>=32 & jtyears!=. & year>=1996
replace tenure=jtyears if year>=1996
replace w=jtsuppwt if year>=1996

keep if tenure>=0 & tenure!=.
drop if w<=0

gen pop=w
gen tenure20p=(tenure>=20 & tenure!=.) 

preserve
foreach sex in 1 2 {
restore
preserve
keep if sex==`sex'

gen cohort=year-age

sum cohort

local min=`r(min)'
local max=`r(max)'

local count=`max'-`min'+1

foreach n of numlist `min'/`max' {
gen cohort`n'=(cohort==`n')
}

foreach a of numlist 55/64 {
gen age`a'=(age==`a')
}

xi: reg tenure20p cohort`min'-cohort`max' age56 age57 age58 age59 age60 age61 age62 age63 age64 [aw=pop], nocons

predict pred_tenure20p
gen agetmp=0

foreach age of numlist 56/64 {
replace pred_tenure20p=pred_tenure20p-(_b[age`age']*age`age')
replace agetmp=agetmp+(_b[age`age'])
}
replace agetmp=agetmp/10
replace pred_tenure20p=pred_tenure20p+agetmp

drop agetmp
rename pred_tenure20p ten20p_5564_`sex'

sort cohort
collapse (mean) ten20p_5564_`sex' [aw=pop], by(cohort)

sort cohort
keep cohort ten20p_5564_`sex'
save "`outputpath'cohort-effects-longtenure-sex`sex'.dta", replace
}

capture log close
