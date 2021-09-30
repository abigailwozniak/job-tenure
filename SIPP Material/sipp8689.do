* read in SIPP data 1986 to 1989 panels

set trace off
set more 1 
capture log close
clear
clear matrix
set linesize 200
set maxvar 30000

log using sipp8689.log, replace
    
quietly infile using sipp/sip86w1, clear
gen wave = 1
gen panel = 1986
save ~/scratch3/tempsipp80, replace

quietly foreach N of num 2/7 {
   quietly infile using sipp/sip86rt`N', clear
   gen wave = `N'
   gen panel = 1986
   append using ~/scratch3/tempsipp80
   save ~/scratch3/tempsipp80, replace
}

quietly infile using sipp/sip87w1, clear
gen wave = 1
gen panel = 1987
append using ~/scratch3/tempsipp80
save ~/scratch3/tempsipp80, replace
quietly foreach N of num 2/7 {
   quietly infile using sipp/sip87rt`N', clear
   gen wave = `N'
   gen panel = 1987
   append using ~/scratch3/tempsipp80
   save ~/scratch3/tempsipp80, replace
}

quietly infile using sipp/sip88w1, clear
gen wave = 1
gen panel = 1988
append using ~/scratch3/tempsipp80
save ~/scratch3/tempsipp80, replace
quietly foreach N of num 2/6 {
   quietly infile using sipp/sip88rt`N', clear
   gen wave = `N'
   gen panel = 1988
   append using ~/scratch3/tempsipp80
   save ~/scratch3/tempsipp80, replace
}

quietly foreach N of num 1/2 {
   quietly infile using sipp/sip89w`N', clear
   gen wave = `N'
   gen panel = 1989
   append using ~/scratch3/tempsipp80
   save ~/scratch3/tempsipp80, replace
}
quietly infile using sipp/sip89rt3, clear
gen wave = 3
gen panel = 1989
append using ~/scratch3/tempsipp80
save ~/scratch3/tempsipp80, replace


rename sc1000 worked
rename sc1656 enrold
rename ws1_2002 empid1
rename ws1_2012 emptype1
rename ws1_2014 employed1
rename ws1_2023 leftemp1
rename ws1_2024 reasleft1
rename ws1_2025 hrswk1
rename ws2_2102 empid2
rename ws2_2112 emptype2
rename ws2_2114 employed2
rename ws2_2123 leftemp2
rename ws2_2124 reasleft2
rename ws2_2125 hrswk2
rename sc1714 selfemp


replace emptype2 = ws2_2012 if panel<=1987 & wave==1

* apparently only asked in wave 2
rename tm8218 mstartemp1
rename tm8220 ystartemp1

rename tm8268 mstartemp2
rename tm8270 ystartemp2

* in_af = in armed forces

keep suseqnum su_id su_rot state h1_wgt fnlwgt* h1_state u1ccwave esr_* leftemp* reasleft* age* sex race ethnicty enrold higrade grd_cmpl in_af ws1_occ ws1_ind ws2_occ ws2_ind selfemp mstartemp* ystartemp* h1_month h1_year wave pp_pnum rrp* panel worked emptype* employed* pp_intvw hrswk*
egen test = count(h1_month), by(panel su_id pp_pnum wave)
tab test
drop if test>=2
drop test
tab h1_month h1_year
tab wave panel

keep if age_1>=18 & age_1<=64

gen emp = esr_1==1 | esr_1==2 | esr_1==3 | esr_1==4 | esr_1==5 if esr_1>=1 & esr_1<=8
gen unemp = esr_1==5 | esr_1==6 | esr_1==7 if esr_1>=1 & esr_1<=8
gen nlf = esr_1==8 if esr_1>=1 & esr_1<=8

gen volsep1 = reasleft1==2 | reasleft1==5 | reasleft1==6 if reasleft1~=.
gen involsep1 = reasleft1==1 | reasleft1==3 | reasleft1==4 if reasleft1~=.
gen nosep1 = leftemp1==0 | leftemp1==2
gen volsep2 = reasleft2==2 | reasleft2==5 | reasleft2==6 if reasleft2~=.
gen involsep2 = reasleft2==1 | reasleft2==3 | reasleft2==4 if reasleft2~=.
gen nosep2 = leftemp2==0 | leftemp2==2
tab volsep1 if emp==1
tab involsep1 if emp==1
tab nosep1 if emp==1

gen month = h1_month
gen year = h1_year+1900

rename pp_intvw intvw

gen weight = round(fnlwgt_1,1)
tab month year

quietly compress
save ~/scratch3/sipp8689, replace


quietly log close

