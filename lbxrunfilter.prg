// Programa   : LBXRUNFILTER
// Fecha/Hora : 09/11/2014 21:48:32
// Propósito  : Ejecutar Filtro en Cursor SQL
// Creado Por : Juan Navas
// Llamado por: DPLBX:SetFilter()
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(oLbx,oCol,uValue,nLastKey)
  LOCAL aData:={},nCol,I,cLower:="",cWhere:="",cSql
  LOCAL aDataLbx:={},nAt,cTitle

  IF oLbx=NIL 
     RETURN .T.
  ENDIF

  IF Empty(oLbx:aCargo)
     oLbx:aCargo:=ACLONE(oLbx:oCursor:aDataFill)
  ENDIF

  nCol:=oCol:nPos

  oLbx:cWhere:=STRTRAN(oLbx:cWhere,CHR(28),"")

  IF ValType(uValue)="C"
     uValue:=ALLTRIM(STRTRAN(uValue,CHR(29),""))
  ENDIF

  IF Empty(uValue)
     CursorArrow()
     RETURN NIL
  ENDIF

  IF ValType(uValue)="C" .AND. !Empty(uValue)
    cWhere:=IF(Empty(oLbx:cWhere)," WHERE ", " AND ")+oLbx:oCursor:FieldName(nCol)+GetWhere(" LIKE ","%"+ALLTRIM(uValue)+"%")
  ENDIF

// ? cWhere,"AQUI"


  cSql:=STRTRAN(oLbx:cSqlFilter,CHR(28),cWhere)

// ? cSql
//
  oLbx:aCargo    :=ACLONE(oLbx:oCursor:aDataFill)
  oLbx:oBrw:CARGO:=ACLONE(oLbx:oCursor:aDataFill)

  CursorWait()

  MsgRun("Leyendo Tabla "+oLbx:oCursor:cTable)

  oLbx:OpenTable(cSql)

// oLbx:oCursor:Browse()
// ? oDp:cSql,oLbx:oCursor:RecCount()>0

  // Recarga y Copia el Contenido para la Opcion SETFILTER
  IF oLbx:oCursor:RecCount()>0
    oLbx:aCargo    :=ACLONE(oLbx:oCursor:aDataFill)
    oLbx:oBrw:CARGO:=ACLONE(oLbx:oCursor:aDataFill)
  ELSE
    oLbx:oCursor:aDataFill:=ACLONE(oLbx:aCargo)
//  oLbx:oBrw:Refresh(.T.)
  ENDIF

  cTitle:=oLbx:oWnd:cTitle
  nAt   :=AT(CHR(9),cTitle)

  IF nAt>0
    cTitle:=LEFT(cTitle,nAt-1)
    oLbx:oWnd:SetText(cTitle)
  ENDIF

  SysRefresh(.T.)

  oLbx:oBrw:Refresh(.T.)
    
  CursorWait()

// ? nCol,uValue,oLbx:oCursor:FieldName(nCol),oLbx:cSqlFilter,cSql

/*

  // Restaura contenido
  IF oDp:nVersion>=6 .AND. oLbx:oBrw:lSetFilter .AND. Empty(uValue)
     oLbx:oCursor:aDataFill:=ACLONE(oLbx:oBrw:aData)
     oLbx:oBrw:Refresh(.T.)
     oLbx:oBrw:lSetFilter:=.F.
     RETURN .F.
  ENDIF

  IF oDp:nVersion<6 .AND. !Empty(oLbx:oBrw:CARGO) .AND. Empty(uValue)
     oLbx:oCursor:aDataFill:=ACLONE(oLbx:oBrw:CARGO)
     oLbx:oBrw:Refresh(.T.)
     RETURN .F.
  ENDIF

  aDataLbx:=IIF(oDp:nVersion>=6,oLbx:oBrw:aData,oLbx:oBrw:CARGO)

  IF ValType(aDataLbx[1,nCol])<>ValType(uValue)
     uValue:=CTOO(uValue,ValType(aDataLbx[1,nCol]))
  ENDIF

  IF ValType(uValue)="C" .AND. !Empty(uValue)
     uValue:=ALLTRIM(uValue)
     cLower:=Lower(uValue)
     AEVAL(aDataLbx,{|a,n| IF(uValue$a[nCol] .OR. cLower$Lower(a[ncol]),AADD(aData,a),NIL)})
  ENDIF

  IF ValType(uValue)<>"C"
     AEVAL(aDataLbx,{|a,n| IF(uValue=a[nCol],AADD(aData,a),NIL)})
  ENDIF

  IF Empty(aData) .AND. !Empty(uValue)
     MensajeErr("No hay Coincidencia con "+CTOO(uValue,"C"))
     RETURN .F.
  ENDIF

  IF !Empty(aData)

     oLbx:oCursor:aDataFill:=ACLONE(aData)
     oLbx:oBrw:Refresh(.T.)

     IF oDp:nVersion>=6
        oLbx:oBrw:lSetFilter:=.T.
     ENDIF

  ENDIF
*/

RETURN .T.
// EOF

