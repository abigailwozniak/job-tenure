set more off
clear
drop _all
graph drop _all
capture log close

***Fig 10

local datapath="G:/mcr/scratch-m1cls01/JHR/processed"
local outputpath="G:/research/tenure/JHR/final/output"
local dtapath="G:/research/tenure/JHR/final/dta"
local logpath="G:/research/tenure/JHR/final/log"

log using `logpath'/fig10.log, replace

use "`dtapath'/ind-occ-asec.dta", clear
sort year occ 
collapse (mean) occ1990, by(year occ)
sort year occ
tempfile occ
save `occ', replace

use "`dtapath'/ind-occ-asec.dta", clear
sort year ind
collapse (mean) ind1990, by(year ind)
sort year ind
tempfile ind
save `ind', replace

use "`datapath'/jan1983.dta", clear
keep if age>=22 & age<=64
keep if esr==1 | esr==2
keep if class>=1 & class<=2

gen white=(race==1)
gen black=(race==2)
gen other=(race==3 )

gen married=(marst==1 | marst==2 | marst==3)

gen hsd=(grdatn<13) | (grdatn==13 & grdcomp==2)
gen hsg=(grdatn==13 & grdcomp==1)
gen sc=(grdatn>=14 & grdatn<17) | (grdatn==17 & grdcomp==2)
gen cg=(grdatn>17) | (grdatn==17 & grdcomp==1)
drop if ind==0 | ind==.
drop if occ==0 | occ==.

sort year ind
merge year ind using `ind'
tab _merge
keep if _merge==3
drop _merge
sort year occ
merge year occ using `occ'
tab _merge
keep if _merge==3
drop _merge

keep weightsupp age sex white black other married hsd hsg sc cg monthwork yrswork year ind1990 occ1990 occ ind

tempfile t1983
save `t1983', replace

use "`datapath'/jan1987.dta", clear
keep if age>=22 & age<=64
keep if esr==1 | esr==2
keep if class>=1 & class<=2

gen white=(race==1)
gen black=(race==2)
gen other=(race==3 )

gen married=(marst==1 | marst==2 | marst==3)

gen hsd=(grdatn<13) | (grdatn==13 & grdcomp==2)
gen hsg=(grdatn==13 & grdcomp==1)
gen sc=(grdatn>=14 & grdatn<17) | (grdatn==17 & grdcomp==2)
gen cg=(grdatn>17) | (grdatn==17 & grdcomp==1)
drop if ind==0 | ind==.
drop if occ==0 | occ==.

sort year ind
merge year ind using `ind'
tab _merge
keep if _merge==3
drop _merge
sort year occ
merge year occ using `occ'
tab _merge
keep if _merge==3
drop _merge

keep weightsupp age sex white black other married hsd hsg sc cg monthwork yrswork year ind1990 occ1990 occ ind

tempfile t1987
save `t1987', replace

use "`datapath'/jan1991.dta", clear
keep if age>=22 & age<=64
keep if esr==1 | esr==2
keep if class>=1 & class<=4

gen white=(race==1)
gen black=(race==2)
gen other=(race==3 | race==4 | race==5)

gen married=(marst==1 | marst==2 | marst==3)

gen hsd=(grdatn<12) | (grdatn==12 & grdcomp==2)
gen hsg=(grdatn==12 & grdcomp==1)
gen sc=(grdatn>=13 & grdatn<16) | (grdatn==16 & grdcomp==2)
gen cg=(grdatn>16) | (grdatn==16 & grdcomp==1)
drop if ind==0 | ind==.
drop if occ==0 | occ==.

sort year ind
merge year ind using `ind'
tab _merge
keep if _merge==3
drop _merge
sort year occ
merge year occ using `occ'
tab _merge
keep if _merge==3
drop _merge

keep weight age sex white black other married hsd hsg sc cg monthwork yrswork year ind1990 occ1990 occ ind

