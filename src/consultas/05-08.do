* Macros auxiliares
local id "05-08"
local cmds_lb1 "{Edad promedio}"
local cmds_lb2 "{Escolaridad promedio}"
local cmds_lb3 "{Ingreso promedio de la ocupación principal}"
local cmds_lb4 "{Mujeres (%)}"
local cmds_lb5 "{Capacitados (%)}"

* Especificación
.table = .ol_table.new
.table.cmds       = "."
.table.cmds_lb    = "."
.table.years      = "2015"
.table.months     = ""
.table.subpops    = "{if _ocupado == 1}"
.table.subpops_lb = "{Ocupados}"
.table.by         = "."
.table.along      = "_rama1_v1 _oficio1"
.table.aggregate  = "{_oficio1}"
.table.src        = "casen"
.table.from       = "$datos"
.table.varlist0   = "."

* Estimación
local i = 1
foreach var in "_edad" "_esc" "_yprincipal" "_mujer" "_capacitado" {
  .table.varlist0 = "_ocupado _oficio1 _rama1_v1 `var'"
  .table.cmds_lb  = "`cmds_lb`i''"
  if (`i' <= 3) {
    .table.cmds = "{mean `var'}"
    .table.by   = ""
  }
  else {
    .table.cmds = "{proportion `var'}"
    .table.by   = "`var'"
  }
  .table.create
  save "$proyecto/data/consultas/`id' [`i'].dta", replace
  local ++i
}











/*
.table.rowvar    = "_oficio1"
.table.colvar    = "cmd_lb"




* Estimación
local i = 1
foreach var in _edad _esc _yprincipal _mujer _capacitado {
  * Especificación
  .table.cmds     = "{mean `var'}"
  .table.subpops  = "{if (_ocupado == 1) & (`var' != 1e5)}"
  .table.varlist0 = "_ocupado _oficio1 _rama1_v1 `var'"
  * Estimación
  .table.create
  * Homologación
  replace cmd_lb = `i'
  local ++i
  * Anexión
  append using `df'
  save `df', replace
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
    5 "% de capacitados",
    modify;
# delimit cr

* Guardado
save "$proyecto/data/tabla 05-08.dta", replace

* Exportación
keep if inlist(_rama1_v1, $sector, 1e6)
.table.export_excel bh, file("$proyecto/data/tabla 05-08.xlsx")
.table.export_excel cv, file("$proyecto/data/tabla 05-08.xlsx")



*/
