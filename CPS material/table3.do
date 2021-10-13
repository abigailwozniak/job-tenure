clear
set more off
graph drop _all
capture log close

local datapath="C:\Users\15099\Downloads\christopher_replicationcode\processed\"
local outputpath="C:\Users\15099\Downloads\christopher_replicationcode\output\"
local dtapath="C:\Users\15099\Downloads\christopher_replicationcode\"
local logpath="C:\Users\15099\Downloads\christopher_replicationcode\"

log using "`logpath'table3.log", replace

use "`outputpath'cohort-effects-separations-men-byage.dta", clear
sort cohort
tempfile sep
save `sep', replace

use "`outputpath'cohort-effects-longtenure-sex1.dta", clear
sort cohort
merge cohort using `sep'
keep if _merge==3
drop _merge

keep if cohort>=1929 & cohort<=1963

keep if ten20p_5564!=.  
sum ten20p_5564 predseprate_multE_3554 predseprate_EN_3554 predur_3554

mat A=J(10,5,0)

reg ten20p_5564 predseprate_EN_3554, robust
mat A[1,1]=_b[predseprate_EN_3554]
mat A[2,1]=_se[predseprate_EN_3554]
mat A[9,1]=`e(r2)'
mat A[10,1]=`e(N)'

reg ten20p_5564 predseprate_EN_2534 predseprate_EN_3544 predseprate_EN_4554 , robust
mat A[3,2]=_b[predseprate_EN_2534]
mat A[4,2]=_se[predseprate_EN_2534]
mat A[5,2]=_b[predseprate_EN_3544]
mat A[6,2]=_se[predseprate_EN_3544]
mat A[7,2]=_b[predseprate_EN_4554]
mat A[8,2]=_se[predseprate_EN_4554]
mat A[9,2]=`e(r2)'
mat A[10,2]=`e(N)'

reg ten20p_5564 predur_3554, robust
mat A[1,3]=_b[predur_3554]
mat A[2,3]=_se[predur_3554]
mat A[9,3]=`e(r2)'
mat A[10,3]=`e(N)'

reg ten20p_5564 predur_2534 predur_3544 predur_4554, robust
mat A[3,4]=_b[predur_2534]
mat A[4,4]=_se[predur_2534]
mat A[5,4]=_b[predur_3544]
mat A[6,4]=_se[predur_3544]
mat A[7,4]=_b[predur_4554]
mat A[8,4]=_se[predur_4554]
mat A[9,4]=`e(r2)'
mat A[10,4]=`e(N)'

reg ten20p_5564 predseprate_multE_3554, robust
mat A[1,5]=_b[predseprate_multE_3554]
mat A[2,5]=_se[predseprate_multE_3554]
mat A[9,5]=`e(r2)'
mat A[10,5]=`e(N)'

drop _all
svmat A

save "`outputpath'table3.dta", replace
capture log close