tempfile t1991
save `t1991', replace

use "G:/mcr/scratch-m1cls01/data/cps/IPUMS/ten-dw/cps_00138.dta" if year>=1996, clear
keep if year>=1996
keep if age>=22 & age<=64
drop if jtyears>=90 
keep if (empstat==10 | empstat==12) 
keep if (classwkr>=21 & classwkr<=28) 

gen hsd=(educ>=2 & educ<72) 
gen hsg=(educ==72 | educ==73) 
gen sc=(educ>73 & educ<111) 
gen cg=(educ>=111 & educ!=.) 

gen white=(race==100)
gen black=(race==200)
gen other=(white==0 & black==0 )

gen married=(marst==1 | marst==2)

foreach yr in 1983 1987 1991 {
append using `t`yr''
}

gen tenure=.
gen w=.

***PROCESSING TENURE

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
replace jtyears=32 if jtyears>=32 & jtyears!=. & year>=1996
replace tenure=jtyears if year>=1996
replace w=jtsuppwt if year>=1996

keep if tenure>=0 & tenure!=.
drop if w<=0
gen longtenure=(tenure>=20 & tenure!=.)
gen shorttenure=(tenure>=0 & tenure<1)

***AGE EFFECTS

gen age1=(age>=22 & age<=29)
gen age2=(age>=30 & age<=39)
gen age3=(age>=40 & age<=44)
gen age4=(age>=45 & age<=49)
gen age5=(age>=50 & age<=54)
gen age6=(age>=55 & age<=59)
gen age7=(age>=60 )

***INDUSTRY AND OCCUPATION EFFECTS

gen indgroup=0
gen occgroup=0

*ag and mining
gen ind_1=(ind1990>=10 & ind1990<=50) 

*const
gen ind_2=(ind1990==60) 

*manuf
gen ind_3=(ind1990>=100 & ind1990<=392) 

*transport & utilities
gen ind_4=(ind1990>=400 & ind1990<=472) 

*wholesale trade
gen ind_5=(ind1990>=500 & ind1990<=571) 

*retail trade + restaurants
gen ind_6=(ind1990>=580 & ind1990<=691) 

*FIRE
gen ind_7=(ind1990>=700 & ind1990<=712) 

*business and repair services
gen ind_8=(ind1990>=721 & ind1990<=760) 

*personal service
gen ind_9=(ind1990>=761 & ind1990<=791 ) 

*entertainment
gen ind_10=(ind1990>=800 & ind1990<=810) 

*prof + related services
gen ind_11=(ind1990>=812 & ind1990<=893) 

*public admin
gen ind_12=(ind1990>=900 & ind1990<=932) 

gen tmpind=(ind_1==1 | ind_2==1 | ind_3==1 | ind_4==1 | ind_5==1 | ind_6==1 | ind_7==1 | ind_8==1 | ind_9==1 | ind_10==1 | ind_11==1 | ind_12==1)
assert ind_1==1 | ind_2==1 | ind_3==1 | ind_4==1 | ind_5==1 | ind_6==1 | ind_7==1 | ind_8==1 | ind_9==1 | ind_10==1 | ind_11==1 | ind_12==1

*managerial and prof specialtiy
gen occ_1=(occ1990>=3 & occ1990<=200) 

*technician
gen occ_2=(occ1990>=203 & occ1990<=235) 

*sales
gen occ_3=(occ1990>=243 & occ1990<=290) 

*office admin
gen occ_4=(occ1990>=303 & occ1990<=391) 

*private HH
gen occ_5=(occ1990>=405 & occ1990<=408) 

*protective servicesum occ
gen occ_6=(occ1990>=415 & occ1990<=427) 

*food prep
gen occ_7=(occ1990>=434 & occ1990<=444) 

*health service
gen occ_8=(occ1990>=445 & occ1990<=447) 

*cleaning and building serv and other service
gen occ_9=(occ1990>=448 & occ1990<=469) 

*ag
gen occ_10=(occ1990>=473 & occ1990<=498) 

*production
gen occ_11=(occ1990>=503 & occ1990<=699) 

*machine operator
gen occ_12=(occ1990>=703 & occ1990<=799) 

*driver
gen occ_13=(occ1990>=803 & occ1990<=859) 

*helper, laborer
gen occ_14=(occ1990>=865 & occ1990<=890) 

gen tmpocc=(occ_1==1 | occ_2==1 | occ_3==1 | occ_4==1 | occ_5==1 | occ_6==1 | occ_7==1 | occ_8==1 | occ_9==1 | occ_10==1 | occ_11==1 | occ_12==1 | occ_13==1 | occ_14==1)
assert occ_1==1 | occ_2==1 | occ_3==1 | occ_4==1 | occ_5==1 | occ_6==1 | occ_7==1 | occ_8==1 | occ_9==1 | occ_10==1 | occ_11==1 | occ_12==1 | occ_13==1 | occ_14==1

gen manuf=(ind_3==1)

gen male=(sex==1)

***YEAR EFFECTS

foreach yr in 1996 1998 2000 2002 2004 2006 2008 2010 2012 2014 2016 2018 2020 {
gen year`yr'=(year==`yr')
}
keep if year>=1996
tempfile temp
save `temp', replace

use `temp', clear

mat A=J(13,5,0)

*model 1 , year FE

