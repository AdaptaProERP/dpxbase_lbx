// Programa   : LBXFIELDVALID
// Fecha/Hora : 30/06/2024 03:42:30
// Propósito  : VALIDACION DEL CAMPO
// Creado Por : Juan Navas
// Llamado por:
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(oLbx,oCol,uValue,nLastKey)
  LOCAL nField,cFunction,lValid:=.F.
  
  IF !Empty(oCol:cField)

     nField   :=oCol:nColArray
     cFunction:=oCol:cFunction

     IF ValType(oLbx:oScript)="O" 

        IF oLbx:oScript:IsFunction(cFunction)

           lValid:=oLbx:oScript:Run(cFunction,uValue,oCol,oLbx,oLbx:oCursor)

           // ? lValid,cFunction,uValue,oCol,oLbx,oLbx:oCursor

           IF ValType(lValid)<>"L"
              lValid:=.F.
           ENDIF

        ELSE

           MsgMemo("FUNCTION "+cFunction+" no existe en Formulario "+oLbx:cFileLbx)

           EJECUTAR("INSPECT",oLbx:oScript)

        ENDIF

     ENDIF

     IF lValid
       oLbx:oCursor:aDataFill[oLbx:oCursor:Recno(),nField]:=uValue
       oLbx:oBrw:DrawLine(.T.)
     ENDIF

// ? oLbx:oCursor:Recno(),"RECNO",nField,"nField",oCol:cFunction,oLbx:oScript:ClassName()
// ViewArray(oLbx:oCursor:aDataFill)

  ENDIF

RETURN .T.
// EOF
