// Programa   : MDILBXREFRESH
// Fecha/Hora : 27/02/2022 02:33:01
// Propósito  : Refrescar LBX
// Creado Por : Juan Navas
// Llamado por:
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(oMdi)
    LOCAL oDpLbx,aKey,cKey,I,oDpLbx

    IF oMdi:nNumLbx>0 // Refrescan los Datos el ListBox

       CursorWait()

       oDpLbx:=GetDpLbx(oMdi:nNumLbx)

       IF ValType(oDpLbx)="O" .AND. ALLTRIM(oDpLbx:cTable)=ALLTRIM(oMdi:oTable:cTable)


          IF oDpLbx:oCursor:RecCount()=0 // Ya Tiene el Primer Registro
             AEVAL(oDpLbx:aBtns,{|o|o[8]:Enable()})
          ENDIF

          aKey:=_VECTOR(oDpLbx:cOrderBy)

          cKey:=IIF( Len(aKey)>0,oMdi:Get(aKey[1]),NIL)

          oDpLbx:Refresh(oMdi:nOption=1,cKey)

          IF LEN(aKey)>1 .AND. ValType(cKey)="C"
             FOR I=2 TO LEN(aKey)
                aKey[I]:=ALLTRIM(aKey[I])
                // ? Ï,aKey[I],oDpLbx:cOrderBy
                cKey:=cKey+CTOO(oMdi:Get(aKey[I]),"C")
               NEXT
          ENDIF

       ELSE

          oDpLbx:=NIL


       ENDIF
       // JN 19/08/2013

       IF ValType(oDpLbx)="O"
        oDpLbx:Refresh(oMdi:nOption=1,cKey)
       ENDIF

    ENDIF

RETURN ValType(oDpLbx)="O"
// eof
