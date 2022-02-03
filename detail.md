### Repository Structure

*The repository is structured as follows:*


- **SIPP_Materials**
  - Contains the do-files to produce the data used int Table 5; Figures 1, 5, 9, and 11; Online Appendix Figures 5, 6. 
- **GSS_Materials**
  - Contains the do-files to reproduce the GSS columns in Table 6
- **NLSY_Materials**
  - Contains the do-files to produce the data used for Online Appendix Figure 4 and Online Appendix Table 3
- **QEMP_Materials**
  - Contains the do-files that reproduce the QEMP columns of Table 6
- **CPS_Materials**
  - Contains the do-files that reproduce Figures 1-12, Tables 1-4, Online Appendix Table 2; and Online Appendix Figures 1-6.


 

## SIPP_Materials

- **Downloading the data**
  - The data files and dictionaries used to read in the raw data were all downloaded from the NBER website: https://www.nber.org/research/data/survey-income-and-program-participation-sipp. 
  
- **Cleaning the data**
  - **sipp96.do** - uses the raw 1996-2008 panel data to construct an appended dataset with data from 1996 to 2013 named **sipp9608.dta** and **tempsipp2.dta**.  
  - **sipp8689.do** - uses the raw 1986-89 panels to construct an appended dataset **tempsipp80.dta**.  
  - **sipp9093.do** - reads in the 1990-93 panels and creates the appended dataset **tempsipp.dta**.
  
- **Figure 1: mean and median tenure by year**
    - **sipp8689ten.do** - uses tempsipp80.dta, calculates mean and median tenure by year, and saves the results in fig1sipp8689.dta.
    - **fig1sipp.do** starts with sipp9609.dta, calculates mean and median tenure by year, appends fig1sipp8689.dta, and saves the resulting data in fig1sipp.dta.
    - See the CPS_Materials section for the do files that use fig1sipp.dta to produce Figure 1 and 9.
- **Figure 5: Retention rates for men**
    - **sipp96nosep8.do** - uses sipp9608.dta, calculates the retention rate for men with 20+ years of tenure and saves the average retention rate over time in sipp96nosep8.dta.
    - **sippeu_old.do** - uses tempsipp80.dta and tempsipp2.dta to calculate the fraction of employed men who transition from employed to unemployed and from employed to not-in-labor force and saves the results in sippeu_old.dta. 
    - The line labeled “Fraction remaining employed, age 50-64” shows 1 –minus the sum of these two transition rates.
    - Merge sipp96nosep8.dta and sippeu_old.dta on year and month to get fig5sipp.dta. See the CPS_Materials section for the do file that uses fig5sipp.dta to produce Figure 5.
- **Figure 9: Percent of workers with less than 1 year of tenure and 1-3 years of tenure**
    - See Figure 1.
- **Figure 11: Decomposition of new hires**
    - **sipp96hires.do** - uses tempsipp2.dta and calculates fraction of employed workers that are new hires (tenure less than 1 quarter), job-to-job flows (tenure less than 1 quarter and employed in the previous quarter), and flows from non-employment (tenure less than one quarter and not employed in the previous quarter), and outputs sipp96hires.dta 
    - See the CPS_materials for the do files that use sipp96hires.dta to output Figure 11.
- **Table 5: Decomposition of the change in the aggregate job-to-job transition rate**
    - **sipp96ee.do** - uses tempsipp2.dta and calculates job-to-job flows by tenure category.  It then calculates counterfactual transition rates holding either the share of each tenure category at its pre-2000 level or the fraction of job-to-job flows for each tenure category at its pre-2000 level.  The actual and counterfactual job-to-job transition rates are then reported to make the table.
- **Appendix Figure 5: Involuntary and Voluntary Separations in the SIPP**
  - **afig5.do** - uses sipp9608.dta and outputs figappend5.dta
  - See the CPS_materials for the do files that use figappend5.dta to output Appendix Figure 5

## GSS_Materials

- **Downloading the data**
  - Raw GSS data were downloaded from https://gssdataexplorer.norc.org/. 
  
- **Cleaning the data**
  - **read_gss_jobtenure.do** - uses raw GSS data to output **read_gss_jobtenure.log** and **gss_jobtenure.dta**.
  
