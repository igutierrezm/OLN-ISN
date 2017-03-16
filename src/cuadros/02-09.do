* Macros auxiliares y objetos temporales
local id "02-09"

* Especificación
.table = .ol_table.new
.table.rowvar = "_rama1_v1"
.table.colvar = "_tamano_empresa"

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
    "2.9. Porcentaje de trabajadores del sector que trabajan " +  ///
    "horas excesivas (49 horas o más) del sector, 2016"

	* Exportación
	.table.export_excel bh, file("`file'") sheet("`id'")
}
