* Macros auxiliares y objetos temporales
local id "05-02"

* Especificación
.table = .ol_table.new
.table.colvar = "_cise_v3"
.table.rowvar = "_rama1_v1 año"

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
    "5.2. Ingresos de la ocupación principal del sector `name' " +  ///
    "según categoría ocupacional y tipo de contrato, 2010 y 2015"

	* Exportación
	.table.export_excel bh, file("`file'") sheet("`id'")
}
