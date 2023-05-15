// Programa   : LBXEDITLBX
// Fecha/Hora : 19/05/2003 16:17:36
// Prop—sito  : Editar planos del editor LBX
// Creado Por : Juan Navas
// Llamado por: SysMenu de DpLbx
// Aplicaci—n : ProgramaciÛn
// Tabla      : Todas

#INCLUDE "DPXBASE.CH"
#INCLUDE "TSBUTTON.CH"

FUNCTION DPXBASE(cFileLbx)
  LOCAL oBar,cTitle,oFontB,oFont
  LOCAL aCoors:=GetCoors( GetDesktopWindow() )

  DEFAULT cFileLbx:="forms\dptablas.lbx"

  LbxRelease()

  cTitle  :=" Editar Par·metros de "+cFileName(cFileLbx)
//  oFrmLbx :=DPEDIT():New(cTitle,"forms\dpEditLbx.edt","oFrmLbx",.T.)

  DEFINE FONT oFont  NAME "Courier New" SIZE 0, -14  
  DEFINE FONT oFontB NAME "Courier New" SIZE 0, -14 BOLD

  DpMdi(cTitle,"oFrmLbx","forms\dpEditLbx.edt")

  oFrmLbx:Windows(0,0,aCoors[3]-160,aCoors[4]-10,.F.)

  oFrmLbx:cMemo:=MemoRead(cFileLbx)  
  oFrmLbx:oMemo:=NIL
  oFrmLbx:cFile:=cFileLbx

  @ 1,1 GET oFrmLbx:oMemo VAR oFrmLbx:cMemo OF oFrmLbx:oDlg SIZE 100,100 HSCROLL FONT oFontB

  oFrmLbx:oWnd:oClient := oFrmLbx:oMemo


  oFrmLbx:Activate({||oFrmLbx:LbxBbtnVar(oFrmLbx)})

RETURN oFrmLbx

/*
// Barra de Botones
*/
FUNCTION LbxBbtnVar(oFrmLbx)
   LOCAL oCursor,oBar,oBtn,oFont,oCol,nDif
   LOCAL nWidth :=0 // Ancho Calculado seg£n Columnas
   LOCAL nHeight:=0 // Alto
   LOCAL nLines :=0 // Lineas

   DEFINE CURSOR oCursor HAND
   DEFINE BUTTONBAR oBar SIZE 45,45 OF oFrmLbx:oDlg 3D CURSOR oCursor

   DEFINE XBUTTON oBtn ;
          FILE oDp:cPathBitMaps+"XSAVE.BMP";
          SIZE 40,42;
          TOOLTIP "Grabar";
          ACTION (MemoWrit(oFrmLbx:cFile,oFrmLbx:oMemo:Gettext()),;
                  Ejecutar("FILEACT",oFrmLbx:cFile),;
                  EJECUTAR("DPTRANSLATOR",oFrmLbx:cFile));
          OF oBar

   DEFINE XBUTTON ;
          FILE oDp:cPathBmp+"colors.bmp";
          TOOLTIP "Generar Colores Decimal/Hexadecimal";
          ACTION (CursorWait(),ejecutar("CGIHTMCOLOR"));
          OF oBar;
          SIZE 40,42

   DEFINE XBUTTON oBtn ;
          FILE "bitmaps\xsalir.bmp";
          TOOLTIP "Cerrar";
          ACTION oFrmLbx:Close() OF oBar;
          SIZE 40,42

   @ 0.1,70 SAY oFrmLbx:cFile OF oBar BORDER SIZE 345,18

   oBar:SetColor(CLR_BLACK,oDp:nGris)
   AEVAL(oBar:aControls,{|o,n|o:cMsg:=o:cToolTip,o:SetColor(CLR_BLACK,oDp:nGris)})

RETURN .T.





//  EOF
