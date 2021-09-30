* calculate fraction of "new hires" in the SIPP

set trace off
set more 1 
capture log close
clear
clear matrix
set linesize 200
set maxvar 30000

log using sipp96hires.log, replace

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

sum tenyr1 tenyr2 if srefmon==4, det
quietly for var tenyr1 tenyr2: replace X = . if X<0 & srefmon==4

gen newhire1 = tenyr1<=.25 if tenyr1~=. & emp==1 & srefmon==4
gen newhire2 = tenyr2<=.25 if tenyr2~=. & emp==1 & srefmon==4
gen newhire = newhire1==1 | newhire2==1 if emp==1 & srefmon==4 & (tenyr1~=. | tenyr2~=.)
gen nonemp = nlf==1 | unemp==1 if srefmon==4 & nlf~=.

sort spanel ssuid pnum swave srefmon
quietly by spanel ssuid pnum: gen emp3 = emp[_n-3] if srefmon==4 & time-time[_n-3]>=.22 & time-time[_n-3]<=.27
quietly by spanel ssuid pnum: gen nonemp3 = (nlf[_n-3]==1 | unemp[_n-3]==1) if srefmon==4 & time-time[_n-3]>=.22 & time-time[_n-3]<=.27 & nlf[_n-3]~=.

tab emp3 nonemp3 if newhire==1
tab emp3 nonemp3 if nonemp==1
gen neestock = nonemp
gen neestock3 = nonemp3
gen en = emp3*nonemp
gen nn = nonemp3*nonemp
gen ne = 1 if nonemp3==1 & emp==1 & srefmon==4
replace ne = 0 if nonemp3==1 & nonemp==1 & srefmon==4
quietly for var emp3 nonemp3: replace X = . if newhire==.
gen ee = emp3*newhire
gen nee = nonemp3*newhire


sum ee nee newhire

collapse (mean) ee nee newhire neestock en nn ne (sum) ensum=en nesum=ne nstock3=neestock3 nstock=neestock [pw=fnlwgt], by(year month)
quietly for var ensum nesum nstock3 nstock: replace X = . if X==0
quietly for var ensum nesum nstock3: gen Xs = X/nstock
gen time = year+month/12 - 1/24
quietly for var newhire ee nee neestock en nn ne ensums nesums nstock3s: gen Xa = X if time>=1995+11/12 & time<2000.13
quietly for var newhire ee nee neestock en nn ne ensums nesums nstock3s: gen Xb = X if time>=2000.8 & time<2008
quietly for var newhire ee nee neestock en nn ne ensums nesums nstock3s: gen Xc = X if time>=2008 & time<2014
quietly for var newhirea newhireb newhirec eea eeb eec neea neeb neec neestocka neestockb neestockc ena enb enc nna nnb nnc nea neb nec ensumsa ensumsb ensumsc nesumsa nesumsb nesumsc nstock3sa nstock3sb nstock3sc: gen Xma = 1/12*(X+X[_n-1]+X[_n-2]+X[_n-3]+X[_n-4]+X[_n-5]+X[_n-6]+X[_n-7]+X[_n-8]+X[_n-9]+X[_n-10]+X[_n-11])  if time<=2013.4
sort year month
graph twoway line newhireama newhirebma newhirecma eeama eebma eecma neeama neebma neecma time,  legend(row(1) order(1 4 7) lab(1 "New Hires") lab(4 "Job-to-Job") lab(7 "Entrants") ) ylab(0(.02).1,nogrid) xlab(1996(2)2014) lc(black black black red red red blue blue blue ) lp(solid solid solid solid solid solid solid solid solid solid solid solid) saving(hires, replace) graphregion(color(white))

keep year month time newhireama newhirebma newhirecma eeama eebma eecma neeama neebma neecma 
save sipp96hires, replace

quietly log close

