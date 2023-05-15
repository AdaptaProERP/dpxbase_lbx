// Programa   : LBXSAVEFIND
// Fecha/Hora : 02/02/2015 04:22:53
// Propósito  : Guardar Búsquedas por Tabla desde DPLBX
// Creado Por : Juan Navas
// Llamado por:
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(oLbx,cType)
  LOCAL cGroup
  LOCAL oData,cPos:="D"+DTOS(oDp:dFecha)+STRTRAN(TIME(),":","")
  LOCAL cTable,cField,uValue,nCol,cDsn,lConfig:=.F.
  LOCAL nAt,nRowSel

  IF oLbx=NIL
    RETURN NIL
  ENDIF

  DEFAULT cType:="FIND"

  nCol  :=oLbx:oBrw:nColSel
  cTable:=oLbx:oCursor:cTable
  cField:=oLbx:oCursor:aFields[nCol,1]
  uValue:=oLbx:oCursor:FieldGet(nCol)

  nAt    :=oLbx:oBrw:nArrayAt
  nRowSel:=oLbx:oBrw:nRowSel 

  IF nAt>0 .AND. nRowSel>0
    oLbx:oBrw:Refresh(.F.)
    oLbx:oBrw:nArrayAt:=nAt
    oLbx:oBrw:nRowSel :=nRowSel
  ENDIF

//  oLbx:oBrw:Refresh(.T.) //  JN 15/04/2016

  IF Empty(uValue)
     RETURN .F.
  ENDIF   

//cGroup:=ALLTRIM(cTable)+"."+ALLTRIM(cField)

  cGroup:=ALLTRIM(cTable)+"."+cType+"."+ALLTRIM(cField)

  lConfig:=(oLbx:oCursor:oOdbc:cDsn=oDp:cDsnConfig)

  IF lConfig 

    SQLDELETE("DPDATACNF","DAT_GROUP"+GetWhere("=",cGroup)+" AND DAT_VALUE"+GetWhere("=",uValue))
    oData:=DATACONFIG(cGroup,"USER")

  ELSE

    SQLDELETE("DPDATASET","DAT_GROUP"+GetWhere("=",cGroup)+" AND DAT_VALUE"+GetWhere("=",uValue))
    oData:=DATASET(cGroup,"USER")

  ENDIF

  oData:Set(cPos,uValue)
  oData:Save()
  oData:End()

RETURN NIL
// EOF

