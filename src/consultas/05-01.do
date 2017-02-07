* Macros auxiliares
local id "05-01"

* Especificación
.table = .ol_table.new
.table.cmds       = "{proportion _cise_v3}"
.table.cmds_lb    = "{%}"
.table.years      = "2010 2016"
.table.months     = "2 5 8 11"
.table.subpops    = "{if (_ocupado == 1)}"
.table.subpops_lb = "{Ocupados}"
.table.by         = "_cise_v3"
.table.along      = "_rama1_v1"
.table.aggregate  = "{_cise_v3} {_rama1_v1} {_cise_v3 _rama1_v1}"
.table.src        = "ene"
.table.from       = "$datos"
.table.varlist0   = "_cise_v3 _ocupado _rama1_v1"

* Estimación
.table.create
save "$proyecto/data/consultas/`id'.dta", replace



















/*
.table.rowvar     = "_cise_v3"
.table.colvar     = "año _rama1_v1"


 .table.annualize
drop if inlist(_cise_v3, 0, 6)
save "$proyecto/data/dta/`table_id'.dta", replace */

*===============================================================================
* Exportación
*===============================================================================
/*
* Exportación, según sector
forvalues sector = 1(1)1 {
	* Preparativos
	use "$proyecto/data/dta/`table_id'.dta", clear
	keep if inlist(_rama1_v1, `sector', 1e6)
	local sector_lb : label _rama1_v1 `sector'

	* Exportación, según variable
	foreach var in bh cv {
		* Cuerpo
		local file "$proyecto/data/xlsx/`var'/`sector_lb'.xlsx"
		putexcel set "`file'", sheet("`table_id'") modify
		.table.export_excel `var', file("`file'") sheet("`table_id'")

		* Título
		local msg = "5.1. Ocupados del sector `sector_lb' por categoría ocupacional y tipo de contrato, 2010 y 2015"
		putexcel A01 = "`msg'", font("Times New Roman", 11) bold

		* Nota 1
		local msg = "Fuente: Elaboración propia. Encuesta Nacional de Empleo, INE."
		putexcel A10 = "`msg'", font("Times New Roman", 10)
	}
}
*/
