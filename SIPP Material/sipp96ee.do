* look at E-E flows by tenure in the 1996 SIPP

set trace off
set more 1 
capture log close
clear
clear matrix
set linesize 200
set maxvar 30000

log using sipp96ee.log, replace

use ~/scratch3/tempsipp2, clear




quietly for var shhadid ghlfsam gvarstr: tostring X, replace


rename tfipsst state
rename rhcalmn month
rename rhcalyr year
rename whfnwgt hwgt
rename wpfinwgt fnlwgt
rename rmesr esr
rename tage age
rename esex sex
rename erace race
rename eorigin ethncty
rename eeducate higrade
rename epppnum pnum
rename errp rrp
rename epdjbthn worked
rename ejobcntr njobs
rename renroll enrold
rename eclwrk1 emptype1
rename eclwrk2 emptype2

* eafnow = in armed forces

keep ssuseq ssuid spanel swave srotaton srefmon month year state hwgt fnlwgt esr estlemp* ersend* age sex race ethncty higrade eafnow tjbocc* ejbind* pnum rrp worked njobs epopstat eeno1 eeno2 enrold emptype* arsend1 arsend2 astlemp1 astlemp2 ejbhrs1 ejbhrs2 tsjdate1 tsjdate2 tejdate1 tejdate2 eoutcome eppflag apdjbthn
egen test = count(month), by(spanel ssuid pnum swave srefmon)
tab test
drop if test>=2
drop test
tab srefmon
replace fnlwgt = fnlwgt/10000 if spanel==2004

replace tsjdate1 = . if tsjdate1==-1
replace tsjdate2 = . if tsjdate2==-1
gen long tsjdate1r = tsjdate1
gen long tsjdate2r = tsjdate2
sort spanel ssuid pnum swave srefmon
quietly by spanel ssuid pnum: replace tsjdate1r = tsjdate1r[_n-1] if eeno1==eeno1[_n-1] & eeno1~=-1 & tsjdate1~=. & tsjdate1[_n-1]~=.
quietly by spanel ssuid pnum: replace tsjdate2r = tsjdate2r[_n-1] if eeno2==eeno2[_n-1] & eeno2~=-1 & tsjdate2~=. & tsjdate2[_n-1]~=.

keep if age>=22 & age<=64

gen emp = esr==1 | esr==2 | esr==3 | esr==4 if esr>=1 & esr<=8
gen unemp = esr==5 | esr==6 | esr==7 if esr>=1 & esr<=8
gen nlf = esr==8 if esr>=1 & esr<=8

gen startyr = int(tsjdate1r/10000)
gen startmn = int(tsjdate1r/100) - startyr*100
gen time = year+month/12-1/24
gen starttime = startyr+startmn/12-1/24
gen tenyr1 = time - starttime
gen startyr2 = int(tsjdate2r/10000)
gen startmn2 = int(tsjdate2r/100) - startyr2*100
gen starttime2 = startyr2+startmn2/12-1/24
gen tenyr2 = time - starttime2

* drop z-types
drop if eoutcome==207
* drop other people in the 1996-onward panels with mostly imputed work info
drop if eppflag==1
drop if apdjbthn==1 | apdjbthn==4
keep if enrold==3

sum tenyr1 tenyr2 if srefmon==1, det


sort spanel ssuid pnum swave srefmon
quietly by spanel ssuid pnum: gen emp3 = emp[_n+3] if srefmon==1 & time[_n+3]-time>=.22 & time[_n+3]-time<=.27
quietly by spanel ssuid pnum: gen estlemp13 = estlemp1[_n+3] if srefmon==1 & time[_n+3]-time>=.22 & time[_n+3]-time<=.27
quietly by spanel ssuid pnum: gen estlemp23 = estlemp2[_n+3] if srefmon==1 & time[_n+3]-time>=.22 & time[_n+3]-time<=.27

gen ee1 = estlemp13==2 & emp3==1 if srefmon==1 & emp==1 & estlemp13>=1 & estlemp13~=.
gen ee2 = estlemp23==2 & emp3==1 if srefmon==1 & emp==1 & estlemp23>=1 & estlemp23~=.

keep if srefmon==1

keep ee* tenyr* year month spanel ssuid pnum swave fnlwgt
reshape long ee tenyr eeno, i(spanel ssuid pnum swave) j(jobnum)
/*
gen tenyrdum = 1 if tenyr<.25
replace tenyrdum = 2 if tenyr>=.25 & tenyr<1
replace tenyrdum = 3 if tenyr>=1 & tenyr<3
replace tenyrdum = 4 if tenyr>=3 & tenyr<5
replace tenyrdum = 5 if tenyr>=5 & tenyr<10
replace tenyrdum = 6 if tenyr>=10 & tenyr~=.
*replace tenyrdum = 7 if tenyr>=15 & tenyr<20
*replace tenyrdum = 8  if tenyr>=20 & tenyr~=.
*/

gen tenyrdum = 1 if tenyr<1
replace tenyrdum = 2 if tenyr>=1 & tenyr<3
replace tenyrdum = 3 if tenyr>=3 & tenyr<5
replace tenyrdum = 4 if tenyr>=5 & tenyr<10
replace tenyrdum = 5 if tenyr>=10 & tenyr~=.

tab tenyrdum
tab tenyrdum ee, row


drop if tenyrdum==.
gen ones = 1 if ee~=.
collapse (mean) ee (sum) eesum=ee stock=ones [pw=fnlwgt], by(year month tenyrdum)
gen time = year+month/12 - 1/24
reshape wide ee eesum stock, i(year month) j(tenyrdum)


gen tp = 1 if time<2000.13
replace tp = 2 if time>=2008
drop if tp==.
collapse (mean) eesum1 eesum2 eesum3 eesum4 eesum5 stock1 stock2 stock3 stock4 stock5 , by(tp)

gen totemp = stock1+stock2+stock3+stock4+stock5
quietly for num 1/5: gen shareX = stockX/totemp
quietly for num 1/5: gen rateX = eesumX/stockX

sort tp
quietly for var share* rate*: gen Xl = X[_n-1]

quietly for num 1/5: gen eehatXa = shareX*rateXl \ gen eehatXb = shareXl*rateX \ gen eehatXc = shareX*rateX

gen eehata = eehat1a+eehat2a+eehat3a+eehat4a+eehat5a
gen eehatb = eehat1b+eehat2b+eehat3b+eehat4b+eehat5b
gen eehatc = eehat1c+eehat2c+eehat3c+eehat4c+eehat5c
* average job-to-job transition rate
gen eerate = (eesum1+eesum2+eesum3+eesum4+eesum5)/(stock1+stock2+stock3+stock4+stock5)
l tp eerate, nod noobs
l tp eehat1c eehat2c eehat3c eehat4c eehat5c if tp==1, nod noobs

* changes in employment share by tenure (contribution in Table is the difference between the number reported below and the actual eerate in the first period reported above)
l eehata if tp==2, nod noobs
* changes in separation rates by tenure (contributions in Table are the difference between the numbers reported below and the actual contributions from the eerates reported above)
l eehatb if tp==2
l eehat1b eehat2b eehat3b eehat4b eehat5b if tp==2, nod noobs


quietly log close

