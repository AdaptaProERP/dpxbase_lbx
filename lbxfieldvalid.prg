// Programa   : LBXFIELDVALID
// Fecha/Hora : 30/06/2024 03:42:30
// Prop�sito  : VALIDACION DEL CAMPO
// Creado Por : Juan Navas
// Llamado por:
// Aplicaci�n :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(oLbx,oCol,uValue,nLastKey)
  LOCAL nField,cFunction,lValid:=.F.,cWhere,cKey

  IF !Empty(oCol:cField)

     nField   :=oCol:nColArray

     IF Empty(cFunction)

        cKey:=oLbx:cOrderBy

        IF Empty(cKey)
          cKey:=oLbx:cPrimary
        ENDIF

        IF Empty(cKey)
           MsgMemo("Requiere Campo Clave para Editar el Registro")
           RETURN .F.
        ENDIF

        cWhere:=oLbx:oCursor:GetWhereKey(cKey)

        lValid:=.T.

        SQLUPDATE(oLbx:cTable,oCol:cField,uValue,cWhere)

     ELSE

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
     ENDIF

     IF lValid
       oLbx:oCursor:aDataFill[oLbx:oCursor:Recno(),nField]:=uValue
       oLbx:oBrw:DrawLine(.T.)
     ENDIF

  ENDIF

RETURN .T.
// EOF
