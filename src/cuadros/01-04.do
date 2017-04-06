* Macros auxiliares y objetos temporales
local id "01-04"

* Especificación
.table = .ol_table.new
.table.rowvar = "_rama1_v1"
.table.colvar = "cmd_lb"

* Exportación
foreach i of numlist $sectores {
	* BBDD
	use "$proyecto/data/consultas/`id'", clear

	* Archivo de destino
	local name : label _rama1_v1 `i'
	local file "$proyecto/data/cuadros/`name'/bh.xlsx"

	* Título del cuadro
	.table.title =  ///
		"1.4. Distribución del PIB y de los ocupados por sector económico, 2015"

	* Exportación
	.table.export_excel bh, file("`file'") sheet("`id'")
}
