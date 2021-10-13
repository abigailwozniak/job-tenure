set more off
clear
graph drop _all

local datapath="C:\Users\15099\Downloads\christopher_replicationcode\processed\"
local outputpath="C:\Users\15099\Downloads\christopher_replicationcode\output\"
local dtapath="C:\Users\15099\Downloads\christopher_replicationcode\"

***FIG 2

use "`datapath'/jan1983.dta", clear
keep if age>=22 & age<=64
keep if esr==1 | esr==2
keep if class>=1 & class<=2
tempfile t1983
save `t1983', replace

use "`datapath'/jan1987.dta", clear
keep if age>=22 & age<=64
keep if esr==1 | esr==2
keep if class>=1 & class<=2

tempfile t1987
save `t1987', replace

use "`datapath'/jan1991.dta", clear
keep if age>=22 & age<=64
keep if esr==1 | esr==2
keep if class>=1 & class<=4

tempfile t1991
save `t1991', replace

use year jtyears empstat age classwkr jtsuppwt using "`dtapath'/cps_00138.dta", clear
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

gen teng=1 if tenure>=0 & tenure<3
replace teng=2 if tenure>=3 & tenure<5
replace teng=3 if tenure>=5 & tenure<10
replace teng=4 if tenure>=10 & tenure<15
replace teng=5 if tenure>=15 & tenure<20
replace teng=6 if tenure>=20 & tenure!=.

sort year teng
collapse (rawsum) w (mean) tenure [aw=w], by(year teng)

sort year 
by year : egen sum=sum(w)
gen share=w/sum

gen yr=.

replace yr=1 if year>=1983 & year<=1991
replace yr=2 if year>=1996 & year<=2000
replace yr=3 if year>=2002 & year<=2020
keep if yr!=.

sort yr teng
collapse (mean) share tenure, by(yr teng)

gen share_1=share if yr==1
gen share_2=share if yr==2
gen share_3=share if yr==3

gen tenure_1=tenure if yr==1
gen tenure_2=tenure if yr==2
gen tenure_3=tenure if yr==3

sort teng
collapse (mean) share_1 share_2 share_3 tenure_1 tenure_2 tenure_3, by(teng)

lab def teng 1 "<3 years" 2 "3 to <5" 3 "5 to <10" 4 "10 to <15" 5 "15 to <20" 6 "20+"
lab val teng teng

# delimit ;
graph bar share_1 share_2 share_3 , over(teng, lab(angle(45) labsize(medium))) 
bar(1, lcolor(black) color(black)) bar(2, lcolor(black) color(gs8))  bar(3, lcolor(black) color(gs16)) 
legend(lab(1 "1983, 1987, 1991") lab(2 "1996-2000") lab(3 "2002-2020") size(medium) rows(1)) 
name(fig2, replace) graphregion(color(white)) ylab(, nogrid)
ylabel(, labsize(medium) nogrid angle(horizontal) ) 
ysize(3.75)
xsize(6.2)
saving("`outputpath'\fig2.gph", replace);

graph export "`outputpath'\fig2.eps", as(eps) name("fig2") replace;

# delimit cr

