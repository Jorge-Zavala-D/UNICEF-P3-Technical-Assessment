# UNICEF-P3-Technical-Assessment

## Overview

This repository contains all the code, data, and outputs associated with the UNICEF P3 Technical Assessment. The assessment consists of two main tasks:

1. **Task 1: Data Preparation and Weighted Coverage Analysis**
   - Calculate population-weighted coverage of health services (antenatal care and skilled birth attendance) for countries categorized as on-track and off-track in achieving under-5 mortality targets as of 2022.

2. **Task 2: Data Perspective Report on Educational Performance**
   - Analyze the evolution of educational performance among 4- to 5-year-old children in Zimbabwe, focusing on literacy, math, physical, learning, and socio-emotional development.

## Repository Structure

- **1 Data/**: Contains the datasets used for both tasks.
  - `0 Support documents/`: Folder with relevant documentation on definitions, questionnaires, and reports used as background materials to understand the data
  - `1 Raw/`: Folder containing all raw datasets used for both tasks 
  - `2 Working/`: Folder with preliminary datasets or auxiliary files used to process final datasets for both tasks.
  - `3 Coded/`: Folder with final datasets for analysis used in Task 1 and Task 2.

- **2 Code/**: Contains all Stata scripts necessary for data cleaning, analysis, and visualization.
  - `0 Master Code_UNICEF P3 Technical Assessment.do`: Master .do file that sets all relevant file paths and runs all data preparation, visualization and analysis codes to replicate the process of Task 1 and Task 2
  - `1a Data Preparation_UNICEF P3 Technical Assessment_Task 1.do`: Script to clean and prepare the raw data for Task 1.
  - `1b Data Visualization_UNICEF P3 Technical Assessment_Task 1.do`: Script to conduct the statistical analysis for Task 1.
  - `2a Data Preparation_UNICEF P3 Technical Assessment_Task 2.do`: Script to clean and prepare the raw data for Task 2.
  - `2b Data Visualization_UNICEF P3 Technical Assessment_Task 2.do`: Script to conduct the statistical analysis for Task 2.

- **3 Output/**: Contains the final outputs, including tables, figures, and written reports.
  - `Data Perspective - L&M.jpg`, `Data Perspective - Learning.jpg`, `Data Perspective - Physical.jpg`, `Data Perspective - SE.jpg`: Stata graphs with figures generated for the Data Perspective report of Task 2.
  - `WC COverage comparison.jpg`: Stata graph with the visualization of on-track / off-track WC Coverage comparison for Task 1
  - ``Data Perspective - EC index.jpg``: Stata graph with the output of the analytical part of Task 2
  - `Reg EC_index child_age_months.xls`: OLS output for analytical part of Task 2.
  - `Zimbabwe EC - Descriptive Stats.xlsx`: Excel file with descriptive stats, cronbachs alpha results for analytical part of Task 2
  - `UNICEF P3 Technical Assessment_Task 2 - Data Perspective.pdf`: Data Perspective report created for Task 2


## Installation Requirements

To run the code in this repository, ensure you have the following installed:

- **Stata**: Version 16 or higher


## Additional Notes
- The scripts are designed to be run sequentially. Ensure that you follow the order of execution as outlined above to avoid any issues.









