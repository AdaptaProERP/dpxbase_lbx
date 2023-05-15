// Programa   : LBXREGSOPORTE
// Fecha/Hora : 05/04/2018 07:13:14
// Propósito  : Ejecutar LBX Tabla DPREGSOPORTE
// Creado Por : Juan Navas
// Llamado por:  Menu eAdaptaPro
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN()
  LOCAL oDb:=OpenOdbc(oDp:cDsnConfig)
  
  // Si la Tabla no Existe, sera Creado desde STRUCT\DPREGSOPORTE.TXT

  IF !oDb:FILE("DPREGSOPORTE")
    // La Tabla no Existe
    EJECUTAR("DPFILSTRTAB","DPREGSOPORTE",.T.)
  ENDIF

  DPLBX("DPREGSOPORTE")

RETURN NIL
// EOF
