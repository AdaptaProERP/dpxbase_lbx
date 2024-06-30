// Programa   : LBXINIGET
// Fecha/Hora : 26/01/2007 23:08:23
// Propósito  : Solicitar Datos de Búsqueda
// Creado Por : Juan Navas
// Llamado por: DPXXX.LBX
// Aplicación : Ventas
// Tabla      : Todas

#INCLUDE "DPXBASE.CH"

PROCE MAIN(cTable,cField,cWhere,cText)
    LOCAL cWhereRet:="",cGet1,cGet2,nLen:=0,nDec:=0,nRadio:=1
    LOCAL oGet1,oGet2,oDlg,oFont,oBtn,oRadio
    LOCAL oControl,aField,cFieldC:="",lData:=.F.,lTodos:=.F.

    DEFAULT cTable           :="DPCLIENTES",;
            cText            :="Nombre",;
            cField           :="CLI_NOMBRE",;
            oDp:lLeft        :=.F.,;
            oDp:lLbxIniFind  :=.F.,;
            oDp:cLbxWhereAuto:=NIL,;
            oDp:oGetLbx      :=NIL

   aField :=_VECTOR(cField,",")
   cField :=IF(LEN(aField)>1,aField[1],cField)
   cFieldC:=IF(LEN(aField)>1,aField[2],""    )

// ? GETPROCE()
// ? oDp:lLbxIniFind,oDp:lLbxRun
//? oDp:Get("l"+"DPINV")
//? oDp:oGetLbx:ClassName()
// ? GETPROCE()
//? cTable,cField,cWhere,cText,oDp:Get("l"+cTable) 

    IF oDp:lLbxIniFind .AND. !Empty(oDp:cLbxWhereAuto)
       RETURN oDp:cLbxWhereAuto
    ENDIF

//? oDp:lLbxRun,"oDp:lLbxRun",oDp:lLbxIniFind,"oDp:lLbxIniFind"

    IF !oDp:Get("l"+cTable) 

       IF cTable=="DPCTA"
         EJECUTAR("DPCTALBXFIND")
       ENDIF

       RETURN NIL
    ENDIF

    IF ValType(oDp:oGetLbx)="O"
       oControl:=oDp:oGetLbx
    ENDIF
  
    SqlFieldLen(cTable,cField,NIL,@nLen,@nDec)

    cGet1:=SPACE(nLen)  
    cGet2:=SPACE(nLen)

    IF ValType(oDp:oLbx)="O" .AND. ValType(oDp:oLbx:oGet)="O"
       oControl:= oDp:oLbx:oGet
       cGet1   :=PADR(EVAL(oControl:bSetGet),nLen)

       // 21/09/2023, sino esta vacio debe buscarlo en el brows
       lData   :=!Empty(ALLTRIM(cGet1))

    ENDIF

    DEFINE FONT oFont  NAME "Tahoma" SIZE 0, -12 BOLD

    DEFINE DIALOG oDlg;
           TITLE "Buscar "+GetFromVar("{oDp:x"+cTable+"}");
           SIZE 400,200;
           COLOR NIL,oDp:nGris

   oDlg:lHelpIcon:=.F.

   @ 5.8,1 CHECKBOX oDp:lLeft PROMPT ANSITOOEM("Lado Izquierdo") SIZE 140,09;
           FONT oFont

    @ 0.2,1 SAY cText FONT oFont COLOR NIL,oDp:nGris

