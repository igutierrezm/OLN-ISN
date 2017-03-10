* Macros auxiliares y objetos temporales
local id "02-02"

* Especificación
.table = .ol_table.new
.table.rowvar = "_tamano_empresa"
.table.colvar = "_rama1_v1 subpop_lb cmd_lb"

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
    "2.2. Número de empresas y ocupados del sector `name' " +  ///
		"por tamaño de empresa según número de trabajadores, " +  ///
		"incluyendo empresas unipersonales (cuenta propia), 2015"

	* Exportación
	.table.export_excel bh, file("`file'") sheet("`id'")
}
