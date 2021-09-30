## Repository Structure

*The repository is structured as follows:*

- **\SIPP Materials**
  - Contains the do-files to reproduce Table 
- **\GSS_Materials**
  - Contains the do-files to reproduce Table 
- **\NLSY_Materials**
  - Contains the do-files to reproduce Tables 
- **\CPS_Materials**
  - Contains the do-files to reproduce 
- **\PSID_Materials**
  - Contains the do-files that reproduce Tables 2, 4, 7, A6, and Figures 6, 7, 10, 12, and A5. The raw CPS data can be obtained from IPUMS, or may be available upon request.

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



