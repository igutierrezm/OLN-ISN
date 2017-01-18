*! 1.0.0 Iván Gutiérrez 23nov2016
* Indicadores seguridad social,
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
	forvalues año = 2010(5)2015 {
		forvalues mes = 2(3)11 {
			* Selección:
			local mes     = string(`mes', "%02.0f")
			local varlist = "b7* b14 b15* cat* fact"
			use `varlist' using "$data/ENE/ENE `año' `mes'.dta", clear

			* Filtración:
			keep if (b7_1 != .)
			* Importante: ¡No todos los ocupados deben responder b7!
			* revisen las pp. 3/4 del cuestionario de la ENE

			* Mutación I:
			generate ni = 1                            // auxiliar
			generate id = _n                           // auxiliar
			rc_ene_rama1,       año(`año') mes(`mes')  // rama de actividad
			rc_ene_tramo_ntrab, año(`año') mes(`mes')  // tamaño de empresa
			drop b14 b15* cat*
			if ("`mode'" == "nacional") {
				replace rama1_rc = 99
			}

			* Data Tidying:
			reshape long b7_ , i(fact id ni rama1_rc tramo_ntrab_rc) j(b7_q)
			rename b7_ b7_a

			* Agregación I:
			local bylist "b7_a b7_q rama1_rc tramo_ntrab_rc"
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
bysort año b7_q rama1_rc tramo_ntrab_rc : egen n0 = total(ni)
generate pc = 100 * ni / n0
drop ni n0

*===============================================================================
* Epílogo
*===============================================================================

* Etiquetas de valores:
# delimit ;
label define b7_q
	1 "b7_1. ¿tiene vacaciones pagadas?"
	2 "b7_2. ¿tiene días pagados por enfermedad?"
	3 "b7_3. ¿tiene cotización previsional o de pensión?"
	4 "b7_4. ¿tiene cotización por previsión de salud?"
	5 "b7_5. ¿tiene cotización por seguro de desempleo?"
	6 "b7_6. ¿tiene permiso por maternidad o paternidad?"
	7 "b7_7. ¿tiene servicio de guarderías infantiles?";
# delimit cr
label values b7_q b7_q

* Etiquetas de variables:
label variable año  "año"
label variable b7_q "b7. pregunta"
label variable b7_a "b7. respuesta"
label variable pc   "% de ocupados dependientes remunerados"

* Guardado:
save "$project/data/chart 03-01-05.dta", replace
beep
