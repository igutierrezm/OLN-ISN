* ISN - Infome Sectorial Nacional (script principal)

* [Editar] Directorios
global OLNTools "C:/Users/observatorio02/Documents/GitHub/OLN-Tools"
global proyecto "C:/Users/observatorio02/Documents/GitHub/OLN-ISN"
global datos    "C:/Users/observatorio02/Documents/BBDD/Stata"

* [Editar] Solicitudes
global carpetas "cuadros"
global cuadros  "0.-.."
global sectores "1 2 4 6 7 9"

* [No editar] Limpieza
set matsize 5000
set more off
clear all
cls

* [No editar] Paquetes externos 
foreach pkg in "" "_casen" "_ene" "_esi" "_pib" "_sii" {
	net install ol_tools`pkg', all force from("$OLNTools/src")
}

* [No editar] Cuadros
foreach carpeta in $carpetas {
	noisily : display as text "`carpeta'/"
	local archivos : dir "$proyecto/src/`carpeta'" files "*.do", respectcase
	foreach archivo of local archivos {
		if regexm("`archivo'", "$cuadros.do") {
			run "$proyecto/src/`carpeta'/`archivo'"
			noisily : display as text _skip(4) "`archivo' completado"
		}
	}
}
beep
