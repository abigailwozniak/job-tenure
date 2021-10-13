clear
set more off
capture log close

*FOR CALCULATING SEPARATION RATE COHORT EFFECTS

local logpath="C:\Users\15099\Downloads\christopher_replicationcode\"
local datapath="C:\Users\15099\Downloads\christopher_replicationcode\processed\"
local outputpath="C:\Users\15099\Downloads\christopher_replicationcode\output\"
local dtapath="C:\Users\15099\Downloads\christopher_replicationcode\"

log using "`logpath'cohort-effects-separation.log", replace

use `dtapath'cps_00138.dta, clear
keep if asecwt>0
keep if age>=35 & age<=54
gen emp=(empstat==10 | empstat==12)
gen emply=(wkswork2>=1 & wkswork2<=6)
gen multemps=(numemps==2 | numemps==3)
gen sep=(emply==1 & emp==0)

gen ur=(empstat>=20 & empstat<=22) if empstat>=10 & empstat<=22

gen married=(marst==1 | marst==2)

gen seprate_EN=sep if emply!=0
gen seprate_multE=multemps if emply!=0

gen cohort=year-age

preserve

foreach sex in 1 2 {
restore
preserve

keep if sex==`sex'
sum cohort

local min=`r(min)'
local max=`r(max)'

local count=`max'-`min'+1

keep if cohort>=1929 & cohort<=1963

foreach n of numlist `min'/`max' {
gen cohort`n'=(cohort==`n')
}

foreach a of numlist 35/54 {
gen age`a'=(age==`a')
}

gen pop=n

sort year
by year: egen sum=sum(pop)
replace pop=pop/sum

foreach s in seprate_multE seprate_EN ur {

local yr=0
if "`s'"=="seprate_multE" local yr="1976"

xi: reg `s' cohort`min'-cohort`max' age35-age54 [aw=asecwt] if year>=`yr'
predict pred`s' if year>=`yr'

gen agetmp=0
foreach v of varlist age35-age54 {
replace pred`s'=pred`s'-(_b[`v']*`v') if  year>=`yr'
replace agetmp=agetmp+_b[`v'] if year>=`yr'
}
replace pred`s'=pred`s'+(agetmp/20) if  year>=`yr'
drop agetmp
}

sort cohort

collapse (mean) predseprate_multE* predseprate_EN* predur* [aw=asecwt], by(cohort)
sort cohort
save "`outputpath'cohort-effects-separations-sex`sex'.dta", replace
}

log close
