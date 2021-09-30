set trace off
set more 1 
capture log close
clear
clear matrix
set linesize 200
set maxvar 30000

log using sipp96nosep8.log, replace
    
use ~/scratch3/sipp9608, clear

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

keep if sex==1
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

collapse (mean) nosep  [pw=fnlwgt], by(year month tencat)
gen time = year+month/12 - 1/24



quietly for var nosep : gen Xa = X if time>=1995+11/12 & time<2000.13
quietly for var nosep : gen Xb = X if time>=2000.7 & time<2008
quietly for var nosep : gen Xc = X if time>=2008 & time<2014

reshape wide nosep* , i(year month) j(tencat)


sort year month
quietly for var nosepa1 nosepb1 nosepc1 nosepa2 nosepb2 nosepc2 nosepa3 nosepb3 nosepc3 nosepa4 nosepb4 nosepc4 nosepa5 nosepb5 nosepc5 nosepa6 nosepb6 nosepc6 nosepa7 nosepb7 nosepc7 nosepa8 nosepb8 nosepc8 : gen Xma = 1/12*(X+X[_n-1]+X[_n-2]+X[_n-3]+X[_n-4]+X[_n-5]+X[_n-6]+X[_n-7]+X[_n-8]+X[_n-9]+X[_n-10]+X[_n-11]) if time<=2013.4
keep year month nosepa8ma nosepb8ma nosepc8ma
save sipp96nosep8, replace

quietly log close

