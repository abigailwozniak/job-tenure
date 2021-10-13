set more off
clear
drop _all
graph drop _all
capture log close

***Table 1

local datapath="C:\Users\15099\Downloads\christopher_replicationcode\processed\"
local outputpath="C:\Users\15099\Downloads\christopher_replicationcode\output\"
local dtapath="C:\Users\15099\Downloads\christopher_replicationcode\"
local logpath="C:\Users\15099\Downloads\christopher_replicationcode\"

use "`datapath'jan1983.dta", clear
keep if age>=22 & age<=64
keep if esr==1 | esr==2
keep if class>=1 & class<=2
tempfile t1983
save `t1983', replace

use "`datapath'jan1987.dta", clear
keep if age>=22 & age<=64
keep if esr==1 | esr==2
keep if class>=1 & class<=2

tempfile t1987
save `t1987', replace

use "`datapath'jan1991.dta", clear
keep if age>=22 & age<=64
keep if esr==1 | esr==2
keep if class>=1 & class<=4

tempfile t1991
save `t1991', replace

use year jtyears empstat age sex classwkr jtsuppwt using "`dtapath'cps_00138.dta", clear
keep if year>=1996
drop if jtyears>=90 
keep if (empstat==10 | empstat==12) 
keep if age>=22 & age<=64
keep if (classwkr>=21 & classwkr<=28) 

foreach yr in 1983 1987 1991 {
append using `t`yr''
}

gen tenure=.
gen w=.

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
replace jtyears=32 if jtyears>=32 & jtyears!=. 
replace tenure=jtyears if year>=1996
replace w=jtsuppwt if year>=1996

keep if tenure>=0 & tenure!=.
drop if w<=0

gen yr=.

replace yr=1 if year>=1983 & year<=1991
replace yr=2 if year>=2002 & year<=2020
keep if yr!=.

gen ageg1=(age>=22 & age<=39)*100
gen ageg2=(age>=40 & age<=49)*100
gen ageg3=(age>=50 & age<=59)*100
gen ageg4=(age>=60 & age<=64)*100

gen longten=(tenure>=20 & tenure!=.)*100

keep if age>=22 & age<=64

mat A=J(9,8,0)

local j=1
foreach s in 1 2 {
foreach a of numlist 1/4 {

sum ageg`a' [aw=w] if sex==`s' & yr==1
mat A[1,`j']=`r(mean)'
local m1=`r(mean)'
sum ageg`a' [aw=w] if sex==`s' & yr==2
mat A[2,`j']=`r(mean)'
local m2=`r(mean)'
local diff=`m2'-`m1'
mat A[3,`j']=`diff'

sum longten [aw=w] if sex==`s' & yr==1 & ageg`a'==100
mat A[4,`j']=`r(mean)'
local m1=`r(mean)'
sum longten [aw=w] if sex==`s' & yr==2 & ageg`a'==100
mat A[5,`j']=`r(mean)'
local m2=`r(mean)'
local diff=`m2'-`m1'
mat A[6,`j']=`diff'

sum tenure [aw=w] if sex==`s' & yr==1 & ageg`a'==100
mat A[7,`j']=`r(mean)'
local m1=`r(mean)'
sum tenure [aw=w] if sex==`s' & yr==2 & ageg`a'==100
mat A[8,`j']=`r(mean)'
local m2=`r(mean)'
local diff=`m2'-`m1'
mat A[9,`j']=`diff'
local ++j
}
}


drop _all
svmat A
save "`outputpath'table1.dta", replace

