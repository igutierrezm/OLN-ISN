* Macros auxiliares
local id "05-11"
local origen  "$proyecto/data/consultas"
local destino "$proyecto/data/cuadros"
local bylist  `""" "" "" "_mujer" "_capacitado""'
tempfile df1

* Especificación de cuadro
.table = .ol_table.new
.table.rowvar = "_oficio4"
.table.colvar = "cmd_lb"

* Preparación de la BBDD
drop _all
save `df1', emptyok
forvalues k = 1(1)5 {
	* Ajustes preliminares
	use "`origen'/`id'B [`k'].dta", clear
	drop if (cmd_type == "proportion")

	* Agregación y creación de proporciones (hay dos métodos)
	local by : word `k' of `bylist'
	.table.annualize_v2, over("_rama1_v1 _oficio4 `by'")
	if inrange(`k', 1, 3) .table.add_asterisks
	if inrange(`k', 4, 5) {
		.table.as_proportion, by("`by'") along("_rama1_v1 _oficio4")
		.table.add_asterisks, add_over("`by'")
		keep if (`by' == 1)
		drop `by'
	}

	* Anexión
	replace cmd_lb = `k'
	append using `df1'
	save `df1', replace
}
* Etiquetado
label values cmd_lb cmd_lb
label define cmd_lb 1 "Edad promedio", modify
label define cmd_lb 2 "Escolaridad promedio", modify
label define cmd_lb 3 "Ingreso promedio ocupación principal", modify
label define cmd_lb 4 "Mujeres (%)", modify
label define cmd_lb 5 "Capacitados (%)", modify

* Guardado
save `df1', replace

* Exportación del cuadro
forvalues i = 1(1)13 {
	* BBDD
	use `df1', clear
	keep if inlist(_rama1_v1, `i')

	* Identificación del nombre del sector
	local name : label _rama1_v1 `i'
	label define _rama1_v1 `i' "Sector", modify
	local file "`destino'/`name'/bh.xlsx"

	* Exportación
	.table.export_excel bh, file("`file'") sheet("`id'")
	putexcel set "`file'", sheet("`id'") modify
	putexcel A1 = ///
		"5.11. Características generales de las principales ocupaciones ejercidas en el sector `name', 2015", ///
		font("Times New Roman", 11) bold
}
