set more off

*** Constructing job tenure and reason for leaving (whyleft) variables for job tenure project.
*** This is revision of make_tenurevars_v2.do from migration decline project.
*** See comments in code regarding whyleft01_ variable and retaining jobs that are not CPS jobs in sample.

*** Updates make sample definitions more similar to SIPP, CPS. Including drop those not employed at previous tenure obs, drop SE, drop enrolled. 

log using make_tenure_whyleft.log, replace

* This is updated data set from migration decline project. Makedata files now in Data Construction folder.

use nlsy79_1979to1994.dta


*** Analysis for job tenure project

foreach x of numlist 80/94 {
  replace hgcrev`x'=. if hgcrev`x' < 0
} 	

foreach x of numlist 79/94 {
  replace minterview`x'=(minterview`x'==-5)
} 
egen count = rowtotal(minterview79 minterview80 minterview81 minterview81 minterview82 minterview83 minterview84 minterview85 minterview86 minterview87 minterview88 minterview89 minterview90 minterview91 minterview92 minterview93 minterview94)
gen continuous=1
replace continuous=0 if count > 0
summ continuous

* Variable for months of tenure on main job (job 1) at previous survey round. And dummy for employment at job 1 in previous round.

gen prevtenuremon1_79=.

foreach x of numlist 80/94 {
   local y = `x' - 1
   gen prevtenuremon1_`x'= . 
   replace prevtenuremon1_`x'=tenuremon1_`y' 
   *replace prevtenuremon1_`x'=tenuremon1_`y' if (esr_key`y'==1 | esr_key`y'==2)
   
   gen prevempd1_`x' = .
   replace prevempd1_`x'=0 if QES2301_`y'==0 | QES2301_`y'==-4
   replace prevempd1_`x'=1 if QES2301_`y'==1
   
   }
   
summ prevtenuremon1* prevempd1*


* Dummy for main job (job 1) is new this survey round. This is defined by accession to a new employer. 
* Reason for leaving previous job 1 employer is defined by a separation from that employer. So affected groups do not overlap perfectly.
* Also, not all Rs with a new main job are employed at that job at the time of interview. Can restrict to employed later.

gen mainisnew79=.
gen tmain79=0 if QES2301_79 < 0 & continuous==1
replace tmain79=1 if QES2301_79 >= 0 & continuous==1

summ age79
gen tmain22_79=0 if continuous==1
replace tmain22_79=1 if QES2301_79 >=0 & age79 >=22 & continuous==1

forvalues x = 80/94 {

   *tab1 emp1previd`x'

   gen mainisnew`x'=.    
   replace mainisnew`x'=0 if emp1previd`x' > 0 
   replace mainisnew`x'=1 if emp1previd`x'==-4 
   
   * Above coding combines those newly employed with those who have an employer change, could try conditioning on prev employment -- 
   * but cutting by tenure on prev job categories does this already, and 1997 def also not conditional on prev emp.
     
   }
   
* 1993 seems to have coding error in which -4 for emp1previd was coded as 0. Changing.

replace mainisnew93=1 if emp1previd93==0 & (esr_key93==1 | esr_key93==2)

forvalues x = 80/94 {

   replace jobsnum`x'=. if jobsnum`x' < 0

   local y = `x' - 1
   gen tmain`x' = tmain`y' if continuous==1 
   replace tmain`x' = mainisnew`x' + tmain`y' if continuous==1 & mainisnew`x'~=.


   gen tmain22_`x' = tmain22_`y' if continuous==1 
   replace tmain22_`x' = (mainisnew`x' + tmain22_`y') if continuous==1 & mainisnew`x'~=. & ((age79 + `x' - 79) > 22)
   replace tmain22_`x'=1 if QES2301_`x' >= 0 & continuous==1 & ((age79 + `x' - 79) == 22)
   
}

summ mainisnew* tmain*
summ jobsnum*
summ age79


* Defining self employed, and other non-standard emp, as well as possible. SE is 1 if a new job and class of worker is SE. SE is also 1 if job 1 not new but was job 1 last int and was SE then.
* Otherwise, missing them. Example, someone who was SE on job 2 last in, that moves up to job 1. 

