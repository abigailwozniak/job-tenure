clear
set more off
capture log close
  
*FOR CALCULATING SEPARATION RATE COHORT EFFECTS

local logpath="C:\Users\15099\Downloads\christopher_replicationcode\"
local datapath="C:\Users\15099\Downloads\christopher_replicationcode\processed\"
local outputpath="C:\Users\15099\Downloads\christopher_replicationcode\output\"
local dtapath="C:\Users\15099\Downloads\christopher_replicationcode\"

log using "`logpath'cohort-effects-separation-byage.log", replace

use asecwt age empstat wkswork2 numemps sex year using `dtapath'cps_00138.dta, clear
keep if asecwt>0
keep if age>=25 & age<=54
gen emp=(empstat==10 | empstat==12)
gen emply=(wkswork2>=1 & wkswork2<=6)
gen multemps=(numemps==2 | numemps==3)
gen sep=(emply==1 & emp==0)

gen ur=(empstat>=20 & empstat<=22) if empstat>=10 & empstat<=22

gen seprate_EN=sep if emply!=0
gen seprate_multE=multemps if emply!=0

gen cohort=year-age
keep if sex==1 

preserve

foreach a in "25to34" "35to44" "45to54" "35to54" {
restore
preserve

if "`a'"=="25to34" {
keep if age>=25 & age<=34
local amin=25
local amax=34
local acount=10
}
if "`a'"=="35to44" {
keep if age>=35 & age<=44
local amin=35
local amax=44
local acount=10
}
if "`a'"=="45to54" {
keep if age>=45 & age<=54
local amin=45
local amax=54
local acount=10
}

if "`a'"=="35to54" {
keep if age>=35 & age<=54
local amin=35
local amax=54
local acount=20
}

sum cohort

local min=`r(min)'
local max=`r(max)'

local count=`max'-`min'+1

keep if cohort>=1929 & cohort<=1963

foreach n of numlist `min'/`max' {
gen cohort`n'=(cohort==`n')
}

foreach a of numlist `amin'/`amax' {
gen age`a'=(age==`a')
}

gen pop=n

sort year
by year: egen sum=sum(pop)
replace pop=pop/sum

foreach s in seprate_multE seprate_EN ur {

local yr=0
if "`s'"=="seprate_multE" local yr="1976"

xi: reg `s' cohort`min'-cohort`max' age`amin'-age`amax' [aw=asecwt] if year>=`yr'
predict pred`s' if year>=`yr'

gen agetmp=0
foreach v of varlist age`amin'-age`amax' {
replace pred`s'=pred`s'-(_b[`v']*`v') if  year>=`yr'
replace agetmp=agetmp+_b[`v'] if year>=`yr'
}
replace pred`s'=pred`s'+(agetmp/`acount') if  year>=`yr'
drop agetmp
}

sort cohort

collapse (mean) predseprate_multE predseprate_EN predur [aw=asecwt], by(cohort)
rename predseprate_multE predseprate_multE_`amin'`amax'
rename predseprate_EN predseprate_EN_`amin'`amax'
rename predur predur_`amin'`amax'
sort cohort
tempfile temp`amin'`amax'
save `temp`amin'`amax'', replace
}

use `temp2534', clear
sort cohort
merge cohort using `temp3544'
drop _merge
sort cohort
merge cohort using `temp4554'
drop _merge
sort cohort
merge cohort using `temp3554'
drop _merge
sort cohort

save "`outputpath'cohort-effects-separations-men-byage.dta", replace


log close
