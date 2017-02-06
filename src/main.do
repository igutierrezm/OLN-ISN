* ISN - Informe Sectorial Nacional (script principal)

*===============================================================================
* Prólogo
*===============================================================================

* Housekeeping
set scrollbufsize 2000000
set more off
clear all
cls

* Macros globales
global proyecto "C:/Users/Pedro/Documents/GitHub/OLN-ISN"
global datos    "C:/Users/Pedro/Documents/Oficina OLN/Datos/Stata"
global pkg      "C:/Users/Pedro/Documents/GitHub/OLN-Tools"
global sector = 3

* Paquetes externos
foreach pkg in "" "_casen" "_ene" "_esi" "_pib" "_sii" {
	net install ol_tools`pkg', all force from("$pkg/src")
}

*===============================================================================
* Cuerpo
*===============================================================================

* Tablas
local files : dir "$proyecto/src/" files "tabla 02-11.do"
foreach file of local files {
	do "$proyecto/src/`file'"
}
beep
