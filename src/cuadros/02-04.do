* Macros auxiliares y objetos temporales
local id "02-04"

* Especificación
.table = .ol_table.new
.table.rowvar = "_region_tr_v1"
.table.colvar = "_tamano_empresa"

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
    "2.4. Distribución de ocupados del sector " +  ///
		"por región de trabajo, según tamaño de empresa, 2016"

	* Exportación
	.table.export_excel bh, file("`file'") sheet("`id'")
}
