// Programa   : LBXTOREPORT
// Fecha/Hora : 09/05/2014 21:54:01
// Propósito  : Generar reporte desde DPLBXRUN
// Creado Por : Juan Navas
// Llamado por: DPLBX():PRINT()
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(oLbx,cFileLbx,cReport)
  LOCAL cMemo,aLines:={},cTable,cSelect,cInner,cWhere,cGroup ,cSql,cOrderBy,cGroupBy,cHaving
  LOCAL cHeader,cView,nWidthC,cData,cPict,nAling
  LOCAL I,oTable,aLin:={},aColRep:={},aRepMemos:={},cTitulo,aTotales:={},aCampos:={},cSumCol:="N",aCols:={}
  LOCAL oCampos,oCol,cType,cPicture,nWidth,aLine,nHeadLine,cColRep,aPicture:={}

  DEFAULT cFileLbx:="FORMS\DPENTESPUB.LBX"

  cMemo :=GETFILESTD(cFileLbx)
  aLines:=STRTRAN(cMemo,CRLF,CHR(10))
  aLines:=_VECTOR(cMemo,CHR(10))
  AEVAL(aLines,{|a,n| aLines[n]:=STRTRAN(a,CHR(13),"")})

  ADEPURA(aLines,{|a,n| LEFT(a,1)="/"})

  cTable       :=LBXGETVALUE("TABLE"  )
  cSelect      :=LBXGETVALUE("SELECT" )
  cInner       :=LBXGETVALUE("INNER"  )
  cWhere       :=LBXGETVALUE("WHERE"  )
  cOrderBy     :=LBXGETVALUE("ORDER BY"   ,.T.) // si esta NIL, devuelve ""
  cGroup       :=LBXGETVALUE("GROUP BY"   ,.T.)
  cGroupBy     :=LBXGETVALUE("GROUP BY"   ,.T.)
  cHaving      :=LBXGETVALUE("HAVING"     ,.T.)
  cSelect      :=IIF( Empty(cSelect ),"*" ,cSelect   )
  cTitulo      :=ALLTRIM(SQLGET("DPTABLAS","TAB_DESCRI","TAB_NOMBRE"+GetWhere("=",cTable)))

  cOrderBy:=IIF(!Empty(cOrderBy)," ORDER BY ","")+cOrderBy

  IF !Empty(cGroup)
     cGroup:=" "+cGroup+" "
     cGroup:=IIF( " GROUP BY "$cGroup , "" , " GROUP BY " )+cGroup
  ENDIF

  IF !" WHERE "$UPPE(cWhere) .AND. !EMPTY(cWhere)
     cWhere:= " WHERE "+cWhere+" "
  ENDIF

  cSql    :="SELECT "+cSelect+" FROM "+UPPE(cTable)+;
            " "+cInner  +;
            " "+cWhere  +;
            " "+cGroup  +;
            " "+cHaving +;
            " "+cOrderBy

  cTable:=ALLTRIM(UPPE(cTable))

  oTable:=OpenTable(cSql,.T.)
  oTable:End()


  FOR I=1 TO 20

      cHeader:=LBXGETVALUE("COL"+STRZERO(I,2)+"_HEADER")
      cView  :=LBXGETVALUE("COL"+STRZERO(I,2)+"_VIEW")
      nWidthC:=LBXGETVALUE("COL"+STRZERO(I,2)+"_WIDTH",NIL,"N")
      cData  :=LBXGETVALUE("COL"+STRZERO(I,2)+"_DATA")
      cPict  :=LBXGETVALUE("COL"+STRZERO(I,2)+"_PICTURE")
      nAling :=LBXGETVALUE("COL"+STRZERO(I,2)+"_ALING")

      IF !Empty(cHeader)
        cData:=IIF(Empty(cData),oTable:FieldName(I))
        AADD(aCampos,{oTable:FieldName(I),cHeader})
