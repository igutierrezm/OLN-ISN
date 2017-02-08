* Macros auxiliares
local id "05-05"
local origen  "$proyecto/data/consultas"
local destino "$proyecto/data/cuadros"

* Especificación
.table = .ol_table.new
.table.rowvar = "_educ"
.table.colvar = "_rama1_v1 año"

* Exportación
forvalues i = 1(1)1 {
	forvalues j = 1(1)1 {
		* Preparación de la BBDD
		use "`origen'/`id'.dta", clear
		keep if (cmd_type != "proportion")
		keep if inlist(_rama1_v1, `i', 1e6)

		* Identificación del nombre del sector
		local name : label _rama1_v1 `i'
		label define _rama1_v1 `i' "Sector", modify
		
		* Exportación (cuerpo)
		local file "`destino'/`name'/bh [`j'].xlsx"
		.table.export_excel bh, file("`file'") sheet("`id'")
		*.table.export_excel cv, file("`file'") sheet("`id'")

		* Título
		local msg = "5.5. Ingresos de la ocupación principal de los ocupados del sector `name' según nivel educacional, 2010 y 2015"
		putexcel set "`file'", sheet("`id'") modify
		putexcel A1 = "`msg'", font("Times New Roman", 11) bold
	}
}
