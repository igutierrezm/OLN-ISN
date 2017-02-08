* Macros auxiliares
local id "05-03"

* Especificación
.table = .ol_table.new
.table.cmds       = "."
.table.cmds_lb    = "{N} {%}"
.table.years      = "2010 2016"
.table.months     = "2 5 8 11"
.table.subpops    = "{if _asalariado == 1}"
.table.subpops_lb = "{Asalariados}"
.table.by         = "."
.table.along      = "_rama1_v1"
.table.aggregate  = "{_rama1_v1}"
.table.src        = "ene"
.table.from       = "$datos"
.table.varlist0   = "_asalariado _rama1_v1 _b7"

* Estimación
forvalues i = 1(1)7 {
  .table.by   = "_b7_`i'"
  .table.cmds = "{total _counter} {proportion _b7_`i'}"
  .table.create
  save "$proyecto/data/consultas/`id' [`i'].dta", replace
}













/*

.table.rowvar     = "cmd_lb"
.table.colvar     = "año _rama1_v1"

forvalues i = 1(1)7 {
  * Especificación
  .table.by       = "_b7_`i'"
  .table.cmds     = "{proportion _b7_`i'}"
  * Estimación
  .table.create
  .table.annualize
  * Homologación
  rename _b7_`i' _b7
  * Anexión
  replace cmd_lb = `i'
  append using "`df'"
  save "`df'", replace
}

* Etiquetado
label variable cmd_lb "Indicador de seguridad social"
# delimit ;
  label define cmd_lb
    1 "... vacaciones pagadas"
    2 "... días pagados por enfermedad"
    3 "... cotización previsional o de pensión"
    4 "... cotización por previsión de salud"
    5 "... cotización por seguro de desempleo"
    6 "... permiso por maternidad o paternidad"
    7 "... servicio de guarderías infantiles",
    modify;
# delimit cr
label values cmd_lb cmd_lb

* Guardado
save "$proyecto/data/tabla 05-03.dta", replace
*/
*===============================================================================
* Exportación
*===============================================================================

/*
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
			"5.1. Ocupados del sector `sector_lb' " + ///
			"por categoría ocupacional y tipo de contrato, 2010 y 2015"
		putexcel A01 = "`msg'", font("Times New Roman", 11) bold

		* Nota 1
		local msg = ///
			"Fuente: Elaboración propia. Encuesta Nacional de Empleo, INE."
		putexcel A10 = "`msg'", font("Times New Roman", 10)
	}
}
*/
