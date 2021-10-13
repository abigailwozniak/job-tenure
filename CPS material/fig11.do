set more off
clear
drop _all
graph drop _all
capture log close

***Fig 11

local datapath="C:\Users\15099\Downloads\christopher_replicationcode\processed\"
local outputpath="C:\Users\15099\Downloads\christopher_replicationcode\output\"
local dtapath="C:\Users\15099\Downloads\christopher_replicationcode\"
local logpath="C:\Users\15099\Downloads\christopher_replicationcode\"

use "`dtapath'fig11sipp.dta", clear
* gen time=year+((month-1)/12)

gen c2=10 if (year==2001 & month>=3 & month<=11) 
gen c3=10 if (year==2007 & month==12) | (year==2008) | (year==2009 & month<=6) 
foreach v of varlist newhireama-neecma {
replace `v'=`v'*100
}

sort year
# delimit ;
twoway 
    (area c2 time, bcolor(gs13) base(0)) 
    (area c3 time, bcolor(gs13) base(0)) 
	(connected newhireama time, msymbol(none) lcolor(black) lwidth(medthick) lpattern(solid))
	(connected eeama time , msymbol(none) lcolor(black) lwidth(medthick) lpattern(dash))
	(connected neeama time , msymbol(none) lcolor(black) lwidth(thick) lpattern(dot))
	(connected newhirebma time, msymbol(none) lcolor(black) lwidth(medthick) lpattern(solid))
	(connected eebma time , msymbol(none) lcolor(black) lwidth(medthick) lpattern(dash))
	(connected neebma time , msymbol(none) lcolor(black) lwidth(thick) lpattern(dot))
	(connected newhirecma time, msymbol(none) lcolor(black) lwidth(medthick) lpattern(solid))
	(connected eecma time , msymbol(none) lcolor(black) lwidth(medthick) lpattern(dash))
	(connected neecma time , msymbol(none) lcolor(black) lwidth(thick) lpattern(dot))
					,
	ytitle("", axis(1) size(small) margin(medsmall)) 
	ylabel(0(2)10, labels labsize(medium) nogrid angle(horizontal)) 
	ymlabel(0(1)10, nolabels ticks )
	xtitle("", size(small)) 
	xlabel(1996(2)2014, labels labsize(medium) ticks) 
	legend(order(3 "New hires" 4 "Job-to-job" 5 "Entrants") rows(1) size(medium) region(style(none)) margin(zero))
	title("", size(small))
	graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(small)) 
	plotregion(fcolor(white) lcolor(black) ifcolor(white) ilcolor(white) margin(tiny))
	xsize(6.2)
	ysize(3.75)
	name("fig11", replace)
	saving("`outputpath'/fig11.gph", replace)
	;

graph export "`outputpath'fig11.eps", 	as(eps) replace;

# delimit cr
