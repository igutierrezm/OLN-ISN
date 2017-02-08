* Macros auxiliares
local id "02-06"
local temp    "_tamaño_empresa_v1"
local origen  "$proyecto/data/consultas"
local destino "$proyecto/data/cuadros"

* Especificación
.table = .ol_table.new
.table.rowvar = "`temp'"
.table.colvar = "_cise_v3"

* Exportación
forvalues i = 1(1)1 {
	forvalues j = 1(1)1 {
		* Preparación de la BBDD
		use "`origen'/`id'.dta", clear
		keep if (cmd_type != "proportion")
		keep if inlist(_rama1_v1, `i')

		* Agregación y creación de proporciones (hay dos métodos)
		.table.annualize_v`j', over("_rama1_v1 _cise_v3 `temp'")
		.table.as_proportion, by("`temp'") along("_rama1_v1 _cise_v3")

		* Identificación del nombre del sector
		local name : label _rama1_v1 `i'
		label define _rama1_v1 `i' "Sector", modify

		* Exportación (cuerpo)
		local file "`destino'/`name'/bh [`j'].xlsx"
		.table.export_excel bh, file("`file'") sheet("`id'")
		*.table.export_excel cv, file("`file'") sheet("`id'")

		* Título
		local msg = "4.3. Ocupados del sector `name' según nivel educacional, 2010 y 2016"
		putexcel set "`file'", sheet("`id'") modify
		putexcel A1 = "`msg'", font("Times New Roman", 11) bold
	}
}
