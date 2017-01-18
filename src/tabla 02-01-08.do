*! 1.0.0 Iván Gutiérrez 23nov2016
* Variación (%) anual del número de ocupados,
* según año, trimestre móvil y sector.
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
		forvalues mes = 1(1)12 {
			* Selección:
			local mes = string(`mes', "%02.0f")
			local varlist = "b14 cae_general e18 fact"
			if ((`año' == 2010) & (`mes' == 1)) continue
			use `varlist' using "$data/ENE/ENE `año' `mes'", clear

			* Filtración I:
			keep if inrange(cae_general, 1, 3)

			* Mutación I:
			generate ni = 1
			rc_ene_rama1, año(`año') mes(`mes')
			if ("`col'" == "nacional") {
				replace rama1_rc = 99
			}

			* Agregación:
			collapse (sum) ni [pw = fact], by(rama1_rc)

			* Mutación II:
			generate año = `año'
			generate mes = `mes'

			* Anexión:
			append using `df'
			save `df', replace
		}
	}
}

* Mutación III:
sort rama1_rc año mes
bysort rama1_rc : gen pc = 100 * (ni[_n] - ni[_n-12]) / ni[_n - 12]

* Filtración II:
bysort rama1_rc : drop if _n <= 12

*===============================================================================
* Epílogo
*===============================================================================

* Etiquetas de variables:
label variable año      "trimestre móvil (año)"
label variable mes      "trimestre móvil (mes central)"
label variable pc       "Variación (%) anual ocupados"
label variable rama1_rc "rama de actividad económica (CIIU rev. 3)"

* Ajustes finales:
*order rama1_rc año mes pc
*keep  rama1_rc año mes pc
*sort  rama1_rc año mes

* Guardado:
save "$project/data/chart 02-01-08.dta", replace
beep
