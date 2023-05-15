// Programa   : LBXFILTERLOG
// Fecha/Hora : 18/02/2020 12:22:37
// Propósito  :
// Creado Por :
// Llamado por:
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(oLbx)
  LOCAL cId  
  LOCAL oData

  IF oLbx=NIL
     RETURN NIL
  ENDIF

// ? oLbx:cTable,"oLbx:cTable"

  oData:=DATASET(cId,"USER")
  cId  :="LBX"+oLbx:cTable
  oData:=DATASET(cId,"USER")
  oLbx:lFilterLog:=oData:Get(cId,oLbx:lFilterLog)
  oData:End()

// ? oLbx:lFilterLog,"oLbx:lFilterLog"

RETURN NIL
// EOF
