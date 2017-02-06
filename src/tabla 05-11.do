* indicadores  :
*   1. escolaridad promedio
*   2. edad promedio
*   3. promedio yopr
*   4. % de mujeres
*   5. % capacitados
* subpoblación : ocupados
* años         : 2010 y 2015
* meses        :
* por          : oficio4 (10 grupos primarios más relevantes)
* según        : sector
* agregaciones :
* fuente       : casen

* Preparativos
drop _all
tempfile df
save `df', emptyok

* Especificación
.table = .ol_table.new
  * Estadísticas
  .table.cmds      = "[delayed]"
  .table.cmds_lb   = "[delayed]"
	* Dominios
  .table.years     = "2015"
  .table.months    = ""
  .table.subpops   = "[delayed]"
	.table.by        = "_oficio4"
  .table.along     = "_rama1_v1"
  .table.aggregate = "{_oficio4}"
  * Estructura
  .table.rowvar    = "_oficio4"
  .table.colvar    = "cmd_lb"
  * I-O
  .table.src       = "casen"
  .table.from      = "$datos"
	.table.varlist0  = "[delayed]"

* Estimación
forvalues j = 1(1)13 {
  local i = 1
  foreach var in _edad _esc _yprincipal _mujer _capacitado _oficio4 {
    * Especificación (act)
    if (`i' != 6) .table.cmds = "{mean `var'}"
    if (`i' == 6) .table.cmds = "{proportion `var'}"
    .table.subpops  = "{if (_rama1_v1 == `j') & (`var' != 1e5)}"
    .table.varlist0 = "_ocupado _oficio4 _rama1_v1 `var'"
    * Estimación
    .table.create
    * Homologación
    replace cmd_lb = `i'
    local ++i

    * Anexión
    append using `df'
    save `df', replace
  }
}
replace bh = 100^1 * bh if inlist(cmd_lb, 4, 5)
replace o2 = 100^2 * bh if inlist(cmd_lb, 4, 5)

* Etiquetado
# delimit ;
  label define cmd_lb
    1 "Edad promedio"
    2 "Escolaridad promedio"
    3 "Ingreso promedio de la ocupación principal"
    4 "% de mujeres"
    5 "% de capacitados"
    6 "% de ocupados c/r al total del sector",
    modify;
# delimit cr
save "$proyecto/data/tabla 05-11.dta", replace

* Exportación
*use "$proyecto/data/tabla 05-11.dta", clear
/* keep if (_rama1_v1 == $sector)
keep _oficio4 cmd_lb bh o2 cv
save `df', replace
keep if (cmd_lb == 6)
gsort -bh
generate ranking = _n
merge 1:m oficio4 using `df', no generate */
/*
.table.export_excel bh, file("$proyecto/data/tabla 05-11.xlsx")
.table.export_excel cv, file("$proyecto/data/tabla 05-11.xlsx")
*/