- **Table 6, GSS columns**
  - Results for the GSS columns of **Table 6** are in 567-605 of **read_gss_jobtenure.log**.
  
- **Figure 12**
  - See the CPS_materials for the do file that uses **gss_jobtenure.dta** to construct **Figure 12**.


## NLSY_Materials 
- **Downloading the data**
  - Raw data files nlsy79_sp2019.dct and nlsy97_sp2019.dct were downloaded from https://www.nlsinfo.org/investigator/pages/login. (These files are large, and thus not included in this repository.)
  
- **Cleaning the data**
  - **makedata_nlsy79.do** - uses the raw data from 1979-1994, cleans it, and outputs nlsy79_1979to1994.dta. This do file calls nlsy79_sp2019.dct, nlsy79_sp2019-value-labels.do, and rename_nlsy79_sp2019.do.
  - **makedata_nlsy97.do** - uses the raw data from 1997-2011, cleans it, and outputs nlsy97_1997to2011.dta. This do file also calls nlsy97_sp2019.dct, nlsy97_sp2019-value-labels.do, and rename_nlsy97_sp2019.do.
  - **nlsy79_sp2019.dct**, **nlsy97_sp2019.dct**, **nlsy79_sp2019-value-labels.do** and **nlsy97_sp2019-value-labels.do** - provided by the NLS INvestigator website (link above) and can be used to repliacte the raw extracts.
  - **rename_nlsy79_sp2019.do** and **rename_nlsy97_sp2019.do** - quickly processes renaming the raw NLSY variables.
  
- **Online Appendix Figure 4 and Online Appendix table 3**
  - **make_tenure_whyleft.do** - uses nlsy79_1979to1994.dta to output results used in AF4 and AT3. 
  - **make_tenure_whyleft_97.do** - uses nlsy97_1997to2011.dta to output results used in AF4 and AT3. 
  - Results for AF4 are in lines 3524 to 3540 of make_tenure_whyleft.log (for ’79) and of 2465 to 2478 for make_tenure_whyleft_97.log (for ’97).
  - Results for AT3 are in lines 3495 to 3505 of make_tenure_whyleft.log (for ’79) and of 2415 to 2424 for make_tenure_whyleft_97.log (for ’97). 


## QEMP_Materials

- **Downloading the Data**
  - The data from the 1960s and 1970s can be found on the ICPSR website (icpsr.org), study numbers 3507, 3510, and 7689.
  
- **Cleaning the Data and Table 6**
  - **qemp.do** - reads in the raw data from all 3 surveys, appends them, and calculates the averages reported in columns labeled “QEMP 1970s” in Table 6.


## CPS_materials ##

- **Downloading the Data**
  - Data on tenure is from the CPS through IPUMS for 1996-2020, the ICPSR extract for 1987 and 1991, and the NBER extract for 1983. For more information, see the datanotes-cps.txt file.
  
- **Figures and Tables**
  - The tables and figures are generated using the correspondingly named stata do files. 
  - The following figures and tables are self-contained within the corresponding do file and do not need auxillary data, except for the CPS microdata.
    - Figures 1, 2, 
    - Online Appendix Figure 3 
    - Table 1
  - The following figures and tables require a crosswalk between the ind1990 and occ1990 variables provided by IPUMS, and the ind/occ variables in the CPS microdata. This file is provided in the repository and is called: **ind-occ-asec.dta** 
    - Figures 3, 4, 7, 10, 
    - Online Appendix Figure 1, 2
    - Tables 2 and 4
    - Online Appendix Table 2
  - The following figures and tables require estimates of cohort average long tenure and separation rates for various ages. Cohort average separation rates are produced in **cohort-effects-separations.do** and **-byage.do**, and cohort average tenure rates are produced in **cohort-effects-longtenure.do**.   
    - Figures 6, 8
    - Table 3 
  - The following tables and figures require summary data from the SIPP, possibly in addition to CPS data.  See elsewhere in the repository for information on processing SIPP data.
    - Figures 5, 9, 11
    - Online Appendix Figure 5, 6
  - The following figure requires summary data from the GSS.  See elsewhere in the repository for information on processing GSS data.
     - Figure 12
   - The following figure requires summary data from the NLSY.  See elsewhere in the repository for information on processing NLSY data.
     - Online Appendix Figure 4

