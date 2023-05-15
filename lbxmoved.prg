// Programa   : LBXMOVED
// Fecha/Hora : 13/12/2016 11:09:34
// Propósito  : Ejecución Cuando una Ventana MDI del formulario LBX es movida y esta fuera del area visual
// Creado Por : Juan Navas
// Llamado por: DPLBX/oBrw:bResized
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(oLbx,oWnd,oBrw)
  LOCAL aWndSize:={}
  LOCAL nHeight
//LOCAL aCoor:=GetCoors( GetDesktopWindow()) // Capacidad Visual
  LOCAL nMaxH:=GetCoors( GetDesktopWindow())[3]-150 // 1024 Maxima Capacidad del Video-Titulo-Menu-Area de Botones-Aerea de Mensajes
  LOCAL nDif // Diferencia extralimitada

  IF oLbx=NIL
     RETURN .F.
  ENDIF

//  oDp:oFrameDp:SetText(lstr(aCoor[1])+","+lstr(aCoor[2])+","+lstr(aCoor[3])+","+lstr(aCoor[4])+" max "+lstr(nMaxH))

  oWnd:CoorsUpdate() // Actualiza ::nTop
  nHeight:=oWnd:nTop+oWnd:nHeight // Altura + Posición del Area de la Ventana MDI que Ocupa LBX
  nDif   :=nMaxH-nHeight

//  oWnd:SetText("MOVED"+lstr(seconds())+"/"+oWnd:Classname()+"/"+LSTR(oWnd:nTop)+","+LSTR(oWnd:nLeft)+","+LSTR(oWnd:nWidth)+","+LSTR(oWnd:nHeight))
//  oWnd:SetText("MOVED"+lstr(nHeight)+" EXTRA "+LSTR(nDif))
  
  // Reduce el Alto de la Ventana
  IF nDif<0
     oWnd:SetSize(NIL,MAX(oWnd:nHeight+nDif,110))
  ENDIF


RETURN .T.
// EOF
