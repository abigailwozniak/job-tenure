* read in SIPP data

set trace off
set more 1 
capture log close
clear
clear matrix
set linesize 200
set maxvar 30000

log using sipp9093.log, replace
 
clear
gen tmp = .
save ~/scratch3/tempsipp, replace

quietly foreach N of num 1/8 {
   quietly infile using sipp/sip90w`N', clear
   append using ~/scratch3/tempsipp
   save ~/scratch3/tempsipp, replace
}
quietly foreach N of num 1/8 {
   quietly infile using sipp/sip91w`N', clear
   append using ~/scratch3/tempsipp
   save ~/scratch3/tempsipp, replace
}
quietly foreach N of num 1/9 {
   quietly infile using sipp/sip92w`N', clear
   append using ~/scratch3/tempsipp
   save ~/scratch3/tempsipp, replace
}
destring suseqnum, replace
save ~/scratch3/tempsipp, replace

quietly foreach N of num 1/9 {
   quietly infile using sipp/sip93w`N', clear
   append using ~/scratch3/tempsipp
   save ~/scratch3/tempsipp, replace
}



quietly log close

