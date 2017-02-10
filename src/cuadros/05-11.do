* Macros auxiliares
local id "05-11"
local origen  "$proyecto/data/consultas"
local destino "$proyecto/data/cuadros"
local bylist  `""" "" "" "_mujer" "_capacitado""'

* Especificación de cuadro
.table = .ol_table.new
.table.rowvar = "_oficio4"
.table.colvar = "cmd_lb"

* Preparación de la BBDD
tempfile df1 df2
forvalues j = 1(1)2 {
	drop _all
	save `df`j'', emptyok
	forvalues k = 1(1)5 {
		* Ajustes preliminares
		use "`origen'/`id'B [`k'].dta", clear
		drop if (cmd_type == "proportion")

		* Agregación y creación de proporciones (hay dos métodos)
		local by : word `k' of `bylist'
		.table.annualize_v`j', over("_rama1_v1 _oficio4 `by'")
		if inlist(`k', 4, 5) {
			.table.as_proportion, by("`by'") along("_rama1_v1 _oficio4")
			keep if (`by' == 1)
			drop `by'
		}

		* Anexión
		replace cmd_lb = `k'
		append using `df`j''
		save `df`j'', replace
	}
	* Etiquetado
	label values cmd_lb cmd_lb
	label define cmd_lb 1 "Edad promedio", modify
	label define cmd_lb 2 "Escolaridad promedio", modify
	label define cmd_lb 3 "Ingreso promedio ocupación principal", modify
	label define cmd_lb 4 "Mujeres (%)", modify
	label define cmd_lb 5 "Capacitados (%)", modify

	* Guardado
	save `df`j'', replace
}

* Exportación del cuadro
forvalues i = 1(1)13 {
	forvalues j = 1(1)2 {
		* BBDD
		use `df`j'', clear
		keep if inlist(_rama1_v1, `i')

		* Identificación del nombre del sector
		local name : label _rama1_v1 `i'
		label define _rama1_v1 `i' "Sector", modify

		* Exportación
		foreach var in bh cv {
			* Cuerpo
			local file "`destino'/`name'/`var' [`j'].xlsx"
			.table.export_excel `var', file("`file'") sheet("`id'")

			* Título
			putexcel set "`file'", sheet("`id'") modify
			putexcel A1 = ///
				"5.11. Características generales de las principales ocupaciones ejercidas en el sector `name', 2015", ///
				font("Times New Roman", 11) bold
		}
	}
}
