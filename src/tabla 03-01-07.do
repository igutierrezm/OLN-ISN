*! 1.0.0 Iván Gutiérrez 23nov2016
* Brechas de ingreso por hora entre hombres y mujeres,
* según año, sector y nivel educacional.
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

* Ingreso/hr:
clear
save `df', emptyok
foreach mode in nacional sectorial {
	forvalues año = 2015(1)2015 {
		* Selección:
		use "$data/ESI/ESI `año' Personas.dta", clear
		rename *, lower

		* Mutación I:
		rc_esi_educ,        año(`año')  // nivel educacional
		rc_esi_rama1,       año(`año')  // rama de actividad
		rc_esi_tramo_ntrab, año(`año')  // tamaño de empresa (tramo)
		rc_esi_habituales,  año(`año')  // horas habituales de trabajo a la semana
		if ("`mode'" == "nacional") {
			replace rama1_rc = 99
		}

		* Filtración:
		keep if inrange(cse_especifico, 1, 7)
		keep if (ing_t_p != .) & (habituales_rc != .)
		keep if (d1_opcion == 1)

		* Agregación:
		local bylist "rama1_rc tramo_ntrab_rc educ_rc sexo"
		collapse ing_t_p  habituales_rc [pw = fact], by(`bylist')

		* Mutación II:
		generate yhr = ing_t_p / habituales_rc / 4
		drop ing_t_p habituales_rc
		generate año = `año'

		* Anexión:
		append using `df'
		save `df', replace
	}
}

* Mutación III:
reshape wide yhr, i(año rama1_rc tramo_ntrab_rc educ_rc) j(sexo)
generate brecha = 100 * (yhr2 - yhr1) / yhr1
fillin año rama1_rc tramo_ntrab_rc educ_rc
drop _fillin

*===============================================================================
* Epílogo
*===============================================================================

* Etiquetas de variables:
label variable año    "año"
label variable brecha "brecha de género"

* Guardado:
save "$project/data/chart 03-01-07.dta", replace
beep
