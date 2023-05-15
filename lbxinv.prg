// Programa   : LBXINV
// Fecha/Hora : 15/04/2018 12:38:46
// Propósito  :
// Creado Por :
// Llamado por:
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN()
  LOCAL oLbx,cFieldFind,nColSel:=2

  oLbx:=DPLBX("DPINV.LBX")

  SysRefresh(.T.)

 //? oLbx:cIniFilter,oLbx:oCursor:Recno()

  IF !Empty(oLbx:cIniFilter) .AND. oLbx:oCursor:Recno()=1 .AND. .F.
     // Debe Blanquear el Contenido

     EJECUTAR("LBXSETINIFILTER",oLbx)

     oLbx:oBrw:Refresh(.T.)

     DPFOCUS(oLbx:oBrw)
     AEVAL(oLbx:oCursor:aFields,{|a,n| oLbx:oCursor:Replace(a[1],CTOFILL(oLbx:oCursor:Fieldget(n)))})
  
     cFieldFind:="INV_DESCRI"
     oLbx:oBrw:Refresh(.T.)
     oLbx:oBrw:GotFocus(.T.)
     oLbx:oBrw:nColSel:=2
     oLbx:oBrw:aCols[2]:Edit(.T.)

  ENDIF


// ?  oLbx:oCursor:cSql
// ? oLbx:cIniFilter

RETURN

FUNCTION CTOFILL(uValue)
    LOCAL nLen

    IF ValType(uValue)="C"
       uValue:=CHR(28)+PADR(" ",LEN(uValue))+CHR(28)
    ENDIF

RETURN uValue
