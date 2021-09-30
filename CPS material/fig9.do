set more off
clear
drop _all
graph drop _all

local datapath="G:/mcr/scratch-m1cls01/JHR/processed"
local outputpath="G:/research/tenure/JHR/final/output"
local dtapath="G:/research/tenure/JHR/final/dta"

***FIG 9

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

keep if tenure>=0 & tenure!=.
drop if w<=0

gen lt1yr=(tenure<1)
gen a1yrto3yr=(tenure>=1 & tenure<3)

drop if tenure==.

sort year
collapse (mean) lt1yr a1yrto3yr [aw=w], by(year)
replace lt1yr=lt1yr*100
replace a1yrto3yr=a1yrto3yr*100

gen q=1
sort year q
gen time=year+((q-1)/4)
sort time
tempfile temp
save `temp', replace

use "`dtapath'/fig1sipp.dta", clear
gen q=2
gen time=year+((q-1)/4)
sort time
tempfile sipp
save `sipp', replace

clear
set obs 34
gen year=1982+_n
expand 4
sort year
by year: gen q=_n
gen time=year+((q-1)/4)
sort time
merge time using `sipp'

gen c1=25 if (year==1990 & q==3) | (year==1990 & q==4) | (year==1991 & q<=1) 
gen c2=25 if (year==2001) 
gen c3=25 if (year==2007 & q==4) | (year==2008) | (year==2009 & q<=2) 

keep time tenlt1y ten13 c1 c2 c3 year q
replace tenlt1y=tenlt1y*100
replace ten13=ten13*100
rename tenlt1y lt1yr 
rename ten13 a1yrto3yr
gen sample="SIPP"
tempfile sipp
save `sipp', replace

clear
set obs 34
gen year=1982+_n
expand 4
sort year
by year: gen q=_n
gen time=year+((q-1)/4)
sort time

merge time using `temp'
drop _merge
sort time
gen c1=25 if (year==1990 & q==3) | (year==1990 & q==4) | (year==1991 & q<=1) 
gen c2=25 if (year==2001) 
gen c3=25 if (year==2007 & q==4) | (year==2008) | (year==2009 & q<=2) 
gen sample="CPS"
append using `sipp'

save `outputpath'/fig9.dta, replace

use `outputpath'/fig9.dta, clear

tempfile temp
save `temp', replace
use `temp', clear
keep if sample=="CPS"
keep year q time lt1yr c1 c2 c3
gen ten="Less than one year"
rename lt1yr cps
sort ten year q time
tempfile cpslt1y
save `cpslt1y', replace

use `temp', clear
keep if sample=="CPS"
keep year q time a1yrto3yr c1 c2 c3
gen ten="One year to three years"
rename a1yrto3yr cps
sort ten year q time
tempfile cps1to3
save `cps1to3', replace

use `temp', clear
keep if sample=="SIPP"
keep year q time a1yrto3yr 
gen ten="One year to three years"
rename a1yrto3yr sipp
sort ten year q time
tempfile sipp1to3
save `sipp1to3', replace

use `temp', clear
keep if sample=="SIPP"
keep year q time lt1yr 
gen ten="Less than one year"
rename lt1yr sipp
sort ten year q time
tempfile sipplt1y
save `sipplt1y', replace

use `cpslt1y', clear
merge ten year q time using `sipplt1y'
drop _merge
tempfile lt1y
save `lt1y', replace

use `cps1to3', clear
merge ten year q time using `sipp1to3'
drop _merge
append using `lt1y'
keep if year>=1995 & year<=2020

# delimit ;

twoway 
    (area c1 time, bcolor(gs13) base(10)) 
    (area c2 time, bcolor(gs13) base(10)) 
    (area c3 time, bcolor(gs13) base(10)) 
	(connected sipp year if year>=1996 , msymbol(circle) mcolor(black) msize(medium) lcolor(black) lwidth(medthick) lpattern(solid))
	(connected cps year if year>=1996 , msymbol(triangle) mcolor(black) msize(medium) lcolor(black) lwidth(medthick) lpattern(dash)),
	by(ten, title("", size(vsmall) color(navy)) 
	subtitle(,bcolor(white) size(small))
	graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(small)) 
	plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(small))
	note("")
	)
	subtitle(,bcolor(white) size(small))	
	ytitle("",  size(small) margin(small)) 
	ylabel(10(5)25, labels labsize(small) nogrid angle(horizontal)) 
	ymlabel()
	xtitle("",  size(small)) 
	xlabel(1995(5)2020, labels labsize(small) ticks) 
	xmtick(1995(1)2020, nolabels) 
	legend(order(4 "SIPP" 5 "CPS") rows(1) size(medsmall) region(style(none)) margin(zero))
	graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(small)) 
	plotregion(fcolor(white) lcolor(navy) ifcolor(white) ilcolor(white) margin(small))
	name(fig9, replace)
	saving("`outputpath'/fig9.gph", replace)
	;
	
graph export "`outputpath'/fig9.eps", as(eps) replace;

# delimit cr
