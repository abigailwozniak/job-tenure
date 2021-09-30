set more off

*** Constructing job tenure and reason for leaving (whyleft) variables for job tenure project.
*** This is revision of make_tenurevars_v2.do from migration decline project.

*** Updates make sample definitions more similar to SIPP, CPS. Including drop those not employed at previous tenure obs, drop SE, drop enrolled.         
                                                                                                                                                         
log using make_tenure_whyleft_97.log, replace

/*** This is an expanded version of the data set from migration decline project. Makedata files for it can be found there. ***/

use nlsy97_1997to2011.dta

*** Harmonize jobid coding across years
summ job1id*
qui replace job1id1997=job1id1997 + 190000 if job1id1997 > 0
qui replace job1id1998=job1id1998 + 190000 if job1id1998 > 0
summ job1id* 

foreach x of numlist 1997/2011 {
  replace intmonth`x'=(intmonth`x'==-5)
} 
egen count = rowtotal(intmonth1997 intmonth1998 intmonth1999 intmonth2000 intmonth2001 intmonth2002 intmonth2003 intmonth2004 intmonth2005 intmonth2006 intmonth2007 intmonth2008 intmonth2009 intmonth2010 intmonth2011)
gen continuous=1
replace continuous=0 if count > 0
summ continuous

* Variable for months of tenure on main job at previous survey round - Plus dummy for employment at main job 1 in previous survey

gen prevtenuremon1_1997=.

foreach x of numlist 1998/2011 {
   local y = `x' - 1
   gen prevtenuremon1_`x'= .
   replace  prevtenuremon1_`x'= tenuremon1_`y'  
   *replace  prevtenuremon1_`x'= tenuremon1_`y' if empstatus_prevweek_`y' > 6 
   
   gen prevempd1_`x' = .
   replace prevempd1_`x'=0 if curemp01_`y'==0 | curemp01_`y'==-4
   replace prevempd1_`x'=1 if curemp01_`y'==1
   
   }
   
summ prevtenuremon1* prevempd1_*

* Variable for main job is new employer

gen mainisnew1997=.
gen tmain1997=0 if job1id1997 < 0
replace tmain1997=1 if job1id1997 > 0
gen tmain22_1997=0

tab1 age1997

forvalues x = 1998/2011 {

	 local y = `x' - 1

   gen mainisnew`x'=.   
   
   * gen mainisnew_old`x'=. 
   * replace mainisnew_old`x'=0 if job1id`x' > 0
   * replace mainisnew_old`x'=1 if job1id`x'==`x'01
   * "Old" coding is incorrect for many Rs. See Employment: An Introduction in NLSY97 documentation appedix.
   
   * Mainisnew means job 1 this year is new to that position. 
   * Can be a new job to the survey year (then jobid has current year as first four digits) or a prev job that wasn't main job.
   
   gen job1id_yr=int(job1id`x'/100)
   replace mainisnew`x'=1 if job1id_yr==`x'
   replace mainisnew`x'=1 if (job1id_yr~=. & job1id_yr~=`x' & job1id`x' ~= job1id`y')
   replace mainisnew`x'=0 if job1id`x' == job1id`y'
   drop job1id_yr
   
   gen tmain`x' = tmain`y' if continuous==1 
   replace tmain`x' = mainisnew`x' + tmain`y' if continuous==1 & mainisnew`x'~=.
   
   gen tmain22_`x' = tmain22_`y' if continuous==1 
   replace tmain22_`x' = (mainisnew`x' + tmain22_`y') if continuous==1 & mainisnew`x'~=. & ((age1997 + `x' - 1997) > 22)
   replace tmain22_`x'=1 if job1id`x' > 0 & continuous==1 & ((age1997 + `x' - 1997) == 22)
      
   }

summ mainisnew* tmain*
*drop mainisnew_old*


*** Recode reason for leaving into invol, vol, and missing - any reason with word quit in title or other is vol
*** Reasons 1 through 5 are the same as 1 through 5 in latter half of NLSY79 codes.

gen whyleft01_1997=.

forvalues x = 1998/2011 {

   local y = `x' - 1
   
   gen whyleft01_`x'=.
   replace whyleft01_`x'=YEMP58400_01_`x' if YEMP58400_01_`x' > 0
   replace whyleft01_`x'=YEMP58400_02_`x' if job2id`x'==job1id`y' & YEMP58400_02_`x' > 0
   replace whyleft01_`x'=YEMP58400_03_`x' if job3id`x'==job1id`y' & YEMP58400_03_`x' > 0
   replace whyleft01_`x'=YEMP58400_04_`x' if job4id`x'==job1id`y' & YEMP58400_04_`x' > 0
   replace whyleft01_`x'=YEMP58400_05_`x' if job5id`x'==job1id`y' & YEMP58400_05_`x' > 0
}   

