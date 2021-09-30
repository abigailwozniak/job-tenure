clear
set more off
graph drop _all

local datapath="G:/mcr/scratch-m1cls01/JHR/processed"
local outputpath="G:/research/tenure/JHR/final/output"
local dtapath="G:/research/tenure/JHR/final/dta"

***FIG 6

foreach s in 1 2 {
use `outputpath'\cohort-effects-longtenure-sex`s'.dta, clear
sort cohort

merge cohort using `outputpath'\cohort-effects-separations-sex`s'.dta
drop _merge
sort cohort

foreach v of varlist ten20p_5564_`s' pred* {
replace `v'=`v'*100
gen `v'_ma=(`v'[_n-1]+`v'+`v'[_n+1])/3
}

keep if ten20p_5564_`s'!=. & predur!=. 

if `s'==1 local yrange1="20(10)50"
if `s'==1 local yrange1t="20(5)50"

if `s'==1 local yrange2="0(4)12"
if `s'==1 local yrange2t="0(2)12"

if `s'==2 local yrange1="15(5)35"
if `s'==2 local yrange1t="15(2.5)35"

if `s'==2 local yrange2="0(5)20"
if `s'==2 local yrange2t="0(2.5)20"

if `s'==1 local fig=6
if `s'==2 local fig=8

# delimit ;

twoway
	(connected ten20p_5564_`s'_ma cohort , yaxis(1) msymbol(none) mcolor(black) msize(medium) lcolor(black) lwidth(thick) lpattern(dash))
	(connected predur_ma cohort , yaxis(2) msymbol(triangle) mcolor(black) msize(medium) lcolor(black) lwidth(medium) lpattern(solid))
	(connected predseprate_EN_ma cohort , yaxis(2) msymbol(square) mcolor(black) msize(medium) lcolor(black) lwidth(medium) lpattern(solid))
	(connected predseprate_multE_ma cohort , yaxis(2) msymbol(circle) mcolor(black) msize(medium) lcolor(black) lwidth(medium) lpattern(solid))
	,
	ytitle("Pct. 20+ years of tenure (dashed)", axis(1) size(medium) margin(medium)) 
	ytitle("Percent (solid)", axis(2) size(medium) margin(medium)) 
	ylabel(`yrange1', axis(1) labels labsize(medium) nogrid angle(horizontal)) 
	ylabel(`yrange2', axis(2) labels labsize(medium) nogrid angle(horizontal)) 
	ytick(`yrange1t', axis(1) nolabels)
	ytick(`yrange2t', axis(2) nolabels)
	xtitle("Birth year of cohort", size(medium) margin(vsmall)) 
	xlabel(1930(5)1965, labels labsize(medium) ticks) 
	xmtick(1930(1)1965, nolabels)  
	legend(order(1 "Avg. pct with 20+ yrs tenure (age 55-64)" 2 "Avg. unemp. rate (age 35-54)" 3 "Avg. pct. emp. in prev. year not emp. currently (age 35-54)" 4 "Avg. pct. with mult emps. in prev year (age 35-54)") rows(4) size(medium) region(style(none)))
	title("", size(small))
	graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(small)) 
	plotregion(fcolor(white) lcolor(black) ifcolor(white) ilcolor(white) margin(tiny))
	ysize(3.75)
	xsize(6.5)
	name("fig`fig'", replace)
	saving("`outputpath'/fig`fig'.gph", replace)
	;
	
# delimit cr
graph export "`outputpath'/fig`fig'.eps", as(eps) replace

}

