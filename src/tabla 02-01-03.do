*! 1.0.0 Iván Gutiérrez 23nov2016
* Tasa de cesantía,
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
			local varlist "b14 cae_general e18 fact"
			if ((`año' == 2010) & (`mes' == 1)) continue
			use `varlist' using "$data/ENE/ENE `año' `mes'", clear

			* Filtración:
			keep if inrange(cae_general, 1, 4)

			* Mutación I:
			generate cesante = (cae_general == 4)
			replace b14 = e18 if cesante         // sector (común)
			rc_ene_rama1, año(`año') mes(`mes')  // rama de actividad
			if ("`col'" == "nacional") {
				replace rama1_rc = 99
			}

			* Agregación:
			collapse (mean) cesante [pw = fact], by(rama1_rc)

			* Mutación II:
			generate tc  = 100*cesante
			generate año = `año'
			generate mes = `mes'
			drop cesante

			* Anexión:
			append using `df'
			save `df', replace

			* Mensajes:
			noisily : display "`año' `mes'"
		}
	}
}

*===============================================================================
* Epílogo
*===============================================================================

* Etiquetas de variables:
label variable año "trimestre móvil (año)"
label variable mes "trimestre móvil (mes central)"
label variable tc  "tasa de cesantía"

* Ajustes finales:
*order sector_rc año mes tc
*keep  sector_rc año mes tc
*sort  sector_rc año mes

* Guardado:
save "$project/data/chart 02-01-03.dta", replace
beep
