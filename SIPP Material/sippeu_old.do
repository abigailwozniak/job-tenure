* calculate transitions from employment to unemployment/nlf for old men in the SIPP
set trace off
set more 1 
capture log close
clear
clear matrix
set linesize 200
set maxvar 30000

log using sippeu_old.log, replace
    
* 1996-2008 panels
use ~/scratch3/tempsipp2, clear


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
keep ssuseq ssuid spanel swave srotaton srefmon month year state hwgt fnlwgt esr estlemp* ersend* age sex race ethncty higrade eafnow tjbocc* ejbind* pnum rrp worked njobs epopstat eeno1 eeno2 enrold emptype* arsend1 arsend2 astlemp1 astlemp2 ejbhrs1 ejbhrs2 tsjdate1 tsjdate2 tejdate1 tejdate2 eoutcome eppflag apdjbthn
keep if age>=22 & age<=64


gen emp = esr==1 | esr==2 | esr==3 | esr==4 | esr==5 if esr>=1 & esr<=8
gen unemp = esr==5 | esr==6 | esr==7 if esr>=1 & esr<=8
gen nlf = esr==8 if esr>=1 & esr<=8



sort spanel ssuid pnum year month
quietly by spanel ssuid pnum: gen eu = emp==1 & unemp[_n+1]==1 if unemp[_n+1]~=. & emp~=.
quietly by spanel ssuid pnum: gen en = emp==1 & nlf[_n+1]==1 if nlf[_n+1]~=. & emp~=.


replace fnlwgt = fnlwgt/1000
drop if eoutcome==207
drop if eppflag==1
drop if apdjbthn==1 | apdjbthn==4
drop if njobs<=0 
keep if emp==1 & emptype1>=1 & emptype1<=5
keep if enrold==3


keep if eu~=. | en~=.
save ~/scratch3/temp, replace

* 1986-89 panels
use ~/scratch3/tempsipp80, clear
rename sc1656 enrold
rename ws1_2012 emptype1
rename sc1714 selfemp
keep su_id su_rot fnlwgt* esr_* age* sex race ethnicty enrold in_af selfemp h*_month h*_year wave pp_pnum panel emptype* pp_intvw
egen test = count(h1_month), by(panel su_id pp_pnum wave)
tab test
drop if test>=2
drop test
quietly for num 1/4: rename hX_month month_X \ rename hX_year year_X
quietly for num 1/4: replace fnlwgt_X = fnlwgtX if panel==1989
drop fnlwgt_5 fnlwgt1 fnlwgt2 fnlwgt3 fnlwgt4 fnlwgt5 age_5
reshape long esr_ month_ year_ fnlwgt_ age_, i(panel su_id pp_pnum wave) j(mis)
rename esr_ esr
rename month_ month
rename year_ year
rename age_ age
rename fnlwgt_ fnlwgt
rename pp_intvw intvw
rename su_id suid 
rename pp_pnum pnum
save ~/scratch3/temp2, replace

* 1990-93 panels
use ~/scratch3/tempsipp, clear
rename ws12012 emptype1
rename empled selfemp
keep  suid entry rot panel wave refmth month year fnlwgt esr age sex race ethncty higrade inaf pnum njob selfemp enrold emptype*  intvw 
append using ~/scratch3/temp2

replace year = year+1900
keep if enrold==3
drop if selfemp==2
drop if intvw==5 | intvw==4 | intvw==3
replace fnlwgt = fnlwgt/1000 
egen test = count(esr), by(panel suid pnum year month)
tab test
drop if test>=2 & test~=.
gen emp = esr==1 | esr==2 | esr==3 | esr==4 | esr==5 if esr>=1 & esr<=8
gen unemp = esr==5 | esr==6 | esr==7 if esr>=1 & esr<=8
gen nlf = esr==8 if esr>=1 & esr<=8
sort panel suid pnum year month
quietly by panel suid pnum: gen eu = emp==1 & unemp[_n+1]==1 if unemp[_n+1]~=. & emp~=. & ((month[_n+1]-month==1) | (month==12 & month[_n+1]==1))
quietly by panel suid pnum: gen en = emp==1 & nlf[_n+1]==1 if nlf[_n+1]~=. & emp~=. & ((month[_n+1]-month==1) | (month==12 & month[_n+1]==1))
keep if emp==1 & emptype1>=1 & emptype1<=6
keep if eu~=. | en~=.

append using ~/scratch3/temp
keep if sex==1
keep if age>=50 & age<=64

replace panel = spanel if spanel>=1996 & spanel~=.
table panel, c(m age)
table panel, c(m eu)
table panel, c(m en)

collapse (mean) en eu [pw=fnlwgt], by(year month)
sum en eu, det

gen time = year+month/12 - 1/24
quietly for var en eu: gen Xa = X if time<1989+5/12
quietly for var en eu: gen Xb = X if time>1989+9/12 & time<1995+9/12
quietly for var en eu: gen Xc = X if time>1995+11/12 & time<2000.13
quietly for var en eu: gen Xd = X if time>2000.8 & time<2008
quietly for var en eu: gen Xe = X if time>=2008 & time<2014


sort year month
quietly for var eua eub euc eud eue ena enb enc end ene: gen Xma = 1/12*(X+X[_n-1]+X[_n-2]+X[_n-3]+X[_n-4]+X[_n-5]+X[_n-6]+X[_n-7]+X[_n-8]+X[_n-9]+X[_n-10]+X[_n-11])

sort time
outfile year month euama eubma eucma eudma euema using sippeu_old.csv, comma wide replace

keep year month euama eubma eucma eudma euema enama enbma encma endma enema
save sippeu_old, replace

quietly log close

