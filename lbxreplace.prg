// Programa   : LBXREPLACE
// Fecha/Hora : 30/06/2024 14:36:06
// Propósito  : Actualizar Visualmente Browse
// Creado Por : Juan Navas
// Llamado por: oLbx:Replace(cField,uValue)
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(oLbx,cField,uValue,lSay)
    LOCAL nField:=0

    DEFAULT lSay:=.T.

    IF oLbx=NIL
       RETURN .F.
    ENDIF

    nField:=oLbx:oCursor:FieldPos(cField)

    IF ValType(nField)="N" .AND. nField>0

       oLbx:oCursor:aDataFill[oLbx:oCursor:Recno(),nField]:=uValue

       IF lSay
         oLbx:oBrw:DrawLine(.T.)
       ENDIF

    ENDIF

RETURN .T.
// EOF
