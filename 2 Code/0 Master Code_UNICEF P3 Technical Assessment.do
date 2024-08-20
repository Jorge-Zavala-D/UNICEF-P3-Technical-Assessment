/*------------------------------------------------------------------------------*
| Title: 			Master code													|
| Project: 			UNICEF P3 Technical Assessment								|
| Authors:			Anonymous author											|
| 					  									                        |
|																				|
| Description:		This .do sets file paths and runs code for tasks			|
|                                                                               |
| Date created: 08/18/2024			 					                        |										          
|																			    |
| Version: Stata 16	                        							 	    |
*-------------------------------------------------------------------------------*/

/*--------------------------*
*           INDEX           *
*---------------------------*

	0. Setup and directory
	I. Define paths

*-------------------------------------------------------------------------------*/

*-----------------------------------*
**#		0. Setup and directory		*
*-----------------------------------*
	clear all
	clear mata
	set more off
	version 16

*-----------------------------------*
**#		I. Define paths				*
*-----------------------------------*

* check what your username is in Stata by typing "di c(username)"
* Left blank to ensure anonymity
if "`c(username)'" == ""  {
	global root ""	}


* globals
global input_dir    	"$root/1 Data"
global code_dir    		"$root/2 Code"
global output_dir    	"$root/3 Output"



///////////////////////////////////////////////////////////////////////////


*-------------------*
*		Task 1		*
*-------------------*

	* 1a. Data Preparation
	do "$code_dir/1a Data Preparation_UNICEF P3 Technical Assessment_Task 1.do"
	
	* 1b. Data visualization
	do "$code_dir/1b Data Visualization_UNICEF P3 Technical Assessment_Task 1.do"
	
	
*-------------------*
*		Task 2		*
*-------------------*

	* 1a. Data Preparation
	do "$code_dir/2a Data Preparation_UNICEF P3 Technical Assessment_Task 2.do"
	
	* 1b. Data visualization
	do "$code_dir/2b Data Visualization_UNICEF P3 Technical Assessment_Task 2.do"
		
	