* ISN - Informe Sectorial Nacional (script principal)

*===============================================================================
* Prólogo
*===============================================================================

* Housekeeping
set more off
clear all
cls

* Macros globales
global datos    "C:/Users/Pedro/Documents/Oficina OLN/Datos/Stata"
global proyecto "C:/Users/Pedro/Documents/GitHub/OLN-ISN"
global sector = 3

* Paquetes externos
local OLNTools "C:/Users/Pedro/Documents/GitHub/OLN-Tools/src"
net install ol_tools_casen, all force from("`OLNTools'")
net install ol_tools_ene,   all force from("`OLNTools'")
net install ol_tools_esi,   all force from("`OLNTools'")
net install ol_tools_sii,   all force from("`OLNTools'")
net install ol_tools,       all force from("`OLNTools'")
* También puede descargar e instalar los paquetes simultáneamente fijando
* local OLNTools net from "https://rawgit.com/igutierrezm/OLNTools/master/src"

*===============================================================================
* Cuerpo
*===============================================================================

* Tablas
local files : dir "$proyecto/src/" files "tabla 02-09.do"
foreach file of local files {
	do "$proyecto/src/`file'"
}
beep
