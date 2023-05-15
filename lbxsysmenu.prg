// Programa   : LBXSYSMENU
// Fecha/Hora : 10/06/2003 01:21:56
// Prop¥sito  : Presentar Sysmenu
// Creado Por :
// Llamado por:
// Aplicaci¥n :
// Tabla      :

#INCLUDE "DPXBASE.CH"

FUNCTION ChangeSysMenu(oWnd,oLbx)
   LOCAL oSysMenu,bBlq1,bBlq2,bBlq3,bBlq4,bBlq5,bBlq6,bBlq7,bBlq8

   ISPCPRG()

   IF !oWnd=NIL
      // Se posiciona para Buscar
      // EJECUTAR("LBXINIFIND",oLbx)
   ENDIF

   IF oWnd=NIL .OR. oLbx=NIL
      RETURN NIL
   ENDIF


   IF !__objHasMsg( oLbx, "nClrText1" )
      __objAddData( oLbx, "nClrText1")
      oLbx:nClrText1:=0
   ENDIF

   IF !__objHasMsg( oLbx, "nClrText2" )
      __objAddData( oLbx, "nClrText2")
      oLbx:nClrText2:=0
   ENDIF

   IF !__objHasMsg( oLbx, "nClrText3" )
      __objAddData( oLbx, "nClrText3")
      oLbx:nClrText3:=0
   ENDIF

   IF !__objHasMsg( oLbx, "nClrText4" )
      __objAddData( oLbx, "nClrText4")
      oLbx:nClrText4:=0
   ENDIF

   IF !__objHasMsg( oLbx, "nClrText5" )
      __objAddData( oLbx, "nClrText5")
      oLbx:nClrText5:=0
   ENDIF


 IF !__objHasMsg( oLbx, "cClrText1" )
      __objAddData( oLbx, "cClrText1")
      oLbx:cClrText1:=""
   ENDIF

   IF !__objHasMsg( oLbx, "cClrText2" )
      __objAddData( oLbx, "cClrText2")
      oLbx:cClrText2:=""
   ENDIF

   IF !__objHasMsg( oLbx, "cClrText3" )
      __objAddData( oLbx, "cClrText3")
      oLbx:cClrText3:=""
   ENDIF

   IF !__objHasMsg( oLbx, "cClrText4" )
      __objAddData( oLbx, "cClrText4")
      oLbx:cClrText4:=""
   ENDIF

   IF !__objHasMsg( oLbx, "cClrText5" )
      __objAddData( oLbx, "cClrText5")
      oLbx:cClrText5:=""
   ENDIF

   IF !__objHasMsg( oLbx, "cSql" ) .AND. ValType(oLbx)="O"

      DEFAULT oLbx:cFileSql:="" 

   ENDIF

   PUBLICO("oDpLbx",oLbx)

   bBlq1:=[LbxRelease(),EJECUTAR("LBXEDITLBX","]+oLbx:cFileLbx+[")]
   bBlq1:=BloqueCod(bBlq1)

   bBlq2:=[LbxRelease(),EJECUTAR("LBXCREATE","]+oLbx:cFileLbx+[")]
   bBlq2:=BloqueCod(bBlq2)

   bBlq3:=[LbxRelease(),EJECUTAR("LBXSETSIZE","]+oLbx:cFileLbx+[",]+str(oLbx:nNumLbx)+[,"SIZE")]
   bBlq3:=BloqueCod(bBlq3)

   bBlq4:={|oDpLbx| oDpLbx:=GetDpLbx(oDp:nNumLbx),;
                    EJECUTAR("INSPECT",oDpLbx)}

   bBlq5:=[LbxRelease(),EJECUTAR("DPLBXADDBTN","]+oLbx:cFileLbx+[")]
   bBlq5:=BloqueCod(bBlq5)

   bBlq6:={||EJECUTAR("BRWEDITCOL",oDpLbx)}

   bBlq7:=[EJECUTAR("DPOPCXTABLAS",NIL,"]+oLbx:cTable+[")]
   bBlq7:=BloqueCod(bBlq7)

   IF Empty(oLbx:cFileSql)
     bBlq8:={||NIL}
   ELSE
     bBlq8:=[EJECUTAR("VIEWRTF","]+oLbx:cFileSql+[")]
     bBlq8:=BloqueCod(bBlq8)
   ENDIF


   REDEFINE SYSMENU oSysMenu OF oWnd
   
   SEPARATOR

   IF !oDp:lDpXbase

     MenuAddItem( "&Personalizar Columnas del Browse ",, .F.,,bBlq6,,,,,,, .F.,,, .F. )

     MenuAddItem( "&Asignar Colores en Opciones de los Campos ["+oLbx:cTable+"]",, .F.,,bBlq7,,,,,,, .F.,,, .F. )


     ENDMENU

     RETURN

   ENDIF

   MenuAddItem( "&Editar Parametros de "+cFileName(oLbx:cFileLbx),, .F.,,bBlq1,,,,,,, .F.,,, .F. )

   MenuAddItem( "&Mover Botones "+cFileName(oLbx:cFileLbx),, .F.,,bBlq5,,,,,,, .F.,,, .F. )

   MenuAddItem( "&Preparar Columnas ",, .F.,,bBlq2,,,,,,, .F.,,, .F. )

   MenuAddItem( "&Asignar Colores en Opciones de los Campos ["+oLbx:cTable+"]",, .F.,,bBlq7,,,,,,, .F.,,, .F. )

   MenuAddItem( "&Grabar Tamaño Visual ",, .F.,,bBlq3,,,,,,, .F.,,, .F. )

   MenuAddItem( "&Personalizar Columnas del Browse ",, .F.,,bBlq6,,,,,,, .F.,,, .F. )

   IF oDp:lTracer
     MenuAddItem( "&Inactivar Traza de Ejecución",, .F.,,{||oDp:lTracer:=!oDp:lTracer},,,,,,, .F.,,, .F. )
   ELSE
     MenuAddItem( "&Activar Traza de Ejecución",, .F.,,{||oDp:lTracer:=!oDp:lTracer},,,,,,, .F.,,, .F. )
   ENDIF

   IF oDp:lTracerSQL
     MenuAddItem( "&Inactivar Traza de SQL",, .F.,,{||oDp:lTracerSQL:=!oDp:lTracerSQL},,,,,,, .F.,,, .F. )
   ELSE
     MenuAddItem( "&Activar Traza de SQL",, .F.,,{||oDp:lTracerSQL:=!oDp:lTracerSQL},,,,,,, .F.,,, .F. )
   ENDIF

   MenuAddItem( "&Ver Setencia SQL ",, .F.,,bBlq8,,,,,,, .F.,,, .F. )

   MenuAddItem( "&Inspector ",, .F.,,bBlq4,,,,,,, .F.,,, .F. )


   ENDMENU

RETURN NIL
// EOF
