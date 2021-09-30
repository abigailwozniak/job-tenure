* Aggregate means and medians for figure 1 from SIPP

set trace off
set more 1 
capture log close
clear
clear matrix
set matsize 800
set linesize 200

log using fig1sipp.log, replace

use ~/scratch3/sipp9608, clear
rename spanel panel

replace higrade = . if higrade==-1
gen lowed = higrade>=31 & higrade<=39
gen highed = higrade>=40 & higrade<=47

keep if emp==1
* drop z-types
drop if eoutcome==207
* drop other people in the 1996-onward panels with mostly imputed work info
drop if eppflag==1
drop if apdjbthn==1 | apdjbthn==4
drop if njobs<0 
keep if emptype1>=1 & emptype1<=5
keep if enrold==3
keep if age>=22 & age<=64

gen startyr2 = int(tsjdate2r/10000)
gen startmn2 = int(tsjdate2r/100) - startyr2*100
gen starttime2 = startyr2+startmn2/12-1/24
gen tenyr2 = time - starttime2
sum tenyr2, det
replace tenyr2 = . if tenyr2<0

rename tenyr tenyr1
reshape long eeno tenyr, i(panel ssuid pnum swave year month) j(job)
drop if eeno==-1
* a handful of people report the same employer number for job 1 and job 2
egen test = count(year), by(panel ssuid pnum swave eeno)
drop if test==2
drop test
tab year month
drop if year==1995
gen tenlt1q = tenyr<.25 if tenyr~=.
gen ten1q = tenyr<=.25 if tenyr~=.
gen ten1q1y = tenyr>.25 & tenyr<=1 if tenyr~=.
gen tenlt1y = tenyr<1 if tenyr~=.
gen ten1y = tenyr<=1 if tenyr~=.
gen ten13 = tenyr>=1 & tenyr<3 if tenyr~=.
collapse (mean) mtensipp = tenyr tenlt1q ten1q ten1q1y ten1y tenlt1y ten13 (median) medtensipp = tenyr  [pw=fnlwgt], by(year)

l year mtensipp medtensipp , nod noobs

append using fig1sipp8689
sort year

l year mtensipp medtensipp , nod noobs

save fig1sipp, replace

quietly log close

