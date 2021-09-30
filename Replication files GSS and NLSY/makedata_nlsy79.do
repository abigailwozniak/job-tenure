set more off

/*** Read in public NLSY79 extract and make basic variables for analysis. ***/

log using makedata_nlsy79.log, replace

*** Edit relevant value-labels file to rename variables

quietly infile using nlsy79_sp2019.dct
quietly do nlsy79_sp2019-value-labels.do
quietly do rename_nlsy79_sp2019.do

* drop weekly arrays for after 1994 -- uncomment rename statements at end of value-lables file to rename arrays
drop STATUS_WK_NUM0888 STATUS_WK_NUM0889 STATUS_WK_NUM089* STATUS_WK_NUM09* STATUS_WK_NUM1*

summ

*** Merge in custom weights for using sample of people in years 1979-1994
sort caseid
merge 1:1 caseid using custwt_1979to1994.dta
drop _merge

*** Measures of firm-specific human capital (tenure)
* The first measure of tenure is just tenure on the main job, tenure1_yy
* The second is the max of tenures on job1-job5

foreach x of numlist 79/94 {
  egen maxtenure`x'= rowmax(tenure1_`x' tenure2_`x' tenure3_`x' tenure4_`x' tenure5_`x')
  replace maxtenure`x'=. if maxtenure`x' < 0
  gen flag`x'=(maxtenure`x' > tenure1_`x')
  replace flag`x'=. if maxtenure`x'==.
}

summ tenure1* maxtenure* flag*
drop flag*

*** Job tenure is calculated in weeks for each job  
*** Job gaps excluded I think
foreach x of numlist 79/94 {
   gen tenuremon1_`x' = tenure1_`x' / 4.333 if tenure1_`x' > 0
}

summ tenure1* tenuremon1_* 

*** Standard Mincerian controls

gen black=0
replace black=1 if race_eth79==2
gen hisp=0
replace hisp=1 if race_eth79==1
gen female=0
replace female=1 if sex79==2
gen age79sq=age79^2

summ black hisp female

*** Highest grade completed each survey year

foreach x of numlist 79/79 {
  qui gen edgrp4_`x'=.
  qui replace edgrp4_`x'=1 if hgcrev`x' < 12
  qui replace edgrp4_`x'=2 if hgcrev`x' == 12  
  qui replace edgrp4_`x'=3 if hgcrev`x' >= 13 & hgcrev`x' <= 15
  qui replace edgrp4_`x'=4 if hgcrev`x' >= 16
  qui replace edgrp4_`x'=. if hgcrev`x' < 0 | hgcrev`x' > 20
}   

foreach x of numlist 80/94 {
  qui gen edgrp4_`x'=.
  local y = `x' - 1
  qui replace edgrp4_`x'=1 if hgcrev`x' < 12
  qui replace edgrp4_`x'=2 if hgcrev`x' == 12  
  qui replace edgrp4_`x'=3 if hgcrev`x' >= 13 & hgcrev`x' <= 15
  qui replace edgrp4_`x'=4 if hgcrev`x' >= 16 & hgcrev`x' <= 20
  qui replace edgrp4_`x'=edgrp4_`y' if hgcrev`x' < 0
}    

summ black hisp female age79 age79sq edgrp4_*
summ edgrp4_* hgcrev*

foreach x of numlist 79/94 {
  qui gen married`x'=.
  qui replace married`x'=1 if marstat`x'==1 | marstat`x'==2 | marstat`x'==5
  qui replace married`x'=0 if marstat`x'==0 | marstat`x'==3 | marstat`x'==6
  
  qui replace region`x'=. if region`x' < 0
  
  qui replace smsares`x'=. if smsares`x' < 0
  qui replace smsares`x'=1 if smsares`x' >=1
}  

summ married* region* smsares*

*** Normalized AFQT scores - already normalized in Investigator?
*** Need to adjust for taking test at different ages

bysort age79: summ AFQT*

*** Construct hourly wages
* NLSY79 seems to only ask total wages, salary and tips in past calendar year, not separately by job
* Construct hourly wage from total earnings, divided by weeks worked last calendar year and usual hours per week on main job

