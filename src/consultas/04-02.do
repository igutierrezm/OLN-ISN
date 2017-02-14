* Macros auxiliares
local id        "04-02"
local aggregate ""
foreach var1 in "" "_mujer" {
  foreach var2 in "" "_rama1_v1" {
    foreach var3 in "" "_tramo_edad_v1" {
      if ("`var1'" == "" & "`var2'" == "" & "`var3'" == "") continue
      local aggregate "`aggregate' {`var1' `var2' `var3'}"
    }
  }
}
display as error "`aggregate'"

* Especificación
.table = .ol_table.new
.table.cmds       = "{total _counter}"
.table.cmds_lb    = "{N}"
.table.years      = "2010 2016"
.table.months     = "2 5 8 11"
.table.subpops    = "{if _ocupado == 1}"
.table.subpops_lb = "{Ocupados}"
.table.by         = "_tramo_edad_v1"
.table.along      = "_rama1_v1 _mujer"
.table.aggregate  = "`aggregate'"
.table.src        = "ene"
.table.from       = "$datos"
.table.varlist0   = "_mujer _ocupado _rama1_v1 _tramo_edad_v1"

* Estimación
.table.create
save "$proyecto/data/consultas/`id'.dta", replace













/*
* Estructura
.table.rowvar    = "_tramo_edad_v1"
.table.colvar    = "_rama1_v1 año"


* Estimación
.table.create
.table.annualize
save "$proyecto/data/tabla 04-02.dta", replace

* Exportación
keep if inlist(_rama1_v1, $sector, 1e6)
.table.export_excel bh, file("$proyecto/data/tabla 04-02.xlsx")
.table.export_excel cv, file("$proyecto/data/tabla 04-02.xlsx")


*/
