/*------------------------------------------------------------------------------*
| Title: 			Data Visualization											|
| Project: 			UNICEF P3 Technical Assessment								|
| Authors:			Anonymous author											|
| 					  									                        |
|																				|
| Description:		This .do imports coded data and create visuals				|
|                                                                               |
| Date created: 08/18/2024			 					                        |										          
|																			    |
| Version: Stata 16	                        							 	    |
*-------------------------------------------------------------------------------*/

/*--------------------------*
*           INDEX           *
*---------------------------*

	I. Create visuals
	II. Interpretation and caveats

*-------------------------------------------------------------------------------*/


*-------------------------------*
*		I. Create visuals		*
*-------------------------------*

	use "$input_dir/3 Coded/UNICEF P3 Technical Assessment_Task1 - Analysis dataset.dta", clear

	graph bar (asis) WC_SAB WC_ANC4, over(StatusU5MR, label(angle(45))) ///
    blabel(bar, format(%9.1f)) ///
    title("Population-Weighted Coverage of Health Services" " ") ///
    ytitle("Weighted Coverage (%)", height(5)) ///
    legend(region(style(none)) order(1 "SAB" 2 "ANC4") position(6)) ///
	graphregion(color(white)) ///
	note(" " "Source: UNICEF Global Data Repository," "United Nations World Population Prospects," "United Nations Inter-agency Group for Child Mortality Estimation (UN IGME)") ///
    name(coverage_comparison, replace)
	
	graph export "$output_dir/WC Coverage comparison.jpg", replace
	
	
*-------------------------------------------*
*		II. Interpretation and caveats		*
*-------------------------------------------*
/*
	The bar graph presents the population-weighted coverage of antenatal care 
	(ANC4) and skilled birth attendance (SAB) for countries categorized as 
	on-track and off-track in achieving the under-5 mortality target by 2020.

	In terms of the Skilled Birth Attendance (SAB) indicator, on-track countries 
	show significantly higher population-weighted coverage of skilled birth 
	attendance at approximately 70.9%, compared to 37.4% in off-track countries. 
	This relevant difference suggests that countries on track to meet under-5 
	mortality targets are generally more effective in ensuring that skilled 
	personnel attend births, possible due to mor capable healthcare 
	infrastructure and higher access to skilled techincal personel, which are 
	crucial for improving maternal and child health outcomes.

	Regarding the Antenatal Care (ANC4) indicator, the coverage is also higher 
	in on-track countries, with a population-weighted average of 49.1%, compared 
	to 40.6% in off-track countries. Although the difference is less pronounced 
	than that observed for skilled birth attendance, it indicates that even in 
	off-track countries, antenatal care coverage is relatively more widespread. 
	This suggests that while there are challenges in achieving optimal coverage, 
	there is still a baseline level of antenatal care being provided, which is 
	essential for monitoring and improving maternal health. However, the 
	relatively small difference also suggest that there must be other relevant 
	factors asside from Antenatal Care that are driving the accomplishment of 
	this SDG.

	There are two main caveats on the analysis. First, the analysis relies on the 
	most recent data from the past five years, which may not fully capture recent 
	efforts or changes in health service coverage. Additionally, the data is 
	based on national averages, which could mask regional disparities within 
	countries. Second, regarding the estimates, the weighted averages are 
	derived from population  projections, which may have inherent uncertainties,
	particularly for countries with rapidly changing demographics. This could 
	affect the reliability of the coverage estimates.
*/