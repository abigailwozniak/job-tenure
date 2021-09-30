set more off
clear
drop _all
graph drop _all
capture log close

***Fig 12

local datapath="G:/mcr/scratch-m1cls01/JHR/processed"
local outputpath="G:/research/tenure/JHR/final/output"
local dtapath="G:/research/tenure/JHR/final/dta"
local logpath="G:/research/tenure/JHR/final/log"

use "`dtapath'/fig12gss.dta", clear
replace djoblose=djoblose*100
keep if year>=1975

sort year ageg4
tempfile temp
save `temp', replace

clear
set obs 29
gen year=_n+1974
expand 4
sort year
by year: gen ageg4=_n
sort year ageg4
merge year ageg4 using `temp'
expand 4
sort year ageg4
by year ageg4: gen q=_n

gen c1=40 if (year==1980 & q>=1 & q<=3) 
gen c2=40 if (year==1981 & q>=3) | (year==1982) 
gen c3=40 if (year==1990 & q==3) | (year==1990 & q==4) | (year==1991 & q<=1) 
gen c4=40 if (year==2001) 
gen c5=40 if (year==2007 & q==4) | (year==2008) | (year==2009 & q<=2) 

gen time=year+((q-1)/4)

# delimit ;
twoway 
    (area c1 time, bcolor(gs13) base(0)) 
    (area c2 time, bcolor(gs13) base(0)) 
    (area c3 time, bcolor(gs13) base(0)) 
    (area c4 time, bcolor(gs13) base(0)) 
    (area c5 time, bcolor(gs13) base(0)) 
	(connected djoblose year if ageg4==1, msymbol(O) msize(small) mcolor(black) lcolor(black) lwidth(think) lpattern(solid))
	(connected djoblose year if ageg4==2, msymbol(none) mcolor(black) lcolor(black) lwidth(medthick) lpattern(dash))
	(connected djoblose year if ageg4==3, msymbol(none) mcolor(black) lcolor(black) lwidth(thick) lpattern(dot))
	(connected djoblose year if ageg4==4, msymbol(Th) mcolor(black) msize(medium) lcolor(black) lwidth(medium) lpattern(solid))
	,
	ytitle("Percent", size(medium) margin(small)) 
	ylabel(0(10)40, labels labsize(medium) nogrid angle(horizontal)) 
	ymlabel(0(5)40, nolabels ticks)
	xtitle("", size(small)) 
	xlabel(1975(5)2015, labels labsize(medium) ticks) 
	xmtick(1975(1)2018, nolabels) 
	legend(order(6 "Less than 25" 7 "25 to 34" 8 "35 to 54" 9 "55 and older" ) rows(2) size(medium) region(style(none)))
	title("", size(small))
	graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(small)) 
	plotregion(fcolor(white) lcolor(black) ifcolor(white) ilcolor(white) margin(tiny))
	name("fig12", replace)
	saving("`outputpath'/fig12.gph", replace)
	;

graph export "`outputpath'/fig12.eps", as(eps) replace;

# delimit cr

# delimit cr
