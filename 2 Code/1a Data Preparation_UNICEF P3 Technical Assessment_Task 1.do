/*------------------------------------------------------------------------------*
| Title: 			Data preparation											|
| Project: 			UNICEF P3 Technical Assessment								|
| Authors:			Anonymous author											|
| 					  									                        |
|																				|
| Description:		This .do imports, cleans and prepares data for analysis 	|
|                                                                               |
| Date created: 08/18/2024			 					                        |										          
|																			    |
| Version: Stata 16	                        							 	    |
*-------------------------------------------------------------------------------*/

/*--------------------------*
*           INDEX           *
*---------------------------*

	I. Prepare UNICEF Global Data Repository data
	II. Prepare United Nations World Population Prospects population data
	III. Prepare Under-five mortality on-track and off-track classifications data
	IV. Merge datasets
	V. Produce Coded dataset for analysis

*-------------------------------------------------------------------------------*/

*-----------------------------------------------------------*
*		I. Prepare UNICEF Global Data Repository data		*
*-----------------------------------------------------------*

	* Import data file as downloaded from the UNICEF Global Data Repository
	import excel "$input_dir/1 Raw/GLOBAL_DATAFLOW_2018-2022.xlsx", 			///
		sheet("Unicef data")													///
		firstrow																///
		clear

	* Keep relevant variables
	keep Geographicarea Indicator TIME_PERIOD OBS_VALUE
	
	* Rename variables to standardize datset
	rename Geographicarea			ctry
	rename Indicator				var
	rename TIME_PERIOD				year
	rename OBS_VALUE				value
	
	* Drop line with missing values from dataset
	drop if var==""
	
	* Transform year and value variables into numeric values
	destring year, replace
	destring value, replace
	
	* Define the highest year with data for each contry-var combination
	bys ctry var: egen year_max = max(year)
	
	* Keep data from the most recent year with data
	keep if year == year_max
	drop year_max
	
	* Drop repeated cases
	bys ctry var year: gen rep=_n
	
	drop if rep>1
	drop rep
	
	* Encode indicador variable
	encode var, gen(var_c)
	drop var
	
	* Reshape dataset from long to wide to get a country level table
	reshape wide value , i(ctry year) j(var_c)
	drop year
	
	* Rename coverage intdicator varaibles
	rename value1 					ANC4
	rename value2					SAB
	
	* Harmonize contry names with other datasets
	replace ctry = "American Samoa" if ctry == "Samoa"
	replace ctry = "Congo" if ctry == "Democratic Republic of the Congo"
	
	* Consolidate indicator values of country duplicates
	bys ctry: egen max1=max(ANC4)
	bys ctry: egen max2=max(SAB)
	bys ctry: gen a=_N
	replace ANC4 = round(max1,.1) if a>1
	replace SAB = round(max2,.1) if a>1
	bys ctry: gen b=_n
	drop if b>1
	drop a b max1 max2

	save "$input_dir/2 Working/coverage.dta", replace

*-------------------------------------------------------------------*
*		II. Prepare United Nations World Population Prospects		*
*			population data											*
*-------------------------------------------------------------------*
	* Import raw data
	import excel "$input_dir/1 Raw/WPP2022_GEN_F01_DEMOGRAPHIC_INDICATORS_COMPACT_REV1.xlsx", 			///
		sheet("Projections")													///
		cellrange("A17:BM22615")													///
		firstrow																///
		clear

	* Keep relevant variables
	keep Regionsubregioncountryorar ISO3Alphacode Type Year Birthsthousands
	
	* Convert births estimates to numeric
	replace Birthsthousands = "" if Birthsthousands == "..."
	destring Birthsthousands, replace
	
	* Keep only country-specific data
	keep if Type == "Country/Area"
	drop Type
	
	* Keep 2022 projection
	keep if Year == 2022
	drop Year
	
	* Rename variables
	rename Regionsubregioncountryorar			ctry1
	rename ISO3Alphacode						ctry_code
	rename Birthsthousands						births2022
	
	save "$input_dir/2 Working/births2022.dta", replace
	
*-----------------------------------------------------------------------*
*		III. Prepare Under-five mortality on-track and off-track		*
*			classifications data										*
*-----------------------------------------------------------------------*

	* Import raw data
	import excel "$input_dir/1 Raw/On-track and off-track countries.xlsx", 			///
		sheet("Sheet1")													///
		cellrange("A1:C201")													///
		firstrow																///
		clear
	
	* Replace values on status variable
	replace StatusU5MR = "on-track" if StatusU5MR == "Achieved" | StatusU5MR == "On Track"
	replace StatusU5MR = "off-track" if StatusU5MR == "Acceleration Needed"
		
	* Rename variables
	rename ISO3Code					ctry_code
	rename OfficialName				ctry2

	* Replace Kosovo ctry_code
	replace ctry_code = "XKX" if ctry2 == "Kosovo (UNSCR 1244)"
	
	
	save "$input_dir/2 Working/U5MRStatus.dta", replace
	
*-------------------------------*
*		IV. Merge datasets		*
*-------------------------------*
	
	use "$input_dir/2 Working/U5MRStatus.dta", clear
	merge 1:1 ctry_code using "$input_dir/2 Working/births2022.dta", gen(merge1)
	replace ctry2 = ctry1 if ctry2 ==""
	rename ctry2 ctry
	merge 1:1 ctry using "$input_dir/2 Working/coverage.dta", gen(merge2)
	* Merge2 == 2 contains country groups 
	drop if merge2==2
	
	drop merge2 merge1 ctry1
	
*---------------------------------------------------*
*		V. Produce Coded dataset for analysis		*
*---------------------------------------------------*

	gen xw_sab = SAB*births2022
	gen xw_anc4 = ANC4*births2022
	clonevar w = births2022
	
	keep if StatusU5MR != ""
	collapse (sum) xw_sab xw_anc4 w, by(StatusU5MR)
	gen WC_SAB = xw_sab / w
	gen WC_ANC4 = xw_anc4 / w
	drop xw_sab xw_anc4 w




	save "$input_dir/3 Coded/UNICEF P3 Technical Assessment_Task1 - Analysis dataset.dta", replace