//        ?  cHeader,cView,nWidthC,cData,cPict,nAling
      ENDIF

  NEXT I


  aColRep  :={}
  nHeadLine:=0

  FOR I=1 TO LEN(aCampos)

     oCampos:=OpenTable("SELECT CAM_NAME,CAM_DESCRI,CAM_TYPE,CAM_LEN FROM DPCAMPOS WHERE CAM_NAME"+GetWhere("=",aCampos[I,1]),.T.)

     cPicture:=""
     cType   :=oCampos:CAM_TYPE

     IF oCampos:RecCount()=0
       oCampos:CAM_DESCRI:=aCampos[I]
       oCampos:CAM_TYPE  :=VALTYPE(oTable:FieldGet(I))
       cType             :=VALTYPE(oTable:FieldGet(I))
       oCampos:CAM_LEN   :=LEN(CTOO(oTable:FieldGet(I),"O"))
     ENDIF

     cHeader:=aCampos[I,2] // ALLTRIM(oCampos:CAM_DESCRI) 
     nWidth :=oCampos:CAM_LEN*8
   
     IF oCampos:CAM_TYPE="D"
       nWidth :=70
     ENDIF 

     IF oCampos:CAM_TYPE="C" .AND. oCampos:CAM_LEN<3
       nWidth :=oCampos:CAM_LEN*20
     ENDIF 

     IF oCampos:CAM_TYPE="L" 
       nWidth :=40
     ENDIF 

     nWidth :=CTOO(nWidth,"N")

     IF ";"$cHeader
       cHeader:=STRTRAN(cHeader,";",[","])
     ENDIF

     cColRep:= CRLF+;
               " COLUMN TITLE "+GetWhere("",cHeader)      +";"+CRLF+;
               "        DATA oCursor:"+oTable:FieldName(I)+";"+CRLF+;
               "        SIZE "+LSTR(nWidth/10)            +";"+CRLF+;   
               "        LEFT " 

     IF cType="N" 

          cPicture:=FIELDPICTURE(oCampos:CAM_TABLE,oCampos:CAM_NAME ,.T.)

          IF Empty(cPicture)
             cPicture:="999,999,999.99"
          ENDIF

          cColRep:= CRLF+;
                   " COLUMN TITLE "+GetWhere("",cHeader)      +";"+CRLF+;
                   "        DATA oCursor:"+oTable:FieldName(I)+";"+CRLF+;
                   "        SIZE "+LSTR(nWidth/10)            +";"+CRLF+; 
                   "        PICTURE "+GetWhere("",cPicture)   +";"+CRLF+;
                   "        RIGHT TOTAL "
 

       ENDIF

       AADD(aColRep,cColRep)
  
       oCampos:End()

   NEXT I

   CREAR_REPORTE(oTable:cTable)

   REPORTE(cTable)

RETURN .T.


FUNCTION LBXGETVALUE(uValue)
   LOCAL nLen:=LEN(uValue)
   LOCAL nAt :=ASCAN(aLines,{|a,n| LEFT(a,nLen)=uValue})

   IF nAt>0
      uValue:=aLines[nAt]
      nAt   :=AT(":=",uValue)
      uValue:=SUBS(uValue,nAt+2,LEN(uValue))
   ELSE
      uValue:=""
   ENDIF

RETURN uValue


