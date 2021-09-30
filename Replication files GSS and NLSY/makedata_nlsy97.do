set more off

log using makedata_nlsy97.log, replace

*** Read in NLSY97 data for doing returns to experience estimation.
*** Updated to add job tenure project variables to nlsy97_fall2011 data set.

qui infile using nlsy97_sp2019.dct
qui do nlsy97_sp2019-value-labels.do
qui do rename_nlsy97_sp2019.do

summ hgc* tenureweeks1* intmonth* hrp1*
summ sex bdate* race_eth

*** Merge in custom weights for using sample of people in years 1979-1994
sort pubid
merge 1:1 pubid using custwt_1997to2011.dta
drop _merge

summ custwt

*** Basic Mincer controls

gen black=(race_eth==1)
gen hisp=(race_eth==2)

gen female=(sex==2)

summ black hisp female

foreach x of numlist 1997/2011 {
  gen age`x'=.
  replace age`x'= (`x' - bdate_year)
  replace age`x' = age`x' - 1 if (bdate_month > intmonth`x') 
  replace age`x'=. if intmonth`x' < 0
}

summ age*

foreach x of numlist 1997/2011 {
  qui gen married`x'=.
  qui replace married`x'=1 if marstat`x'>=3 & marstat`x'<=6 
  qui replace married`x'=0 if marstat`x'==1 | marstat`x'==2 | marstat`x'==7 | marstat`x'==8 | marstat`x'==9 | marstat`x'==10
  
  qui replace region`x'=. if region`x' < 0
  
  qui replace smsares`x'=. if smsares`x' < 0 | smsares`x'==5
  qui replace smsares`x'=0 if smsares`x'==1
  qui replace smsares`x'=1 if smsares`x' > 1 & smsares`x'~=.
}  

summ married* region* smsares*

foreach x of numlist 1997/1997 {
  gen edgrp4_`x'=.
  qui replace edgrp4_`x'=1 if hgc`x' < 12 & hgc`x' > 0
  qui replace edgrp4_`x'=2 if hgc`x' == 12  
  qui replace edgrp4_`x'=3 if hgc`x' >= 13 & hgc`x' <= 15
  qui replace edgrp4_`x'=4 if hgc`x' >= 16
  qui replace edgrp4_`x'=. if hgc`x' < 0 | hgc`x' > 20
}    

foreach x of numlist 1998/2011 {
  local y = `x' - 1
  qui gen edgrp4_`x'=.
  qui replace edgrp4_`x'=1 if hgc`x' < 12 & hgc`x' > 0
  qui replace edgrp4_`x'=2 if hgc`x' == 12  
  qui replace edgrp4_`x'=3 if hgc`x' >= 13 & hgc`x' <= 15
  qui replace edgrp4_`x'=4 if hgc`x' >= 16 & hgc`x' <= 20
  qui replace edgrp4_`x'=edgrp4_`y' if hgc`x' < 0
}    

summ edgrp4_* hgc*


*** Job tenure is calculated in weeks for each job in NLSY97
*** Job gaps excluded
foreach x of numlist 1997/2011 {
   gen tenuremon1_`x' = tenureweeks1_`x' / 4.333 if tenureweeks1_`x' > 0
}

summ tenuremon1_*

*** Highest grade completed
*XXXX

*** ASVAB scores available in NLSY97 - need to figure out how to use these
*XXXX

*** BLS created hourly rate of pay for each job, extreme values need to be trimmed
*** Merge in cpi for deflating hourly wages 

preserve
clear

use cpiu_8284
drop if year < 1997 | year > 2011
rename cpiu_8284 cpiu_8284_
gen id=1
reshape wide cpiu_8284_, i(id) j(year)
tempfile tempcpi
save `tempcpi', replace
clear

restore 

gen id=1
merge m:1 id using `tempcpi'
drop _merge
summ cpiu*

foreach x of numlist 1997/2011 {
  gen rhrp1_`x'=.
  replace rhrp1_`x' = hrp1_`x' / cpiu_8284_`x' if hrp1_`x' > 0
  }

summ rhrp1* hrp1* 

foreach x of numlist 1997/2011 {
  egen templo=pctile(rhrp1_`x'), p(2.5)
  egen temphi=pctile(rhrp1_`x'), p(97.5)
  replace rhrp1_`x'=. if (rhrp1_`x' > temphi | rhrp1_`x' < templo)
  drop temphi templo
}

summ rhrp1*

/*** Not sure why but some of the emp_status arrays seem to be missing, prior to 1999, on Investigator. Commenting out for now. ***/

/***

*** Create variables comparable to weeks unemployed last year (PCY) to that from 79 data - also count up weeks of active service ;

foreach x of numlist 1997/2011 {
   gen wksuemp_pcy`x'=.
   gen wksactive`x'=.
   local y = `x' - 1
      foreach z of numlist 1/52 {
      replace wksuemp_pcy`x'=1 if wksuemp_pcy`x'==. & EMP_STATUS_`y'_`z'==4
      replace wksuemp_pcy`x'= (wksuemp_pcy`x' + 1) if wksuemp_pcy`x'~=. & EMP_STATUS_`y'_`z'==4
      replace wksactive`x'=1 if wksactive`x'==. & EMP_STATUS_`y'_`z'==6
      replace wksactive`x'= (wksactive`x' + 1) if wksactive`x'~=. & EMP_STATUS_`y'_`z'==6
   }
}

foreach x of numlist 1996 {
   gen wkswkann`x'=.
      foreach z of numlist 1/52 {
      replace wkswkann`x'=1 if wkswkann`x'==. & EMP_STATUS_`x'_`z' > 100
      replace wkswkann`x'= (wkswkann`x' + 1) if wkswkann`x'~=. & EMP_STATUS_`x'_`z' > 100
   }
}
summ wksuemp* wksactive* wkswkann*

*save nlsy97_1997to2011_empstatus.dta, replace

***/

drop EMP_STATUS*
      
quietly compress

save nlsy97_1997to2011.dta, replace

log close
clear


