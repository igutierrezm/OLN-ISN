* Macros auxiliares y objetos temporales
local id "04-04"

* Especificación
.table = .ol_table.new
.table.rowvar = "_rama1_v1"
.table.colvar = "año"

* Exportación
foreach i of numlist $sectores {
	* BBDD
	use "$proyecto/data/consultas/`id'.dta", clear

  * Archivo de destino
	local name : label _rama1_v1 `i'
  local file "$proyecto/data/cuadros/`name'/bh.xlsx"

  * Título del cuadro
  .table.title =  ///
    "4.4. Porcentaje de conmutantes según sectores productivos, 2010-2016"

	* Exportación
	.table.export_excel bh, file("`file'") sheet("`id'")
}