gen selfemp79=.
replace selfemp79=1 if emp1class_79==3 | emp1class_79==4 

forvalues x = 80/93 {

   gen selfemp`x'=.   
   local y = `x' - 1
   replace selfemp`x'=1 if mainisnew`x'==1 & (emp1class_`x'==3 | emp1class_`x'==4) 
   replace selfemp`x'=1 if mainisnew`x'==0 & selfemp`y'==1 & emp1previd`x'==1
   
   }
   
gen selfemp94=.
replace selfemp94=1 if mainisnew94==1 & (emp1class_94==4 | emp1class_94==5) 
replace selfemp94=1 if mainisnew94==0 & selfemp93==1 & emp1previd94==1

summ selfemp*


* Indicator for voluntary, involuntary separation from last job 1 employer. 

gen whyleft01_79=.

forvalues x = 80/94 {

   gen whyleft01_`x'=.
   replace whyleft01_`x'=QES23A01_`x' if QES23A01_`x' > 0
   replace whyleft01_`x'=QES23A02_`x' if emp2previd`x'==1 & QES23A02_`x' > 0
   replace whyleft01_`x'=QES23A03_`x' if emp3previd`x'==1 & QES23A03_`x' > 0
   replace whyleft01_`x'=QES23A04_`x' if emp4previd`x'==1 & QES23A04_`x' > 0
   replace whyleft01_`x'=QES23A05_`x' if emp5previd`x'==1 & QES23A05_`x' > 0
}   
   
*** Recode reason for leaving into invol, vol, and missing - any reason with word quit in title is vol, others invol

foreach x of numlist 79/83 {
   gen invol`x'=.
   replace invol`x'=1 if whyleft01_`x'>=0 & whyleft01_`x'< 4
   replace invol`x'=0 if whyleft01_`x'>= 4 & whyleft01_`x' < 99
   }

foreach x of numlist 84/94 {
   gen invol`x'=.
   replace invol`x'=1 if whyleft01_`x'>=0 & whyleft01_`x'< 6
   replace invol`x'=0 if whyleft01_`x'>= 6 & whyleft01_`x' < 99
   }

tab1 invol*
summ invol* tenuremon*

forvalues x = 79/94 {
   tabulate mainisnew`x' invol`x'
}

sort caseid
save nlsy79_tenure_plus_whyleft.dta, replace

* Note: QES2301_ is "are you currently employed at job 1", QES23A01_ is "if not, why did you leave" - recoded into whyleft01_ above.   

keep tenuremon1* prevtenuremon1* hgcrev* QES2301_* QES2302_* esr_key* black hisp female age79 edgrp4* wkswk_pcy* job1iscps* invol* mainisnew* whyleft01_* emp1previd* caseid custwt inschool_* selfemp* prevempd1* tmain* jobsnum* continuous
reshape long tenuremon1_ prevtenuremon1_ hgcrev QES2301_ QES2302_ esr_key edgrp4_ wkswk_pcy job1iscps invol mainisnew whyleft01_ emp1previd inschool_ selfemp prevempd1_ tmain tmain22_ jobsnum, i(caseid) j(year)


summ

gen age = age79 + (year - 79)
gen age2 = age^2 

char edgrp4_[omit] 2
xi, prefix(_Y) i.year
xi, prefix(_E) i.edgrp4_

*gen lnrhw=ln(rcpshrp)


*** Create estimating samples - drop if in armed forces, currently enrolled in regular school, or currently self-employed in job1
*** Retaining those where job 1 is not CPS job. This was used in BPEA analysis as an indicator for whether job 1 was main job. Didn't want to code someone as job switcher just because main job switched order in job numbers.
*** Per emails with Steve McClaskie at CHRR, seems like most job 1s are main employer, current or past, in those years, so eliminating the job1iscps restriction.
*** Consistent with this, emp1previd above is greater than 1 for less than 1% of obs per year. So either employer 1 is new or was job 1 in previous survey round.  

