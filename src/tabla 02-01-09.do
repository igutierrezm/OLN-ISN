*! 1.0.0 Iván Gutiérrez 23nov2016
* Exportaciones,
* según año, trimestre y sector.
* CCNN

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

* Selección:
use "$data/Exportaciones/Exportaciones.dta", clear
noisily : describe

* Mutación I:
generate año =  year(fecha)
generate mes = month(fecha)
rc_pib_rama1, version(1)

* Agregación:
collapse (sum) exp, by(año rama1_rc subsector)

* Mutación:
bysort año rama1_rc : egen exp0 = total(exp)
generate pc = 100 * exp / exp0
drop exp exp0

* Etiqueras de variables:
label variable año "año"
label variable pc  "% exportaciones"

* Guardado:
save "$project/data/chart 02-01-09.dta", replace
beep
