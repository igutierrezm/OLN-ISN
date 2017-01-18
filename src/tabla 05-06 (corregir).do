* indicadores  : ingreso promedio de la ocupación principal
* subpoblación : ocupados
* años         : 2010 y 2015
* meses        :
* por          : nivel educacional (educ)
* según        : sector
* agregaciones : "educ", "sector", "educ x sector"
* fuente       : esi


clear
tempfile df
save `df', emptyok
forvalues año = 2010(1)2015 {
	foreach mes in in 02 05 08 11 {
		foreach varlist in "" "_rama1" {
			* Selección:
			local mes = string(`mes', "%02.0f")
			local selection "b14 cae_general fact habituales"
			use `selection' using "$datos/ENE/ENE `año' `mes'.dta", clear

			* Filtración:
			keep if inrange(cae_general, 1, 3)

			* Mutación:
			generate ni = 1                             // auxiliar
			gen_ene_rama1,       año(`año') mes(`mes')  // rama de actividad
			gen_ene_exceso_hr,   año(`año') mes(`mes')  // exceso de horas trabajadas
			foreach var in `varlist' {
				capture replace `var' = 1e6
			}

			* Agregación:
			local bylist "_exceso_hr _rama1"
			collapse (sum) ni [pweight = fact], by(`bylist')

			* Mutación:
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
collapse ni, by(año `bylist')

* Mutación III:
bysort año _rama1 : egen n0 = total(ni)
generate pc = 100 * ni / n0
drop n0

* Etiquetado (variables):
label variable año "año"
label variable ni  "n de ocupados"
label variable pc  "% de ocupados"

* Guardado:
save "$tablas/tabla 05-01-07.dta", replace