foreach x of numlist 79/94 {
  gen hrlywage`x' = .
  replace hrlywage`x' = totwages`x' / (cpsweekhrs`x' * wkswk_pcy`x')
  replace hrlywage`x' = . if totwages`x' < 0 | cpsweekhrs`x' < 0 | wkswk_pcy`x' < 0   
  replace hrlywage`x' = . if totwages`x'==. | cpsweekhrs`x'==. | wkswk_pcy`x'==. 
  replace cpshrp`x' = . if cpshrp`x' < 0
  replace hrp1_`x' = . if hrp1_`x' < 0
}

* DO MORE CHECKING OF THE wage VARIABLE
* Also have hrp1_ and cpshrp - created variables 

summ hrlywage* hrp1* cpshrp*

*** Need to trim hrp variables - created variables do not eliminate unreasonable responses

foreach x of numlist 79/94 {
  egen templo=pctile(hrp1_`x'), p(2.5)
  egen temphi=pctile(hrp1_`x'), p(97.5)
  egen templo2=pctile(cpshrp`x'), p(2.5)
  egen temphi2=pctile(cpshrp`x'), p(97.5)
  replace hrp1_`x'=. if (hrp1_`x' > temphi | hrp1_`x' < templo)
  replace cpshrp`x'=. if (cpshrp`x' > temphi2 | cpshrp`x' < templo2)
  drop temphi* templo*
  replace hrp1_`x'=hrp1_`x' / 100
  replace cpshrp`x' = cpshrp`x' / 100
}

summ hrlywage* hrp1* cpshrp*

*** Merge in cpi for deflating hourly wages 

preserve
clear

use cpiu_8284
drop if year < 1979 | year > 1994
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

foreach x of numlist 79/94 {
  gen realwage`x' = 100 * hrlywage`x' / cpiu_8284_19`x' 
  gen rhrp1_`x' = 100 * hrp1_`x' / cpiu_8284_19`x'
  gen rcpshrp`x' = 100 * cpshrp`x' / cpiu_8284_19`x'
  }

summ realwage* hrlywage* rhrp1* hrp1* rcpshrp* cpshrp*

*** Create variables comparable to weeks unemployed last year (PCY) to that from 97 data - also count up weeks of active service ;

gen wksuemp2_pcy79=.
gen wksactive79=.
foreach x of numlist 1/9 {
  replace wksuemp2_pcy79=1 if wksuemp2_pcy79==. & STATUS_WK_NUM000`x'==4
  replace wksuemp2_pcy79=(wksuemp2_pcy79 + 1) if wksuemp2_pcy79~=. & STATUS_WK_NUM000`x'==4
  replace wksactive79=1 if wksactive79==. & STATUS_WK_NUM000`x'==7
  replace wksactive79=(wksactive79 + 1) if wksactive79~=. & STATUS_WK_NUM000`x'==7
}

foreach x of numlist 10/53 {
  replace wksuemp2_pcy79=1 if wksuemp2_pcy79==. & STATUS_WK_NUM00`x'==4
  replace wksuemp2_pcy79=(wksuemp2_pcy79 + 1) if wksuemp2_pcy79~=. & STATUS_WK_NUM00`x'==4
  replace wksactive79=1 if wksactive79==. & STATUS_WK_NUM00`x'==7
  replace wksactive79=(wksactive79 + 1) if wksactive79~=. & STATUS_WK_NUM00`x'==7
}

gen wksuemp2_pcy80=.
gen wksactive80=.
foreach x of numlist 54/99 {
  replace wksuemp2_pcy80=1 if wksuemp2_pcy80==. & STATUS_WK_NUM00`x'==4
  replace wksuemp2_pcy80=(wksuemp2_pcy80 + 1) if wksuemp2_pcy80~=. & STATUS_WK_NUM00`x'==4
  replace wksactive80=1 if wksactive80==. & STATUS_WK_NUM00`x'==7
  replace wksactive80=(wksactive80 + 1) if wksactive80~=. & STATUS_WK_NUM00`x'==7
}

foreach x of numlist 100/105 {
  replace wksuemp2_pcy80=1 if wksuemp2_pcy80==. & STATUS_WK_NUM0`x'==4
  replace wksuemp2_pcy80=(wksuemp2_pcy80 + 1) if wksuemp2_pcy80~=. & STATUS_WK_NUM0`x'==4
  replace wksactive80=1 if wksactive80==. & STATUS_WK_NUM0`x'==7
  replace wksactive80=(wksactive80 + 1) if wksactive80~=. & STATUS_WK_NUM0`x'==7
}

foreach x of numlist 106 158 210 262 367 419 471 523 628 680 732 784 836 {
   if `x' <= 262 {
      local yr = ((`x' - 2)/52) + 79
   }
   if  `x' > 262 & `x' <= 523 {
      local yr = ((`x' - 3)/52) + 79
   }
   if  `x' > 523 {
      local yr = ((`x' - 4)/52) + 79
   }   
   gen wksuemp2_pcy`yr'=.
   gen wksactive`yr'=.
   qui foreach z of numlist 0/51 {
      local z2 = `x' + `z'
      replace wksuemp2_pcy`yr'=1 if wksuemp2_pcy`yr'==. & STATUS_WK_NUM0`z2'==4
      replace wksuemp2_pcy`yr'=(wksuemp2_pcy`yr' + 1) if wksuemp2_pcy`yr'~=. & STATUS_WK_NUM0`z2'==4
      replace wksactive`yr'=1 if wksactive`yr'==. & STATUS_WK_NUM0`z2'==7
      replace wksactive`yr'=(wksactive`yr' + 1) if wksactive`yr'~=. & STATUS_WK_NUM0`z2'==7
   }
}

* NLSY has a few 53-week years
foreach x of numlist 314 575 {
   if `x'==314 {
      local yr = 85
   }
   if `x'==575 {
      local yr = 90
   }
   gen wksuemp2_pcy`yr'=.
   gen wksactive`yr'=.
   qui foreach z of numlist 0/52 {
      local z2 = `x' + `z'
      replace wksuemp2_pcy`yr'=1 if wksuemp2_pcy`yr'==. & STATUS_WK_NUM0`z2'==4
      replace wksuemp2_pcy`yr'=(wksuemp2_pcy`yr' + 1) if wksuemp2_pcy`yr'~=. & STATUS_WK_NUM0`z2'==4
      replace wksactive`yr'=1 if wksactive`yr'==. & STATUS_WK_NUM0`z2'==7
      replace wksactive`yr'=(wksactive`yr' + 1) if wksactive`yr'~=. & STATUS_WK_NUM0`z2'==7
   }
}

summ wksuemp2* wksuemp_* wksactive*
drop STATUS_WK_*

quietly compress
save nlsy79_1979to1994.dta, replace

log close
clear
