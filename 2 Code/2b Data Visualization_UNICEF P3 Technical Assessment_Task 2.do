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

	I. Statistical analysis
	II. Prepare visuals
	
*-------------------------------------------------------------------------------*/

*-----------------------------------*
*		I. Statistical analysis		*
*-----------------------------------*
{
	*Calculate a table of summary statistics showing the percent correct for each of EC6, EC7, EC8, EC9, EC10, EC11, EC12, EC13, EC14, EC15 by child age in years
	
	global ec ec6 ec7 ec8 ec9 ec10 ec11 ec12 ec13 ec14 ec15
	
		global sumstats $ec
		putexcel set "$output_dir\Zimbabwe EC - Descriptive Stats.xlsx", sheet("By age in years") modify
		matrix define A = J(10, 6, .)
		local ri = 1
		local ri2 = 4
		foreach x of global sumstats {
			quietly summarize `x' if child_age_years == 3, detail
			matrix A[`ri', 1] = r(N)	
			matrix A[`ri', 2] = r(mean)
			matrix A[`ri', 3] = r(p50)
			matrix A[`ri', 4] = r(sd)
			matrix A[`ri', 5] = r(min)
			matrix A[`ri', 6] = r(max)
			putexcel A`ri2' = ("`x'")
			sleep 0
			local lab: variable label `x'				
			putexcel B`ri2' = ("`lab'")	
			sleep 0		
			local ri = `ri' + 1
			local ri2 = `ri2' + 1
		}
		putexcel C4=matrix(A)
		sleep 0
		putexcel C3=("Panel A: Children at 3-years-old")
		sleep 0
		putexcel C2=("Obs.")
		sleep 0
		putexcel D2=("Mean")
		sleep 0
		putexcel E2=("Median")
		sleep 0
		putexcel F2=("Std. Deviation")
		sleep 0
		putexcel G2=("Min.")
		sleep 0
		putexcel H2=("Max.")
		
		
		putexcel set "$output_dir\Zimbabwe EC - Descriptive Stats.xlsx", sheet("By age in years") modify
		matrix define A = J(10, 6, .)
		local ri = 1
		local ri2 = 15
		foreach x of global sumstats {
			quietly summarize `x' if child_age_years == 4, detail
			matrix A[`ri', 1] = r(N)	
			matrix A[`ri', 2] = r(mean)
			matrix A[`ri', 3] = r(p50)
			matrix A[`ri', 4] = r(sd)
			matrix A[`ri', 5] = r(min)
			matrix A[`ri', 6] = r(max)
			putexcel A`ri2' = ("`x'")
			sleep 0
			local lab: variable label `x'				
			putexcel B`ri2' = ("`lab'")	
			sleep 0		
			local ri = `ri' + 1
			local ri2 = `ri2' + 1
		}
		putexcel C15=matrix(A)
		putexcel C14=("Panel B: Children at 3-years-old")

	

	* Calculate an index, by taking the arithmetic average of the 10 items (EC6, EC7, EC8, EC9, EC10, EC11, EC12, EC13, EC14, EC15).
	egen ec_index = rowmean(ec6 ec7 ec8 ec9 ec10 ec11 ec12 ec13 ec14 ec15)
	
	* Calculate the Cronbach’s Alpha of the index and report it in a table along with the number of observations.
		* Store the output in a matrix
	alpha ec6 ec7 ec8 ec9 ec10 ec11 ec12 ec13 ec14 ec15, item
	matrix list r(Alpha)
	local N = r(N)
		* Create a table
	matrix define report_final= J(2, 1, .)
	matrix report_final[1,1] = r(alpha)
	count
	matrix report_final[2,1] = r(N)
	matrix rownames report_final = Cronbachs_Alpha N_Observations
	matrix list report_final
		* Export to table
	esttab matrix(report_final), title("Cronbach's Alpha and Number of Observations") cells("report")
	putexcel set "$output_dir\Zimbabwe EC - Descriptive Stats.xlsx", sheet("Cronbach Alpha Index") modify
	putexcel B2=matrix(report_final)
	putexcel A2="Cronbachs Alpha"
	putexcel A3="Number of Observations"
	
	* Plot the conditional mean of the created index on the child’s age in months at the time of the interview.
	graph twoway (fpfitci ec_index child_age_months, lcolor(navy) lpattern(dash) acolor(navy%20)),	///
		ytitle("Proportion of Children (%)", height(5)) xtitle("Child Age in Months", height(5)) ///
		title("Educational performance index Evolution" " ") ///
		xline(36, lpattern(dot)) ///
		xline(42, lpattern(dot)) ///
		xline(48, lpattern(dot)) ///
		xline(54, lpattern(dot)) ///
		xline(60, lpattern(dot)) ///
		xlab(36(1)60) ///
		ylab(,angle(horizontal)) ///
		graphregion(color(white)) ///
		legend(region(style(none)) rows(3) cols(1) order(2 "EC Index")) 

	graph export "$output_dir/Data Perspective - EC index.jpg", replace
	
	* Print a table of OLS regression results regressing index on the child’s age in months at the time of the interview. 
	reg ec_index child_age_months, r
	outreg2 using "$output_dir\Reg EC_index child_age_months.xls", excel replace ctitle("Educational performance index ") 
}	
*-------------------------------*
*		II. Prepare visuals		*
*-------------------------------*
{
	use "$input_dir/3 Coded/UNICEF P3 Technical Assessment_Task2 - Analysis dataset.dta", clear

	* Literacy and Math
	graph twoway (fpfitci ec6 child_age_months, lcolor(navy) lpattern(dash) acolor(navy%20))	///
				(fpfitci ec7 child_age_months, lcolor(green) lpattern(dot) acolor(green%20))	///
				(fpfitci ec8 child_age_months, lcolor(maroon) lpattern(dash_dot) acolor(maroon%20)),	///
		ytitle("Proportion of Children (%)", height(5)) xtitle("Child Age in Months", height(5)) ///
		title("Literacy and Math Skills Evolution" " ") ///
		xline(36, lpattern(dot)) ///
		xline(42, lpattern(dot)) ///
		xline(48, lpattern(dot)) ///
		xline(54, lpattern(dot)) ///
		xline(60, lpattern(dot)) ///
		xlab(36(1)60) ///
		ylab(,angle(horizontal)) ///
		graphregion(color(white)) ///
		legend(region(style(none)) rows(3) cols(1) order(2 "Identify Letters (EC6)" 4 "Read Words (EC7)" 6 "Recognize Numbers (EC8)")) 

	graph export "$output_dir/Data Perspective - L&M.jpg", replace
		
		
	* Physical Skills
	graph twoway (fpfitci ec9 child_age_months, lcolor(navy) lpattern(dash) acolor(navy%20))	///
				(fpfitci ec10 child_age_months, lcolor(maroon) lpattern(dash_dot) acolor(maroon%20)),	///
		ytitle("Proportion of Children (%)", height(5)) xtitle("Child Age in Months", height(5)) ///
		title("Physical Skills Evolution" " ") ///
		xline(36, lpattern(dot)) ///
		xline(42, lpattern(dot)) ///
		xline(48, lpattern(dot)) ///
		xline(54, lpattern(dot)) ///
		xline(60, lpattern(dot)) ///
		xlab(36(1)60) ///
		ylab(,angle(horizontal)) ///
		graphregion(color(white)) ///
		legend(region(style(none)) rows(3) cols(1) order(2 "Pick Up Small Objects (EC9)" 4 "Too Sick to Play (EC10)"))

	graph export "$output_dir/Data Perspective - Physical.jpg", replace
		
	* Learning Skills
	graph twoway (fpfitci ec11 child_age_months, lcolor(navy) lpattern(dash) acolor(navy%20))	///
				(fpfitci ec12 child_age_months, lcolor(maroon) lpattern(dash_dot) acolor(maroon%20)),	///
		ytitle("Proportion of Children (%)", height(5)) xtitle("Child Age in Months", height(5)) ///
		title("Learning Skills Evolution" " ") ///
		xline(36, lpattern(dot)) ///
		xline(42, lpattern(dot)) ///
		xline(48, lpattern(dot)) ///
		xline(54, lpattern(dot)) ///
		xline(60, lpattern(dot)) ///
		xlab(36(1)60) ///
		ylab(,angle(horizontal)) ///
		graphregion(color(white)) ///
		legend(region(style(none)) rows(3) cols(1) order(2 "Follow Directions (EC11)" 4 "Complete Tasks Independently (EC12)"))		
		
	graph export "$output_dir/Data Perspective - Learning.jpg", replace

	
	* Socio-emotional Development
	graph twoway (fpfitci ec13 child_age_months, lcolor(navy) lpattern(dash) acolor(navy%20))	///
				(fpfitci ec14 child_age_months, lcolor(green) lpattern(dot) acolor(green%20))	///
				(fpfitci ec15 child_age_months, lcolor(maroon) lpattern(dash_dot) acolor(maroon%20)),	///
		ytitle("Proportion of Children (%)", height(5)) xtitle("Child Age in Months", height(5)) ///
		title("Socio-emotional Development Skills Evolution" " ") ///
		xline(36, lpattern(dot)) ///
		xline(42, lpattern(dot)) ///
		xline(48, lpattern(dot)) ///
		xline(54, lpattern(dot)) ///
		xline(60, lpattern(dot)) ///
		xlab(36(1)60) ///
		ylab(,angle(horizontal)) ///
		graphregion(color(white)) ///
		legend(region(style(none)) rows(3) cols(1) order(2 "Gets Along with Others (EC13)" 4 "Kicks/Bites (EC14)" 6 "Easily Distracted (EC15)")) 
		
	graph export "$output_dir/Data Perspective - SE.jpg", replace
}
