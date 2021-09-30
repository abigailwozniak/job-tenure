#delimit ;

   infix
      year     1 - 20
      jobmeans 21 - 40
      union_   41 - 60
      memunion 61 - 80
      yearsjob 81 - 100
      promteok 101 - 120
      jobsecok 121 - 140
      laidoff  141 - 160
      jobfind1 161 - 180
      trynewjb 181 - 200
      satjob1  201 - 220
      hispanic 221 - 240
      sample   241 - 260
      jobpromo 261 - 280
      jobhour  281 - 300
      jobsec   301 - 320
      id_      321 - 340
      wrkstat  341 - 360
      age      361 - 380
      educ     381 - 400
      sex      401 - 420
      race     421 - 440
      reg16    441 - 460
      mobile16 461 - 480
      region   481 - 500
      joblose  501 - 520
      jobfind  521 - 540
      jobinc   541 - 560
      wtssall  561 - 580
using GSS.dat;

label variable year     "Gss year for this respondent                       ";
label variable jobmeans "Work important and feel accomplishment";
label variable union_   "Does r or spouse belong to union";
label variable memunion "Membership in labor union";
label variable yearsjob "Time at current job";
label variable promteok "Rs chances for promotion good";
label variable jobsecok "The job security is good";
label variable laidoff  "R was laid off main job last year";
label variable jobfind1 "How easy for r to find a same job";
label variable trynewjb "How likely r make effort for new job next year";
label variable satjob1  "Job satisfaction in general";
label variable hispanic "Hispanic specified";
label variable sample   "Sampling frame and method";
label variable jobpromo "Chances for advancement";
label variable jobhour  "Short working hours";
label variable jobsec   "No danger of being fired";
label variable id_      "Respondent id number";
label variable wrkstat  "Labor force status";
label variable age      "Age of respondent";
label variable educ     "Highest year of school completed";
label variable sex      "Respondents sex";
label variable race     "Race of respondent";
label variable reg16    "Region of residence, age 16";
label variable mobile16 "Geographic mobility since age 16";
label variable region   "Region of interview";
label variable joblose  "Is r likely to lose job";
label variable jobfind  "Could r find equally good job";
label variable jobinc   "High income";
label variable wtssall  "Weight variable";


label define gsp001x
   9        "No answer"
   8        "Don't know"
   5        "Fifth"
   4        "Fourth"
   3        "Third"
   2        "Second"
   1        "Most impt"
   0        "Not applicable"
;
label define gsp002x
   9        "No answer"
   8        "Don't know"
   4        "Neither belongs"
   3        "R and spouse belong"
   2        "Spouse belongs"
   1        "R belongs"
   0        "Not applicable"
;
label define gsp003x
   9        "No answer"
   8        "Don't know"
   2        "No"
   1        "Yes"
   0        "Not applicable"
;
*label define gsp004x
   99       "No answer"
   98       "Dont know"
   0.75     "6-11.9 months"
   0.25     "Less than 6 months"
   -1       "Not applicable"
;
label define gsp005x
   9        "No answer"
   8        "Dont know"
   4        "Not at all true"
   3        "Not too true"
   2        "Somewhat true"
   1        "Very true"
   0        "Not applicable"
;
label define gsp006x
   9        "No answer"
   8        "Dont know"
   4        "Not at all true"
   3        "Not too true"
   2        "Somewhat true"
   1        "Very true"
   0        "Not applicable"
;
label define gsp007x
   9        "No answer"
   8        "Dont know"
   2        "No"
   1        "Yes"
   0        "Not applicable"
;
label define gsp008x
   9        "No answer"
   8        "Dont know"
   3        "Not easy at all to find similar job"
   2        "Somewhat easy to find similar job"
   1        "Very easy to find similar job"
   0        "Not applicable"
;
label define gsp009x
   9        "No answer"
   8        "Dont know"
   3        "Not at all likely"
   2        "Somewhat likely"
   1        "Very likely"
   0        "Not applicable"
;
label define gsp010x
   9        "No answer"
   8        "Dont know"
   4        "Not at all satisfied"
   3        "Not too satisfied"
   2        "Somewhat satisfied"
   1        "Very satisfied"
   0        "Not applicable"
