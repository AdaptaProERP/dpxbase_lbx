// Programa   : LBXSETSIZE
// Fecha/Hora : 19/04/2015 03:12:09
// Propósito  : Asignar Tamaño Formulario DPLBX
// Creado Por : Juan Navas
// Llamado por: LBXCREATE
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(cFileLbx,cDescri)
  LOCAL oLbx,nWidth:=0,nHeight:=0,cMemo:="",cMemo2:="",nAt,aText:={},I
  
  IF Empty(cFileLbx) .OR. !("."$cFileLbx) 
     RETURN .F.
  ENDIF

  oLbx:=GetDpLbx(cDescri)

  nWidth :=oLbx:oWnd:nWidth()
  nHeight:=oLbx:oWnd:nHeight()

  AADD(aText,{"WIDTH" ,nWidth })
  AADD(aText,{"HEIGHT",nHeight})
  
  cMemo:=MemoRead(cFileLbx)

  FOR I=1 TO LEN(aText)
    nAt   :=AT(aText[I,1],cMemo)
    cMemo2:=SUBS(cMemo,nAt,LEN(cMemo))
    cMemo :=LEFT(cMemo,nAt+5)+":="+LSTR(aText[I,2])
    cMemo2:=SUBS(cMemo2,AT(CRLF,cMemo2)+2,LEN(cMemo2))
    cMemo :=cMemo+CRLF+cMemo2
  NEXT I

  DPWRITE(cFileLbx,cMemo)

RETURN .T.
// EOF
