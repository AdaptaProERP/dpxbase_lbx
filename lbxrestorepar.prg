// Programa   : LBXRESTOREPAR
// Fecha/Hora : 26/05/2019 07:07:16
// Propósito  : Restaurar Parámetros de la Ventana
// Creado Por : Juan Navas
// Llamado por:
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(oFrm)
  LOCAL oIni,cFile,cParam
  LOCAL nWidth:=0,nHeight:=0

  IF oFrm=NIL .OR. Empty(oFrm:cFileLbx)
     RETURN .F.
  ENDIF

  cFile:="MYFORMS\"+cFileNoExt(oFrm:cFileLbx)+".LBXP"

  IF !FILE(cFile)
     RETURN .F.
  ENDIF

  INI oIni File (cFile)

  cParam:=oIni:Get( "cAlias", "browse", "")

  nWidth :=oIni:Get( "cAlias", "Width" ,nWidth)
  nHeight:=oIni:Get( "cAlias", "Height",nHeight)

  IF !nWidth=0 .AND. !nHeight=0

//  oFrm:oWnd:SetSize(nWidth,nHeight,.T.)
//  oFrm:oWnd:Refresh(.T.)
//  oFrm:aSize[3]:=nWidth
//  oFrm:aSize[4]:=nHeight

  ENDIF

  DEFAULT oFrm:bValid   :={|| EJECUTAR("LBXSAVEPAR",oFrm)}

  oFrm:oBrw:RestoreState(cParam)

  oFrm:nWidth :=nWidth
  oFrm:nHeight:=nHeight

RETURN .T.
// EOF

