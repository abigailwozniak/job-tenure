set more off
clear
drop _all

local datapath="C:\Users\15099\Downloads\christopher_replicationcode\processed\"
local outputpath="C:\Users\15099\Downloads\christopher_replicationcode\output\"
local dtapath="C:\Users\15099\Downloads\christopher_replicationcode\"
local logpath="C:\Users\15099\Downloads\christopher_replicationcode\"

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

use year age sex jtsuppwt jtyears empstat classwkr educ marst ind1990 occ1990 ind occ using "`dtapath'cps_00138.dta" if year>=1996, clear
keep if year>=1996
keep if age>=22 & age<=64
drop if jtyears>=90 
keep if (empstat==10 | empstat==12) 
keep if (classwkr>=21 & classwkr<=28) 

gen hsd=(educ>=2 & educ<72) 
gen hsg=(educ==72 | educ==73) 
gen sc=(educ>73 & educ<111) 
gen cg=(educ>=111 & educ!=.) 

gen tenure=.
gen w=.

***PROCESSING TENURE

*1996+
replace jtyears=. if jtyears>90 & year>=1996
replace jtyears=32 if jtyears>=32 & jtyears!=. & year>=1996
replace tenure=jtyears if year>=1996
replace w=jtsuppwt if year>=1996

keep if tenure>=0 & tenure!=.
drop if w<=0

gen pop=w
gen tenurelt1y=(tenure<1 & tenure!=.)

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

gen yearg=1 if year>=1996 & year<=2000
replace yearg=2 if year>=2016 & year<=2020

keep if yearg!=.
replace tenurelt1y=tenurelt1y*100
local i=1
mat A=J(18,3,0)
foreach s in 1 2 {
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
	"edg==2"
 {;
# delimit cr
	
sum tenurelt1y [aw=w] if sex==`s' & `r' & yearg==1
local m1=`r(mean)'
mat A[`i',1]=`r(mean)'

sum tenurelt1y [aw=w] if sex==`s' & `r' & yearg==2
local m2=`r(mean)'
mat A[`i',2]=`r(mean)'

local diff=`m2'-`m1'

mat A[`i',3]=`diff'
local ++i
}
}

drop _all
svmat A
save "`outputpath'appendtable2.dta", replace