//  @ 1.8,1 SAY cText+" (2)" FONT oFont

    @ 1.1,.8 GET oGet1 VAR cGet1 SIZE 180,11 FONT oFont
    @ 2.1,.8 GET oGet2 VAR cGet2 SIZE 180,11 FONT oFont;
             WHEN !Empty(cGet1)

    oGet1:bKeyDown:={ |nKey| IF((nKey=VK_F6 .OR. nKey=13) .AND. !Empty(cGet1+cGet2), BuscarReg(nKey) , NIL) }
    oGet2:bKeyDown:={ |nKey| IF((nKey=VK_F6 .OR. nKey=13) .AND. !Empty(cGet1+cGet2), BuscarReg(nKey) , NIL) }

    @ 03,01 RADIO oRadio VAR nRadio;
            ITEMS "&AND", "&OR";
            SIZE 30, 13;
            WHEN !Empty(cGet2)
 

    @03.7,12+5-8 SBUTTON oBtn ;
             SIZE 45, 20 FONT oFont;
             FILE "BITMAPS\XFIND2.BMP",,"BITMAPS\XFINDG2.BMP" NOBORDER;
             LEFT PROMPT "Buscar F6";
             COLORS CLR_BLACK, { CLR_WHITE, oDp:nGris, 1};
             ACTION (lTodos:=.F.,BuscarReg());
             WHEN !Empty(cGet1+cGet2)

    oBtn:cToolTip:="Buscar Registros"
    oBtn:cMsg    :=oBtn:cToolTip

    @03.7,22-4 SBUTTON oBtn ;
             SIZE 45, 20 FONT oFont;
             FILE "BITMAPS\XBROWSE.BMP" NOBORDER;
             LEFT PROMPT "Todos";
             COLORS CLR_BLACK, { CLR_WHITE, oDp:nGris, 1 };
             ACTION (lTodos:=.T.,oDlg:End()) CANCEL

    oBtn:lCancel :=.T.
    oBtn:cToolTip:="Cancelar y Cerrar Formulario "
    oBtn:cMsg    :=oBtn:cToolTip


    @03.7,22+5+0 SBUTTON oBtn ;
             SIZE 45, 20 FONT oFont;
             FILE "BITMAPS\XSALIR.BMP" NOBORDER;
             LEFT PROMPT "Cerrar";
             COLORS CLR_BLACK, { CLR_WHITE, oDp:nGris, 1 };
             ACTION oDlg:End() CANCEL

    oBtn:lCancel :=.T.
    oBtn:cToolTip:="Cancelar y Cerrar Formulario "
    oBtn:cMsg    :=oBtn:cToolTip

    AEVAL(oRadio:aItems,{|o|o:SetFont(oFont) })

    ACTIVATE DIALOG oDlg CENTERED ON INIT (EJECUTAR("FRMMOVE",oDlg,oControl),;
                                           IF(lData,BuscarReg(),NIL),;
                                           oGet1:SetFocus(),.F.)

    IF lTodos=.T.
       cWhereRet:=" 1=1 "
    ENDIF

RETURN cWhereRet

FUNCTION BuscarReg(nKey)

   LOCAL nCount,cScope,cOper:=" LIKE ",I,cWhereD
   LOCAL aFields:={"INV_OBS1","INV_OBS2","INV_OBS3","INV_CODIGO"}
   LOCAL cLeft:=IIF(oDp:lLeft,"","%")

   cScope:=cField+GetWhere(cOper,cLeft+ALLTRIM(cGet1)+"%")

   IF !Empty(cGet2)

      cScope:=cScope+ IIF(nRadio=1," AND "," OR ")+;
              cField+GetWhere(cOper,cLeft+ALLTRIM(cGet2)+"%")

   ENDIF

   IF cField="INV_DESCRI"

      FOR I=1 TO LEN(aFields)
         aFields[I]:=STRTRAN(cScope,"INV_DESCRI",aFields[I])
      NEXT I

      FOR I=1 TO LEN(aFields)
         cScope    :=cScope + " OR ("+aFields[I]+")"
      NEXT I

   ENDIF

   IF !Empty(cFieldC)

   ENDIF
 
   nCount:=COUNT(cTable,cScope)

   oGet1:nLastKey:=0

   IF nKey=13 .AND. nCount=0
     RETURN .F.
   ENDIF
  
   IF nCount=0 
      oGet1:MsgErr("Registros no Encontrados","Buscador")
//      MensajeErr("Registros no Encontrados")
      RETURN .F.
   ENDIF

   cWhereRet:=cScope

   oDlg:End()

RETURN .T.
// EOF
