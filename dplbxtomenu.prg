// Programa   : DPLBXTOMENU
// Fecha/Hora : 27/12/2019 09:30:34
// Propósito  : Crear Menú desde Tablas DPLBX
// Creado Por :
// Llamado por:
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(cTable)
    LOCAL cCodigo,cSintax,cWhere,cModulo,cTitle

    DEFAULT cTable:="DPVARSERVICIOS"

    cSintax:=[DPLBX("]+cTable+[.LBX")]

    cWhere :="MNU_ACCION"+GetWhere("=",cSintax)
    cModulo:=SQLGET("DPTABLAS","TAB_APLICA","TAB_NOMBRE"+GetWhere("=",cTable))
    cCodigo:=SQLGET("DPMENU","MNU_CODIGO",cWhere)

    EJECUTAR("DPMENU",IF(Empty(cCodigo),1,3),cCodigo)

    IF Empty(cCodigo)
      oMENU:oMNU_MODULO:VarPut(cModulo)
      EVAL(oMENU:oMNU_MODULO:bChange)
    ENDIF

    oMENU:oMNU_VERTIC:VarPut("Ficheros")
    EVAL(oMENU:oMNU_VERTIC:bChange)

    cTitle:=[{oDp:]+cTable+[}]+SPACE(40)
    oMENU:oMNU_TITULO:VarPut(cTitle,.T.)

    oMENU:oMNU_ACCION:VarPut(cSintax+SPACE(40),.T.)


    IF !Empty(GETRELEASE())
       cWhere:=[ISRELEASE("]+GETRELEASE()+[")]
       oMENU:oMNU_CONDIC:VarPut(cWhere+SPACE(40),.T.)
    ENDIF


RETURN .T.
// EOF
