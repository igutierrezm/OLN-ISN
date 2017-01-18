*! 1.0.0 Iván Gutiérrez 23nov2016
* PIB encadenado (desestacionalizado),
* según año, trimestre y sector.
* CCNN

*===============================================================================
* Preámbulo
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

* Selección:
use "$data/PIB/PIB NSED.dta", clear

* Mutación:
rc_pib_rama1, version(1)

* Agregación:
collapse (sum) pib, by(rama1_rc fecha)

* Guardado:
save "$project/data/chart 02-01-01.dta", replace
beep
