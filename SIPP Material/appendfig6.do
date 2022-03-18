set more off
clear

local datapath="G:/mcr/scratch-m1cls01/JHR/processed"
local outputpath="G:/research/tenure/JHR/final/output"
local dtapath="G:/research/tenure/JHR/final/dta"

***APPENDIX FIG 6

use "`dtapath'/figappend5.dta", clear

gen time=year+((month-1)/12)

gen c1=.045 if (year==1990 & month>=7) | (year==1991 & month<=3)
gen c2=.045 if (year==2001 & month>=3 & month<=11) 
gen c3=.045 if (year==2007 & month==12) | (year==2008) | (year==2009 & month<=6) 


sort year month
# delimit ;
twoway 
    (area c2 time, bcolor(gs13) base(0)) 
    (area c3 time, bcolor(gs13) base(0)) 
	(connected tempjobendeda1ma time, msymbol(none) lcolor(black) lwidth(thick) lpattern(solid))
	(connected tempjobendeda2ma time, msymbol(none) lcolor(gs8) lwidth(thick) lpattern(solid))
	(connected tempjobendeda3ma time, msymbol(none) lcolor(navy) lwidth(thick) lpattern(dash))
	(connected tempjobendeda4ma time, msymbol(none) lcolor(forest_green) lwidth(thick) lpattern(dot))
	(connected tempjobendedb1ma time, msymbol(none) lcolor(black) lwidth(thick) lpattern(solid))
	(connected tempjobendedb2ma time, msymbol(none) lcolor(gs8) lwidth(thick) lpattern(solid))
	(connected tempjobendedb3ma time, msymbol(none) lcolor(navy) lwidth(thick) lpattern(dash))
	(connected tempjobendedb4ma time, msymbol(none) lcolor(forest_green) lwidth(thick) lpattern(dot))
	(connected tempjobendedc1ma time, msymbol(none) lcolor(black) lwidth(thick) lpattern(solid))
	(connected tempjobendedc2ma time, msymbol(none) lcolor(gs8) lwidth(thick) lpattern(solid))
	(connected tempjobendedc3ma time, msymbol(none) lcolor(navy) lwidth(thick) lpattern(dash))
	(connected tempjobendedc4ma time, msymbol(none) lcolor(forest_green) lwidth(thick) lpattern(dot))
					,
	ytitle("", size(medium) margin(small)) 
	ylabel(0(.01).04, labels labsize(medium) nogrid angle(vertical)) 
	xtitle("", size(small) margin(medsmall)) 
	xlabel(1996(2)2014, labels labsize(medium) ticks) 
	legend(order(3 "<1 quarter" 4 "1Q to 1 year" 5 "1 year to 2 years" 6 "2 years to 5 years") rows(2) size(medium) region(style(none)) margin(zero))
	title("", size(small))
	graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(medium)) 
	plotregion(fcolor(white) lcolor(black) ifcolor(white) ilcolor(white) margin(tiny))
	xsize(6.2)
	ysize(3.75)
	name("appendfig6", replace)
	saving("`outputpath'/appendfig6.gph", replace)
	;

graph export "`outputpath'/appendfig6.eps", as(eps) replace;
# delimit cr

