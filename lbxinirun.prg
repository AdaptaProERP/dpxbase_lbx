// Programa   : LBXINIRUN
// Fecha/Hora : 15/04/2018 12:31:05
// Propósito  : Inicio para Buscar Productos
// Creado Por : Juan Navas
// Llamado por:
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(oLbx)
  LOCAL cFieldFind,nColSel:=2
  LOCAL lIniFilter:=CTOO(oLbx:cIniFilter,"L")

  SysRefresh(.T.)

//? lIniFilter,"lIniFilter"

  IF !Empty(oLbx:cIniFilter) .AND. oLbx:oCursor:Recno()=1 .AND. lIniFilter 
     // Debe Blanquear el Contenido
    
     EJECUTAR("LBXSETINIFILTER",oLbx)

     oLbx:oBrw:Refresh(.T.)

     DPFOCUS(oLbx:oBrw)
     // 02/02/2021 Vacia un Registro

     IF !"WHERE "$oLbx:cSql
       AEVAL(oLbx:oCursor:aFields,{|a,n| oLbx:oCursor:Replace(a[1],CTOFILL(oLbx:oCursor:Fieldget(n)))})
     ENDIF
  
     cFieldFind:="INV_DESCRI"

     oLbx:oBrw:Refresh(.T.)
     oLbx:oBrw:GotFocus(.T.)
     oLbx:oBrw:nColSel:=2
     oLbx:oBrw:aCols[2]:Edit(.T.)

     DPFOCUS(oLbx:oBrw)

  ENDIF

// ? oLbx:lGoBottom,"oLbx"

IF !oLbx:lGoBottom
//  oLbx:oBrw:GoTop()
//  oLbx:oBrw:Refresh(.T.)
//  oLbx:oBrw:GotFocus(.T.)
ENDIF

RETURN NIL

FUNCTION CTOFILL(uValue)
    LOCAL nLen

    IF ValType(uValue)="C"
       uValue:=CHR(29)+PADR(" ",LEN(uValue))+CHR(29)
    ENDIF

RETURN uValue

// EOF
