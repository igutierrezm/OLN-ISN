* ISN - Informe Sectorial Nacional (script principal)

* Directorios (oficina)
// global OLNTools "C:/Users/observatorio02/Documents/GitHub/OLN-Tools"
// global proyecto "C:/Users/observatorio02/Documents/GitHub/OLN-ISN"
// global datos    "C:/Users/observatorio02/Documents/datos"

* Directorios (casa)
global OLNTools "C:\Users\ivang\Documents\GitHub/OLN-Tools"
global proyecto "C:\Users\ivang\Documents\GitHub/OLN-ISN"
global datos    "D:\Users\ivang\Documents\BBDD\Stata"

* Solicitudes (editar)
global carpetas "cuadros"
global cuadros  "05-.."
global sectores "11(1)11"

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
