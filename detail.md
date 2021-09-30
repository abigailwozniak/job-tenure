## Repository Structure

*The repository is structured as follows:*

- **SIPP Materials**
  - Contains the do-files to reproduce Figures 1, 5, 9, and 11; Table 5. 
- **GSS Materials**
  - Contains the do-files to reproduce the GSS columns in Table 6
- **NLSY_Materials**
  - Contains the do-files to reproduce Online Appendix Figure 4 and Online Appendix Table 3
- **QEMP Materials**
  - Contains the do-files that reproduce the QEMP columns of Table 6
- **CPS + other data Materials**
  - Contains the do-files that reproduce all other figures and tables

## SIPP Materials

Files for replication of SIPP analysis
1.	The SIPP data files were all downloaded from the NBER website: https://www.nber.org/research/data/survey-income-and-program-participation-sipp.  This site also posts Stata dictionaries that were used to read in the raw data.
2.	sipp96.do reads in the 1996-2008 panels and creates an appended dataset with data from 1996 to 2013 named sipp9608.dta.  It also creates the file tempsipp2.dta as an intermediate step.  The file sipp8689.do reads in the 1986-89 panels and creates an appended dataset tempsipp80.dta.  The file sipp9093.do reads in the 1990-93 panels and creates the appended dataset tempsipp.dta
For Figure 1: mean and median tenure by year
3.	The file sipp8689ten.do takes tempsipp80.dta, calculates mean and median tenure by year, and saves the results in fig1sipp8689.dta.
4.	The file fig1sipp.do starts with sipp9609.dta, calculates mean and median tenure by year, appends fig1sipp8689.dta, and saves the resulting data in fig1sipp.dta.
For Figure 5: Retention rates for men
5.	The file sipp96nosep8.do starts with sipp9608.dta, calculates the retention rate for men with 20+ years of tenure and saves the average retention rate over time in sipp96nosep8.dta.
6.	The file sippeu_old.do calculates the fraction of employed men who transition from employed to unemployed and from employed to not-in-labor force and saves the results in sippeu_old.dta.  It uses data from the 1986-89 panels (tempsipp80.dta), the 1990-93 panels (tempsipp.dta) and the 1996-2008 panels (tempsipp2.dta).  The line labeled “Fraction remaining employed, age 50-64” shows 1 –minus the sum of these two transition rates.
For Figure 9: Percent of workers with less than 1 year of tenure and 1-3 years of tenure
7.	The SIPP lines in this figure are calculated in fig1sipp.do and saved in fig1sipp.do.
For Figure 11: Decomposition of new hires
8.	The file sipp96hires.do uses the 1996-08 panels (tempsipp2.dta) and calculates fraction of employed workers that are new hires (tenure less than 1 quarter), job-to-job flows (tenure less than 1 quarter and employed in the previous quarter), and flows from non-employment (tenure less than one quarter and not employed in the previous quarter). 
For Table 5: Decomposition of the change in the aggregate job-to-job transition rate
9.	The file sipp96ee.do uses the 1996-08 panels (tempsipp2.dta) and calculates job-to-job flows by tenure category.  It then calculates counterfactual transition rates holding either the share of each tenure category at its pre-2000 level or the fraction of job-to-job flows for each tenure category at its pre-2000 level.  The actual and counterfactual job-to-job transition rates are then reported to make the table.


## GSS Materials

GSS Results for Table 6 come from read_gss_jobtenure.do and are posted in the associated log file. Results were pasted into Word tables.
•	Raw GSS data were downloaded from https://gssdataexplorer.norc.org/. 
•	Results for the GSS columns of Table 6 are in 567-605 of read_gss_jobtenure.log.
•	Note that results for the QEMP columns of T6 come from Raven’s files. 


## NLSY Materials 

- These are make_tenure_whyleft.do (for 1979) and make_tenure_whyleft_97.do (for 1997).
-These two do files process the nearly NLSY data for their respective cohorts, using nlsy79_1979to1994.dta and nlsy97_1997to2011.dta. The raw data were downloaded from https://www.nlsinfo.org/investigator/pages/login. After raw data were downloaded, basic cleaning was done using the code in makedata_nlsy79.do. The do and log files from makedata_nlsy79.do are available in the repository. Makedata_nlsy79.do also calls nlsy79_sp2019.dct, nlsy79_sp2019-value-labels.do, and rename_nlsy79_sp2019.do. The first two of those three were provided by the NLS Investigator website above and can be used to replicated the raw extracts. The rename file was constructed by the authors to quickly process renaming the raw NLSY variables. Analogous data construction files are also posted for the 97 extracts. 
- Results are contained in the log files and were pasted into word tables/excel.
- Results for AF4 are in lines 3524 to 3540 of make_tenure_whyleft.log (for ’79) and of 2465 to 2478 for make_tenure_whyleft_97.log (for ’97).
- Results for AT3 are in lines 3495 to 3505 of make_tenure_whyleft.log (for ’79) and of 2415 to 2424 for make_tenure_whyleft_97.log (for ’97). 


## QEMP Materials

Files for replication of the QEMP columns of Table 6
1.	The data from the 1960s and 1970s are from Quality of Employment surveys, which can be found on the ICPSR website (icpsr.org), study numbers 3507, 3510, and 7689.
2.	The file qemp.do reads in the raw data from all 3 surveys, appends them, and calculates the averages reported in columns labeled “QEMP 1970s” in Table 6.


## CPS + other data materials ##

The tables and figures are generated using the correspondingly named stata do files. 

As noted in datanotes-cps.txt, we use the NBER extract for 1983, and ICPSR extracts for 1987 and 1991.  The files dataclean_1983, _1987, and _1991 process these data.  For 1996 and later, we use data provided by IPUMS.

The following figures and tables are self-contained within the corresponding do file and do not need auxillary data, except for the CPS microdata.

- Figures 1, 2, Append 3; Table 1

The following figures and tables require a crosswalk between the ind1990 and occ1990 variables provided by IPUMS, and the ind/occ variables in the CPS microdata. This file is provided in the replication package and is called: ind-occ-asec.dta 

- Figures 3, 4, 7, 10, Append 1, Append 2; Tables 2 and 4

The following figures and tables require estimates of cohort average long tenure and separation rates for various ages. Cohort average separation rates are produced in cohort-effects-separations.do and -byage.do, and cohort average tenure rates are produced in cohort-effects-longtenure.do.   

- Figures 6, 8; Table 3

The following tables and figures require summary data from the SIPP, possibly in addition to CPS data.  See elsewhere in replication package for information on processing SIPP data.

- Figures 5, 9, 11, Append 5, Append 6

The following figure requires summary data from the GSS.  See elsewhere in replication package for information on processing GSS data.

- Figure 12

The following figure requires summary data from the NLSY.  See elsewhere in replication package for information on processing NLSY data.

- Append Figure 4

