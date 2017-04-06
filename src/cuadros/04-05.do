* Macros auxiliares y objetos temporales
local id "04-05"

* Especificación
.table = .ol_table.new
.table.rowvar = "año mes"
.table.colvar = "_rama1_v1 _mujer"

* Exportación
foreach i of numlist $sectores {
	* BBDD
	use "$proyecto/data/consultas/`id'.dta", clear
  keep if inlist(_rama1_v1, `i', .z)

  * Archivo de destino
	local name : label _rama1_v1 `i'
  local file "$proyecto/data/cuadros/`name'/bh.xlsx"

  * Título del cuadro
  .table.title =  ///
    "4.5. Edad promedio de los ocupados del sector, según sexo, 2010-2016"

	* Exportación
	.table.export_excel bh, file("`file'") sheet("`id'")
}
