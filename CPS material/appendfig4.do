set more off
clear
graph drop _all

local datapath="G:/mcr/scratch-m1cls01/JHR/processed"
local outputpath="G:/research/tenure/JHR/final/output"
local dtapath="G:/research/tenure/JHR/final/dta"

***APPENDIX FIG 4

use "`dtapath'/figappend4.dta", clear
gen xtitle="Number of main employers since age 22"
# delimit ;
graph bar share1979 share1997, over(nemp, lab(labsize(medium))) over(xtitle, lab(labsize(medium))) 
bar(1, lcolor(black) color(black)) bar(2, color(white) lcolor(black))
legend(lab(1 "1979") lab(2 "1997") size(medium) rows(1) region(style(none)) margin(small)) 
name(hist_mainemp, replace) graphregion(color(white)) ylab(, nogrid)
ytitle("Percent of sample", axis(1) size(medium) margin(medsmall)) 
ylabel(0(5)40, labsize(medium) nogrid angle(horizontal) ) 
ysize(3.75)
xsize(6.2)
saving("`outputpath'/appendfig4.gph", replace);
# delimit cr

graph export "`outputpath'/appendfig4.eps", as(eps) replace

