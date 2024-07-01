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

   oLbx:lONCHANGE:=.F.

   nAt:=AT("FUNCTION",oLbx:cMemo)
   
   IF nAt=0 

      oLbx:cProgram:=GetLbx("SCRIPT",NIL,"C")

      // nombre del Programa DpXbase
      IF Empty(oLbx:cProgram)
         RETURN oScript 
      ENDIF

      oScript:=XCOMPILA(oLbx:cProgram) // utiliza un programa DpXbase

   ELSE

      oLbx:cScript:=SUBS(oLbx:cMemo,nAt,LEN(oLbx:cMemo))
      oLbx:cScript:=STRTRAN(oLbx:cScript,CHR(13)+CHR(13),"") // resuelve funciones no encontrada
      // oLbx:cScript:=STRTRAN(oLbx:cScript,CHR(09)        ,"") // resuelve funciones no encontrada
      // oLbx:cScript:=STRTRAN(oLbx:cScript,CHR(10)        ,"") // resuelve funciones no encontrada


      oScript:=TScript():New("")
      oScript:cProgram:=cFileNoPath(cFileNoExt(oLbx:cFileLbx))
      oScript:Reset()
      oScript:lPreProcess := .T.
      oScript:cClpFlags   := "/i"+Alltrim(oDp:cPathInc)
      oScript:Compile(oLbx:cScript)

      // Error de Compilación
      IF !Empty(oScript:cError)
        MsgMemo("Error Compilación"+oScript:cError,oLbx:cFileLbx)
        oScript:End()
        RETURN NIL
      ENDIF

   ENDIF

   oLbx:oScript:=oScript

   IF ValType(oLbx:oScript)="O" .AND. oLbx:oScript:IsFunction("ONCHANGE")
      oLbx:lONCHANGE:=.T.
   ENDIF

RETURN oScript
// EOF
