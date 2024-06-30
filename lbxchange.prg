// Programa   : LBXCHANGE
// Fecha/Hora : 29/06/2024 03:58:09
// Propósito  : Ejecución dinámica en metodo bChange en ::oBrw en Objeto LBX
// Creado Por : Juan Navas
// Llamado por:
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(oLbx)
  LOCAL I,nCol,nEditType,oCol,cPicture

  FOR I=1 TO LEN(oLbx:aColEdit)

     nCol     :=oLbx:aColEdit[I,1]
     nEditType:=oLbx:aColEdit[I,4]
     nEditType:=IF(nEditType=0 .AND. !Empty(oLbx:aColEdit[I,3]),1,nEditType)
     oCol     :=oLbx:oBrw:aCols[nCol]
     cPicture :=oLbx:aColEdit[I,6]

     IF nEditType>0
        oCol:nEditType   :=nEditType
        oCol:cEditPicture:=STRTRAN(cPicture,",","")
        oCol:bOnPostEdit :={|oCol,uValue,nLastKey,nCol|EJECUTAR("LBXFIELDVALID",oDp:oLbx,oCol,uValue,nLastKey),oDp:oLbx:lFind:=.F.,KillFind(oDp:oLbx:oBrw,oDp:oLbx:oBrw:nColSel)}
     ENDIF

  
  NEXT I

RETURN .T.
// EOF

