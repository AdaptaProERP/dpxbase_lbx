// Programa   : LBXGOTFOCUS
// Fecha/Hora : 03/01/2024 10:16:31
// Propósito  : Restaura el focus del formulario LBX 
// Creado Por :
// Llamado por:
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(oLbx)
  LOCAL oFont,nAt
//  oDp:oFrameDp:SetText("aqui"+ValType(oLbx)+oLbx:Classname())

  IF oLbx=NIL
     RETURN NIL
  ENDIF

  // DEFINE FONT oFont (oLbx:oBrw:oFont:cFaceName)

  DEFINE FONT oFont NAME (oLbx:oBrw:oFont:cFaceName) SIZE oLbx:oBrw:oFont:nInpWidth,oLbx:oBrw:oFont:nInpHeight

  nAt  :=oLbx:oBrw:nArrayAt
  oFont:=oLbx:oBrw:oFont
  oLbx:oBrw:SetFont(oFont)

  oLbx:oBrw:Refresh(.F.)
  oLbx:oBrw:nArrayAt:=nAt


IF .F.
  releasefont() // 01/01/2024
  DEFINE FONT oFont NAME (oLbx:oBrw:oFont:cFaceName) SIZE oLbx:oBrw:oFont:nInpWidth,oLbx:oBrw:oFont:nInpHeight

  oLbx:oBrw:SetFont(oFont)


  oDp:oFrameDp:SetText(oLbx:oBrw:oFont:cParam) // LSTR(oLbx:oBrw:oFont:nInpHeight))
ENDIF
 

RETURN NIL

