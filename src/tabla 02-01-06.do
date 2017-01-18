*! 1.0.0 Iván Gutiérrez 23nov2016
* PIB y ocupados de cada sector en cada región (% del total de cada región),
* según año.
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
forvalues año = 2010(1)2014 {
	foreach mes in 02 05 08 11 {
		* Selección:
		local varlist "b14 cae_general fact region"
		use `varlist' using "$data/ENE/ENE `año' `mes'", clear

		* Filtración:
		keep if inrange(cae_general, 1, 3)

		* Mutación I:
		generate ocupados = 1                            // auxiliar
		rc_ene_region, año(`año') mes(`mes')             // región de residencia
		rc_ene_rama1,  año(`año') mes(`mes') version(2)  // rama de actividad

		* Agregación:
		collapse (sum) ocupados [pw = fact], by(rama1_rc region_rc)

		* Mutación II:
		generate año = `año'
		generate mes = `mes'

		* Anexión:
		append using `df'
		save `df', replace
	}
}

* Agregación II:
collapse (mean) ocupados, by(año rama1_rc region_rc)
save `df', replace

*===============================================================================
* 2. PIB
*===============================================================================

* BBDD:
use "$data/PIB/PIB RSCO.dta", clear

* Mutación:
generate año = year(fecha)
rc_pib_rama1, version(2)  // rama de actividad
rc_pib_region             // región

* Filtración:
keep if inrange(año, 2010, 2014)
keep if inrange(sector, 1, 12)

* Agregación:
collapse (sum) pib, by(año rama1_rc region_rc)

*===============================================================================
* Consolidación
*===============================================================================

* Unión:
merge 1:1 año rama1_rc region_rc using `df', nogenerate

* Mutación:
foreach var of varlist pib ocupados {
	bysort año region_rc : egen sum_`var' = total(`var')
	generate pc_`var' = 100 * `var' / sum_`var'
	drop `var' sum_`var'
}

*===============================================================================
* Epílogo
*===============================================================================

* Etiquetas de variables:
label variable año         "año"
label variable pc_pib      "% pib (a precios corrientes)"
label variable pc_ocupados "% ocupados"

* Ajustes finales:
/* keep  año rama1_rc pc_pib pc_ocupados
sort  año rama1_rc pc_pib pc_ocupados
order año rama1_rc pc_pib pc_ocupados */

* Guardado:
save "$project/data/chart 02-01-06.dta", replace
beep
