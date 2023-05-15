// Programa   : LBXDPMODUPD // Fecha/Hora : 15/12/2014 15:42:30
// Propósito  : Modulo de Modulos de Actualización de Datos
// Creado Por :
// Llamado por:
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(cModulo)
  LOCAL oDpLbx
  LOCAL cNombre:=""
  LOCAL cWhere :=""
  LOCAL cTitle :=""

  DEFAULT cModulo:=SQLGET("DPMODUPDDATOS","MUD_CODIGO")

  cNombre:=SQLGET("DPMODUPDDATOS","MUD_DESCRI","MUD_CODIGO"+GetWhere("=",cModulo))
  cTitle :=oDp:DPMODLEEDATOS+" ["+ALLTRIM(cNombre)+"]"
  cWhere :="PLD_CODMOD"+GetWhere("=",cModulo)

  oDpLbx:=TDpLbx():New("DPPRGUPDDATOS.LBX",cTitle,cWhere,NIL,NIL)
  oDpLbx:cModulo:=cModulo
  oDpLbx:Activate()

RETURN NIL
// EOF

