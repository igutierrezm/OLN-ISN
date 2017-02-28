* Macros auxiliares y objetos temporales
local id "05-11"
local cmds_lb1 "{1: Escolaridad promedio}"
local cmds_lb2 "{2: Edad promedio}"
local cmds_lb3 "{3: Ingreso promedio de la ocupación principal}"
local cmds_lb4 "{4: N}"
local cmds_lb5 "{5: N}"
local varlist  "_oficio4 _ocupado _rama1_v1 _pweight _counter"
tempfile df

*===============================================================================
* Consulta Auxiliar
*===============================================================================

* Preparación de la BBDD
select_casen, varlist("`varlist'") año("2015")
use `r(selection)' using "$datos/CASEN/CASEN 2015.dta", clear
ol_generate, db("casen") varlist("`varlist'") año("2015")
keep if (_ocupado == 1)

* Ocupados, según oficio y rama de actividad
collapse (sum) _counter [pweight = _pweight], by(_rama1_v1 _oficio4)
gsort _rama1_v1 -_counter

* Ranking de las 10 ocupaciones más ejercidas, según sector
by _rama1_v1 : keep if _n <= 10
save `df', replace
forvalues j = 1(1)13 {
  use `df', clear
  keep if (_rama1_v1 == `j')
  local rk`j' = _oficio4[1]
  forvalues k = 1(1)10 {
    local member_k  = _oficio4[`k']
    local rk`j' = "`rk`j'', `member_k'"
  }
}
* Sin saber el ranking de antemano, la tabla principal tardaría eones en salir.

*===============================================================================
* Consulta principal
*===============================================================================

drop _all
save `df', replace emptyok
forvalues j = 1(1)13 {
  local i = 1
  foreach var in "_esc" "_edad" "_yprincipal" "_mujer" "_capacitado" {
    * Especificación
    .table = .ol_table.new
    .table.cmds       = "{mean `var'}"
    .table.cmds_lb    = "`cmds_lb`i''"
    .table.cmds_fmt   = "{%15,0fc}"
    .table.years      = "2015"
    .table.months     = ""
    .table.subpops    = "{if (_rama1_v1 == `j') & inlist(_oficio4, `rk`j'')}"
    .table.subpops_lb = "{1: Ocupados}"
    .table.by         = ""
    .table.along      = "_oficio4 _rama1_v1"
    .table.margins    = ""
    .table.margins_lb = ""
    .table.src        = "casen"
    .table.from       = "$datos"
    .table.varlist0   = "_oficio4 _rama1_v1 `var'"
    if (`i' == 1) .table.cmds_fmt = "{%15,1fc}"
    if (`i' >= 4) .table.cmds     = "{proportion `var'}"
    if (`i' >= 4) .table.by       = "`var'"

    * Estimación
    .table.create
    .table.add_asterisks
    if (`i' >= 4) keep if (`var' == 1)
    if (`i' >= 4) drop `var'
    append2 using `df'
    save `df', replace
    local ++i
  }
}
save "$proyecto/data/consultas/`id'.dta", replace
