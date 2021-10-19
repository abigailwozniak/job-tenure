set trace off
set more 1 
capture log close
clear
clear matrix
set linesize 200
set maxvar 30000

log using afig5.log, replace
    
use ~\Downloads\raven_replicationcode\sipp9608, clear

replace higrade = . if higrade==-1
gen lowed = higrade>=31 & higrade<=39
gen highed = higrade>=40 & higrade<=47

keep if emp==1
* drop z-types
drop if eoutcome==207
* drop other people in the 1996-onward panels with mostly imputed work info
drop if eppflag==1
drop if apdjbthn==1 | apdjbthn==4
drop if njobs<=0 
keep if emptype1>=1 & emptype1<=5
keep if enrold==3

gen tempsep1 = ersend1==1 
gen permsep1 = ersend1>=2 & ersend1<=15
gen tempsep2 = ersend2==1 
gen permsep2 = ersend2>=2 & ersend2<=15 

rename spanel panel
sort panel ssuid pnum year month
quietly by panel ssuid pnum: gen test = 1 if ((volsep1==1 & volsep1[_n-1]==1) | (involsep1==1 & involsep1[_n-1]==1)) & tsjdate1r==tsjdate1r[_n-1] & panel>=1996
tab year if test==1
quietly for var nosep1 volsep1 involsep1: replace X = . if test==1
quietly by panel ssuid pnum: gen test2 = 1 if ((volsep2==1 & volsep2[_n-1]==1) | (involsep2==1 & involsep2[_n-1]==1)) & tsjdate2r==tsjdate2r[_n-1] & panel>=1996
tab year if test2==1
quietly for var nosep2 volsep2 involsep2: replace X = . if test2==1
drop test*
gen jendyr1 = int(tejdate1/10000) if tejdate1~=-1
gen jendmo1 = int(tejdate1/100) - jendyr1*100 if tejdate1~=-1
gen jendyr2 = int(tejdate2/10000) if tejdate2~=-1
gen jendmo2 = int(tejdate2/100) - jendyr2*100 if tejdate2~=-1
quietly for var nosep1 volsep1 involsep1: replace X = . if ((year==jendyr1 & month+4==jendmo1) | (year+1==jendyr1 & month==9 & jendmo1==1) | (year+1==jendyr1 & month==10 & jendmo1==2) | (year+1==jendyr1 & month==11 & jendmo1==3) | (year+1==jendyr1 & month==12 & jendmo1==4))
quietly for var nosep2 volsep2 involsep2: replace X = . if ((year==jendyr2 & month+4==jendmo2) | (year+1==jendyr2 & month==9 & jendmo1==2) | (year+1==jendyr2 & month==10 & jendmo2==2) | (year+1==jendyr2 & month==11 & jendmo2==3) | (year+1==jendyr2 & month==12 & jendmo2==4))

gen startyr2 = int(tsjdate2r/10000)
gen startmn2 = int(tsjdate2r/100) - startyr2*100
gen starttime2 = startyr2+startmn2/12-1/24
gen tenyr2 = time - starttime2
sum tenyr2, det
replace tenyr2 = . if tenyr2<0
sum tenyr tenyr2, det

tab sex
rename tenyr tenyr1
reshape long nosep volsep involsep emptype eeno tenyr ersend tempsep permsep ejbind, i(panel ssuid pnum swave year month) j(job)
drop if nosep==.
drop if eeno==-1
* a handful of people report the same employer number for job 1 and job 2
egen test = count(year), by(panel ssuid pnum swave eeno)
drop if test==2
drop test

gen tencat = 1 if tenyr<.25 & tenyr~=.
replace tencat = 2 if tenyr>=.25 & tenyr<1
replace tencat = 3 if tenyr>=1 & tenyr<2
replace tencat = 4 if tenyr>=2 & tenyr<5
replace tencat = 5 if tenyr>=5 & tenyr<10
replace tencat = 6 if tenyr>=10 & tenyr<15
replace tencat = 7 if tenyr>=15 & tenyr<20
replace tencat = 8 if tenyr>=20 & tenyr~=.

lab def tencat 1 "<1Q" 2 "1Q<=T<1Y" 3 "1Y<=T<2Y" 4 "2Y<=T<5Y" 5 "5Y<=T<10Y"
lab val tencat tencat
drop if tencat==.
keep if age>=22 & age<=64 
tab tencat


collapse (mean) volsep involsep [pw=fnlwgt], by(year month tencat)
gen time = year+month/12 - 1/24



quietly for var volsep involsep : gen Xa = X if time>=1995+11/12 & time<2000.13
quietly for var volsep involsep : gen Xb = X if time>=2000.7 & time<2008
quietly for var volsep involsep : gen Xc = X if time>=2008 & time<2014

reshape wide volsep* involsep* , i(year month) j(tencat)


sort year month
quietly for var volsepa1 volsepb1 volsepc1 volsepa2 volsepb2 volsepc2 volsepa3 volsepb3 volsepc3 volsepa4 volsepb4 volsepc4 volsepa5 volsepb5 volsepc5 volsepa6 volsepb6 volsepc6 volsepa7 volsepb7 volsepc7 volsepa8 volsepb8 volsepc8  : gen Xma = 1/12*(X+X[_n-1]+X[_n-2]+X[_n-3]+X[_n-4]+X[_n-5]+X[_n-6]+X[_n-7]+X[_n-8]+X[_n-9]+X[_n-10]+X[_n-11])  if time<=2013.4
quietly for var involsepa1 involsepb1 involsepc1 involsepa2 involsepb2 involsepc2 involsepa3 involsepb3 involsepc3 involsepa4 involsepb4 involsepc4 involsepa5 involsepb5 involsepc5 involsepa6 involsepb6 involsepc6 involsepa7 involsepb7 involsepc7 involsepa8 involsepb8 involsepc8  : gen Xma = 1/12*(X+X[_n-1]+X[_n-2]+X[_n-3]+X[_n-4]+X[_n-5]+X[_n-6]+X[_n-7]+X[_n-8]+X[_n-9]+X[_n-10]+X[_n-11])  if time<=2013.4

lab var time " "

save ~\Downloads\raven_replicationcode\figappend5.dta, replace

graph twoway line volsepa1ma volsepb1ma volsepc1ma volsepa2ma volsepb2ma volsepc2ma volsepa3ma volsepb3ma volsepc3ma volsepa4ma volsepb4ma volsepc4ma time, t1title("Voluntary Separaration") legend(row(2) order(1 4 7 10) lab(1 "<1 quarter") lab(4 "1Q to 1 year") lab(7 "1 year to 2 years") lab(10 "2 year to 5 years")) ylab(,nogrid) xlab(1996(2)2014) lc(black black black red red red blue blue blue green green green) lp(solid solid solid solid solid solid solid solid solid solid solid solid) saving(afig5b, replace) graphregion(color(white))
graph twoway line involsepa1ma involsepb1ma involsepc1ma involsepa2ma involsepb2ma involsepc2ma involsepa3ma involsepb3ma involsepc3ma involsepa4ma involsepb4ma involsepc4ma time, t1title("Involuntary Separaration") legend(row(2) order(1 4 7 10) lab(1 "<1 quarter") lab(4 "1 quarter to 1 year") lab(7 "1 year to 2 years") lab(10 "2 years to 5 years")) ylab(,nogrid) xlab(1996(2)2014) lc(black black black red red red blue blue blue green green green) lp(solid solid solid solid solid solid solid solid solid solid solid solid) saving(afig5a, replace) graphregion(color(white))

quietly log close

