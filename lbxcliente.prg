// Programa  : LBXCLIENTE
// Fecha/Hora: 02/01/2003 21:26:46
// Propósito : Presentar lista de la tabla de Clientes
// Creado Por: Juan Navas
#INCLUDE "FIVEWIN.CH"
#INCLUDE "XBROWSE.CH"

FUNCTION LBXCLIENTE()

   local oChild, oBrw , oCursor ,cSql,oFrameDp
   
   oFrameDp:=VP("oFrameDp")

   cSql:="SELECT VEN_NOMBRE AS YOLO,CLI_CODIGO,CLI_NOMBRE,CLI_TEL1,CLI_TEL2,CLI_CODVEN"+;
         " FROM DPCLI INNER JOIN DPVEN ON CLI_CODVEN=VEN_CODIGO ORDER BY CLI_TEL1"

   oCursor :=OPENTABLA("DPCLI",,cSql)

   DEFINE WINDOW oChild TITLE "Prueba de ListBox/Sql " MDICHILD 
   
   oBrw := TXBrowse():New( oChild )
   oBrw:nMarqueeStyle       := MARQSTYLE_HIGHLCELL
   oBrw:nColDividerStyle    := LINESTYLE_BLACK
   oBrw:nRowDividerStyle    := LINESTYLE_BLACK
   oBrw:lColDividerComplete := .t.

   BrwSetCursor(oBrw,oCursor,.T.)

   oBrw:nMarqueeStyle   := MARQSTYLE_HIGHLCELL
   oBrw:lHScroll        := .t.
   oBrw:lVScroll        := .t.
   oBrw:nRowSel         := 1

   oBrw:CreateFromCode()
   oBrw:GoTop()

   oChild:oClient := oBrw

   ACTIVATE WINDOW oChild  ON INIT oBrw:SetFocus()

RETURN NIL



