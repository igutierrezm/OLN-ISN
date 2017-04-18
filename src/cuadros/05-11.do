* Macros auxiliares y objetos temporales
local id "05-11"

* Especificación
.table = .ol_table.new
.table.rowvar = "_rama1_v3 _oficio4"
.table.colvar = "cmd_lb"

* Exportación
foreach i of numlist $sectores {
	* BBDD
	use "$proyecto/data/consultas/`id'.dta", clear
	keep if inlist(_rama1_v1, `i')

  * Archivo de destino
	local name : label _rama1_v1 `i'
	label define _rama1_v1 `i' "Sector", modify
  local file "$proyecto/data/cuadros/`name'/bh.xlsx"

	* Título del cuadro
  .table.title =  ///
		"5.11. Características generales de las principales ocupaciones " +  ///
		"ejercidas en el sector `name', 2015"

	* Exportación
	.table.export_excel bh, file("`file'") sheet("`id'")
}
