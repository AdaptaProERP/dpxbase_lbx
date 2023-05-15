// Programa   : LBXTIPPROVEEDOR
// Fecha/Hora : 30/08/2016 02:23:31
// Propósito  : Crear Lbx Tipo de Proveedpr
// Creado Por : Juan Navas
// Llamado por:
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(cTipo,lRun)
   LOCAL cFile,cFileOrg:="forms\dpproveedor.lbx"
   LOCAL oDpLbx

   DEFAULT cTipo:="Proveedor",;
           lRun :=.F.

   IF Empty(cTipo)
      cTipo:="Proveedor"
   ENDIF

   //SQLGET("DPTIPPROVEEDOR","TIP_CODIGO"),;

   IF "PROVEE"$UPPER(cTipo) 

      cFile:=cFileNoPath(cFileOrg)

      IF lRun
        DPLBX(cFile,cTipo,"PRO_TIPO"+GetWhere("=",cTipo))
      ENDIF

      RETURN cFile

   ENDIF

   cTipo:=ALLTRIM(cTipo)
   cFile:=LOWER("FORMS\DPPROVEEDOR_"+ALLTRIM(STRTRAN(cTipo," ","_"))+".LBX")

   IF !FILE(cFile)
      COPY FILE (cFileOrg) TO (cFile)
   ENDIF

   cFile:=cFileNoPath(cFile)

   IF lRun
      DPLBX(cFile,cTipo,"PRO_TIPO"+GetWhere("=",cTipo))
   ENDIF

RETURN cFile
// EOF
