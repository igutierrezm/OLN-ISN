* indicadores  :
*   1. % de ocupados con subempleo involuntario
*   2. % de ocupados que trabajan horas excesivas
* subpoblación : ocupados del sector (exceptuando fnr)
* años         : 2010 y 2015
* meses        :
* por          :
* según        : cise, rama1
* agregaciones : cise, rama1, cise x rama1
* fuente       : ene

* Preparativos
drop _all
tempfile df
save "`df'", emptyok

* Especificación
.table = .ol_table.new
  * Estadísticas
  .table.cmds      = "[delayed]"
  .table.cmds_lb   = "[delayed]"
	* Dominios
  .table.years     = "2010 2015"
  .table.months    = "2 5 8 11"
  .table.subpops   = "{if (_ocupado == 1) & (_cise_v1 != 3)}"
	.table.by        = "[delayed]"
  .table.along     = "_cise_v1 _rama1_v1"
  .table.aggregate = "{_cise_v1} {_rama1_v1} {_cise_v1 _rama1_v1}"
  * Estructura
  .table.rowvar    = "_cise_v1 año"
  .table.colvar    = "_rama1_v1 cmd_lb"
  * I-O
  .table.src       = "ene"
  .table.from      = "$datos"
	.table.varlist0  = "[delayed]"

* Estimación
local i = 1
foreach var in _jparcial_inv _exceso_hr_int {
  * Especificación
	.table.varlist0  = "_cise_v1 _ocupado _rama1_v1 `var'"
  .table.cmds      = "{proportion `var'}"
  .table.by        = "`var'"
  * Estimación
  .table.create
  .table.annualize
  * Homologación
  rename `var' categoria
  replace cmd_lb = `i'
  local ++i
  * Anexión
  append using "`df'"
  save "`df'", replace
}

* Etiquetado
label define cmd_lb 1 "Subempleo",       modify
label define cmd_lb 2 "Horas excesivas", modify
label values cmd_lb cmd_lb

* Guardado
save "$proyecto/data/tabla 05-06.dta", replace

* Exportación
keep if (categoria == 1) & inlist(_rama1_v1, $sector, 1e6)
.table.export_excel bh, file("$proyecto/data/tabla 05-06.xlsx")
.table.export_excel cv, file("$proyecto/data/tabla 05-06.xlsx")
