// Programa   : LBXSETINIFILTER
// Fecha/Hora : 16/04/2018 15:13:54
// Propósito  : Inicio para Realizar Filtrado
// Creado Por : Juan Navas
// Llamado por: LBX Boton Filtrar
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(oLbx)
  LOCAL I,oBrw,oCol,cTitle

  IF oLbx=NIL 
     RETURN NIL
  ENDIF

  oLbx:lFind:=.T.
  oBrw:=oLbx:oBrw

  cTitle:=oLbx:oWnd:cTitle

  cTitle:=ALLTRIM(cTitle)+CHR(9)+" [ Filtrar ]"

  oLbx:oWnd:SetText(cTitle)

  // Version 5.1 requiere esta asignación
  IF oDp:nVersion<6 .AND. Empty(oBrw:CARGO)
     oBrw:CARGO:=ACLONE(oLbx:oCursor:aDataFill)
  ENDIF

  FOR I=1 TO LEN(oBrw:aCols)

     oBrw:aCols[I]:nEditType:=1

     oBrw:aCols[I]:bOnPostEdit:={|oCol,uValue,nLastKey,nCol|EJECUTAR("LBXRUNFILTER",oDp:oLbx,oCol,uValue,nLastKey),oDp:oLbx:lFind:=.F.,KillFind(oDp:oLbx:oBrw,oDp:oLbx:oBrw:nColSel)}

  NEXT

// oCol:=oBrw:SelectedCol()
  oCol:=oBrw:aCols[oBrw:nColSel]
  oCol:Edit()

RETURN

