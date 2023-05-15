// Programa   : DPLBXEDIT
// Fecha/Hora : 26/06/2008 22:53:57
// Propósito  : Test para Editar Casillas LBX
// Creado Por :
// Llamado por:
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(oLbx,uValue,nLastKey,nCol)
  LOCAL nCol:=3,oCol,oBrw,cCod

  IF oLbx=NIL

    oLbx:=DPLBX("DPINVEDIT.LBX")

    RETURN .T.

  ENDIF

  IF oLbx:ClassName()="TDPLBX"

    oLbx:oBrw:nColSel:=3
    oCol:=oLbx:oBrw:aCols[3]
    oCol:nEditType:=1
    oLbx:oBrw:Cargo:={oLbx:oCursor:INV_CODIGO,oLbx}
    oCol:bOnPostEdit  :={|oCol,uValue,nLastKey,nCol|oCol:nEditType:=0,oCol:bOnPostEdit:=NIL,;
                          EJECUTAR("DPLBXEDIT",oCol,uValue,nLastKey,nCol)}

    oCol:Edit(1)

    RETURN .T.

  ENDIF
  
  IF "BRW"$oLbx:ClassName()

     cCod:=oLbx:oBrw:Cargo[1]
     oLbx:=oLbx:oBrw:Cargo[2]

     SQLUPDATE("DPINV","INV_IMPPVP",uValue,"INV_CODIGO"+GetWhere("=",cCod))

     oLbx:Refresh()
     oLbx:oBrw:KeyBoard(VK_DOWN) // Bajar
  ENDIF

RETURN
