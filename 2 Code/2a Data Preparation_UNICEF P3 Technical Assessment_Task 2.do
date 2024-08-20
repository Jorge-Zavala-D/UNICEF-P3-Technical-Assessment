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

	I. Prepare data
	II. Create final data for analysis
*-------------------------------------------------------------------------------*/

*---------------------------*
*		I. Prepare data		*
*---------------------------*
{
	* Import data file as downloaded from the UNICEF Global Data Repository
	import delimited "$input_dir/1 Raw/Zimbabwe_children_under5_interview.csv",	///
		clear
	
	* Recode all relevant variables as binay (1 = Yes, 0 = No, DK = 0) and input corresponding missing values
	label def yn 0 No 1 Yes, replace
	foreach x in ec6 ec7 ec8 ec9 ec10 ec11 ec12 ec13 ec14 ec15	{
		recode `x' (8=0) (9=.) (2=0)
	label val `x' yn		
	}
	
	* Create child age in months at point of interview
	gen child_age_months = mofd(date(ïinterview_date, "YMD")) - mofd(date(child_birthday, "YMD")), after(child_birthday)
	
	
	* Label variables
	label var ïinterview_date "Date of Interview"
	label var child_age_years "Child age in years"
	label var child_birthday "Child date of birth"
	label var ec6 "Can (name) identify or name at least ten letters of the alphabet?"
	label var ec7 "Can (name) read at least four simple, popular words?"
	label var ec8 "Does (name) know the name and recognize the symbol of all numbers from 1 to 10?
	label var ec9 "Can (name) pick up a small object with two fingers, like a stick or a rock from the ground?"
	label var ec10 "Is (name) sometimes too sick to play?"
	label var ec11 "Does (name) follow simple directions on how to do something correctly?"
	label var ec12 "When given something to do, is (name) able to do it independently?"
	label var ec13 "Does (name) get along well with other children?"
	label var ec14 "Does (name) kick, bite, or hit other children or adults?"
	label var ec15 "Does (name) get distracted easily?"
}
*-----------------------------------------------*
*		II. Create final data for analysis		*
*-----------------------------------------------*
{	
	save "$input_dir/3 Coded/UNICEF P3 Technical Assessment_Task2 - Analysis dataset.dta", replace
	
}
	
	
	
	