// Programa   : LBXINIFIND
// Fecha/Hora : 15/04/2016 09:53:07
// Propósito  : Inicio de Búsqueda con LBX (Cuando se solicita LBX para buscar datos Asociado a get debe
//              activar el boton Buscar o Localizar según definición en LBX
// Creado Por : Juan Navas
// Llamado por: LBXSYSMENU
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(oLbx)
    LOCAL nAt,oCol,nLastKey:=13
    LOCAL nColFind:=2,cFind:="FILTER"
  
    IF oLbx=NIL
       RETURN NIL
    ENDIF

    // JN 18/11/2020, Caso del Get dentro de TBAR 
    //IF !("TDIALOG"$oLbx:oGet:oWnd:ClassName())
    //    RETURN NIL
    // ENDIF

    IF !Empty(oLbx:uFieldFind)

       // Buscar valor inicial
       oCol:=oLbx:oBrw:aCols[1]
       oLbx:DbSeek(oCol,oLbx:uFieldFind,nLastKey)

       IF !oLbx:oGet=NIL
          oLbx:oGet:VarPut(oLbx:uFieldFind,.T.) // Se restaura el contenido del GET
          RETURN .T.
       ENDIF

    ENDIF

    nColFind:=CTOO(GetLbx("COLFIND"),"N")
    cFind   :=GetLbx("TYPEFIND")

    cFind   :=IF(Empty(cFind)   ,"FIND",cFind   )
    nColFind:=IF(Empty(nColFind),1     ,nColFind)

    nAt:=ASCAN(oLbx:aBtns,{|a|a[7]=cFind})

    IF nAt>0
       oLbx:oBrw:nColSel:=nColFind
//     DPFOCUS(oLbx:oBrw)
//     SysRefresh(.T.)
//     EVAL(oLbx:aBtns[nAt,8]:bAction)
//     oLbx:oBrw:KeyBoard(ASC(" "))
    ENDIF

RETURN NIL