foreach x of numlist 1997/2011 {
   gen invol`x'=.
   *tab1 whyleft01_`x'
   replace invol`x'=1 if whyleft01_`x'>=0 & whyleft01_`x'< 6
   replace invol`x'=0 if whyleft01_`x' >= 6 & whyleft01_`x'<= 17
   *replace invol`x'=0 if whyleft01_`x' >= 6 & whyleft01_`x'< 1000 
   
}

tab1 invol*
summ invol* tenuremon*
summ mainisnew* whyleft01* 

forvalues x = 1998/2011 {
   table mainisnew`x' invol`x', contents(freq) missing
}


sort pubid
save nlsy97_tenure_plus_whyleft.dta, replace

keep tenuremon1* prevtenuremon* edgrp4* black hisp female age1997 edgrp4* curemp01_* curemp02_* invol* mainisnew* whyleft01_* enrollstat* job1se_* prevempd1_* tmain* continuous pubid custwt
reshape long tenuremon1_ prevtenuremon1_ edgrp4_ curemp01_ curemp02_ invol mainisnew whyleft01_ enrollstat job1se_ prevempd1_ tmain tmain22_, i(pubid) j(year)


drop if year > 2011 | year < 1997
summ

gen age = age1997 + (year - 1997)
gen age2 = age^2 
bys year: summ age

char edgrp4_[omit] 2
xi, prefix(_Y) i.year
xi, prefix(_E) i.edgrp4_

gen ptencat=.
replace ptencat=1 if prevtenuremon1_ > 0 & prevtenuremon1_ < 12
replace ptencat=2 if prevtenuremon1_ >= 12 & prevtenuremon1_ < 36
replace ptencat=3 if prevtenuremon1_ >= 36 & prevtenuremon1_ < 60
replace ptencat=4 if prevtenuremon1_ >= 60 & prevtenuremon1_ < 120
replace ptencat=5 if prevtenuremon1_ >= 120 & prevtenuremon1_~=.

gen tencat=.
replace tencat=1 if tenuremon1_ > 0 & tenuremon1_ < 12
replace tencat=2 if tenuremon1_ >= 12 & tenuremon1_ < 36
replace tencat=3 if tenuremon1_ >= 36 & tenuremon1_ < 60
replace tencat=4 if tenuremon1_ >= 60 & tenuremon1_ < 120
replace tencat=5 if tenuremon1_ >= 120 & tenuremon1_~=.

/**

* Previous coding breaking up less than one year of tenure.
gen ptencat=.
replace ptencat=1 if prevtenuremon1_ > 0 & prevtenuremon1_ < 3
replace ptencat=2 if prevtenuremon1_ >= 3 & prevtenuremon1_ < 12
replace ptencat=3 if prevtenuremon1_ >= 12 & prevtenuremon1_ < 36
replace ptencat=4 if prevtenuremon1_ >= 36 & prevtenuremon1_ < 60
replace ptencat=5 if prevtenuremon1_ >= 60 & prevtenuremon1_ < 120
replace ptencat=6 if prevtenuremon1_ >= 120 & prevtenuremon1_~=.

gen tencat=.
replace tencat=1 if tenuremon1_ > 0 & tenuremon1_ < 3
replace tencat=2 if tenuremon1_ >= 3 & tenuremon1_ < 12
replace tencat=3 if tenuremon1_ >= 12 & tenuremon1_ < 36
replace tencat=4 if tenuremon1_ >= 36 & tenuremon1_ < 60
replace tencat=5 if tenuremon1_ >= 60 & tenuremon1_ < 120
replace tencat=6 if tenuremon1_ >= 120 & tenuremon1_~=.

label define ptencatlbl 1 "Less than 1Q" 2 "1Q to less than 1Y" 3 "1Y to less than 3Y" 4 "3Y to less than 5Y" 5 "5Y to less than 10Y" 6 "10Y and up"

**/

label define ptencatlbl 1 "Less than 1Y" 2 "1Y to less than 3Y" 3 "3Y to less than 5Y" 4 "5Y to less than 10Y" 5 "10Y and up"
label values ptencat ptencatlbl
label values tencat ptencatlbl

tab1 ptencat
bys year: tab1 ptencat

* Among those with obs on invol, what is share invol across prev tenure categories?
tabulate ptencat, summarize(invol)
tabulate ptencat if age >=22, summarize(invol)

gen empd=.
replace empd=1 if curemp01_==1
replace empd=0 if curemp01_==0 | curemp01_==-4

gen empd2=.
replace empd2=1 if curemp02_==1
replace empd2=0 if curemp02_==0 | curemp02_==-4
summ empd2

* Drop multiple job holders
drop if empd2==1 & empd==1


bys year: tab1 age

*** Age restriction. Age tops out at 31. Drop if currently enrolled. Drop if self employed. Drop if not employed on main job at previous interview, when tenure measured.

drop if age < 22
drop if ptencat==.
drop if prevempd1_ ~= 1


tab1 year ptencat
bys year: tab1 invol

