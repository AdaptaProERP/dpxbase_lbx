// Programa   : LBXFIND
// Fecha/Hora : 05/07/2003 01:31:02
// Propósito  : Realizar Busquedas en Cursor Sql desde la Clase DpLbx
// Creado Por : Juan Navas
// Llamado por: DPLBX
// Aplicación : Todas
// Tabla      : Todas

#INCLUDE "DPXBASE.CH"

PROCE LBXFIND(oDpLbx)
  LOCAL oBrw,I,oCol

  IF oDplBx=NIL
    RETURN .F.
  ENDIF

  oBrw:=oDpLbx:oBrw

  IF Empty(oBrw:CARGO)
     oBrw:CARGO     :=oDpLbx:oCursor:aDataFill
  ENDIF
  
  FOR I=1 TO LEN(oBrw:aCols)
     oBrw:aCols[I]:nEditType:=1
     oBrw:aCols[I]:bOnPostEdit:={|oCol,uValue,nLastKey,nCol|EJECUTAR("LBXFINDBRW",oCol,uValue,nLastKey,oDp:oLbx:oCursor:nRecno,oDp:oLbx)}
  NEXT

  oCol:=oBrw:SelectedCol()
  oCol:Edit()

RETURN NIL
// EOF

