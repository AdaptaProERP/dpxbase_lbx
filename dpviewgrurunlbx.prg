// Programa   : DPVIEWGRURUNLBX
// Fecha/Hora : 28/04/20186 08:53:52
// Propósito  : Presentar Visualizar por Grupo
// Creado Por : Juan Navas
// Llamado por: 
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(cCodGru,cDescri,lIndFin)
   LOCAL oDpLbx,cWhere

   DEFAULT cCodGru:=SQLGET("DPVIEWGRU","VIG_CODIGO"),;
           cDescri:=SQLGET("DPVIEWGRU","VIG_DESCRI","VIG_CODIGO"+GetWhere("=",cCodGru)),;
           lIndFin:=.F.

   cWhere:="VIR_CODGRU" + GetWhere("=",cCodGru )

   cDescri:=GetFromVar("{oDp:xDPVIEWGRU}")+": ["+cCodGru+"] "+cDescri

   oDpLbx:=DPLBX("DPVIEWGRURUN.LBX",cDescri,cWhere,NIL,NIL,NIL,{cCodGru,lIndFin})
   oDpLbx:cCargo:=cCodGru

RETURN .T.
//