/*
// Crea Automáticamente el Reporte
*/
FUNCTION CREAR_REPORTE(cCodigo)
    LOCAL cMemo   :=MEMOREAD("FORMS\DEFAULT.REP")
    LOCAL cColumna:="",aSql:={},nAt,aLines:={}
    LOCAL cSql    :=ALLTRIM(cSql)
    LOCAL cFile   :="REPORT\"+cCodigo+".SRE"
    LOCAL cFileDxb:="REPORT\"+cCodigo+".DXB"
    LOCAL cFileRep:="REPORT\"+cCodigo+".REP"
    LOCAL cMemoM  :="" // Campos Memos

    LOCAL oTable
    LOCAL cGrupo  :=SQLGET("DPGRUREP","GRR_CODIGO")
    LOCAL cReport :=""
    LOCAL cAplica :=SQLGET("DPTABLAS","TAB_APLICA","TAB_NOMBRE"+GetWhere("=",cTable ))


    FERASE(cFile)
    FERASE(cFileDxb)
    FERASE(cFileRep)

    IF !Empty(SQLGET("DPREPORTES","REP_CODIGO","REP_CODIGO"+GetWhere("=",cCodigo)))
      SQLDELETE("DPREPORTES","REP_CODIGO"+GetWhere("=",cCodigo))
    ENDIF

    AEVAL(aRepMemos,{|a,n| cMemoM:=cMemoM + IIF( Empty(cMemoM),"",CRLF)+a})

    cAplica:=cAplica + SQLGET("DPMENU","MNU_TITULO","MNU_VERTIC"+GetWhere("=","A"    ))

    cReport:="// Reporte Creado Automáticamente por LBXTOREPORT "    +CRLF+;
             "// Fecha      : "+DTOC(oDp:dFecha)+" Hora : "+TIME()+CRLF+;
             "// Aplicación : "+cAplica                           +CRLF+;
             "// Tabla      : "+cTable         

    AEVAL(aColRep,{|a,n| cColumna:=cColumna+IIF(Empty(cColumna),"",CRLF)+a+CRLF })

    cColumna:=STRTRAN(cColumna,['],["])

    cMemo   :=STRTRAN(cMemo,"<COLUMN>",cColumna)
    cMemo   :=STRTRAN(cMemo,"<REPORT>",cReport )
    cMemo   :=STRTRAN(cMemo,"<GROUP>" ,""      )
    cMemo   :=STRTRAN(cMemo,"<MEMOS>" ,cMemoM  )
    cMemo   :=STRTRAN(cMemo,"// Genera Código SQL","")
    cMemo   :=STRTRAN(cMemo,"<TITLE>",cTitulo)

//    cMemo   :=STRTRAN(cMemo,"//BRWMAKER",SPACE(05)+[IF Empty(CTABLE(cSql)) ]+CRLF+SPACE(08)+[MensajeErr("Este Reporte requiere ser Ejecutado desde la Consulta ]+cCodigo+[")]+CRLF+SPACE(08)+[RETURN .F. ]+CRLF+SPACE(05)+[ENDIF])

    cMemo   :=STRTRAN(cMemo,"//BRWMAKER",SPACE(05)+[cSql:="]+ALLTRIM(cSql)+["])

//IF Empty(CTABLE(cSql)) ]+CRLF+SPACE(08)+[MensajeErr("Este Reporte requiere ser Ejecutado desde la Consulta ]+cCodigo+[")]+CRLF+SPACE(08)+[RETURN .F. ]+CRLF+SPACE(05)+[ENDIF])

    cMemo   :=STRTRAN(cMemo,"cSql   :=oGenRep:BuildSql()","cSql   :=oGenRep:cSql ")

    DPWRITE(cFile,cMemo)

    oTable:=OpenTable("SELECT * FROM DPREPORTES WHERE REP_CODIGO"+GetWhere("=",cCodigo),.T.)
 

    IF oTable:RecCount()=0
       oTable:AppendBlank()
       oTable:cWhere:=""
    ENDIF
   
    oTable:Replace("REP_CODIGO",cCodigo)
    oTable:Replace("REP_DESCRI",cTitulo)
    oTable:Replace("REP_FECHA" ,oDp:dFecha)
    oTable:Replace("REP_HORA"  ,TIME()    )
    oTable:Replace("REP_FUENTE",cMemo)
    oTable:Replace("REP_GRUPO" ,cGrupo)
    oTable:Replace("REP_TABLA" ,cTable)

    oTable:Commit(oTable:cWhere)
    oTable:End()

RETURN NIL

// EOF
