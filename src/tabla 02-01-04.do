*! 1.0.1 Iván Gutiérrez 25nov2016
* Distribución del PIB y de los ocupados,
* según año y sector.
* CCNN/ENE

*===============================================================================
* Prólogo
*===============================================================================

* Housekeeping:
set more off
clear
cls

* Objetos temporales:
tempfile df

*===============================================================================
* 1. Ocupados
*===============================================================================

save `df', emptyok
forvalues año = 2010(1)2015 {
	foreach mes in 02 05 08 11 {
		* Selección:
		local varlist "b14 cae_general fact"
		use `varlist' using "$data/ENE/ENE `año' `mes'", clear

		* Filtración:
		keep if inrange(cae_general, 1, 3)

		* Mutación I:
		generate ocupados = 1
		rc_ene_rama1, año(`año') mes(`mes')

		* Agregación I:
		collapse (sum) ocupados [pw = fact], by(rama1_rc)

		* Mutación II:
		generate año = `año'
		generate mes = `mes'

		* Anexión:
		append using `df'
		save `df', replace
	}
}

* Agregación II:
collapse (mean) ocupados, by(año rama1_rc)
save `df', replace

*===============================================================================
* 2. PIB
*===============================================================================

* Selección:
use "$data/PIB/PIB NSCO.dta", clear

* Mutación:
generate año = year(fecha)  // año
rc_pib_rama1, version(1)    // rama de activdad

* Filtración:
keep if inrange(año, 2010, 2015)
keep if (rama1_rc != .)

* Agregación:
collapse (sum) pib, by(año rama1_rc)

*===============================================================================
* 3. Consolidación
*===============================================================================

* Unión:
merge 1:1 año rama1_rc using `df'

* Mutación:
foreach var of varlist pib ocupados {
	egen    sum_`var' = total(`var'), by(año)
	generate pc_`var' = 100 * `var' / sum_`var'
}

*===============================================================================
* Epílogo
*===============================================================================

* Etiquetas de variables:
label variable año         "año"
label variable pc_pib      "% pib (a precios corrientes)"
label variable pc_ocupados "% ocupados"

* Ajustes finales:
keep  año rama1_rc pc_pib pc_ocupados
sort  año rama1_rc pc_pib pc_ocupados
order año rama1_rc pc_pib pc_ocupados

* Guardado:
save "$project/data/chart 02-01-04.dta", replace
beep
