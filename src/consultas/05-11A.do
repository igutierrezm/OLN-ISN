* Macros auxiliares
local id "05-11A"
local file "$datos/CASEN/CASEN 2015.dta"
local varlist "_oficio4 _ocupado _rama1_v1 _pweight _counter"

* Preparación de la BBDD
select_casen, varlist("`varlist'") año("2015")
use `r(selection)' using "`file'", clear
ol_generate, db("casen") varlist("`varlist'") año("2015")
keep if (_ocupado == 1)

* Ocupados, según oficio y rama de actividad
collapse (sum) _counter [pweight = _pweight], by(_rama1_v1 _oficio4)
gsort _rama1_v1 -_counter

* Ranking
by _rama1_v1 : keep if _n <= 10
save "$proyecto/data/consultas/`id'.dta", replace
