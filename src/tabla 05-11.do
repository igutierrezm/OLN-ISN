* indicador 1  : escolaridad promedio
* indicador 2  : edad promedio
* indicador 3  : promedio yopr
* indicador 4  : % de mujeres
* indicador 5  : % capacitados
* indicador 5  : distribución de ocupados
* subpoblación : ocupados
* años         : 2010 y 2015
* meses        :
* por          : oficio4 (10 grupos primarios más relevantes)
* según        : sector
* agregaciones :
* fuente       : casen

* Especificación
.table = .ol_table.new
  * Estadísticas
  .table.cmds      = ""
  .table.masks     = ""
	* Dominios
  .table.years     = "2015"
  .table.months    = ""
  .table.subpop    = ""
	.table.by        = "_oficio4"
  .table.along     = "_rama1_v1"
  .table.aggregate = `""_oficio4""'
  * Estructura
  .table.rowvar    = "_oficio4"
  .table.colvar    = "mask"
  * I-O
  .table.src       = "casen"
	.table.varlist0  = ""

* Estimación
drop _all
tempfile df
save `df', emptyok
forvalues i = 1(1)6 {
  forvalues j = 1(1)13 {
    * Especificación (act)
    local var : word `i' of _edad _esc _yprincipal _mujer _capacitado _oficio4
    if (`i' != 6) .table.cmds = `""mean `var'""'
    if (`i' == 6) .table.cmds = `""proportion `var'""'
    .table.subpop   = "if (_rama1_v1 == `j') & (`var' != 1e5)"
    .table.varlist0 = "_ocupado _oficio4 _rama1_v1 `var'"
    * Estimación
    .table.create
    * Anexión
    replace mask = `i'
    append using `df'
    save `df', replace
  }
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
    5 "% de capacitados"
    6 "% de ocupados c/r al total del sector",
    modify;
# delimit cr
save "$proyecto/data/tabla 05-11", replace

* Exportación
/* bysort _rama1_v1
keep if inlist(_rama1_v1, $sector, 1e6)
.table.export_excel bh, file("tabla 05-11")
.table.export_excel cv, file("tabla 05-11") */
