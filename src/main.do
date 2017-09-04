* ISN - Informe Sectorial Nacional (script principal)

* Directorios (editar)
global OLNTools "C:/Users/observatorio02/Documents/GitHub/OLN-Tools"
global proyecto "C:/Users/observatorio02/Documents/GitHub/OLN-ISN"
global datos    "C:/Users/observatorio02/Documents/datos"

* Solicitudes (editar)
global carpetas "consultas cuadros"
global cuadros  "05-.."
global sectores "5"
/*
Cuadros pendientes:
02-04
02-07
02-10
04-01
04-02
05-02
05-05
05-06
05-08
05-09
05-10
05-11
*/

* Preámbulo
cls
clear all
set more off
set matsize 5000
foreach pkg in "" "_casen" "_ene" "_esi" "_pib" "_sii" {
	net install ol_tools`pkg', all force from("$OLNTools/src")
}

* Cuerpo
foreach carpeta in $carpetas {
	local directorio "$proyecto/src/`carpeta'"
	local archivos : dir "`directorio'" files "*.do", respectcase
	foreach archivo of local archivos {
		if regexm("`archivo'", "$cuadros.do") {
			run "$proyecto/src/`carpeta'/`archivo'"
			noisily : display as text "`carpeta'/`archivo' completado"
		}
	}
}
beep
