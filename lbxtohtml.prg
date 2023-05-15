// Programa   : LBXTOHTML
// Fecha/Hora : 28/06/2012 15:55:20
// Propósito  : Exportar Contenido de Browse LBX hacia HTML
// Creado Por : Juan Navas
// Llamado por:
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(oLbx,cEmpresa,cTitle,lAll,nColDescri,nColMemo)
   LOCAL cSql,aData,aHead:=NIL

   IF !ValType(oLbx)="O"
      RETURN NIL
   ENDIF

   DEFAULT cEmpresa:=oDp:cEmpresa,;
           cTitle  :=oLbx:cTitle,;
           lAll    :=.F.

   IF lAll

     aData:=ASQL(oLbx:cSql)
     oLbx:oBrw:aArrayData:=ACLONE(aData)

   ELSE

     oLbx:oBrw:aArrayData:=ACLONE(oLbx:oCursor:aDataFill)

   ENDIF


//   ? oLbx:oCursor:Browse()

   cTitle:=GetFromVar(cTitle)

// ViewArray(oLbx:oBrw:aArrayData)
// ? oLbx,cEmpresa,cTitle,lAll,nColDescri,nColMemo,"oLbx,cEmpresa,cTitle,lAll,nColDescri,nColMemo"
   
   EJECUTAR("BRWTOHTML",oLbx:oBrw,NIL,cTitle,aHead,aData,nColDescri,nColMemo)

RETURN
// EOF
