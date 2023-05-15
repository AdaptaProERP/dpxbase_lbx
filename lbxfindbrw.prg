// Programa   : LBXFINDBRW
// Fecha/Hora : 26/01/2015 05:01:56
// Propósito  : Ejecutar Búsquedas de LBX en DpXBase
// Creado Por : Juan Navas
// Llamado por:
// Aplicación : LBXFIND
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(oCol,uValue,nLastKey,nRecno,oLbx)
   LOCAL nAt
   IF oLbx=NIL
      RETURN NIL
   ENDIF
  
   IF oDp:oLbx:DbSeek(oCol,uValue,nLastKey)
      oDp:oLbx:oBrw:DrawLine(.T.)
      nAt:=oDp:oLbx:oBrw:nArrayAt
      EJECUTAR("LBXSAVEFIND",oDp:oLbx)
   ENDIF
  
RETURN NIL
// EOF

