set more off

clear
local datapath="G:/mcr/scratch-m1cls01/JHR/"
quietly infix                    ///
  byte    state          79-80   ///
  byte    mlr            131      ///
  byte    class		     166      ///
  long    ind            160-162    ///
  long    occ            163-165    ///
  byte    hh	         116-117      ///
  byte    age            120-121   ///
  byte	  marst			 122	///
  byte    race           130     ///
  byte    sex            125     ///
  byte    grdatn         127-128 ///
  byte    grdcomp        129     ///
  byte    esr 	         198     ///
  byte    month          2-3 ///
  float   weight 	     248-255 ///
  byte    workyrago      361     ///
  byte    samework 	     362     ///
  byte    monthwork      377-378     ///
  byte    yrswork	     374-376 ///
  byte 	  unionstat		 188	///
  byte	  unioncover     189   ///
using "`datapath'raw/1991/09716-0001-Data.txt"

gen year=1991

label var samework     `"Item34: doing same king of work a year ago"'
label var workyrago `"Item 34: working year ago "'
label var mlr     `"Item 19: major activity last week"'
label var esr    `"Employment status recode"'
label var grdatn    `"Item 31: highest grade attained"'
label var grdcomp   `"Completed highest grade attended"'

label define grade_lbl 01 `"none"'
label define grade_lbl 02 `"1st"', add
label define grade_lbl 03 `"2nd"', add
label define grade_lbl 04 `"3rd"', add
label define grade_lbl 05 `"4th"', add
label define grade_lbl 06 `"5th"', add
label define grade_lbl 07 `"6th"', add
label define grade_lbl 08 `"7th"', add
label define grade_lbl 09 `"8th"', add
label define grade_lbl 10 `"9th"', add
label define grade_lbl 11 `"10th"', add
label define grade_lbl 12 `"11th"', add
label define grade_lbl 13 `"12th"', add
label define grade_lbl 14 `"college 1"', add
label define grade_lbl 15 `"college 2"', add
label define grade_lbl 16 `"college 3"', add
label define grade_lbl 17 `"college 4"', add
label define grade_lbl 18 `"college 5"', add
label define grade_lbl 19 `"college 6"', add

label values grdatn grade_lbl

label define esr_lbl 01 `"working"'
label define esr_lbl 02 `"with job, not at work"', add
label define esr_lbl 03 `"looking for work"', add
label define esr_lbl 04 `"house keeping"', add
label define esr_lbl 05 `"at school"', add
label define esr_lbl 06 `"unable to work"', add
label define esr_lbl 07 `"other (eetired)"', add
label values esr esr_lbl

label values grdatn grade_lbl

label define mlr_lbl 01 `"working"'
label define mlr_lbl 02 `"with job, not at work"', add
label define mlr_lbl 03 `"looking for work"', add
label define mlr_lbl 04 `"house keeping"', add
label define mlr_lbl 05 `"at school"', add
label define mlr_lbl 06 `"unable to work"', add
label define mlr_lbl 07 `"other (eetired)"', add
label values mlr mlr_lbl

label define mar_lbl 01 `"marr, civ spouse present"'
label define mar_lbl 02 `"marr, AF spouse present"', add
label define mar_lbl 03 `"marr, spouse absent"', add
label define mar_lbl 04 `"widowed"', add
label define mar_lbl 05 `"divorced"', add
label define mar_lbl 06 `"separated"', add
label define mar_lbl 07 `"never married"', add
label values marst mar_lbl 

label define race_lbl 01 `"white"'
label define race_lbl 02 `"black"', add
label define race_lbl 03 `"american indian"', add
label define race_lbl 04 `"asian"', add
label define race_lbl 05 `"other"', add

label values race race_lbl
drop if age==.

save "`datapath'processed/jan1991.dta", replace

