// Programa   : LBXLNKEXPORT
// Fecha/Hora : 03/11/2015 10:38:13
// Propósito  : Exportar Programas DpXbase
// Creado Por : Juan Navas
// Llamado por: DPPROGRA.LBX
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(oLbx)
  LOCAL aCodigos:={},cWhere

  IF !ValType(oLbx)="O"
     RETURN .F.
  ENDIF

  WHILE !oLbx:oCursor:Eof()
    AADD(aCodigos,oLbx:oCursor:LNK_TABLES)
    AADD(aCodigos,oLbx:oCursor:LNK_TABLED)
    oLbx:oCursor:DbSkip()
  ENDDO

  cWhere:=GetWhereOr("TAB_NOMBRE",aCodigos)

  EJECUTAR("DPTABSELEXP",cWhere)

RETURN NIL
// EOF


