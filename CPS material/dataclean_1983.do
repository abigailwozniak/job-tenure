set more off

clear
local datapath="G:/mcr/scratch-m1cls01/JHR/"

quietly infix                    ///
  byte    state          17-18   ///
  byte    mlr            49      ///
  byte    class		     170      ///
  long    ind            374-376    ///
  long    occ            377-379    ///
  byte    hh	         96      ///
  byte    marst 		 99   ///
  byte    age            97-98   ///
  byte    race           100     ///
  byte    sex            101     ///
  byte    grdatn         103-104 ///
  byte    grdcomp        105     ///
  byte    esr 	         109     ///
  byte    month          118-119 ///
  float   weight 	     121-132 ///
  float   weightsupp	 414-425 ///
  byte    workyrago      427     ///
  byte    samework 	     429     ///
  byte    monthwork      435-436     ///
  byte    yrswork	     433-434 ///
using "`datapath'raw/1983/cpsjan83.dat"

gen year=1983

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

save "`datapath'processed/jan1983.dta", replace

