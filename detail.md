## Repository Structure

*The repository is structured as follows:*


- **SIPP_Materials**
  - Contains the do-files to reproduce table 5 and the data used in Figures 1, 5, 9, and 11; Online Appendix Figures 5,6. Note the CPS Materials section has the do-files that uses the data to create the Figures themselves.
- **GSS_Materials**
  - Contains the do-files to reproduce the GSS columns in Table 6
- **NLSY_Materials**
  - Contains the do-files to reproduce Online Appendix Figure 4 and Online Appendix Table 3
- **QEMP Materials**
  - Contains the do-files that reproduce the QEMP columns of Table 6
- **CPS_Materials**
  - Contains the do-files that reproduce Figures 1-12, Tables 1-4, and Online Appendix Figures 1-6.




## SIPP Materials

- Downloading the data
  - The data files and dictionaries used to read in the raw data were all downloaded from the NBER website: https://www.nber.org/research/data/survey-income-and-program-participation-sipp. 
- Cleaning the data
  - sipp96.do reads in the 1996-2008 panels and creates an appended dataset with data from 1996 to 2013 named sipp9608.dta and tempsipp2.dta.  
  - sipp8689.do reads in the 1986-89 panels and creates an appended dataset tempsipp80.dta.  
  - sipp9093.do reads in the 1990-93 panels and creates the appended dataset tempsipp.dta
- Figures and tables
  - Figure 1: mean and median tenure by year
    - The file sipp8689ten.do takes tempsipp80.dta, calculates mean and median tenure by year, and saves the results in fig1sipp8689.dta.
    - The file fig1sipp.do starts with sipp9609.dta, calculates mean and median tenure by year, appends fig1sipp8689.dta, and saves the resulting data in fig1sipp.dta.
  - Figure 5: Retention rates for men
    - The file sipp96nosep8.do starts with sipp9608.dta, calculates the retention rate for men with 20+ years of tenure and saves the average retention rate over time in sipp96nosep8.dta.
    - The file sippeu_old.do calculates the fraction of employed men who transition from employed to unemployed and from employed to not-in-labor force and saves the results in sippeu_old.dta.  It uses data from the 1986-89 panels (tempsipp80.dta), the 1990-93 panels (tempsipp.dta) and the 1996-2008 panels (tempsipp2.dta).  The line labeled “Fraction remaining employed, age 50-64” shows 1 –minus the sum of these two transition rates.
  - Figure 9: Percent of workers with less than 1 year of tenure and 1-3 years of tenure
    - The SIPP lines in this figure are calculated in fig1sipp.do and saved in fig1sipp.do.
  - Figure 11: Decomposition of new hires
    - The file sipp96hires.do uses the 1996-08 panels (tempsipp2.dta) and calculates fraction of employed workers that are new hires (tenure less than 1 quarter), job-to-job flows (tenure less than 1 quarter and employed in the previous quarter), and flows from non-employment (tenure less than one quarter and not employed in the previous quarter). 
  - Table 5: Decomposition of the change in the aggregate job-to-job transition rate
    - The file sipp96ee.do uses the 1996-08 panels (tempsipp2.dta) and calculates job-to-job flows by tenure category.  It then calculates counterfactual transition rates holding either the share of each tenure category at its pre-2000 level or the fraction of job-to-job flows for each tenure category at its pre-2000 level.  The actual and counterfactual job-to-job transition rates are then reported to make the table.


## GSS Materials

- Raw GSS data were downloaded from https://gssdataexplorer.norc.org/. 
- Results for the GSS columns of Table 6 are in 567-605 of read_gss_jobtenure.log.


## NLSY Materials 
- Raw data was downloaded from https://www.nlsinfo.org/investigator/pages/login
- Basic cleaning was done with makedata_nlsy79.do.
- The two do files that output the data used in Online Appendix Figure 4 and Online Appendix table 3 are make_tenure_whyleft.do (for 1979) and make_tenure_whyleft_97.do (for 1997).
- - These two do files process the nearly NLSY data for their respective cohorts, using nlsy79_1979to1994.dta and nlsy97_1997to2011.dta. 
- - Makedata_nlsy79.do also calls nlsy79_sp2019.dct, nlsy79_sp2019-value-labels.do, and rename_nlsy79_sp2019.do. The first two of those three were provided by the NLS Investigator website above and can be used to replicated the raw extracts. The rename file was constructed by the authors to quickly process renaming the raw NLSY variables. Analogous data construction files are also posted for the 97 extracts. 
- - Results for AF4 are in lines 3524 to 3540 of make_tenure_whyleft.log (for ’79) and of 2465 to 2478 for make_tenure_whyleft_97.log (for ’97).
- - Results for AT3 are in lines 3495 to 3505 of make_tenure_whyleft.log (for ’79) and of 2415 to 2424 for make_tenure_whyleft_97.log (for ’97). 


## QEMP Materials

- The data from the 1960s and 1970s can be found on the ICPSR website (icpsr.org), study numbers 3507, 3510, and 7689.
- The file qemp.do reads in the raw data from all 3 surveys, appends them, and calculates the averages reported in columns labeled “QEMP 1970s” in Table 6.


## CPS_materials ##
- Data
- - Data on tenure is from the CPS through IPUMS for 1996-2020, the ICPSR extract for 1987 and 1991, and the NBER extract for 1983.
- - - Note: during the early stage of our research, we discovered that tenure variables for earlier years in IPUMS were incorrectly coded.  We think that these issues have been resolved,  but have continued using NBER/ICPSR extracts for earlier years. For 1987 and 1991, we use the ICPSR extract, because the NBER extract appeared to be corrupted.
- - Data on the separation rates is from the Annual Social and Economic Supplements through IPUMS.
- - 1996-2020 CPS tenure data from IPUMS. 
- - - The necessary variables are: year, age, sex, educ, marst, empstat, classwkr, ind1990, occ1990, jtsuppwt, jtyears, and race.
- - NBER 1983 
- - - nber data codebook: http://data.nber.org/cps/cpsjan83.pdf
- - - nber raw data: http://data.nber.org/cps/cpsjan83.zip
- - code for extracting necessary variables: dataclean_1983.do
- - ICPSR 1987 
- - - ICPSR codebook and data: https://www.icpsr.umich.edu/web/ICPSR/studies/8913/datadocumentation#
- - - code for extracting necessary variables: dataclean_1987.do
- - ICPSR 1991
- - - ICPSR codebook and data: https://www.icpsr.umich.edu/web/ICPSR/studies/9716
- - - code for extracting necessary variables: dataclean_1991.do
- - 1962-2020 separation rate data from the ASES through IPUMS
- - - Samples: 1962-2020
- - - Variables: asecwt, age, empstat, wkswork2, numemps, sex, year


- 
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

