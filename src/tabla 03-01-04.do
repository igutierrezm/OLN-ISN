*! 1.0.0 Iván Gutiérrez 23nov2016
* Distribución de trabajadores dependientes por tamaño de empresa,
* según año, sector y tipo de contrato.
* ENE

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
* Cuerpo
*===============================================================================

save `df', emptyok
foreach col in nacional sectorial {
	foreach año in 2010 2015 {
		foreach mes in 02 05 08 11 {
			* Selección:
			local varlist "b14 b15* b8 b9 cat* fact"
			use `varlist' using "$data/ENE/ENE `año' `mes'.dta", clear

			* Filtración:
			keep if (b8 != .)
			* Población:
			* Empleados u obreros para un patrón, empresa o institución,
			* sea esta pública o privada, incluyndo a los familiares remunerados.

			* Mutación I:
			generate ni = 1                            // auxiliar
			rc_ene_rama1,       año(`año') mes(`mes')  // rama de actividad
			rc_ene_contrato,    año(`año') mes(`mes')  // tipo de contrato
			rc_ene_tramo_ntrab, año(`año') mes(`mes')  // tamaño de empresa (tramo)
			if ("`col'" == "nacional") {
				replace rama1_rc = 99
			}

			* Agregación I:
			local bylist "rama1_rc contrato_rc tramo_ntrab_rc"
			collapse (sum) ni [pw = fact], by(`bylist')

			* Mutación II:
			generate año = `año'
			generate mes = `mes'

			* Anexión:
			append using `df'
			save `df', replace
		}
	}
}

* Agregación II:
fillin   año mes `bylist'
recode   ni (. = 0)
collapse ni, by(año `bylist')

* Mutación III:
bysort año rama1_rc contrato_rc : egen n0 = total(ni)
generate pc = 100 * ni / n0
drop n0

*===============================================================================
* Epílogo
*===============================================================================

* Etiquetas de variables:
label variable año "año"
label variable ni  "n de trabajadores dependientes"
label variable pc  "% de trabajadores dependientes"

* Guardado:
save "$project/data/chart 03-01-04.dta", replace
beep
