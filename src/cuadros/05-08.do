* Macros auxiliares
local id "05-08"
local origen  "$proyecto/data/consultas"
local destino "$proyecto/data/cuadros"
local bylist  `""" "" "" "_mujer" "_capacitado""'
tempfile df1

* Especificación de cuadro
.table = .ol_table.new
.table.rowvar = "_oficio1"
.table.colvar = "cmd_lb"

* Preparación de la BBDD
drop _all
save `df1', emptyok
forvalues k = 1(1)5 {
	* BBDD
	local by : word `k' of `bylist'
	use "`origen'/`id' [`k'].dta", clear
	if inrange(`k', 4, 5) .table.add_asterisks, add_over(`by')
	if inrange(`k', 1, 3) .table.add_asterisks
	if inrange(`k', 4, 5) keep if (`by' == 1)

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
save "$proyecto/data/cuadros/`id'", replace
forvalues i = 1(1)13 {
		* BBDD
		use `df1', clear
		keep if inlist(_rama1_v1, `i')

		* Identificación del archivo de destino
		local name : label _rama1_v1 `i'
		label define _rama1_v1 `i' "Sector", modify
		local file "`destino'/`name'/bh.xlsx"

		* Exportación
		.table.export_excel bh, file("`file'") sheet("`id'")
		putexcel set "`file'", sheet("`id'") modify
		putexcel A1 = ///
			"5.8. Características generales de los ocupados del sector `name' por tipo de ocupación, 2015", ///
			font("Times New Roman", 11) bold
}
