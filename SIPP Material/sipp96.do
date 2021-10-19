* read in SIPP 1996 data

set trace off
set more 1 
capture log close
clear
clear matrix
set linesize 200
set maxvar 30000

log using sipp96.log, replace
    
clear
gen tmp = .
save ~/scratch3/tempsipp2, replace

quietly foreach N of num 1/12 {
   quietly infile using sipp/sip96l`N', clear
   append using ~/scratch3/tempsipp2
   save ~/scratch3/tempsipp2, replace
}

quietly foreach N of num 1/9 {
   quietly infile using sipp/sip01w`N', clear using(~/data_house/sipp/l01puw`N'.dat)
   append using ~/scratch3/tempsipp2
   save ~/scratch3/tempsipp2, replace
}
quietly for var grgc: tostring X, replace
quietly for var eentaid epppnum lgtkey: destring X , replace

* For 2004, I downloaded SAS data files and converted them into Stata using StatTransfer.  
* That gave me .dta files, so then I just needed to append them to the main file.  

quietly for num 1/12: append using ~/data_house/sipp/l04puwX
save ~/scratch3/tempsipp2, replace

quietly foreach N of num 1/16 {
   quietly infile using sipp/sippl08puw`N', clear using(~/data_house/sipp/l08puw`N'.dat)
   append using ~/scratch3/tempsipp2
   save ~/scratch3/tempsipp2, replace
}

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

replace tsjdate1 = . if tsjdate1==-1
replace tsjdate2 = . if tsjdate2==-1
gen long tsjdate1r = tsjdate1
gen long tsjdate2r = tsjdate2
sort spanel ssuid pnum swave srefmon
quietly by spanel ssuid pnum: replace tsjdate1r = tsjdate1r[_n-1] if eeno1==eeno1[_n-1] & eeno1~=-1 & tsjdate1~=. & tsjdate1[_n-1]~=.
quietly by spanel ssuid pnum: replace tsjdate2r = tsjdate2r[_n-1] if eeno2==eeno2[_n-1] & eeno2~=-1 & tsjdate2~=. & tsjdate2[_n-1]~=.


keep if srefmon==1
tab month year
tab swave spanel


keep if age>=18 & age<=64



gen emp = esr==1 | esr==2 | esr==3 | esr==4 | esr==5 if esr>=1 & esr<=8
gen unemp = esr==5 | esr==6 | esr==7 if esr>=1 & esr<=8
gen nlf = esr==8 if esr>=1 & esr<=8

gen volsep1 = (ersend1>=2 & ersend1<=7) | ersend1==12  | ersend1==14 | ersend1==15
gen involsep1 = ersend1==1 | ersend1==8 | ersend1==9 | ersend1==10 | ersend1==11 | ersend1==13 
gen nosep1 = estlemp1==1
tab volsep1 if emp==1
tab involsep1 if emp==1
tab nosep1 if emp==1
gen volsep2 = (ersend2>=2 & ersend2<=7) | ersend2==12  | ersend2==14 | ersend2==15
gen involsep2 = ersend2==1 | ersend2==8 | ersend2==9 | ersend2==10 | ersend2==11 | ersend2==13 
gen nosep2 = estlemp2==1

gen sepdum1 = 0 if nosep1==1
replace sepdum1 = 1 if volsep1==1
replace sepdum1 = 2 if involsep1==1

gen agedum = 1 if age>=18 & age<=21
replace agedum = 2 if age>=22 & age<=29
replace agedum = 3 if age>=30 & age<=39
replace agedum = 4 if age>=40 & age<=49
replace agedum = 5 if age>=50 & age<=64

tab agedum sepdum1 if emp==1, row


gen weight = round(fnlwgt,1)
tab month year
table year if emp==1 & njobs>=1 [w=weight], c(m nosep1 m volsep1 m involsep1)
table year if njobs>=1 [w=weight], c(m nosep1 m volsep1 m involsep1)
table year if emp==1 & njobs>=1 & enrold==3 & emptype1~=6 [w=weight], c(m nosep1 m volsep1 m involsep1)
sum ejbhrs1 if emp==1 & njobs>=1 & enrold==3 & emptype1>=1 & emptype1<=5, det
rename ejbhrs1 hrswk1
rename ejbhrs2 hrswk2

gen startyr = int(tsjdate1r/10000)
gen startmn = int(tsjdate1r/100) - startyr*100
gen time = year+month/12-1/24
gen starttime = startyr+startmn/12-1/24
gen tenyr = time - starttime

l swave year month eeno1 esr emp tenyr tsjdate1  tsjdate1r njobs estlemp1 tejdate1 if spanel==2004 & ssuid=="613133000828"  & pnum==102, nod noobs
sum tenyr if emp==1, det
replace tenyr = . if tenyr<0


* !rm ~/scratch3/tempsipp2.dta
quietly compress
save ~/scratch3/sipp9608, replace

quietly log close

