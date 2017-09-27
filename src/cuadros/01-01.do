* Macros auxiliares y objetos temporales
local id "01-01"

* Especificación
.table = .ol_table.new
.table.rowvar = "_año _mes"
.table.colvar = "_rama1_v1"

* Exportación
foreach i of numlist $sectores {
	* BBDD
	use "$proyecto/data/consultas/`id'.dta", clear
	keep if inlist(_rama1_v1, `i')

	* Archivo de destino
	local name : label _rama1_v1 `i'
	local file "$proyecto/data/cuadros/`name'/bh.xlsx"
	label define _rama1_v1 `i' "PIB", modify

  * Título del cuadro
  .table.title =  ///
		"1.1. Evolución PIB del sector `name' (desestacionalizado), " +  ///
		"trimestres 2008-2016."

	* Exportación
	.table.export_excel bh, file("`file'") sheet("`id'")
}
