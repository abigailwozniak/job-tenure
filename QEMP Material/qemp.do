* read in quality of employment data from the 1969-77 surveys

set trace off
set more 1 
capture log close
clear
clear matrix
set matsize 800
set linesize 200

log using qemp.log, replace


infile using qemp6970.dct, clear
gen year = 1969
save temp, replace
infile using qemp7273.dct, clear
gen year = 1972
append using temp
save temp, replace
infile using qemp77.dct, clear
gen year = 1977
append using temp
tab year
gen female = sex==5 if sex~=9 & sex~=. & year<=1969
replace female = sex==2 if year>=1972
replace age = . if age==99
replace yrborn = . if yrborn==0 | yrborn==98 | yrborn==99
replace age = 77-yrborn if yrborn~=97 & year==1977
replace age = 78 if yrborn==97 & year==1977
replace age = 77-yrbornb if yrbornb~=97 & year==1977 & age==.
replace age = 78 if yrbornb==97 & year==1977 & age==.
drop if selfemp==1
drop if age<22 | age>64
gen head = hhrel==1 if hhrel~=. & year==1969
replace head = hhrel==1 | hhrel==2 if year==1977 & hhrel~=.
replace educ = educb if year==1977 & (educ==. | educ==0)

replace educ = . if educ==99
gen eddum = 1 if educ>=0 & educ<=40 & year==1977
replace eddum = 2 if educ>=50 & educ<=70 & year==1977
replace eddum = 1 if educ>=0 & educ<=4 & year==1972
replace eddum = 2 if educ>=5 & educ<=7 & year==1972
replace eddum = 1 if educ>=0 & educ<=40 & year==1969
replace eddum = 2 if educ>=50 & educ<=70 & year==1969

tab year eddum

gen mfg = 1 if ind>=206 & ind<=459 & year==1969
replace mfg = 1 if ind>=107 & ind<=398 & year==1972
replace mfg = 1 if ind>=107 & ind<=398 & year==1977
replace mfg = 0 if mfg==. & ind~=.

gen agecat = 1 if age>=22 & age<=29
replace agecat = 2 if age>=30 & age<=39
replace agecat = 3 if age>=40 & age<=49
replace agecat = 4 if age>=50 & age<=64
tab agecat year, col

replace union = . if union==9
replace union = 0 if union==5

replace empten = 2 if empten==1
replace empten = . if empten==9 | empten==0
lab def empten 2 "less than = 1Q" 3 "1Q to 1Y" 4 "1.1 to 3 years" 5 "3.1 to 5 years" 6 "5.1 to 10 years" 7 "10.1 to 20 years" 8 "more than 20 years"
lab val empten empten
gen emptenb = empten
replace emptenb = 3 if emptenb==2
lab def emptenb 3 "less than = 1Y" 4 "1.1 to 3 years" 5 "3.1 to 5 years" 6 "5.1 to 10 years" 7 "10.1 to 20 years" 8 "more than 20 years"
lab val emptenb emptenb
tab empten year, col

quietly for var njlook njeasy jobsec jobsat: replace X = . if X==8 | X==9
gen njlookyes = njlook==1 | njlook==3 if njlook~=.
gen njlookvery = njlook==1 if njlook~=.
gen njeasyyes = ((njeasy==3 | njeasy==5) & (year==1972 | year==1977)) |  ((njeasy==1 | njeasy==3) & year==1969) if njeasy~=.
gen njveasyyes = (njeasy==5 & (year==1972 | year==1977)) |  (njeasy==1  & year==1969) if njeasy~=.
table year, c(m njlookyes m njlookvery m njeasyyes m njveasyyes) 
gen temp = jobsec if (year==1972 | year==1977)
replace jobsec = 1 if temp==4 & (year==1972 | year==1977)
replace jobsec = 2 if temp==3 & (year==1972 | year==1977)
replace jobsec = 3 if temp==2 & (year==1972 | year==1977)
replace jobsec = 4 if temp==1 & (year==1972 | year==1977)
drop temp
lab def jobsec 1 "very true" 2 "somewhat true" 3 "a little true" 4 "not at all true"
lab val jobsec jobsec
tab jobsec year, col
gen jobsecb = 1 if jobsec<=2
replace jobsecb = 0 if jobsec==3 | jobsec==4

* job security is good (column 1)
tab jobsecb
tab emptenb jobsecb, row
tab jobsecb if female==0 & agecat==4

* how easy to find new job (column 3)
tab njeasyyes
tab emptenb njeasyyes, row
tab njeasyyes if female==0 & agecat==4

* how satisfied with own job (column 5)
gen temp = jobsat if (year==1972 | year==1977)
replace jobsat = 1 if temp==4 & (year==1972 | year==1977)
replace jobsat = 2 if temp==3 & (year==1972 | year==1977)
replace jobsat = 3 if temp==2 & (year==1972 | year==1977)
replace jobsat = 4 if temp==1 & (year==1972 | year==1977)
drop temp
gen jobsatb = 1 if jobsat==1 | jobsat==2
replace jobsatb = 0 if jobsat==3 | jobsat==4
tab jobsatb
tab emptenb jobsatb, row
tab jobsatb if female==0 & agecat==4

* search for new job (column 7)
tab njlookyes
tab emptenb njlookyes, row
tab njlookyes if female==0 & agecat==4


quietly log close




