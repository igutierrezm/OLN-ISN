* Macros auxiliares
local id "05-11B"
local cmds_lb1 "{Edad promedio}"
local cmds_lb2 "{Escolaridad promedio}"
local cmds_lb3 "{Ingreso promedio de la ocupación principal}"
local cmds_lb4 "{N} {%}"
local cmds_lb5 "{N} {%}"

* Más macros auxiliares - Top 10 de los oficios, según sector
forvalues j = 1(1)13 {
  use "$proyecto/data/consultas/05-11A.dta", clear
  keep if (_rama1_v1 == `j')
  local top10_`j' = _oficio4[1]
  forvalues k = 1(1)10 {
    local member_k  = _oficio4[`k']
    local top10_`j' = "`top10_`j'', `member_k'"
  }
}

* Especificación
.table = .ol_table.new
.table.cmds       = "."
.table.cmds_lb    = "."
.table.years      = "2015"
.table.months     = ""
.table.subpops    = "."
.table.subpops_lb = "."
.table.by         = "."
.table.along      = "_oficio4 _rama1_v1"
.table.aggregate  = ""
.table.src        = "casen"
.table.from       = "$datos"
.table.varlist0   = "."

* Estimación
local i = 1
foreach var in _edad _esc _yprincipal _mujer _capacitado {
  * Inicializacion de la BBDD
  drop _all
  tempfile df`i'
  save `df`i'', emptyok replace
  forvalues j = 1(1)13 {
    .table.subpops = "{if (_rama1_v1 == `j') & inlist(_oficio4, `top10_`j'')}"
    .table.varlist0   = "_oficio4 _rama1_v1 `var'"
    .table.subpops_lb = "{Ocupados}"
    .table.cmds_lb    = "`cmds_lb`i''"
    if (`i' <= 5) {
      .table.by   = "`var'"
      .table.cmds = "{total _counter} {proportion `var'}"
    }
    if (`i' <= 3) {
      .table.by   = ""
      .table.cmds = "{mean `var'}"
    }
    .table.create
    append using `df`i''
    save `df`i'', replace
  }
  save "$proyecto/data/consultas/`id' [`i'].dta", replace
  local ++i
}





















/*

* Estructura
.table.rowvar    = "_oficio4"
.table.colvar    = "cmd_lb"



* Estimación
forvalues j = 1(1)13 {
  local i = 1
  foreach var in _edad _esc _yprincipal _mujer _capacitado _oficio4 {
    * Especificación (act)
    .table.subpops  = "{if (_rama1_v1 == `j') & (`var' != 1e5)}"
    if (`i' != 6) {
      .table.cmds = "{mean `var'}"
      .table.varlist0 = "_ocupado _oficio4 _rama1_v1 `var'"
    }
    if (`i' == 6) {
      .table.cmds = "{proportion `var'}"
      .table.varlist0 = "_ocupado _rama1_v1 `var'"
    }
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
use "$proyecto/data/tabla 05-11.dta", clear
keep if (_rama1_v1 == $sector)
keep _oficio4 cmd_lb bh o2 cv
save `df', replace
keep if (cmd_lb == 6)
gsort -bh
generate ranking = _n
merge 1:m oficio4 using `df', no generate
.table.export_excel bh, file("$proyecto/data/tabla 05-11.xlsx")
.table.export_excel cv, file("$proyecto/data/tabla 05-11.xlsx")


*/
