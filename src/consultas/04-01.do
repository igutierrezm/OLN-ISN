* Macros auxiliares
local id       "04-01"
local cmds_lb1 "{Edad promedio}"
local cmds_lb2 "{Escolaridad promedio}"
local cmds_lb3 "{Ingreso promedio de la ocupación principal}"
local cmds_lb4 "{%}"
local cmds_lb5 "{%}"

* Especificación
.table = .ol_table.new
.table.cmds       = "."
.table.cmds_lb    = "."
.table.years      = "2015"
.table.months     = ""
.table.subpops    = "{if _ocupado == 1}"
.table.subpops_lb = "{Ocupados}"
.table.by         = "."
.table.along      = "_rama1_v1"
.table.aggregate  = "{_rama1_v1}"
.table.src        = "esi"
.table.from       = "$datos"
.table.varlist0   = "."

* Estimación
local i = 1
foreach var in "_edad" "_esc" "_yprincipal" "_superior_completa" "_mujer" {
  .table.varlist0 = "_ocupado _rama1_v1 `var'"
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
