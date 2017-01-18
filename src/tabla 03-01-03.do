*! 1.0.0 Iván Gutiérrez 23nov2016
* Número y distribución de ocupados por tramo de tamaño de empresa,
* según año y sector.
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
	forvalues año = 2010(1)2015 {
		forvalues mes = 2(3)11 {
			* Selección:
			local mes     = string(`mes', "%02.0f")
			local varlist = "b14 b15* cae* cat* fact mes_central"
			use  `varlist' using "$data/ENE/ENE 2014 `mes'.dta", clear

			* Filtración:
			keep if inrange(cae_general, 1, 3)

			* Mutación I:
			generate ni = 1                            // auxiliar
			rc_ene_rama1,       año(`año') mes(`mes')  // rama de actividad
			rc_ene_tramo_ntrab, año(`año') mes(`mes')  // tamaño de empresa (tramo)
			if ("`col'" == "nacional") {
				replace rama1_rc = 99
			}

			* Agregación I:
			local bylist "rama1_rc tramo_ntrab_rc"
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

*===============================================================================
* Epílogo
*===============================================================================

* Etiquetas de variables:
label variable año "año"
label variable ni  "n. de ocupados"

* Guardado:
save "$project/data/chart 03-01-03.dta", replace
beep