;
label define gsp011x
   99       "No answer"
   98       "Don't know"
   50       "Other, not specified"
   47       "Hispanic"
   46       "Latino/a"
   45       "Latin"
   41       "South american"
   40       "Latin american"
   35       "Filipino/a"
   31       "Basque"
   30       "Spanish"
   25       "Chilean"
   24       "Argentinian"
   23       "Venezuelan"
   22       "Columbian"
   21       "Equadorian"
   20       "Peruvian"
   16       "West indian"
   15       "Dominican"
   11       "Honduran"
   10       "Central american"
   9        "Costa rican"
   8        "Nicaraguan"
   7        "Panamanian"
   6        "Guatemalan"
   5        "Salvadorian"
   4        "Cuban"
   3        "Puerto rican"
   2        "Mexican, mexican american, chicano/a"
   1        "Not hispanic"
   0        "Not applicable"
;
label define gsp012x
   10       "2010 fp"
   9        "2000 fp"
   8        "1990 fp"
   7        "1980 fp blk oversamp"
   6        "1980 fp"
   5        "1980 bfp blk oversamp"
   4        "1970 fp blk oversamp"
   3        "1970 fp"
   2        "1970 bq"
   1        "1960 bq"
;
label define gsp013x
   9        "No answer"
   8        "Don't know"
   5        "Fifth"
   4        "Fourth"
   3        "Third"
   2        "Second"
   1        "Most impt"
   0        "Not applicable"
;
label define gsp014x
   9        "No answer"
   8        "Don't know"
   5        "Fifth"
   4        "Fourth"
   3        "Third"
   2        "Second"
   1        "Most impt"
   0        "Not applicable"
;
label define gsp015x
   9        "No answer"
   8        "Don't know"
   5        "Fifth"
   4        "Fourth"
   3        "Third"
   2        "Second"
   1        "Most impt"
   0        "Not applicable"
;
label define gsp016x
   9        "No answer"
   8        "Other"
   7        "Keeping house"
   6        "School"
   5        "Retired"
   4        "Unempl, laid off"
   3        "Temp not working"
   2        "Working parttime"
   1        "Working fulltime"
   0        "Not applicable"
;
label define gsp017x
   99       "No answer"
   98       "Don't know"
   89       "89 or older"
;
label define gsp018x
   99       "No answer"
   98       "Don't know"
   97       "Not applicable"
;
label define gsp019x
   2        "Female"
   1        "Male"
;
label define gsp020x
   3        "Other"
   2        "Black"
   1        "White"
   0        "Not applicable"
;
label define gsp021x
   9        "Pacific"
   8        "Mountain"
   7        "W. sou. central"
   6        "E. sou. central"
   5        "South atlantic"
   4        "W. nor. central"
   3        "E. nor. central"
   2        "Middle atlantic"
   1        "New england"
   0        "Foreign"
;
label define gsp022x
   9        "No answer"
   8        "Don't know"
   3        "Different state"
   2        "Same st,dif city"
   1        "Same city"
   0        "Not applicable"
;
label define gsp023x
   9        "Pacific"
   8        "Mountain"
   7        "W. sou. central"
   6        "E. sou. central"
   5        "South atlantic"
   4        "W. nor. central"
   3        "E. nor. central"
   2        "Middle atlantic"
   1        "New england"
   0        "Not assigned"
;
label define gsp024x
   9        "No answer"
   8        "Don't know"
   5        "Leaving labor force"
   4        "Not likely"
   3        "Not too likely"
   2        "Fairly likely"
   1        "Very likely"
   0        "Not applicable"
;
label define gsp025x
   9        "No answer"
   8        "Don't know"
   3        "Not easy"
   2        "Somewhat easy"
   1        "Very easy"
   0        "Not applicable"
;
label define gsp026x
   9        "No answer"
   8        "Don't know"
   5        "Fifth"
   4        "Fourth"
   3        "Third"
   2        "Second"
   1        "Most impt"
   0        "Not applicable"
;


label values jobmeans gsp001x;
label values union_   gsp002x;
label values memunion gsp003x;
label values yearsjob gsp004x;
label values promteok gsp005x;
label values jobsecok gsp006x;
label values laidoff  gsp007x;
label values jobfind1 gsp008x;
label values trynewjb gsp009x;
label values satjob1  gsp010x;
label values hispanic gsp011x;
label values sample   gsp012x;
label values jobpromo gsp013x;
label values jobhour  gsp014x;
label values jobsec   gsp015x;
label values wrkstat  gsp016x;
label values age      gsp017x;
label values educ     gsp018x;
label values sex      gsp019x;
label values race     gsp020x;
label values reg16    gsp021x;
label values mobile16 gsp022x;
label values region   gsp023x;
label values joblose  gsp024x;
label values jobfind  gsp025x;
label values jobinc   gsp026x;


