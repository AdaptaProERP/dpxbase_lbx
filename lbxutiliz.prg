// Programa   : LBXUTILIZ
// Fecha/Hora : 06/12/2018 15:57:07
// Prop�sito  : Productos por Utilizaci�n
// Creado Por : Juan Navas
// Llamado por:
// Aplicaci�n :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(cUtiliz)
   LOCAL cWhere,cTitle

   DEFAULT cUtiliz:="Venta"

   cUtiliz:=ALLTRIM(cUtiliz)

   cTitle:=oDp:DPINV+" ["+oDp:xDPINVUTILIZ+"="+cUtiliz+"]"

   cWhere:="INV_UTILIZ"+GetWhere("=",cUtiliz)

   DPLBX("DPINV.LBX",cTitle,cWhere,NIL,NIL,NIL,{cUtiliz})

RETURN
