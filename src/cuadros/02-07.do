* Macros auxiliares y objetos temporales
local id "02-07"

* Especificación
.table = .ol_table.new
.table.rowvar = "_tamano_empresa"
.table.colvar = "_cise_v3"

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
    "2.7. Ingresos de la ocupación principal del sector " +  ///
    "por categoría ocupacional y tamaño de empresa, 2015"

	* Exportación
	.table.export_excel bh, file("`file'") sheet("`id'")
}
