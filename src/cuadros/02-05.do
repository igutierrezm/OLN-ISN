* Macros auxiliares y objetos temporales
local id "02-05"

* Especificación
.table = .ol_table.new
.table.rowvar = "temp"
.table.colvar = "_educ"

* Exportación
forvalues i = 1(1)13 {
	* BBDD
	use "$proyecto/data/consultas/`id'.dta", clear
	rename _tamaño_empresa temp
	keep if inlist(_rama1_v1, `i')

	* Nombre del sector
	local name : label _rama1_v1 `i'
	label define _rama1_v1 `i' "Sector", modify
  local file "$proyecto/data/cuadros/`name'/bh.xlsx"

  * Exportación
	.table.export_excel bh, file("`file'") sheet("`id'")
	putexcel set "`file'", sheet("`id'") modify
	putexcel A1 = ///
		"2.5. Distribución de ocupados por tamaño de empresa según nivel educacional (%), 2016", ///
		font("Times New Roman", 11) bold
}
