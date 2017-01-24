* indicador 1  : escolaridad promedio
* indicador 2  : edad promedio
* indicador 3  : promedio yopr
* indicador 4  : % de mujeres
* indicador 5  : % capacitados
* subpoblación : ocupados
* años         : 2010 y 2015
* meses        :
* por          :
* según        : sector
* agregaciones : sector
* fuente       : casen

* Preparativos
drop _all
tempfile df
save `df', emptyok

* Especificación
.table = .ol_table.new
  * Estadísticas
  .table.cmds      = "(delayed)"
  .table.masks     = ""
	* Dominios
  .table.years     = "2015"
  .table.months    = ""
  .table.subpop    = "(delayed)"
	.table.by        = ""
  .table.along     = "_rama1_v1"
  .table.aggregate = "_rama1_v1"
  * Estructura
  .table.rowvar    = "mask"
  .table.colvar    = "_rama1_v1"
  * I-O
  .table.src       = "casen"
	.table.varlist0  = "(delayed)"

* Estimación
local i = 1
foreach var in _edad _esc _yprincipal _mujer _capacitado {
  .table.cmds     = `""mean `var'""'
  .table.subpop   = "if (_ocupado == 1) & (`var' != 1e5)"
  .table.varlist0 = "_ocupado _rama1_v1 `var'"
  * Estimación
  .table.create
  * Anexión
  replace mask = `i'
  append using "`df'"
  save "`df'", replace
  local ++i
}
replace bh = 100^1 * bh if inlist(mask, 4, 5)
replace o2 = 100^2 * bh if inlist(mask, 4, 5)

* Etiquetado
# delimit ;
  label define mask
    1 "Edad promedio"
    2 "Escolaridad promedio"
    3 "Ingreso promedio de la ocupación principal"
    4 "% de mujeres"
    5 "% de capacitados",
    modify;
# delimit cr
save "$proyecto/data/tabla 04-01", replace

* Exportación
keep if inlist(_rama1_v1, $sector, 1e6)
.table.export_excel bh, file("tabla 04-01")
.table.export_excel cv, file("tabla 04-01")
