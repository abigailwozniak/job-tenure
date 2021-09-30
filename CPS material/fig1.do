set more off
clear
graph drop _all

local datapath="G:/mcr/scratch-m1cls01/JHR/processed"
local outputpath="G:/research/tenure/JHR/final/output"
local dtapath="G:/research/tenure/JHR/final/dta"

***FIG 1

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

use year jtyears empstat age classwkr jtsuppwt using "G:/mcr/scratch-m1cls01/data/cps/IPUMS/ten-dw/cps_00138.dta", clear
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

gen mean=tenure 
gen median=tenure 

keep if tenure>=0 & tenure!=.
drop if w<=0

sort year
collapse (mean) mean (p50) median [aw=w], by(year)
*NOTE: turning annual data into quarterly for purposes of recession shading in figure
gen q=1
sort year q
gen time=year+((q-1)/4)
sort time
tempfile temp
save `temp', replace
save "`dtapath'/cpstrends.dta", replace

*NOTE: turning annual data into quarterly for purposes of recession shading in figure
use "`dtapath'/fig1sipp.dta", clear
gen q=2
gen time=year+((q-1)/4)
sort time
keep time mtensipp medtensipp
*sort year q
tempfile sipp
save `sipp', replace

clear
set obs 38
gen year=1982+_n
expand 4
sort year
by year: gen q=_n
gen time=year+((q-1)/4)
sort time

merge time using "`dtapath'/cpstrends.dta"
drop _merge

sort time
merge time using `sipp'

keep if year>=1983

gen c1=10 if (year==1990 & q==3) | (year==1990 & q==4) | (year==1991 & q<=1) 
gen c2=10 if (year==2001) 
gen c3=10 if (year==2007 & q==4) | (year==2008) | (year==2009 & q<=2) 
sort year

# delimit ;
# delimit ;
twoway 
    (area c1 time, bcolor(gs13) base(2)) 
    (area c2 time, bcolor(gs13) base(2)) 
    (area c3 time, bcolor(gs13) base(2)) 
	(connected mean time if year>=1996, msymbol(O) mcolor(black) msize(medium) lcolor(black) lwidth(medthick) lpattern(solid))
	(connected mean time if year<=1991, msymbol(O) mcolor(black) msize(medium) lcolor(black) lwidth(medthick) lpattern(solid))
	(connected mtensipp time if year<=1988, msymbol(Oh) mcolor(black) msize(medium) lcolor(black) lwidth(medthick) lpattern(dash))
	(connected mtensipp time if year>1988, msymbol(Oh) mcolor(black) msize(medium) lcolor(black) lwidth(medthick) lpattern(dash))
	(connected median time if year>=1996, msymbol(T) mcolor(black) msize(medium) lcolor(black) lwidth(medthick) lpattern(solid))
	(connected median time if year<=1991, msymbol(T) mcolor(black) msize(medium) lcolor(black) lwidth(medthick) lpattern(solid))
	(connected medtensipp time if year<=1988, msymbol(Th) mcolor(black) msize(medium) lcolor(black) lwidth(medthick) lpattern(dash))
	(connected medtensipp time if year>1988, msymbol(Th) mcolor(black) msize(medium) lcolor(black) lwidth(medthick) lpattern(dash))
					,
	ytitle("", axis(1) size(small) margin(medsmall)) 
	ylabel(2(2)10, labels labsize(medium) nogrid angle(horizontal)) 
	ymlabel(2(1)10, nolabels ticks )
	xtitle("", size(small)) 
	xlabel(1985(5)2020, labels labsize(medium) ticks) 
	xmtick(1983(1)2020, nolabels) 
	legend(order(4 "Mean (CPS)" 6 "Mean (SIPP)" 8 "Median (CPS)" 10 "Median (SIPP)") rows(2) size(medium) region(style(none)) margin(zero))
	title("", size(small))
	graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(small)) 
	plotregion(fcolor(white) lcolor(black) ifcolor(white) ilcolor(white) margin(tiny))
	xsize(6.2)
	ysize(3.75)
		name("fig1", replace)
	saving("`outputpath'\fig1.gph", replace)
	;
	
graph export "`outputpath'\fig1.eps", 
	as(eps) 
	replace;
