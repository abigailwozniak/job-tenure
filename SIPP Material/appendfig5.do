set more off
clear
graph drop _all

local datapath="G:/mcr/scratch-m1cls01/JHR/processed"
local outputpath="G:/research/tenure/JHR/final/output"
local dtapath="G:/research/tenure/JHR/final/dta"

***APPENDIX FIG 5

use "`dtapath'/figappend5.dta", clear

* gen time=year+((month-1)/12)

gen c1=.15 if (year==1990 & month>=7) | (year==1991 & month<=3)
gen c2=.15 if (year==2001 & month>=3 & month<=11) 
gen c3=.15 if (year==2007 & month==12) | (year==2008) | (year==2009 & month<=6) 


sort year month
# delimit ;
twoway 
    (area c2 time, bcolor(gs13) base(0.0)) 
    (area c3 time, bcolor(gs13) base(0.0)) 
	(connected volsepa1ma time, msymbol(none) lcolor(black) lwidth(thick) lpattern(solid))
	(connected volsepa2ma time, msymbol(none) lcolor(gs8) lwidth(thick) lpattern(solid))
	(connected volsepa3ma time, msymbol(none) lcolor(navy) lwidth(thick) lpattern(dash))
	(connected volsepa4ma time, msymbol(none) lcolor(forest_green) lwidth(thick) lpattern(dot))
	(connected volsepb1ma time, msymbol(none) lcolor(black) lwidth(thick) lpattern(solid))
	(connected volsepb2ma time, msymbol(none) lcolor(gs8) lwidth(thick) lpattern(solid))
	(connected volsepb3ma time, msymbol(none) lcolor(navy) lwidth(thick) lpattern(dash))
	(connected volsepb4ma time, msymbol(none) lcolor(forest_green) lwidth(thick) lpattern(dot))
	(connected volsepc1ma time, msymbol(none) lcolor(black) lwidth(thick) lpattern(solid))
	(connected volsepc2ma time, msymbol(none) lcolor(gs8) lwidth(thick) lpattern(solid))
	(connected volsepc3ma time, msymbol(none) lcolor(navy) lwidth(thick) lpattern(dash))
	(connected volsepc4ma time, msymbol(none) lcolor(forest_green) lwidth(thick) lpattern(dot))
					,
	ytitle("", size(medium) margin(small)) 
	ylabel(0.0(.05).15, labels labsize(medium) nogrid angle(vertical)) 
	xtitle("", size(small) margin(medsmall)) 
	xlabel(1996(2)2014, labels labsize(medium) ticks) 
	legend(order(3 "<1 quarter" 4 "1Q to 1 year" 5 "1 year to 2 years" 6 "2 years to 5 years") rows(2) size(medium) region(style(none)) margin(zero))
	title("A. Voluntary separations", size(medium))
	graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(medium)) 
	plotregion(fcolor(white) lcolor(black) ifcolor(white) ilcolor(white) margin(tiny))
	xsize(6.2)
	ysize(3.75)
	name("appendfig5A", replace)
	saving("`outputpath'/appendfig5a.gph", replace)
	;

graph export "`outputpath'/appendfig5a.eps", as(eps) replace;
# delimit cr

drop c1-c3

gen c1=.15 if (year==1990 & month>=7) | (year==1991 & month<=3)
gen c2=.15 if (year==2001 & month>=3 & month<=11) 
gen c3=.15 if (year==2007 & month==12) | (year==2008) | (year==2009 & month<=6) 


sort year month
# delimit ;
twoway 
    (area c2 time, bcolor(gs13) base(0.0)) 
    (area c3 time, bcolor(gs13) base(0.0)) 
	(connected involsepa1ma time, msymbol(none) lcolor(black) lwidth(thick) lpattern(solid))
	(connected involsepa2ma time, msymbol(none) lcolor(gs8) lwidth(thick) lpattern(solid))
	(connected involsepa3ma time, msymbol(none) lcolor(navy) lwidth(thick) lpattern(dash))
	(connected involsepa4ma time, msymbol(none) lcolor(forest_green) lwidth(thick) lpattern(dot))
	(connected involsepb1ma time, msymbol(none) lcolor(black) lwidth(thick) lpattern(solid))
	(connected involsepb2ma time, msymbol(none) lcolor(gs8) lwidth(thick) lpattern(solid))
	(connected involsepb3ma time, msymbol(none) lcolor(navy) lwidth(thick) lpattern(dash))
	(connected involsepb4ma time, msymbol(none) lcolor(forest_green) lwidth(thick) lpattern(dot))
	(connected involsepc1ma time, msymbol(none) lcolor(black) lwidth(thick) lpattern(solid))
	(connected involsepc2ma time, msymbol(none) lcolor(gs8) lwidth(thick) lpattern(solid))
	(connected involsepc3ma time, msymbol(none) lcolor(navy) lwidth(thick) lpattern(dash))
	(connected involsepc4ma time, msymbol(none) lcolor(forest_green) lwidth(thick) lpattern(dot))
					,
	ytitle("", size(medium) margin(small)) 
	ylabel(0.0(.05).15, labels labsize(medium) nogrid angle(vertical)) 
	xtitle("", size(small) margin(medsmall)) 
	xlabel(1996(2)2014, labels labsize(medium) ticks) 
	legend(order(3 "<1 quarter" 4 "1Q to 1 year" 5 "1 year to 2 years" 6 "2 years to 5 years") rows(2) size(medium) region(style(none)) margin(zero))
	title("B. Involuntary separations", size(medium))
	graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(medium)) 
	plotregion(fcolor(white) lcolor(black) ifcolor(white) ilcolor(white) margin(tiny))
	xsize(6.2)
	ysize(3.75)
		name("appendfig5b", replace)
	saving("`outputpath'/appendfig5b.gph", replace)
	;

graph export "`outputpath'/appendfig5b.eps", as(eps) replace;
# delimit cr
	
