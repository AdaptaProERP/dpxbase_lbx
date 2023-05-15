// Programa   : LBXSAVEPAR
// Fecha/Hora : 26/05/2019 07:07:16
// Propósito  : Restaurar Parámetros de la Ventana
// Creado Por : Juan Navas
// Llamado por:
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(oFrm)
  LOCAL oIni,cFile,cParam

  IF oFrm=NIL .OR. Empty(oFrm:cFileLbx)
     RETURN .T.
  ENDIF

  cFile:="MYFORMS\"+cFileNoExt(oFrm:cFileLbx)+".LBXP"

  INI oIni File (cFile)

  oIni:Set( "cAlias", "browse", oFrm:oBrw:SaveState() )
  oIni:Set( "cAlias", "Width" , oFrm:oWnd:nWidth() )
  oIni:Set( "cAlias", "Height", oFrm:oWnd:nHeight() )

//? oFrm:cFileLbx

RETURN .T.
// EOF

