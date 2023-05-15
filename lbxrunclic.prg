// Programa   : LBXRUNCLIC
// Fecha/Hora : 14/05/2023 19:07:21
// Propósito  : Ejecutar CLIC desde formulario LBX, pertimir editar el campo , caso de logico cambiarlo sin necesidad de modificar
// Creado Por : Juan Navas
// Llamado por:
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(oLbx)
    LOCAL cTable,cWhere:="",cField,nAt,bLDblClick:=NIL,I,aField,uValue,cKey:=""

    IF oLbx=NIL
       RETURN .F.
    ENDIF

    cField:=oLbx:cPrimary

    IF !Empty(oLbx:aColEdit) .AND. !Empty(cField)

       aField:=_VECTOR(cField)

       FOR I=1 TO LEN(aField)
           cWhere:=cWhere+IF(Empty(cWhere),""," AND ")+aField[I]+GetWhere("=",oLbx:oCursor:FieldGet(aField[I]))
           cKey  :=cKey  +IF(Empty(cKey  ),"",","    )+oLbx:oCursor:FieldGet(aField[I])
       NEXT I

       nAt   :=ASCAN(oLbx:aColEdit,{|a,n| a[1]=oLbx:oBrw:nColSel})
       uValue:=oLbx:oCursor:FieldGet(oLbx:aColEdit[nAt,2])

       IF nAt>0 .AND. AccessField(oLbx:cTable,oLbx:aColEdit[nAt,2],3) .AND. ValType(uValue)="L"
           SQLUPDATE(oLbx:cTable,oLbx:aColEdit[nAt,2],!uValue,cWhere) // Actualiza el Campo
           oLbx:oCursor:aDataFill[oLbx:oCursor:RecNo(),oLbx:oBrw:nColSel]:=!uValue // Actualiza el Browse
           oLbx:oBrw:DrawLine(.T.) // Refresca el browse
           AUDITAR("DMOD" , NIL ,oLbx:cTable, cKey) // Guarda Pista de Auditoría
           RETURN .T.
       ENDIF

     ENDIF

RETURN .F.
// EOF
