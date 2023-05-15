// Programa   : LBXREPEXPORT
// Fecha/Hora : 03/11/2015 10:38:13
// Propósito  : Exportar Programas DpXbase
// Creado Por : Juan Navas
// Llamado por: DPPROGRA.LBX
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(oLbx)
  LOCAL aCodigos:={}

  IF !ValType(oLbx)="O"
     RETURN .F.
  ENDIF

  WHILE !oLbx:oCursor:Eof()
    AADD(aCodigos,oLbx:oCursor:REP_CODIGO)
    oLbx:oCursor:DbSkip()
  ENDDO

  EJECUTAR("DPREPSELEXP",aCodigos,.F.)

RETURN NIL
// EOF


