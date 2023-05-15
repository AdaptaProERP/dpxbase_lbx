// Programa   : LBXRESIZED
// Fecha/Hora : 13/12/2016 11:09:34
// Propósito  : Ejecución Cuando una Ventana MDI del formulario LBX es movida y esta fuera del area visual
// Creado Por : Juan Navas
// Llamado por: DPLBX/oBrw:bResized
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(oLbx,oWnd,oBrw)
  LOCAL aWndSize:={}

  IF oLbx=NIL
     RETURN .F.
  ENDIF

//  oWnd:SetText(lstr(seconds())+"/"+oWnd:Classname()+"/"+LSTR(oWnd:nTop())+"/"+LSTR(oWnd:nTop)+"-"+LSTR(oWnd:nLeft())+"-"+LSTR(oWnd:nWidth())+"- "+LSTR(oWnd:nHeight()))

   IF oWnd:nTop()<180
     // oWnd:Move(180,oWnd:nLeft(),NIL,NIL,.T.)
   ENDIF

RETURN .T.
// EOF