*drop if job1iscps~=1
drop if esr_key==8
drop if inschool_==1
drop if selfemp==1

* bys year: tab1 whyleft01*
* bys job1iscps: tab1 esr_key whyleft01_
* bys year: tab1 job1iscps
* bys year: tab1 whyleft01_ if job1iscps==1

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

* Small numbers of obs in 10+ years cat
tab1 ptencat
bys year: tab1 ptencat

* Among those with obs on invol, what is share invol across prev tenure categories?
tabulate ptencat, summarize(invol)
tabulate ptencat if age >=22, summarize(invol)

gen empd=.
replace empd=1 if QES2301_==1
replace empd=0 if QES2301_==0 | QES2301_==-4
summ empd

gen empd2=.
replace empd2=1 if QES2302_==1
replace empd2=0 if QES2302_==0 | QES2302_==-4
summ empd2

* Drop multiple job holders
drop if empd2==1 & empd==1


bys year: tab1 ptencat whyleft01_

*** Age and ptencat restrictions. Age tops out at 31 in 1997, so match that. Drop those not employed at previous interview.

drop if age < 22 | age > 31
drop if ptencat==.
drop if prevempd1_ ~= 1


tab1 year ptencat
bys year: tab1 ptencat whyleft01_
bys year: tab1 invol mainisnew

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


* Universe of invol is everyone with a whyleft code for current or previous job 1. Check that some are not employed at current interview.
bys invol: summ empd


*** Mainisnew includes jobs new to main position, so can have (many) with mainisnew=1 but no invol code

* mainisnew=1 empd=1 and invol=. can happen if kept old main job as non-main employer
* mainisnew=0 empd=1 and invol~=. can happen if left and returned to previous main employer
* mainisnew=0 or =1 and empd=0 should have invol code for why left that employer

tab1 mainisnew
bys mainisnew: tab1 invol
bys mainisnew: tab1 invol if empd==1
bys mainisnew: tab1 invol if empd==0
tab1 whyleft01_ if mainisnew==0 & empd==1

** Some Rs are curr empd at main employer, main is not new, but have valid reason for sep code. Could be left and returned to orig main emp.
** whyleft01_ codes consistent with this: 1 = layoff, 3 = temp job ended (most years), 5 and 7 = quit to look for new job (many years).
** Could do more here but this seems reasonable.


* Dummies for shares of those previously employed who left vol, invol, temp job ended

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

bys year: summ tempend sepinvol sepvol conempemp jobsnum tmain tmain22_

tab1 ptencat     
bys ptencat: summ empd mainisnew invol
table ptencat [pw=custwt], contents(mean empd mean mainisnew mean invol mean continuedemp mean conempemp)
table ptencat [pw=custwt], contents(mean sepinvol mean sepvol mean tempend mean tmain)

table ptencat [pw=custwt], contents(mean tempend mean sepinvol mean sepvol mean conempemp mean tmain)
table ptencat [pw=custwt], contents(mean tempend mean sepinvol mean sepvol mean conempemp mean tmain22_)

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

keep if continuous==1
collapse (percent) continuous [pw=custwt], by(jobsnum)
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

* Assess quality of tmain, tmain22_ relative to CHRR constructed jobsnum

table ptencat [pw=custwt], contents(mean tmain mean tmain22_ mean jobsnum)
table age [pw=custwt], contents(mean tmain mean tmain22_ mean jobsnum)
corr tmain tmain22_ jobsnum
bys year: corr tmain tmain22_ jobsnum

*sort year
*univar year 

** Omit obs not in continuously
table ptencat if continuous==1 [pw=custwt], contents(mean tmain mean tmain22_ mean jobsnum)
table age if continuous==1 [pw=custwt], contents(mean tmain mean tmain22_ mean jobsnum)
corr tmain tmain22_ jobsnum if continuous==1 
bys year: corr tmain tmain22_ jobsnum if continuous==1 

** Drop recession years

preserve
drop if inlist(year, 80, 81, 82, 90, 91)

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


