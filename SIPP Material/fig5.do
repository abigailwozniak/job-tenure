set more off
clear

local datapath="G:/mcr/scratch-m1cls01/JHR/processed"
local outputpath="G:/research/tenure/JHR/final/output"
local dtapath="G:/research/tenure/JHR/final/dta"

***FIG 5

use "`dtapath'/fig5sipp.dta", clear
drop time
gen time=year+((month-1)/12)

gen c1=.99 if (year==1990 & month>=7) | (year==1991 & month<=3)
gen c2=.99 if (year==2001 & month>=3 & month<=11) 
gen c3=.99 if (year==2007 & month==12) | (year==2008) | (year==2009 & month<=6) 


sort year month
# delimit ;
twoway 
    (area c1 time, bcolor(gs13) base(.968)) 
    (area c2 time, bcolor(gs13) base(.968)) 
    (area c3 time, bcolor(gs13) base(.968)) 
	(connected nosepa8ma time, msymbol(none) lcolor(black) lwidth(thick) lpattern(solid))
	(connected eeama time, msymbol(none) lcolor(black) lwidth(thick) lpattern(dash))
	(connected nosepb8ma time, msymbol(none) lcolor(black) lwidth(thick) lpattern(solid))
	(connected eebma time, msymbol(none) lcolor(black) lwidth(thick) lpattern(dash))
	(connected nosepc8ma time, msymbol(none) lcolor(black) lwidth(thick) lpattern(solid))
	(connected eecma time, msymbol(none) lcolor(black) lwidth(thick) lpattern(dash))
	(connected eedma time, msymbol(none) lcolor(black) lwidth(thick) lpattern(dash))
	(connected eeema time, msymbol(none) lcolor(black) lwidth(thick) lpattern(dash))
					,
	ytitle("", size(medium) margin(small)) 
	ylabel(.97(.005).99, labels labsize(medium) nogrid angle(vertical)) 
	xtitle("", size(small) margin(medsmall)) 
	xlabel(1986(4)2014, labels labsize(medium) ticks) 
	legend(order(4 "Retention rate, 20+ years tenure" 5 "Fraction remaining employed, age 50-64" ) rows(2) size(medium) region(style(none)) margin(zero))
	title("", size(small))
	graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(medium)) 
	plotregion(fcolor(white) lcolor(black) ifcolor(white) ilcolor(white) margin(tiny))
	xsize(6.2)
	ysize(3.75)
		name("fig5", replace)
	saving("`outputpath'/fig5.gph", replace)
	;

graph export "`outputpath'/fig5.eps", as(eps) replace;

# delimit cr

