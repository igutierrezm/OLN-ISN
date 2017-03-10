* Macros auxiliares y objetos temporales
local id "05-01"

* Especificación
.table = .ol_table.new
.table.rowvar = "año _rama1_v1"
.table.colvar = "_cise_v3"

* Exportación
foreach i of numlist $sectores {
	* BBDD
	use "$proyecto/data/consultas/`id'.dta", clear
	keep if inlist(_rama1_v1, `i', .z)

	* Archivo de destino
	local name : label _rama1_v1 `i'
	label define _rama1_v1 `i' "Sector", modify
  local file "$proyecto/data/cuadros/`name'/bh.xlsx"

	* Título del cuadro
  .table.title =  ///
    "5.1. Ocupados del sector `name' " +  ///
		"según categoría ocupacional y tipo de contrato, 2010 y 2016"

	* Exportación
	.table.export_excel bh, file("`file'") sheet("`id'")
}
