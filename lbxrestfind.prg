// Programa   : LBXRESTFIND
// Fecha/Hora : 02/02/2014 07:03:06
// Propósito  : Recuperar Registros Buscados mediante LBXSAVEFIND
// Creado Por : Juan Navas
// Llamado por:
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(oLbx,cType)
   LOCAL cGroup,cWhere:="",aFields:={},uValue,cRefere,aTitle:={},cDataSet,aData:={},lConfig
   LOCAL cTable,cField

   IF oLbx=NIL
      RETURN NIL
   ENDIF

   DEFAULT cType:="FIND",;
           oDp:nLimitFind:=15

   cTable:=oLbx:oCursor:cTable
   cField:=oLbx:oCursor:aFields[1,1]
   cGroup:=ALLTRIM(cTable)+"."+cType+"."+ALLTRIM(cField)

   cWhere:="DAT_GROUP"+GetWhere("=",cGroup)

   AADD(aFields,"DAT_VALUE")
   AADD(aTitle ,"Código"   )

   lConfig :=(oLbx:oCursor:oOdbc:cDsn=oDp:cDsnConfig)
   cDataSet:=IIF(lConfig,"DPDATACNF",oDp:cDPDATASET)

   aData   :=ASQL("SELECT DAT_VALUE FROM "+cDataSet+" WHERE "+cWhere+" GROUP BY DAT_VALUE ORDER BY CONCAT(DAT_FECHA,DAT_HORA) DESC LIMIT "+LSTR(oDp:nLimitFind))

   AEVAL(aData,{|a,n| aData[n]:=ALLTRIM(a[1])})

RETURN aData
// EOF

