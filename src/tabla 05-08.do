* indicadores  :
*   1. escolaridad promedio
*   2. edad promedio
*   3. promedio yopr
*   4. % de mujeres
*   5. % capacitados
* subpoblación : ocupados
* años         : 2010 y 2015
* meses        :
* por          : oficio1
* según        : rama1
* agregaciones : oficio1
* fuente       : casen

* Preparativos
drop _all
tempfile df
save `df', emptyok

* Especificación
.table = .ol_table.new
  * Estadísticas
  .table.cmds      = "[delayed]"
  .table.masks     = "[delayed]"
	* Dominios
  .table.years     = "2015"
  .table.months    = ""
  .table.subpop    = "if _ocupado == 1"
	.table.by        = ""
  .table.along     = "_oficio1 _rama1_v1"
  .table.aggregate = "_oficio1"
  * Estructura
  .table.rowvar    = "_oficio1"
  .table.colvar    = "mask"
  * I-O
  .table.src       = "casen"
	.table.varlist0  = "[delayed]"

* Estimación
local i = 1
foreach var in _edad _esc _yprincipal _mujer _capacitado {
  * Especificación
  .table.cmds     = "(mean `var')"
  .table.subpop   = "if (_ocupado == 1) & (`var' != 1e5)"
  .table.varlist0 = "_ocupado _oficio1 _rama1_v1 `var'"
  * Estimación
  .table.create
  * Homologación
  replace mask = `i'
  local ++i
  * Anexión
  append using `df'
  save `df', replace
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

* Guardado
save "$proyecto/data/tabla 05-08.dta", replace

* Exportación
keep if inlist(_rama1_v1, $sector, 1e6)
.table.export_excel bh, file("$proyecto/data/tabla 05-08.xlsx")
.table.export_excel cv, file("$proyecto/data/tabla 05-08.xlsx")
