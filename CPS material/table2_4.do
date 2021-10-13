set more off
clear
drop _all
local datapath="C:\Users\15099\Downloads\christopher_replicationcode\processed\"
local outputpath="C:\Users\15099\Downloads\christopher_replicationcode\output\"
local dtapath="C:\Users\15099\Downloads\christopher_replicationcode\"

use "`dtapath'ind-occ-asec.dta", clear
sort year occ 
collapse (mean) occ1990, by(year occ)
sort year occ
tempfile occ
save `occ', replace

use "`dtapath'ind-occ-asec.dta", clear
sort year ind
collapse (mean) ind1990, by(year ind)
sort year ind
tempfile ind
save `ind', replace

use "`datapath'jan1983.dta", clear
keep if age>=40 & age<=64
keep if esr==1 | esr==2
keep if class>=1 & class<=2

gen married=(marst==1 | marst==2 | marst==3)

drop if ind==0 | ind==.
drop if occ==0 | occ==.

gen hsd=(grdatn<13) | (grdatn==13 & grdcomp==2)
gen hsg=(grdatn==13 & grdcomp==1)
gen sc=(grdatn>=14 & grdatn<17) | (grdatn==17 & grdcomp==2)
gen cg=(grdatn>17) | (grdatn==17 & grdcomp==1)

sort year ind
merge year ind using `ind'
tab _merge
keep if _merge==3
drop _merge
sort year occ
merge year occ using `occ'
tab _merge
keep if _merge==3
drop _merge

keep weightsupp age sex married monthwork yrswork year ind1990 occ1990 occ ind hsd hsg sc cg 

tempfile t1983
save `t1983', replace

use "`datapath'jan1987.dta", clear
keep if age>=40 & age<=64
keep if esr==1 | esr==2
keep if class>=1 & class<=2

gen married=(marst==1 | marst==2 | marst==3)

drop if ind==0 | ind==.
drop if occ==0 | occ==.

gen hsd=(grdatn<13) | (grdatn==13 & grdcomp==2)
gen hsg=(grdatn==13 & grdcomp==1)
gen sc=(grdatn>=14 & grdatn<17) | (grdatn==17 & grdcomp==2)
gen cg=(grdatn>17) | (grdatn==17 & grdcomp==1)

sort year ind
merge year ind using `ind'
tab _merge
keep if _merge==3
drop _merge
sort year occ
merge year occ using `occ'
tab _merge
keep if _merge==3
drop _merge

keep weightsupp age sex married monthwork yrswork year ind1990 occ1990 occ ind hsd hsg sc cg 

tempfile t1987
save `t1987', replace

use "`datapath'jan1991.dta", clear
keep if age>=40 & age<=64
keep if esr==1 | esr==2
keep if class>=1 & class<=4

gen married=(marst==1 | marst==2 | marst==3)

drop if ind==0 | ind==.
drop if occ==0 | occ==.

gen hsd=(grdatn<12) | (grdatn==12 & grdcomp==2)
gen hsg=(grdatn==12 & grdcomp==1)
gen sc=(grdatn>=13 & grdatn<16) | (grdatn==16 & grdcomp==2)
gen cg=(grdatn>16) | (grdatn==16 & grdcomp==1)

sort year ind
merge year ind using `ind'
tab _merge
keep if _merge==3
drop _merge
sort year occ
merge year occ using `occ'
tab _merge
keep if _merge==3
drop _merge

keep weight age sex married monthwork yrswork year ind1990 occ1990 occ ind hsd hsg sc cg 

tempfile t1991
save `t1991', replace

use year age sex jtsuppwt jtyears empstat classwkr educ marst ind1990 occ1990 ind occ using "`dtapath'cps_00138.dta" if year>=1996, clear
keep if year>=1996
keep if age>=40 & age<=64
drop if jtyears>=90 
keep if (empstat==10 | empstat==12) 
keep if (classwkr>=21 & classwkr<=28) 

gen hsd=(educ>=2 & educ<72) 
gen hsg=(educ==72 | educ==73) 
gen sc=(educ>73 & educ<111) 
gen cg=(educ>=111 & educ!=.) 

gen married=(marst==1 | marst==2)

foreach yr in 1983 1987 1991 {
append using `t`yr''
}

keep if age>=40 & age<=64

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
gen tenure20=(tenure>=20 & tenure!=.)
gen tenurelt1Q=(tenure<.25 & tenure!=.)

gen indgroup=0
gen occgroup=0

*manuf
replace indgroup=1 if (ind1990>=100 & ind1990<=392) 

*public admin
replace indgroup=2 if (ind1990>=900 & ind1990<=932) 

replace indgroup=3 if ind1990>=1 & ind1990<=932 & indgroup!=1 & indgroup!=2

assert indgroup!=. 

*non-routine cog=manag, prof, tech
replace occgroup=1 if occ1990>=3 & occ1990<=235
*routine cog=sales, clerical, admin support
replace occgroup=2 if occ1990>=243 & occ1990<=391
*routine manual=prod, craft, repair, operator
replace occgroup=3 if occ1990>=503 & occ1990<=890
*non-routine man=service
replace occgroup=4 if occ1990>=405 & occ1990<=498

gen edg=1 if hsd==1 | hsg==1
replace edg=2 if sc==1 | cg==1

gen yearg=1 if year==1983 | year==1987
replace yearg=2 if year>=2010 & year<=2020

keep if yearg!=.
replace tenure20=tenure20*100
foreach s in 1 2 {
mat A_`s'=J(13,3,0)
local i=1
# delimit ;
foreach r in 
	"indgroup==1"
	"indgroup==2"
	"indgroup==3"
	"occgroup==1"
	"occgroup==2"
	"occgroup==3"
	"occgroup==4"
	"edg==1"
	"edg==1 & married==1"
	"edg==1 & married==0"
	"edg==2"
	"edg==2 & married==1"
	"edg==2 & married==0" {;
# delimit cr
	
sum tenure20 [aw=w] if sex==`s' & `r' & yearg==1
local m1=`r(mean)'
mat A_`s'[`i',1]=`r(mean)'

sum tenure20 [aw=w] if sex==`s' & `r' & yearg==2
local m2=`r(mean)'
mat A_`s'[`i',2]=`r(mean)'

local diff=`m2'-`m1'

mat A_`s'[`i',3]=`diff'
local ++i
}
}

drop _all
svmat A_1
save "`outputpath'table2.dta", replace

drop _all
svmat A_2
save "`outputpath'table4.dta", replace
