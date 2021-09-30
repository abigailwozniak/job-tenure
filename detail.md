## Repository Structure

*The repository is structured as follows:*

- **\CPS_ASEC_Materials**
  - Contains the do-files to reproduce Table 7 and A1, and Figures 4, 5, A1, A3, and A4. Also contains the do-files to replicate the main data sets for the tables and figures, but none of the raw CPS or ASEC data are provided.
- **\Firms_90_10_GSS_Materials**
  - Contains the do-files to reproduce Table 8, and Figures 8 and 9. Note that only Table 8 can be completely replicated, as the underlying General Social Survey (GSS) data for Figures 8 and 9 are not provided.
- **\NLS_Materials**
  - Contains the do-files to reproduce Tables 5, 6, and 7. Also contains the do-files for replicating the three main National Longitudinal Survey data sets, but the raw NLS data are not provided.
- **\PCA_Materials**
  - Contains the do-files to reproduce Tables 1, 2, 3, A2, A3, A4, A5, and Figures 1, 2, 3, and A2. These do-files call data created by the Matlab code in the **Replicate_MullerWatsonTrends** folder.
- **\PSID_CPS_Materials**
  - Contains the do-files that reproduce Tables 2, 4, 7, A6, and Figures 6, 7, 10, 12, and A5. The raw CPS data can be obtained from IPUMS, or may be available upon request.

## CPS_ASEC_Materials

*Note that none of the data used in these do-files are provided (other than **j2jqwi.csv**)*

- **Data set construction**
  - **annual-data.do** – Creates annual-level data set for time series analysis.
  - **flows-monthly.do** – merges in flows data from Elsby, Michales, and Ratner with most recent data as provided by the BLS.
  - **match_extract.do** – for extracting variables from raw CPS data.
  - **match_flows-age-sex.do** – constructs the annual flows by age and sex data set.
  - **match_merge.do** – takes extracted CPS data from **match_extract.do**.
  - **jobchange-migrate-decomp.do** – Creates job changing and migration rates (**empchange-decomp.dta** and **migstate-decomp.dta**) using March CPS data and uses these data to run cell-level regressions for the decompositions shown in Figure 5 and Figure A4.
  - **transitions-by-group.do** – creates **transitions-by-group.dta**.
  - **Estar-FE-decomp.do** – Creates E* rates (**Estar-decomp.dta**) using matched CPS data (not provided) and uses these data to run cell-level regressions for the decompositions shown in Figure 5 and Figure A4.
  - **NE-FE-decomp.do** – Creates NE rates (**NE-decomp.dta**) using matched CPS data and uses these data to run cell-level regressions for the decompositions shown in Figure 5 and Figure A4.
  - **starE-FE-decomp.do** – creates * E rates (**starE-decomp.dta**) using matched CPS data and uses these data to run cell-level regressions for the decompositions shown in Figure 5 and Figure A4.
  - **UE-FE-decomp.do** – creates UE rates (**UE-decomp.dta**) using matched CPS data and uses these data to run cell-level regressions for the decompositions shown in Figure 5 and Figure A4.
  - **unicon-collapse.do** – collapses Unicon migration data.
  - **unicon-collapse-byagesex.do** - collapses Unicon migration data by age and sex.
  - **j2jgqwi.do** – imports the **j2jqwi.csv** and saves it as **j2jaqwi.dta**.
