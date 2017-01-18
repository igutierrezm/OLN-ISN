* indicador 1  : escolaridad promedio
* indicador 2  : edad promedio
* indicador 3  : promedio yopr
* indicador 4  : % de mujeres
* indicador 5  : % capacitados
* subpoblación : ocupados
* años         : 2010 y 2015
* meses        :
* por          : oficio1
* según        : sector
* agregaciones : "oficio1"
* fuente       : casen

* Especificación
.table = .ol_table.new
  * Estadísticas
  .table.cmds      = ""
  .table.masks     = ""
	* Dominios
  .table.years     = "2015"
  .table.months    = ""
  .table.subpop    = "if _ocupado == 1"
	.table.by        = ""
  .table.along     = "_oficio1 _rama1_v1"
  .table.aggregate = `""_oficio1""'
  * Estructura
  .table.rowvar    = "_oficio1"
  .table.colvar    = "mask"
  * I-O
  .table.src       = "casen"
	.table.varlist0  = ""

* Estimación
drop _all
tempfile df
save `df', emptyok
forvalues i = 1(1)5 {
    * Especificación (act)
    local var : word `i' of _edad _esc _yprincipal _mujer _capacitado
    .table.cmds     = `""mean `var'""'
    .table.subpop   = "if (_ocupado == 1) & (`var' != 1e5)"
    .table.varlist0 = "_ocupado _oficio1 _rama1_v1 `var'"
    * Estimación
    .table.create
    * Anexión
    replace mask = `i'
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
save "$proyecto/data/tabla 05-08", replace

* Exportación
keep if inlist(_rama1_v1, $sector, 1e6)
.table.export_excel bh, file("tabla 05-08")
.table.export_excel cv, file("tabla 05-08")
