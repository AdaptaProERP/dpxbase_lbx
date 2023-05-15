// Programa   : DPLBXADDBTN
// Fecha/Hora : 16/04/2016
// Propósito  : Aegregar Espacio para Botones
// Creado Por : Juan Navas
// Llamado por:
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(cFileLbx)

   DEFAULT cFileLbx:="FORMS\DPLINK.LBX" 

   oFrm:=DPEDIT():New("Mover Botones en "+cFileLbx,"DPLBXADDBTN.edt","oFrm",.T.)

   oFrm:nDesde  :=5
   oFrm:cMemo   :=MemoRead(cFileLbx)
   oFrm:cFileLbx:=cFileLbx

   @ 1,01 LABEL "Desde: " RIGHT

   @ 2,01 Get oFrm:nDesde SPINNER PICTURE "99" RIGHT
   
   @ 5,06 GET oFrm:oMemo VAR oFrm:cMemo MULTI READONLY HSCROLL

   @ 2,1 BUTTON " > "       ACTION oFrm:LBXBTNADD()
   @ 2,1 BUTTON " Guardar " ACTION DPWRITE(oFrm:cFileLbx,ALLTRIM(oFrm:cMemo))
   @ 2,1 BUTTON " Salir "   ACTION oFrm:Close()

   oFrm:Activate()

   IF .T.
     oDp:nDif:=(oDp:aCoors[3]-180-oFrm:oWnd:nHeight())
     oFrm:oWnd:SetSize(oDp:aCoors[4]-10,oDp:aCoors[3]-190,.T.)
     oFrm:oMemo:SetSize(oDp:aCoors[4]-40,oDp:aCoors[3]-300,.T.)
   ENDIF

RETURN

FUNCTION LBXBTNADD()
   LOCAL cBtn1:="",cBtn2:="", nHasta:=30,I

   WHILE nHasta>oFrm:nDesde
       cBtn1:="BTN"+STRZERO(nHasta,2)+"_"
       nHasta--
       cBtn2:="BTN"+STRZERO(nHasta,2)+"_"
       oFrm:cMemo:=STRTRAN(oFrm:cMemo,cBtn2,cBtn1)
   ENDDO

   oFrm:oMemo:Refresh(.F.)

RETURN NIL
// EOF

