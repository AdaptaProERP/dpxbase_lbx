// Programa   : LBXDPMODLEE // Fecha/Hora : 15/12/2014 15:42:30
// Propósito  : Modulo de Modulos de Lectura
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

  DEFAULT cModulo:=SQLGET("DPMODLEEDATOS","MLD_CODIGO")

  cNombre:=SQLGET("DPMODLEEDATOS","MLD_DESCRI","MLD_CODIGO"+GetWhere("=",cModulo))
  cTitle :=oDp:DPMODLEEDATOS+" ["+ALLTRIM(cNombre)+"]"
  cWhere :="PLD_CODMOD"+GetWhere("=",cModulo)

  oDpLbx:=TDpLbx():New("DPPRGLEEDATOS.LBX",cTitle,cWhere,NIL,NIL)
  oDpLbx:cModulo:=cModulo
  oDpLbx:Activate()

RETURN NIL
// EOF
