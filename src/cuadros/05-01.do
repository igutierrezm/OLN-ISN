* Macros auxiliares y objetos temporales
local id "05-01"

* Especificación
.table = .ol_table.new
.table.rowvar = "año _rama1_v1"
.table.colvar = "_cise_v3"

* Exportación
foreach i in $sectores {
	* BBDD
	use "$proyecto/data/consultas/`id'.dta", clear
	keep if inlist(_rama1_v1, `i', 1e6)
	replace cmd_fmt = "%15,1fc"

	* Archivo de destino
	local name : label _rama1_v1 `i'
	label define _rama1_v1 `i' "Sector", modify
  local file "$proyecto/data/cuadros/`name'/bh.xlsx"

	* Título del cuadro
  local title =  ///
    "5.1. Ocupados del sector `name' " + ///
		"según categoría ocupacional y tipo de contrato, 2010 y 2016"

	* Exportación
	.table.export_excel bh, file("`file'") sheet("`id'")
	putexcel set "`file'", sheet("`id'") modify
	putexcel A1 = "`title'", font("Times New Roman", 11) bold
}
