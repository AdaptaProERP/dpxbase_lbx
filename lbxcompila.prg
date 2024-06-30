// Programa   : LBXCOMPILA
// Fecha/Hora : 29/06/2024 02:23:20
// Propósito  : Compila lista de funciones declaradas dentro del mismo formulario LBX
// Creado Por : Juan Navas
// Llamado por:
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(oLbx)
   LOCAL oScript:=NIL,nAt

   nAt:=AT("FUNCTION",oLbx:cMemo)
   
   IF nAt=0 
       RETURN oScript 
   ENDIF

   oLbx:cScript:=SUBS(oLbx:cMemo,nAt,LEN(oLbx:cMemo))

   oScript:=TScript():New("")
   oScript:cProgram:=cFileNoPath(cFileNoExt(oLbx:cFileLbx))
   oScript:Reset()
   oScript:lPreProcess := .T.
   oScript:cClpFlags   := "/i"+Alltrim(oDp:cPathInc)
   oScript:Compile(oLbx:cScript)

   // Error de Compilación
   IF !Empty(oScript:cError)
      oScript:End()
      RETURN NIL
   ENDIF
   
   oLbx:oScript:=oScript

RETURN oScript
// EOF
