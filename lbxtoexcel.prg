// Programa   : LBXTOEXCEL
// Fecha/Hora : 28/06/2012 15:55:20
// Prop�sito  : Exportar Contenido de Browse LBX hacia EXCEL
// Creado Por : Juan Navas
// Llamado por:
// Aplicaci�n :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(oLbx,cEmpresa,cTitle)
   LOCAL cSql,aData

   IF !ValType(oLbx)="O"
      RETURN NIL
   ENDIF

   DEFAULT cEmpresa:=oDp:cEmpresa,;
           cTitle  :=oLbx:cTitle


   aData:=ASQL(oLbx:cSql)

   oLbx:oBrw:aArrayData:=ACLONE(aData)

   cTitle:=GetFromVar(cTitle)
   
   EJECUTAR("BRWTOEXCEL",oLbx:oBrw,cEmpresa,cTitle)

RETURN
// EOF
