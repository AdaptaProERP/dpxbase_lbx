// Programa   : LBXFILTERLOGRUN
// Fecha/Hora : 18/02/2020 12:31:54
// Propósito  :
// Creado Por :
// Llamado por:
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(oLbx)
  LOCAL aData,cWhere,aExcluye,aTotales:={}
  LOCAL cId  
  LOCAL oData

  IF oLbx=NIL
     RETURN NIL
  ENDIF

  aExcluye:=GetExcluye(oLbx:cTable)

  DEFAULT oDp:cFilterIni:=aExcluye[2]

  cWhere  :=oLbx:cFilter_Log+GetWhere("<>",oLbx:lFilterLog)

  IF oLbx:lFilterLog

    IF !Empty(oDp:cFilterIni)

       cWhere  :=oLbx:cFilter_Log+GetWhere("=",oLbx:lFilterLog)
       cWhere:=oDp:cFilterIni+" AND "+cWhere

//? cWhere,"FILTRADO"

    ELSE

       cWhere  :=oLbx:cFilter_Log+GetWhere("<>",oLbx:lFilterLog)

    ENDIF
    
// ? cWhere,"cWhere"

    SETEXCLUYE(oLbx:cTable,cWhere)

  ELSE

    SETEXCLUYE(oLbx:cTable,IF(Empty(oDp:cFilterIni),NIL,oDp:cFilterIni))

  ENDIF

  cWhere:=aExcluye[2]

// ? cWhere,"cWhere INICIAL"

  aData:=ASQL(oLbx:cSql)

//? oDp:cSql
  // Restaura, Exclusion

  SETEXCLUYE(oLbx:cTable,aExcluye[2])

//? oLbx:cFilter_Log,"cFilter_Log",cWhere
//? oLbx:cTable,oLbx:lFilterLog,CLPCOPY(oLbx:cSql)

  IF !Empty(aData)
     oLbx:oCursor:aDataFill:=ACLONE(aData)
     oLbx:oBrw:Gotop()
     oLbx:oBrw:Refresh(.T.)

     IF oLbx:oBrw:lFooter
       aTotales:=ATOTALES(oLbx:oCursor:aDataFill)
       EJECUTAR("BRWCALTOTALES",oLbx:oBrw,NIL,aTotales)
     ENDIF

  ENDIF

  cId:="LBX"+oLbx:cTable

  oData:=DATASET(cId,"USER")
  oData:Set(cId,oLbx:lFilterLog)
  oData:Save()
  oData:End()


//  ViewArray(aData)

RETURN NIL
// EOF

