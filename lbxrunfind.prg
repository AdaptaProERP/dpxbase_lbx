// Programa   : LBXRUNFIND
// Fecha/Hora : 03/02/2015 10:57:59
// Prop�sito  : Buscar Texto
// Creado Por : Juan navas
// Llamado por: Boton Buscar
// Aplicaci�n :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(uValue,nCol)
   
   IF Empty(uValue)
      RETURN NIL
   ENDIF

   DEFAULT nCol:=1

   IF !Empty(oDp:oLbx:aCargo)
     oDp:oLbx:oCursor:aDataFill:=ACLONE(oDp:oLbx:aCargo)
     oDp:oLbx:oBrw:Refresh(.T.)

     IF oDp:nVersion>=5.1
        oDp:oLbx:oBrw:lSetFilter:=.T.
     ENDIF

   ENDIF

   oDp:oLbx:DbSeek2(oDp:oLbx:oBrw:aCols[nCol],uValue,NIL)
   oDp:oLbx:Refresh(.F.)

RETURN NIL
// EOF