* Technically NLS wants you to sub in the edited version (EDT) of cv_enrollstat, but the diffs seem small.
drop if inlist(enrollstat,8,9,10,11)
tab1 enrollstat

* This SE variable only available from 2000 on but should be okay given our age requirements.
bys year: summ job1se_
drop if job1se_==1


*** Concern that change in job number coding plus computer assisted interviewing could lead to better employer tracking.
*** Coding, recording of tenure on main job each year should have changed less across survey years and versions. So do some checks using only that.

* Probability that current tenure on main job is over a year, and currently employed, by previous tenure category.

gen checkten1yrplus=0
replace checkten1yrplus=1 if empd==1 & tencat>=3 & tencat~=.

table ptencat [pw=custwt], contents(mean checkten1yrplus)

*tabulate ptencat tencat [pw=custwt], nofreq
tabulate ptencat tencat, row column nofreq  

* Dummy for continued employment 

gen continuedemp=.
replace continuedemp=1 if ptencat~=. & mainisnew==0
replace continuedemp=0 if ptencat~=. & mainisnew==1

gen conempemp=.
replace conempemp=0 if ptencat~=. 
replace conempemp=1 if ptencat~=. & mainisnew==0 & empd==1


* Universe of invol is everyone with a whyleft code. Check that some are not employed at current interview  
bys invol: summ empd

*** Mainisnew includes jobs new to main position, so can have (many) with mainisnew=1 but no invol code

* mainisnew=1 empd=1 and invol=. can happen if kept old main job as non-main employer
* mainisnew=0 empd=1 and invol~=. can happen if left and returned to previous main employer
* mainisnew=0 or =1 and empd=0 should have invol code for why left that employer

tab1 mainisnew
bys mainisnew: tab1 invol
bys mainisnew: tab1 invol if empd==1
bys mainisnew: tab1 invol if empd==0


* Dummies for shares of those previously employed who left vol, invol

gen sepvol=.
replace sepvol=0 if ptencat~=.
replace sepvol=1 if ptencat~=. & invol==0

gen sepinvol=.
replace sepinvol=0 if ptencat~=.
replace sepinvol=1 if ptencat~=. & invol==1

gen tempend=.
replace tempend=0 if ptencat~=.
replace tempend=1 if tempend==0 & whyleft01_==3

gen somecoll=.
replace somecoll=0 if edgrp4_==1 | edgrp4_==2
replace somecoll=1 if edgrp4_==3 | edgrp4_==4


/* MAIN RESULTS TABLES, by previous tenure category */

tab1 ptencat
bys ptencat: summ empd mainisnew invol
table ptencat [pw=custwt], contents(mean empd mean mainisnew mean invol mean continuedemp mean conempemp)
table ptencat [pw=custwt], contents(mean sepinvol mean sepvol mean tempend mean tmain)

table ptencat [pw=custwt], contents(mean tempend mean sepinvol mean sepvol mean conempemp mean tmain)
table age [pw=custwt], contents(mean tmain)

table ptencat [pw=custwt], contents(mean tempend mean sepinvol mean sepvol mean conempemp mean tmain22_)
table age [pw=custwt], contents(mean tmain22_)

preserve 

keep if continuous==1
collapse (percent) continuous [pw=custwt], by(tmain)
list
 
restore 
preserve 

keep if continuous==1
collapse (percent) continuous [pw=custwt], by(tmain22_)
list
 
restore 
preserve
keep if continuous==1 & somecoll==0
collapse (percent) continuous [pw=custwt], by(tmain22_)
list
 
restore 
preserve
keep if continuous==1 & somecoll==1
collapse (percent) continuous [pw=custwt], by(tmain22_)
list
 
restore 


sort year
univar year

** Compare tmain, tmain22 among obs in continuously

table ptencat if continuous==1 [pw=custwt], contents(mean tmain mean tmain22_)
table age if continuous==1 [pw=custwt], contents(mean tmain mean tmain22_)
corr tmain tmain22_ if continuous==1 
bys year: corr tmain tmain22_ if continuous==1 

** Drop recession years

preserve
drop if inlist(year, 2000, 2001, 2008, 2009)

table ptencat [pw=custwt], contents(mean empd mean mainisnew mean invol mean continuedemp mean conempemp)
table ptencat [pw=custwt], contents(mean sepinvol mean sepvol mean tempend)
restore

* Adjust for changing age composition by year

corr invol sepinvol age

xi, pre(_A) i.age 
keep year custwt _A* empd mainisnew invol continuedemp sepinvol sepvol tempend

foreach x in empd mainisnew invol continuedemp sepinvol sepvol tempend {
	reg `x' _A*
	predict `x'_adj, residuals
}

sort year

table year [pw=custwt], contents(mean empd_adj mean mainisnew_adj mean invol_adj)
table year [pw=custwt], contents(mean sepinvol_adj mean sepvol_adj mean tempend_adj)

log close
clear




