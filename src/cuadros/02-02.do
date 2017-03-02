* Macros auxiliares y objetos temporales
local id "02-02"

* Especificación
.table = .ol_table.new
.table.rowvar = "temp"
.table.colvar = "_rama1_v1 subpop_lb cmd_lb"

* Exportación
foreach i in $sectores {
	* BBDD
	use "$proyecto/data/consultas/`id'.dta", clear
	replace cmd_fmt = "%15,0fc" if (cmd_lb == 1)
	replace cmd_fmt = "%15,1fc" if (cmd_lb == 2)
	keep if inlist(_rama1_v1, `i', 1e6)
	rename _tamaño_empresa temp

	* Archivo de destino
	local name : label _rama1_v1 `i'
	label define _rama1_v1 `i' "Sector", modify
  local file "$proyecto/data/cuadros/`name'/bh.xlsx"

	* Título del cuadro
  local title = ///
    "2.2. Número de empresas y ocupados del sector " + ///
		"por tamaño de empresa según número de trabajadores, " + ///
		"incluyendo empresas unipersonales (cuenta propia), 2015"

	* Exportación
	.table.export_excel bh, file("`file'") sheet("`id'")
	putexcel set "`file'", sheet("`id'") modify
	putexcel A1 = "`title'", font("Times New Roman", 11) bold
}
