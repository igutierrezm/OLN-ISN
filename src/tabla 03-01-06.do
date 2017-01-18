*! 1.0.0 Iván Gutiérrez 23nov2016
* Porcentaje de trabajadores que trabaja horas excesivas (48 horas o más),
* según año, sector y tramo de tamaño de empresa.
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
foreach mode in nacional sectorial {
	forvalues año = 2010(1)2015 {
		forvalues mes = 2(3)11 {
			* Selección:
			local mes = string(`mes', "%02.0f")
			local varlist "b7* b14 b15* cae* cat* fact habituales"
			use `varlist' using "$data/ENE/ENE `año' `mes'.dta", clear

			* Filtración:
			keep if inrange(cae_general, 1, 3)

			* Mutación I:
			generate ni = 1                            // auxiliar
			rc_ene_rama1,       año(`año') mes(`mes')  // rama de actividad
			rc_ene_exceso_hr,   año(`año') mes(`mes')  // exceso de horas trabajadas
			rc_ene_tramo_ntrab, año(`año') mes(`mes')  // tamaño de empresa (tramo)
			if ("`mode'" == "nacional") {
				replace rama1_rc = 99
			}

			* Agregación I:
			local bylist "exceso_hr_rc rama1_rc tramo_ntrab_rc"
			collapse (sum) ni [pweight = fact], by(`bylist')

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
bysort año rama1_rc tramo_ntrab_rc : egen n0 = total(ni)
generate pc = 100 * ni / n0
drop n0

*===============================================================================
* Epílogo
*===============================================================================

* Etiquetas de variables:
label variable año "año"
label variable ni  "n de ocupados"
label variable pc  "% de ocupados"

* Guardado:
save "$project/data/chart 03-01-06.dta", replace
beep
