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
