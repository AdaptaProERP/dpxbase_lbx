// Programa   : DPPROVPROGLBX   
// Fecha/Hora : 13/03/2007 17:07:54
// Propósito  : Crear Planificación de Compromisos
// Creado Por : Juan Navas
// Llamado por: DPPROVEEDORMNU
// Aplicación : Compras
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(cCodSuc,cCodigo,lView)

   LOCAL oLbx
   LOCAL cWhere,cTitle,cNombre,cFileLbx:="DPPROVEEDORPROG.LBX"

   DEFAULT cCodSuc:=oDp:cSucursal,;
           cCodigo:=STRZERO(1,10),;
           lView  :=.F.

   IF !EJECUTAR("DPREQVERSION",4.1)
      RETURN .F.
   ENDIF

   cNombre:=MYSQLGET("DPPROVEEDOR","PRO_NOMBRE","PRO_CODIGO"+GetWhere("=",cCodigo))

   cTitle:=ALLTRIM(GetFromVar("{oDp:DPPROVEEDORPROG}"))+;
          " ["+cCodigo+" "+ALLTRIM(cNombre)+" ]"

   cWhere:="PGC_CODSUC"+GetWhere("=",cCodSuc)+" AND "+;
           "PGC_CODIGO"+GetWhere("=",cCodigo)


   IF lView .AND. MYCOUNT("DPPROVEEDORPROG",cWhere)=0

      MensajeErr(oDp:xDPPROVEEDOR+": "+cCodigo+" "+cNombre+CRLF+"NO Posee "+oDp:DPPROVEEDORPROG)
      EJECUTAR("BRDOCPROCREAPLA","DOC_CODIGO"+GetWhere("=",cCodigo),NIL,11)
      RETURN .F.

   ENDIF

   cFileLbx:=IIF( lView ,"DPPROVEEDORPROGCON.LBX" , cFileLbx )

   oDp:aRowSql:={} // Lista de Campos Seleccionados

   oDpLbx:=TDpLbx():New(cFileLbx,cTitle,cWhere,NIL,NIL,{cCodigo,cNombre})
   oDpLbx:uValue1:=cCodigo
   oDpLbx:uValue2:=cNombre

   oDpLbx:Activate()

   oDpLbx:uValue1:=cCodigo
   oDpLbx:uValue2:=cNombre

RETURN .T.
// EOF
