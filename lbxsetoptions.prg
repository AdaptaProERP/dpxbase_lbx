// Programa   : LBXSETOPTIONS
// Fecha/Hora : 10/11/2014 02:35:23
// Propósito  : Asignar Busquedas por Opciones del Contenido del Campo
// Creado Por :
// Llamado por:
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(oLbx)
  LOCAL oCol,aData:={},nCol,I,nAt,oBrw,aDataTxt:={}
  LOCAL aDataBrw:={}

  IF oLbx=NIL
     RETURN .F.
  ENDIF

  oBrw:=oLbx:oBrw

  IF oDp:nVersion>=6 .AND. Empty(oBrw:aData) 
     oBrw:aData:=oBrw:aArrayData
  ENDIF

  IF oDp:nVersion<6 .AND. Empty(oBrw:CARGO) 
     oBrw:CARGO:=oLbx:oCursor:aDataFill
  ENDIF

  aDataBrw:=IF(!Empty(oBrw:CARGO),oBrw:CARGO,oBrw:aData)

  oCol:=oBrw:SelectedCol()
  nCol:=oCol:nPos

  FOR I=1 TO LEN(aDataBrw)
    nAt:=ASCAN(aData,aDataBrw[I,nCol])
    IF nAt=0
      AADD(aData,aDataBrw[I,nCol])
    ENDIF
  NEXT 

  IF !(LEN(aData)>1 .AND. LEN(aData)<>LEN(aDataBrw))
     RETURN .T.
  ENDIF

  aData:=ASORT(aData)

  IF ValType(aData[1])="C"
    aDataTxt:=aData
  ELSE
    AEVAL(aData,{|a,n|AADD(aDataTxt,CTOO(a,"C"))})
  ENDIF

  
  oCol:aEditListTxt   :=aDataTxt
  oCol:aEditListBound :=aData
  oCol:nEditType      :=EDIT_LISTBOX
  oCol:bOnPostEdit  :={|oCol,uValue|EJECUTAR("BRWOPTIONS",oCol,uValue,oDp:oLbx)}
  oCol:Edit()

RETURN .T.
// EOF



