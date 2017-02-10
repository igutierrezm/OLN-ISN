* Macros auxiliares
local id "02-05"
local temp    "_tamaño_empresa_v1"
local origen  "$proyecto/data/consultas"
local destino "$proyecto/data/cuadros"

* Especificación
.table = .ol_table.new
.table.rowvar = "`temp'"
.table.colvar = "_educ"

* Exportación
forvalues i = 1(1)13 {
	forvalues j = 1(1)2 {
		* Preparación de la BBDD
		use "`origen'/`id'.dta", clear
		keep if (cmd_type != "proportion")
		keep if inlist(_rama1_v1, `i')

		* Agregación y creación de proporciones (hay dos métodos)
		.table.annualize_v`j', over("_rama1_v1 _educ `temp'")
		.table.as_proportion, by("`temp'") along("_rama1_v1 _educ")

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
				"2.5. Distribución de ocupados por tamaño de empresa según nivel educacional (%), 2016", ///
				font("Times New Roman", 11) bold
		}
	}
}
