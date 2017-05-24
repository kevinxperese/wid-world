import excel using "$eastern_bloc_data/Ex_socialist.xlsx", ///
	cellrange(A7:P52) clear

keep A C I P
rename A year
rename C valueCZ
rename I valueRU
rename P valueYU

reshape long value, i(year) j(iso) string

// Extend the value for USSR for Russia, and to Czechoslovakia for Czechia
expand 2 if inlist(iso, "RU", "CZ"), generate(newobs)
replace iso = "SU" if (iso == "RU") & newobs
replace iso = "CS" if (iso == "CZ") & newobs
drop newobs
drop if inlist(iso, "RU", "CZ") & (year < 1989)

keep if value < .
rename value def_east

sort iso year

label data "Generated by import-eastern-bloc-deflator.do"
save "$work_data/eastern-bloc-deflator.dta", replace