local i=1
reg shorttenure year1996-year2020 [aw=w], nocons
local i=1
foreach yr in 1996 1998 2000 2002 2004 2006 2008 2010 2012 2014 2016 2018 2020 {
mat A[`i',1]=_b[year`yr']
local ++i
}

*model 2 , year FE and demo ex age

local i=1
reg shorttenure year1996-year2020 age1-age6 male [aw=w], nocons
foreach yr in 1996 1998 2000 2002 2004 2006 2008 2010 2012 2014 2016 2018 2020 {
mat A[`i',2]=_b[year`yr']
local ++i
}

*model 3 , year FE and demo incl age

local i=1
reg shorttenure year1996-year2020 age1-age6 hsg sc cg white black married male [aw=w], nocons
foreach yr in 1996 1998 2000 2002 2004 2006 2008 2010 2012 2014 2016 2018 2020 {
mat A[`i',3]=_b[year`yr']
local ++i
}

*model 4 , year FE and demo incl age, manuf

local i=1
reg shorttenure year1996-year2020 age1-age6 hsg sc cg white black married manuf male [aw=w], nocons
foreach yr in 1996 1998 2000 2002 2004 2006 2008 2010 2012 2014 2016 2018 2020 {
mat A[`i',4]=_b[year`yr']
local ++i
}

*model 5 , year FE and demo incl age, manuf, ind and occ

local i=1
reg shorttenure year1996-year2020 age1-age6 hsd hsg sc white black married ind_1-ind_11 occ_1-occ_13 male [aw=w], nocons
foreach yr in 1996 1998 2000 2002 2004 2006 2008 2010 2012 2014 2016 2018 2020 {
mat A[`i',5]=_b[year`yr']
local ++i
}

drop _all
svmat A
gen year=.
local i=1
foreach yr in 1996 1998 2000 2002 2004 2006 2008 2010 2012 2014 2016 2018 2020 {
replace year=`yr' in `i'
local ++i
}

rename A1 yearFE
rename A2 age
rename A3 demog
rename A4 manuf
rename A5 indocc

sort year

save `outputpath'\fig10.dta, replace

use `outputpath'\fig10.dta, clear
sort year

sort year
foreach var of varlist yearFE-indocc {
replace `var'=`var'*100
sum `var' if year==1996
gen d_`var'=`var'-`r(mean)'
replace d_`var'=0 if year==1996
}


gen q=1
sort year q
gen time=year+((q-1)/4)
sort time
tempfile temp
save `temp', replace

clear
set obs 25
gen year=1995+_n
expand 4
sort year
by year: gen q=_n
gen time=year+((q-1)/4)
sort time

merge time using `temp'

gen c2=2 if (year==2001) 
gen c3=2 if (year==2007 & q==4) | (year==2008) | (year==2009 & q<=2) 

gen line=0 if year==1996
replace line=0 if year==2020

sort time

# delimit ;
twoway 
    (area c2 time, bcolor(gs13) base(-6)) 
    (area c3 time, bcolor(gs13) base(-6))
	(connected d_yearFE time , msymbol(square) mcolor(black) msize(medium) lcolor(black) lwidth(medthick) lpattern(solid))
	(connected d_age time  , msymbol(circle) mcolor(black) msize(medium) lcolor(black) lwidth(medium) lpattern(solid))
	(connected d_demog time  , msymbol(Oh) mcolor(black) msize(medsmall) lcolor(black) lwidth(medium) lpattern(solid))
	(connected d_indocc time  , msymbol(Th) mcolor(black) msize(medium) lcolor(black) lwidth(medium) lpattern(solid))
	(connected line time, msymbol(none) lcolor(black) lwidth(thin) lpattern(solid))
	,
	ytitle("", size(medium) margin(vsmall)) 
	ylabel(-6(2)2, labels labsize(medium) nogrid angle(horizontal)) 
	ymlabel(-6(1)2, nolabels ticks)
	yline()
	yscale(range(-6 2))
	xtitle("", size(small)) 
	xlabel(1996 2000 2005 2010 2015 2020, labels labsize(medium) ticks) 
	xmtick(1996(1)2020, nolabels) 
	legend(order(3 "No controls" 4 "Age and sex" 5 "Age, sex, educ., race, mar st." 6 "Demog., and full ind. and occ. controls") rows(3) size(medium) region(style(none)) margin(zero))
	title("", size(small))
	graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white) margin(small)) 
	plotregion(fcolor(white) lcolor(black) ifcolor(white) ilcolor(white) margin(tiny))
	ysize(3.75)
	xsize(6.2)
	name("fig10", replace)
	saving("`outputpath'/fig10.gph", replace)
	;

graph export "`outputpath'/fig10.eps", as(eps) replace;

# delimit cr
log close
	