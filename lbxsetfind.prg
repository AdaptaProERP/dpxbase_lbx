// Programa   : LBXSETFIND	
// Fecha/Hora : 27/01/2015 13:41:43
// Propósito  : Ejecutar Busquedas de LBX
// Creado Por :
// Llamado por:
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(oLbx,lFind)

  LOCAL I,oCol,oTable,cWhere:="",nAt,cField,oBrw

  DEFAULT lFind:=.T.

  IF oLbx=NIL
     RETURN .F.
  ENDIF

  oBrw:=oLbx:oBrw
//  oBrw:CancelEdit() // JN 15/04/2016 Crea marca blanca
  KILLFIND(oBrw,NIL)

  IF EMPTY(oLbx:aZero)

    cWhere:="CAM_TABLE = '"+oLbx:oCursor:cFileName+"'"
    oTable:=OPENTABLE("SELECT * FROM DPCAMPOS WHERE "+ cWhere , .T. )

    WHILE !oTable:Eof()
       FOR I := 1 TO LEN(oLbx:oCursor:aFields)
         IF ALLTRIM(UPPE(oLbx:oCursor:aFields[I,1]))=ALLTRIM(UPPE(oTable:CAM_NAME))
            AADD(oLbx:aZero,CTOLOG(oTable:CAM_ZERO))
         ENDIF
       NEXT

       oTable:DbSkip()
    ENDDO
    oTable:End()

  ENDIF

  IF oLbx:lFind
     oLbx:lFind:=.f.
     oLbx:oBrw:CancelEdit()
     Return killfind(oBrw)
  ENDIF

  oLbx:lFind:=.T.

  FOR I=1 TO LEN(oLbx:oBrw:aCols)

     oLbx:oBrw:aCols[I]:nEditType:=1

     IF lFind
/*
       oLbx:oBrw:aCols[I]:bOnPostEdit:={|oCol,uValue,nLastKey,nCol|oDp:oLbx:DbSeek(oCol,uValue,nLastKey),;
                                                                   oDp:oLbx:lFind:=.F.,;
                                                                   EJECUTAR("LBXSAVEFIND",oDp:oLbx),;
                                                                   KillFind(oDp:oLbx:oBrw,oDp:oLbx:oBrw:nColSel)}
*/

       oLbx:oBrw:aCols[I]:bOnPostEdit:={|oCol,uValue,nLastKey,nCol|oDp:oLbx:DbSeek(oCol,uValue,nLastKey),;
                                                                   oDp:oLbx:lFind:=.F.,;
                                                                   KillFind(oDp:oLbx:oBrw,oDp:oLbx:oBrw:nColSel),;
                                                                   EJECUTAR("LBXSAVEFIND",oDp:oLbx)}
//,;
//                                                                   KillFind(oDp:oLbx:oBrw,oDp:oLbx:oBrw:nColSel)}

     ELSE
       // Localizar
       oLbx:oBrw:aCols[I]:bOnPostEdit:={|oCol,uValue,nLastKey,nCol|EJECUTAR("LBXFILTER",oDp:oLbx,oCol,uValue,nLastKey),::lFind:=.F.,KillFind(oDp:oLbx:oBrw,oDp:oLbx:oBrw:nColSel)}
     ENDIF

  NEXT

//oCol:= oLbx:oBrw:SelectedCol()
  oCol:= oLbx:oBrw:aCols[oLbx:oBrw:nColSel]
  oCol:Edit()

RETURN NIL
// eof
