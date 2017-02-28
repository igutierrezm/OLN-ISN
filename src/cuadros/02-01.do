* Macros auxiliares y objetos temporales
local id "02-01"

* Especificación
.table = .ol_table.new
.table.rowvar = "_tamaño_empresa_v1"
.table.colvar = "_rama1_v1 subpop_lb cmd_lb"

* Exportación
forvalues i = 1(1)13 {
	* BBDD
	use "$proyecto/data/consultas/`id'.dta", clear
	keep if inlist(_rama1_v1, `i', 1e6)

	* Nombre del sector
	local name : label _rama1_v1 `i'
	label define _rama1_v1 `i' "Sector", modify
  local file "$proyecto/data/cuadros/`name'/bh.xlsx"

  * Exportación
	.table.export_excel bh, file("`file'") sheet("`id'")
	putexcel set "`file'", sheet("`id'") modify
	putexcel A1 = ///
		"2.1. Número de empresas y ocupados por tamaño de empresa según número de trabajadores, 2015", ///
		font("Times New Roman", 11) bold
}
