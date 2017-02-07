* Macros auxiliares
local id "05-02"

* Especificación
.table = .ol_table.new
.table.cmds      = "{mean _yprincipal}"
.table.cmds_lb   = "{%}"
.table.years     = "2010 2015"
.table.months    = ""
.table.subpops   = "{if (_mantuvo_empleo == 1)}"
.table.by        = ""
.table.along     = "_rama1_v1 _cise_v3"
.table.aggregate = "{_cise_v3} {_rama1_v1} {_cise_v3 _rama1_v1}"
.table.src       = "esi"
.table.from      = "$datos"
.table.varlist0  = "_cise_v3 _mantuvo_empleo _rama1_v1 _yprincipal"

* Estimación
.table.create
save "$proyecto/data/consultas/`id'.dta", replace


















*===============================================================================
* Exportación
*===============================================================================

/*

.table.rowvar    = "_cise_v3"
.table.colvar    = "año _rama1_v1"


* Exportación, según sector
forvalues sector = 1(1)1 {
	* BBDD relevante
	use "$proyecto/data/dta/`table_id'.dta", clear
	keep if inlist(_rama1_v1, `sector', 1e6)

	* Nombre del sector
	local sector_lb : label _rama1_v1 `sector'

	* Exportación, según variable
	foreach var in bh cv {
		* Hoja de destino
		local file "$proyecto/data/xlsx/`var'/`sector_lb'.xlsx"
		putexcel set "`file'", sheet("`table_id'") modify

		* Cuerpo
		.table.export_excel `var', file("`file'") sheet("`table_id'")

		* Título
		local msg = ///
			"5.2. Ingresos de la ocupación principal del sector " +  ///
			"`sector_lb' según categoría ocupacional y tipo de contrato, 2010 y 2015"
		putexcel A01 = "`msg'", font("Times New Roman", 11) bold
		/*
		* Nota 1
		local msg = ///
			"Fuente: Elaboración propia. Encuesta Nacional de Empleo, INE."
		putexcel A10 = "`msg'", font("Times New Roman", 10)
		*/
	}
}
*/
