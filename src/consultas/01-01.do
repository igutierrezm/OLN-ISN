* Preparación de la BBDD
use "$datos/PIB/PIB NSED", clear
gen_pib_rama1_v1
gen_pib_año
gen_pib_mes
drop if (_rama1_v1 == .)
replace _mes = mod(_mes + 1, 12)

* PIB sectorial según sector, año y mes
collapse (sum) pib, by(_rama1_v1 _año _mes)

* Ajustes finales
generate cmd_type = "total"
label variable pib "PIB encadenado (desestacionalizado)"

* Guardado
save "$proyecto/data/consultas/01-01.dta", replace



















/*
* Exportación
forvalues i = 1(1)13 {
	* Preparación de la BBDD
	use "$proyecto/data/consultas/01-01.dta", clear
	keep if inlist(_rama1_v1, `i', 1e6)
	reshape wide pib, i(_año _mes) j(_rama1_v1)
	order _año _mes pib*
	order _año _mes

	* Etiquetado
	label variable pib`i'     "Sectorial"
	label variable pib1000000 "Nacional"
}
*/

* Exportación
/*
local file "$proyecto/data/contabla 01-01.xlsx"
export excel using "`file'", sheet("01") sheetmodify cell("A2") firstrow(varlabels)
putexcel set "`file'", sheet("01", replace) modify
*/
