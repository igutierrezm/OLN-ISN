* Macros auxiliares y objetos temporales
local id "01-07"

* Especificación
.table = .ol_table.new
.table.rowvar = "año mes"
.table.colvar = "_rama1_v1"

* Exportación
foreach i of numlist $sectores {
	* Especificación
	if (`i' != 12) .table.colvar = "_rama1_v1"
	if (`i' == 12) .table.colvar = "b14"

	* BBDD
	use "$proyecto/data/consultas/`id'", clear
	if (`i' != 12) keep if inlist(_rama1_v1, `i', .z) & (b14 == .z)
	if (`i' == 12) drop if (_rama1_v1 == .z) & (b14 != .z)
	if (`i' == 12) drop if (_rama1_v1 != .z) & (b14 == .z)
	if (`i' == 12) keep if inlist(_rama1_v1, `i', .z)

	* Archivo de destino
	local name : label _rama1_v1 `i'
	local file "$proyecto/data/cuadros/`name'/bh.xlsx"
	label define _rama1_v1 `i' "Sector", modify

	.table.title =  ///
		"1.7. Evolución ocupados del sector `name', 2010-2016 " +  ///
		"(miles de personas)"

	* Exportación
	.table.export_excel bh, file("`file'") sheet("`id'")
}
