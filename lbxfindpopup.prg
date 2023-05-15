// Programa   : LBXFINDPOPUP
// Fecha/Hora : 03/02/2015 09:16:03
// Propósito  : Menu de Búsqueda LBX
// Creado Por : Juan Navas
// Llamado por: LBXMENU FIND
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"
#INCLUDE "C5MENU.CH"

PROCE MAIN(oLbx)
   LOCAL oPop
   LOCAL aBuscar:={"UNO","DOS","TRES","CUATRO"}

   IF oLbx=NIL
      RETURN NIL
   ENDIF

   C5MENU oPop POPUP;
          COLOR    oDp:nMenuItemClrText,oDp:nMenuItemClrPane;
          COLORSEL oDp:nMenuItemSelText,oDp:nMenuItemSelPane;
          COLORBOX oDp:nMenuBoxClrText;
          HEIGHT   oDp:nMenuHeight;
          FONT     oDp:oFontMenu;
          LOGOCOLOR oDp:nMenuMainClrText

        //FOR I=1 TO LEN(aBuscar)

          C5MENUITEM aBuscar[1] ;
                     ACTION MensajeErr("aBuscar")

          C5MENUITEM aBuscar[1] ;
                     ACTION MensajeErr("aBuscar")

          C5MENUITEM aBuscar[1] ;
                     ACTION MensajeErr("aBuscar")

          C5MENUITEM aBuscar[1] ;
                     ACTION MensajeErr("aBuscar")

RETURN oPop
// EOF
