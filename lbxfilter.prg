// Programa   : LBXFILTER
// Fecha/Hora : 09/11/2014 21:48:32
// Propósito  : Aplicar Filtros en Registros
// Creado Por : Juan Navas
// Llamado por: DPLBX:SetFilter()
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(oLbx,oCol,uValue,nLastKey)
  LOCAL aData:={},nCol,I,cLower:=""
  LOCAL aDataLbx:={},cSql

  IF oLbx=NIL 
     RETURN .T.
  ENDIF

//  IF Empty(oLbx:aCargo)
//     oLbx:aCargo:=ACLONE(oLbx:oCursor:aDataFill)
//  ENDIF

  IF Empty(uValue) .AND. !Empty(oLbx:cIniFilter) .AND. oLbx:oCursor:Recno()=1
     MsgRun("Leyendo")
     cSql:=STRTRAN(oLbx:cSqlFilter,CHR(28),"")
     CursorWait()
     oLbx:OpenTable(cSql)
     oLbx:aCargo    :=ACLONE(oLbx:oCursor:aDataFill)
     oLbx:oBrw:CARGO:=ACLONE(oLbx:oCursor:aDataFill)
     oLbx:cIniFilter:="" // Ya no es Necesario
     RETURN .T.
  ENDIF

  IF !Empty(oLbx:cIniFilter)
     EJECUTAR("LBXRUNFILTER",oLbx,oCol,uValue,nLastKey)
     RETURN .F.
  ENDIF

  IF Empty(oLbx:aCargo)
     oLbx:aCargo:=ACLONE(oLbx:oCursor:aDataFill)
  ENDIF


  nCol:=oCol:nPos

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

RETURN .T.
// EOF
