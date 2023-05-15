// Programa   : LBXPRGEXPORT
// Fecha/Hora : 03/11/2015 10:38:13
// Prop�sito  : Exportar Programas DpXbase
// Creado Por : Juan Navas
// Llamado por: DPPROGRA.LBX
// Aplicaci�n :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(oLbx)
  LOCAL aCodigos:={}

  IF !ValType(oLbx)="O"
     RETURN .F.
  ENDIF

  WHILE !oLbx:oCursor:Eof()
    AADD(aCodigos,oLbx:oCursor:PRG_CODIGO)
    oLbx:oCursor:DbSkip()
  ENDDO

  EJECUTAR("DPPRGSELEXP",aCodigos,.F.)

RETURN NIL
// EOF

