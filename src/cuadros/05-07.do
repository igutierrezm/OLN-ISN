* Macros auxiliares y objetos temporales
local id "05-07"

* Especificación
.table = .ol_table.new
.table.rowvar = "_oficio1"
.table.colvar = "_rama1_v1 año"

* Exportación
foreach i of numlist $sectores {
	* Especificación
	if (`i' != 12) .table.colvar = "_rama1_v1 año"
	if (`i' == 12) .table.colvar = "b14"

	* BBDD
	use "$proyecto/data/consultas/`id'.dta", clear
	if (`i' != 12) keep if inlist(_rama1_v1, `i', .z)
	if (`i' == 12) keep if inlist(_rama1_v1, `i') & (b14 != .z) & (año == 2016)

  * Archivo de destino
	local name : label _rama1_v1 `i'
	label define _rama1_v1 `i' "Sector", modify
  local file "$proyecto/data/cuadros/`name'/bh.xlsx"

  * Título del cuadro
  .table.title =  ///
    "5.7. Distribución de ocupados del sector `name' " +  ///
    "por tipo de ocupación, 2010 y 2016"

	* Exportación
	.table.export_excel bh, file("`file'") sheet("`id'")
}
