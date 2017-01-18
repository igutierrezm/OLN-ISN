*! 1.0.0 Iván Gutiérrez 23nov2016
* Número y distribución de empresas y ocupados por tamaño de empresa,
* según año y sector.
* SII/ENE

*===============================================================================
* Prólogo
*===============================================================================

* Housekeeping:
set more off
clear
cls

* Objetos temporales:
tempfile df1 df2

*===============================================================================
* 1. Ocupados
*===============================================================================

clear
save `df1', emptyok
foreach mode in nacional sectorial {
	forvalues año = 2014(1)2014 {
		foreach mes in 02 05 08 11 {
			* Selección:
			local varlist "b14 b15* cae* cat* fact mes_central"
			use `varlist' using "$data/ENE/ENE `año' `mes'.dta", clear

			* Filtración:
			keep if inrange(cae_general, 1, 3)

			* Mutación I:
			generate ocupados = 1
			rc_ene_rama1,       año(2014) mes(`mes')  // rama de actividad
			rc_ene_tramo_ntrab, año(2014) mes(`mes')  // tamaño empresa
			if ("`mode'" == "nacional") {
				replace rama1_rc = 99
			}

			* Agregación I:
			local bylist "rama1_rc tramo_ntrab_rc"
			collapse (sum) ocupados [pw = fact], by(`bylist')

			* Mutacion II:
			generate año = `año'
			generate mes = `mes'

			* Anexión:
			append using `df1'
			save `df1', replace
		}
	}
}

* Agregación II:
fillin año mes `bylist'
recode ocupados (. = 0)
collapse ocupados, by(año `bylist')
save `df1', replace

*===============================================================================
* 2. Empresas
*===============================================================================

clear
save `df2', emptyok
foreach mode in nacional sectorial {
	forvalues año = 2014(1)2014 {
		* Selección:
		local varlist "sector tramo_venta tramo_ntrab"
		use `varlist' using "$data/SII/SII - Base empresas `año'.dta", clear

		* Mutación I:
		generate empresas = 1
		rc_sii_rama1, año(2014)  // rama de actividad
		if ("`mode'" == "nacional") {
			replace rama1_rc = 99
		}

		* Agregación:
		collapse (sum) empresas, by(rama1_rc tramo_ntrab)
		fillin rama1_rc tramo_ntrab
		recode empresas (. = 0)

		* Mutación II:
		generate año = `año'
		rename tramo_ntrab tramo_ntrab_rc
		drop _fillin

		* Anexión:
		append using `df2'
		save `df2', replace
	}
}

*===============================================================================
* 3. Consolidado
*===============================================================================

* Unión:
merge 1:1 año rama1_rc tramo_ntrab_rc using `df1', nogenerate

* Mutación:
fillin año rama1_rc tramo_ntrab
recode ocupados empresas (. = 0)
drop _fillin

*===============================================================================
* Epílogo
*===============================================================================

* Etiquetas de valores:
label values tramo_ntrab_rc tramo_ntrab_rc

* Etiquetas de variables:
label variable año "año"
label variable ocupados "n ocupados"
label variable empresas "n empresas"

* Guardado:
save "$project/data/chart 03-01-02.dta", replace
beep
