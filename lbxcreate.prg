// Programa  : LBXCREATE 
// Fecha/Hora: 19/05/2003 16:17:36
// Prop¥sito : Crear Editores LBX para cualquier tabla
// Creado Por: Juan Navas
#INCLUDE "DPXBASE.CH"
#INCLUDE "TSBUTTON.CH"
#INCLUDE "XBROWSE.CH"

FUNCTION DPXBASE(cTable,cDescri,cFileLbx)
  LOCAL oBar,cTitle,oFields,cSql,aFields,aSelect,oCol,oFont,oSay,oBrw
  LOCAL cSelect,I,cCol,aSort,nAt,oLbx,lCreate:=.F.,cKey,oCursor,cForm 
  LOCAL cNumTab

  DEFAULT  cTable :=SQLGET("DPTABLAS","TAB_NOMBRE"),;
           cDescri:=SQLGET("DPTABLAS","TAB_DESCRI","TAB_NOMBRE"+GetWhere("=",cTable)),;
           cNumTab:=SQLGET("DPTABLAS","TAB_NUMERO","TAB_NOMBRE"+GetWhere("=",cTable))

  DEFINE FONT oFont NAME "CURIER" SIZE 0,-12 

  CursorWait()

  IF ("."$cTable) .AND. cFileLbx="SIZE" 

     cFileLbx:=cTable
     cTable  :=GETINI(cFileLbx,"TABLE") // Lista de Campos ya seleccionados

     oLbx:=GetDpLbx(cDescri) 

     IF ValType(oLbx)="O" // Utilizamos el Mismo de QuickBrowse
       oLbx:cFileIni:=cTable // cNumTab
       VP("SCRRUNFUNCTION","SAVECOORD")
       SCRRUN("QUICKBRW",oLbx,.T.)
     ENDIF

     RETURN .T.

  ENDIF

  cTable:=ALLTRIM(cTable)

  IF "."$cTable // cNumTab // NÀmero del archivo LBX, vino como parametro

    cFileLbx:=cTable // NumTab
    cTable  :=GETINI(cFileLbx,"TABLE") // Lista de Campos ya seleccionados
    cSql    :="SELECT TAB_NUMERO,TAB_DESCRI FROM DPTABLAS WHERE TAB_NOMBRE"+;
               GetWhere("=",cTable)
    oFields :=OpenTable(cSql,.T.)
    cDescri :=oFields:TAB_DESCRI
    cNumTab :=oFields:TAB_NUMERO
    oFields:End()
       ELSE

    // oDp:cPathExe+"FORMS\DEFAULT.LBX"

    DEFAULT cFileLbx:=oDp:cPathExe+"FORMS\"+ALLTRIM(cTable)+".LBX"

  ENDIF

  // Necesito la clave del primer indice de la tabla

//  cTable,"Antes del Cursor",cFileLbx

  oCursor:=OpenTable(cTable,.f.) // Solicito la tabla vacia
  cKey   :=oCursor:IndexKey(1) // Solicito la primera Clave
  IF EMPTY(cKey) // Si no tiene Indice, asume el primer Campo
     cKey:=oCursor:FieldName(1)
  ENDIF


  oCursor:End()

  IF !FILE(cFileLbx) // Debe Crearlo desde Default

     DEFAULT cFileLbx:=cNumTab

// ? oDp:cPathExe+"FORMS\DEFAULT.LBX"
// ? CLPCOPY(MEMOREAD(oDp:cPathExe+"FORMS\DEFAULT.LBX"))

     __COPYFILE(oDp:cPathExe+"FORMS\DEFAULT.LBX",cFileLbx)

//     EJECUTAR("FILEACT",cFileLbx)
//     EJECUTAR("FILESAVEBIN",cFileLbx,cFileNoPath(cFileLbx),NIL,cFileLbx,"DPFILES",NIL,.F.,.T.,0)

     lCreate:=.T.

  ENDIF

  IniGetLbx(MEMOREAD(cFileLbx))
  cSelect:=GETLBX("SELECT") // Lista de Campos ya seleccionados

  IF !lCreate
    cDescri:=GETLBX("TITLE")
  ENDIF

  IF EMPTY(cSelect) // Debe Colocar por Defecto las Clave del primer Indice
     cSelect:=STRTRAN(cKey,"+",",")
  ENDIF

  cForm:=cFileName(cFileLbx) // Nombre del Formulario

  //? cSELECT

  cSql   :="SELECT CAM_NAME,CAM_DESCRI FROM DPCAMPOS WHERE CAM_TABLE"+;
            GetWhere("=",cTable)
 
  oFields:=OpenTable(cSql,.T.)
  oFields:End()
  aFields:=oFields:aDataFill
  AEVAL(aFields,{|a,n|aFields[I,1]:=ALLTRIM(a[1])})

  aSelect:={}       //aFields // Selecciona todos los campos

  I:=0
  WHILE ++I<=LEN(aFields) 
    IF ALLTRIM(aFields[I,1])$cSelect
       AADD(aSelect,aFields[I])
       ADEL(aFields,I)
       ASIZE(aFields,LEN(aFields)-1)
       I:=0
    ENDIF
  ENDDO

  // Debe Busca el Nombre de las Columnas en Lbx
  FOR I=1 TO LEN(aSelect)
     cCol:="COL"+STRZERO(I,2)+"_HEADER"
     cCol:=GETLBX(cCol) // Lista de Campos ya seleccionados
     IF !EMPTY(cCol)
        aSelect[I,2]:=PADR(cCol,LEN(aSelect[I,2]))
     ENDIF
  NEXT I

  // Ahora debe order los campos como estaban
  aSort  :={}
  cSelect:=_VECTOR(cSelect,",")
  FOR I=1 TO LEN(cSelect)
     nAt:=ASCAN(aSelect,{|a,n| ALLTRIM(a[1])=ALLTRIM(cSelect[I])})
     IF nAt>0
       AADD(aSort,aSelect[nAt])
     ENDIF
  NEXT I
  aSelect:=aSort

  IF EMPTY(aSelect)
     aSelect:=aFields
     aFields:={}
  ENDIF

  cTitle  :=" Crear Browse de la tabla "+cNumTab+"/"+cTable

  oFrmLbx :=DPEDIT():New(cTitle,"forms\dpCreateLbx.edt","oFrmLbx",.T.)

  oFrmLbx:SetScript()
  oFrmLbx:oSay    :=NIL
  oFrmLbx:cNumTab :=cNumTab
  oFrmLbx:cFileLbx:=cFileLbx
  oFrmLbx:cDescri :=cDescri
  oFrmLbx:cTable  :=cTable
  oFrmLbx:cKey    :=cKey
  oFrmLbx:cIndex  :=cKey
  oFrmLbx:cForm   :=cFileNoExt(cForm) // Codigo del Formulario
  oFrmLbx:oBtn1   :=NIL
  oFrmLbx:nClrPane1:=oDp:nClrPane1
  oFrmLbx:nClrPane2:=oDp:nClrPane2

  @ 2,01 SAY "  Campos de la Tabla    " 
  @ 2,10 SAY "  Campos Seleccionados  " 

  // Botones del Cuerpo
  @5, 5  SBUTTON oFrmLbx:oBtn1 ;
         SIZE 50, 50 ;
         FILE "BITMAPS\xnext.BMP","BITMAPS\xnext.BMP","BITMAPS\xnext.BMP" NOBORDER ;
         LEFT PROMPT "Seleccionar" ;
         COLORS CLR_BLACK, { 14680063, 14680063 , 1 };
         ACTION oFrmLbx:SWAPBRW(oFrmLbx:oBrw1,oFrmlbx:oBrw2)

  @5, 5  SBUTTON oFrmLbx:oBtn2 ;
         SIZE 50, 50 ;
         FILE "BITMAPS\xprev.BMP" NOBORDER;
         LEFT PROMPT "Quitar" ;
         COLORS CLR_BLACK, { 16772829, 16772829, 1 };
         ACTION oFrmlBx:SWAPBRW(oFrmLbx:oBrw2,oFrmlbx:oBrw1)

  // Bubir Lista
  @5, 5  SBUTTON oFrmLbx:oBtn3 ;
         SIZE 50, 50 ;
         FILE "BITMAPS\xsubir.BMP" NOBORDER;
         LEFT PROMPT "Subir" ;
         COLORS CLR_BLACK, { 16772829, 16772829, 1 };
         ACTION oFrmlBx:SWAPLINE(oFrmlbx:oBrw2,.T.)

  // Bajar Lista
  @5, 5  SBUTTON oFrmLbx:oBtn3 ;
         SIZE 50, 50 ;
         FILE "BITMAPS\xbajar.BMP" NOBORDER ;
         LEFT PROMPT "Bajar" ;
         COLORS CLR_BLACK, { 16772829, 16772829, 1 };
         ACTION oFrmlBx:SWAPLINE(oFrmlbx:oBrw2,.F.)
 
   // Campos Disponibles 
   oFrmLbx:oBrw1:= TXBrowse():New( oFrmLbx:oDlg )
   oFrmLbx:oBrw1:SetFont(oFont)
   oFrmLbx:SetName(oFrmLbx:oBrw1,aFields,.f.)
//   oFrmLbx:oBrw1:CreateFromCode()


/*
   oFrmLbx:oBrw1:bClrSel:={|oBrw,nClrText,aData|oBrw:=oFrmLbx:oBrw1,;
                                 nClrText:=0,;
                               {nClrText,iif( oBrw:nArrayAt%2=0, oFrmLbx:nClrPane1, oFrmLbx:nClrPane2 ) } }
*/

    // Campos Seleccionados 
   oFrmLbx:oBrw2:= TXBrowse():New( oFrmLbx:oDlg )
   oFrmLbx:oBrw2:SetFont(oFont)
   oFrmLbx:SetName(oFrmLbx:oBrw2,aSelect,.t.)

/*
   oFrmLbx:oBrw2:bClrSel:={|oBrw,nClrText,aData|oBrw:=oFrmLbx:oBrw2,;
                                 nClrText:=0,;
                               {nClrText,iif( oBrw:nArrayAt%2=0, oDp:nClrPane1, oDp:nClrPane2 ) } }
*/

   @ 10,1 Say oFrmLbx:oSay2 PROMPT   {||STRZERO(oFrmLbx:oBrw2:nArrayAt,3)+"/"+;
                                        STRZERO(oFrmLbx:oBrw2:nLen    ,3)}



   oBrw:=oFrmLbx:oBrw2
   oBrw:bChange:={||oFrmLbx:oSay2:Refresh()}

//  oFrmLbx:oBrw2:CreateFromCode()

   EVAL(oBrw:bChange)

   SysRefresh(.T.)

   IF lCreate 
      oFrmLbx:SaveLbx()
   ENDIF

   oFrmLbx:Activate({||oFrmLbx:LBXBOTBAR(oFrmLbx)})

RETURN oFrmLbx

/*
// Barra de Botones
*/
FUNCTION LBXBOTBAR(oFrmLbx)

  LOCAL oBar,oBtn

  DEFINE BUTTONBAR oBar SIZE 39, 39 3D OF oFrmLbx:oDlg

  DEFINE XBUTTON oBtn ;
         FILE oDp:cPathBitMaps+"xSave.BMP";
         TOOLTIP "Grabar";
         SIZE 35,35;
         ACTION oFrmLbx:SaveLbx(oFrmLbx) OF oBar
// 
//       COLORS CLR_WHITE, { nRGB(243,250,200), CLR_BLACK, 5 }  OF oBar
 
  DEFINE XBUTTON oBtn ;
         FILE oDp:cPathBitMaps+"Run.BMP";
         TOOLTIP "Ejecutar";
         SIZE 35,35;
         ACTION oFrmLbx:RunLbx(oFrmLbx);
         OF oBar
  
  DEFINE XBUTTON oBtn ;
         FILE oDp:cPathBitMaps+"Form.BMP";
         TOOLTIP "Crear Programa para Formulario de Carga";
         SIZE 38,38;
         ACTION (oFrmLbx:CreateScr(oFrmLbx),oFrmLbx:Close());
         OF oBar

  DEFINE XBUTTON oBtn ;
         FILE oDp:cPathBitMaps+"MENU.BMP";
         TOOLTIP "Crear Programa para Menú para  "+cTable;
         SIZE 38,38;
         ACTION  EJECUTAR("DPBUILDMNU",oFrmLbx:cTable,.T.); 
         OF oBar


  DEFINE XBUTTON oBtn ;
         FILE oDp:cPathBitMaps+"VIEW.BMP";
         TOOLTIP "Crear Programa Menú para Consultar "+cTable;
         SIZE 38,38;
         ACTION  EJECUTAR("DPBUILDCON",oFrmLbx:cTable,.T.); 
         OF oBar


  DEFINE XBUTTON oBtn ;
         FILE oDp:cPathBitMaps+"MENU2.BMP";
         TOOLTIP "Agregar Menú "+cTable;
         SIZE 38,38;
         ACTION  EJECUTAR("DPLBXTOMENU",oFrmLbx:cTable,.T.); 
         OF oBar


   DEFINE XBUTTON oBtn ;
         FILE oDp:cPathBitMaps+"XEDIT.BMP";
         TOOLTIP "Editar "+oFrmLbx:cFileLbx;
         SIZE 38,38;
         ACTION EJECUTAR("LBXEDITLBX",oFrmLbx:cFileLbx);
         OF oBar

  DEFINE XBUTTON oBtn ;
         FILE oDp:cPathBitMaps+"copy2.BMP";
         TOOLTIP "Reiniciar desde Default";
         SIZE 38,38;
         ACTION (__COPYFILE(oDp:cPathExe+"FORMS\DEFAULT.LBX",oFrmLbx:cFileLbx),;
                 oFrmLbx:SaveLbx(oFrmLbx)) ;
         OF oBar

   DEFINE XBUTTON oBtn ;
         FILE oDp:cPathBitMaps+"xSalir.BMP";
         TOOLTIP "Grabar";
         SIZE 38,38;
         ACTION oFrmLbx:Close();
         OF oBar

   Aeval(oBar:aControls,{|a,n|a:SetColor(NIL,oDp:nGris)})
   oBar:SetColor(NIL,oDp:nGris)

   oFrmLbx:oBrw2:bClrSel:={|oBrw,nClrText,aData|oBrw:=oFrmLbx:oBrw2,;
                                 nClrText:=0,;
                                 {nClrText,iif( oBrw:nArrayAt%2=0, oDp:nClrPane1, oDp:nClrPane2 ) } }


   oFrmLbx:oBrw1:bClrSel:={|oBrw,nClrText,aData|oBrw:=oFrmLbx:oBrw1,;
                                 nClrText:=0,;
                                 {nClrText,iif( oBrw:nArrayAt%2=0, oDp:nClrPane1, oDp:nClrPane2 ) } }

   oFrmLbx:oBrw1:SetColor(nil,oFrmLbx:nClrPane1)
   oFrmLbx:oBrw2:SetColor(nil,oFrmLbx:nClrPane1)

RETURN .T.

/*
// Intercambio de Campos entre Lineas
*/
FUNCTION SWAPLINE(oBrw,lUp)
  LOCAL aLine,nAt:=oBrw:nArrayAt,nRow:=oBrw:nRowSel
  LOCAL nNext:=nAt+IIF(lUp,-1,1)

  SetFocus(oBrw)  
  oBrw:nLen:=LEN(oBrw:aArrayData)

  nNext:=IIF(nNext<1                   ,LEN(oBrw:aArrayData),nNext)
  nNext:=IIF(nNext>LEN(oBrw:aArrayData),1                   ,nNext)

  aLine:=oBrw:aArrayData[nNext] // Actual

  oBrw:SetFocus()
  oBrw:aArrayData[nNext]:=oBrw:aArrayData[nAt]
  oBrw:aArrayData[nAt  ]:=aLine
  oBrw:nArrayAt:=nNext

  oBrw:Refresh()
  oBrw:nArrayAt:=nNext
  oBrw:nRowSel :=nRow+IIF(lUp,-1,1)
  oBrw:nRowSel :=Max(1,oBrw:nRowSel)
  oBrw:DrawLine()
//oBrw:DrawLine( .t., oBrw:nRowSel )

  IF nNext=1
    oBrw:GoTop()
    oBrw:Refresh()
    oBrw:nArrayAt:=1
    oBrw:nRowSel :=1
  ELSEIF nNext=LEN(oBrw:aArrayData).and.lUp
    // oBrw:GoBottom()
    // oBrw:nArrayAt:=nNext

    oBrw:Refresh(.T.)
    oBrw:GoBottom(.T.)


  ENDIF

RETURN 
 
/*
// Intercambio de Campos entre Browse
*/
FUNCTION SWAPBRW(oBrw1,oBrw2)
   // Quita del Brow1 y Coloca  en el Browse 2
   LOCAL nAt1:=oBrw1:nArrayAt
   LOCAL nAt2:=oBrw2:nArrayAt
   LOCAL aSwap:=oBrw1:aArrayData[nAt1]

   IF LEN(oBrw1:aArrayData)=1.AND.EMPTY(oBrw1:aArrayData[1]) // ya esta Vacio
      RETURN NIL
   ENDIF

   IF LEN(oBrw1:aArrayData)=1 // Ultimo no Puede estar Vacio
     AEVAL(oBrw1:aArrayData[1],{|a,i|oBrw1:aArrayData[1,i]:=""})
   ELSE 
     ADEL(oBrw1:aArrayData,nAt1)
     ASIZE(oBrw1:aArrayData,LEN(oBrw1:aArrayData)-1)
   ENDIF

   oBrw1:Refresh()

   nAt2:=Min(nAt2+1,len(oBrw2:aArrayData))
   AADD(oBrw2:aArrayData,NIL)
   AINS(oBrw2:aArrayData,nAt2)
   oBrw2:aArrayData[nAt2]:=aSwap
   oBrw2:nArrayAt:=nAt2
   oBrw2:Refresh()

   nAt2:=ASCAN(oBrw2:aArrayData,{|a,i|Empty(a[1])})
   IF nAt2>0
      ADEL(oBrw2:aArrayData,nAt2)
      ASIZE(oBrw2:aArrayData,LEN(oBrw2:aArrayData)-1)
      oBrw2:Refresh()
   ENDIF

   IF oBrw1:bChange!=NIL
      EVAL(oBrw1:bChange)
   ENDIF

   IF oBrw2:bChange!=NIL
      EVAL(oBrw2:bChange)
   ENDIF
 RETURN .T.

FUNCTION SETNAME(oBrw,aData,lEdit)
   LOCAL nFor,oCol,aHead:={"Campo","Descripción"}
   LOCAL aWidth:={96,390}

   IF EMPTY(aData) // Browse no puede estar vacio
      AADD(aData,{"",""})
   ENDIF

   oBrw:SetArray(aData,!lEdit)

   For nFor:= 1 to len(oBrw:aCols)
      oCol:= oBrw:aCols[nFor]
      oCol:cHeader:=aHead[nFor]
      oCol:nWidth :=aWidth[nFor]
   Next

   if lEdit
      oCol:nEditType:=1
   endif

IF .F.

//   oBrw:nMarqueeStyle   := MARQSTYLE_HIGHLCELL
   oBrw:lHScroll        := .f.

//   oBrw:nColDividerStyle    := LINESTYLE_BLACK
//   oBrw:nRowDividerStyle    := LINESTYLE_BLACK
//   oBrw:lColDividerComplete := .t.
//   oBrw:nMarqueeStyle       := MARQSTYLE_HIGHLROW
   oBrw:lRecordSelector     :=.f.  // if true a record selector column is displayed

/*
   oBrw:nColDividerStyle    := LINESTYLE_BLACK
   oBrw:nRowDividerStyle    := LINESTYLE_BLACK
   oBrw:lColDividerComplete := .t.
   oBrw:nMarqueeStyle       := MARQSTYLE_HIGHLROW
   oBrw:lRecordSelector     :=.f.  // if true a record selector column is displayed
*/



   oBrw:lFooter     := .T.
   oBrw:lHScroll    := .F.
   oBrw:nHeaderLines:= 2
   oBrw:nDataLines  := 1
   // oBrw:nFooterLines:= 1
ENDIF

//   oBrw:nMarqueeStyle   := MARQSTYLE_HIGHLCELL
   oBrw:lHScroll        := .f.

//   oBrw:nColDividerStyle    := LINESTYLE_BLACK
//   oBrw:nRowDividerStyle    := LINESTYLE_BLACK
   oBrw:lColDividerComplete := .t.
//   oBrw:nMarqueeStyle       := MARQSTYLE_HIGHLROW
   oBrw:lRecordSelector     :=.f.  // if true a record selector column is displayed


   oBrw:nRecSelColor:=oDp:nLbxClrHeaderPane // 12578047 // 16763283
/*
   oBrw:bClrStd               := {|oBrw,nClrText,aData|oBrw:=oDPGRUCTA:oBrw,aData:=oBrw:aArrayData[oBrw:nArrayAt],;
                                           oDPGRUCTA:nClrText,;
                                          {nClrText,iif( oBrw:nArrayAt%2=0, oDPGRUCTA:nClrPane1, oDPGRUCTA:nClrPane2 ) } }
*/

   oBrw:bClrHeader            := {|| { oDp:nLbxClrHeaderText, oDp:nLbxClrHeaderPane}}
   oBrw:bClrFooter            := {|| { oDp:nLbxClrHeaderText, oDp:nLbxClrHeaderPane}}

   oBrw:bClrFooter          := {|| { oDp:nLbxClrHeaderText, oDp:nLbxClrHeaderPane}}
   oBrw:bClrHeader          := {|| { oDp:nLbxClrHeaderText, oDp:nLbxClrHeaderPane}}
   oBrw:CreateFromCode()

RETURN .T.

/*
// Grabar Lbx
*/
FUNCTION SAVELBX(cFileLbx)
   LOCAL cSelect :="",aFields,I,cCol,BTN01,aKeys,nAt,BTN02
   LOCAL cKey    :=oFrmLbx:cIndex,aSelect:={}
   LOCAL cTitle  :="{oDp:"+oFrmLbx:cTable+"}"
   LOCAL cOrderBy:="" // Asume el Primer Campo
   LOCAL oCampo  

   cKey:=STRTRAN(oFrmLbx:cKey,"+",",")
   cKey:=IIF(EMPTY(cKey),aFields[1,1],cKey)
   cKey:=STRTRAN(cKey," ","")
   cKey:=STRTRAN(cKey,",","+oCursor:")

   DEFAULT cFileLbx:=oFrmLbx:cFileLbx

   aFields:=oFrmLbx:oBrw2:aArrayData

   // Genera los Campos
   FOR I=1 TO LEN(aFields)
      cOrderBy:=IIF(Empty(cOrderBy),aFields[I,1],cOrderBy)
      cSelect:=cSelect + iif( empty(cSelect) , "" , "," ) +ALLTRIM(aFields[I,1])
      AADD(aSelect,aFields[I,1])
   NEXT I
 
   INISAVE(oFrmLbx:cFileLbx,"TABLE"   ,oFrmLbx:cTable  ,[MAIN],.F.)
   INISAVE(oFrmLbx:cFileLbx,"TITLE"   ,cTitle          ,[MAIN],.F.)
   INISAVE(oFrmLbx:cFileLbx,"SELECT"  ,cSelect         ,[MAIN],.F.)
   INISAVE(oFrmLbx:cFileLbx,"ORDER BY",cOrderBy        ,[MAIN],.F.)

   // Borrar Columnas
   FOR I=1 TO 20
     cCol:="COL"+STRZERO(I,2)
     INISAVE(oFrmLbx:cFileLbx,cCol+"_HEADER","" ,[MAIN], .T.)
   NEXT I

   // Generar las Columnas
   FOR I=1 TO LEN(aFields)
     cCol:="COL"+STRZERO(I,2)

     oCampo:=OpenTable("SELECT CAM_TYPE FROM DPCAMPOS WHERE CAM_TABLE"+;
             GetWhere("=",oFrmLbx:cTable)+" AND "+;
             " CAM_NAME"+GetWhere("=",aFields[I,1]),.T.)

     INISAVE(oFrmLbx:cFileLbx,cCol+"_HEADER",ALLTRIM(aFields[I,2]) ,[MAIN], .F. )

     IF oCampo:CAM_TYPE="L"
        INISAVE(oFrmLbx:cFileLbx,cCol+"_VIEW","4" ,[MAIN], .F. )
     ENDIF

     oCampo:End()
   NEXT I

   // Verifica si los Campos Claves estan en la Lista
   aKeys:=_VECTOR(cKey,"+")

   // Ahora los pasa en Limpio
   cKey:=""
   FOR I=1 TO LEN(aKeys)
      nAt:=ASCAN(aSelect,{|a|UPPE(ALLTRIM(a))$UPPE(ALLTRIM(aKeys[I]))})
      IF nAt>0
         cKey:=cKey+IIF(EMPTY(cKey),"","+")+aKeys[I]
      ENDIF
   NEXT I

   IF EMPTY(cKey) // Asume el primer Campo, Cuando Est¯ vacio
      cKey:=aSelect[1] 
   ENDIF

   BTN01:=GETINI(oFrmLbx:cFileLbx,"BTN01_ACTION") // Action Incluir
   IF Empty(BTN01)
      INISAVE(oFrmLbx:cFileLbx,"BTN01_ACTION",[SCRRUN("]+ALLTRIM(oFrmLbx:cForm)+[",1,IIF(oCursor:Eof(),NIL,oCursor:]+cKey+[))],[MAIN],.F.)
   ENDIF

   BTN01:=GETINI(oFrmLbx:cFileLbx,"BTN02_ACTION") // Action Consultar
   IF Empty(BTN01)
//    INISAVE(oFrmLbx:cFileLbx,"BTN02_ACTION",[SCRRUN("]+ALLTRIM(oFrmLbx:cForm)+[",2,IIF(oCursor:Eof(),NIL,oCursor:]+cKey+[))],[MAIN],.F.)
      INISAVE(oFrmLbx:cFileLbx,"BTN02_ACTION",[EJECUTAR("]+ALLTRIM(oFrmLbx:cForm)+[CON",oCursor:]+cKey+[)],[MAIN],.F.)
   ENDIF

   BTN01:=GETINI(oFrmLbx:cFileLbx,"BTN03_ACTION") // Modificar
   IF Empty(BTN01)
      INISAVE(oFrmLbx:cFileLbx,"BTN03_ACTION",[SCRRUN("]+ALLTRIM(oFrmLbx:cForm)+[",3,oCursor:]+cKey+[)],[MAIN],.F.)
   ENDIF

   // Menu
   BTN01:=GETINI(oFrmLbx:cFileLbx,"BTN05_ACTION") // Menu
   IF Empty(BTN01)
      INISAVE(oFrmLbx:cFileLbx,"BTN05_ACTION",[EJECUTAR("]+ALLTRIM(oFrmLbx:cForm)+[MNU",oCursor:]+cKey+[)],[MAIN],.F.)
   ENDIF


   BTN01:=GETINI(oFrmLbx:cFileLbx,"BTN08_ACTION") // Imprimir

   IF Empty(BTN01)
      INISAVE(oFrmLbx:cFileLbx,"BTN08_ACTION",[oDpLbx:PRINT()],[MAIN],.F.)
   ENDIF


// ? "AQUI ES",oFrmLbx:cFileLbx
//   EJECUTAR("FILEACT",oFrmLbx:cFileLbx,oFrmLbx:cTitle,oFrmLbx:cTable)
 
RETURN

FUNCTION RUNLBX(oFrmLbx)

    LbxRelease()
    SAVELBX(oFrmLbx)
    DPLBX(oFrmLbx:cFileLbx)

RETURN

FUNCTION INISAVE(cFile,cName,uValue,cSection,lDelete)
   LOCAL cMemo,nContar:=0,aLines,I,nAT:=0,cNameX,lFound,cComment:="",nAtComm:=0

   IF !File(cFile)
      RETURN .F.
   ENDIF

   cMemo  :=ALLTRIM(MemoRead(cFile))
   cMemo  :=STRTRAN(cMemo,Chr(10),"")
   aLines :=_VECTOR(cMemo,CHR(13))
   cMemo  :=""
   
   WHILE nContar<20 .AND. nAt=0
     cNameX:=cName+SPACE(nContar)+":="
     nAt   :=ASCAN(aLines,{|a,i,lFound|a:=ALLTRIM(a),lFound:=(cNameX==LEFT(a,LEN(cNameX))),lFound})
     nContar++
   ENDDO   

   // Borrar un Valor
   IF nAt>1 .AND. lDelete // Debe Borrar que se Indican
     ADEL(aLines,nAt)
     ASIZE(aLines,Len(aLines)-1)
     nAt:=0
   ELSE
     IF lDelete .AND. nAt=0 // No encontro
       RETURN .F.
     ENDIF
   ENDIF

   IF nAt>1 .AND. !lDelete  // Fue Encontrada

     IF "//"$aLines[nAt]
       nAtComm :=AT("//",aLines[nAt])
       cComment:=SPACE(nAtComm-Len(cNameX+uValue)-1)+""+SUBS(aLines[nAt],nAtComm,LEN(aLines[nAt]))
     ENDIF
     aLines[nAt]:=UPPE(cNameX)+uValue+cComment

   ELSE

     IF !lDelete
       // Agrega el Nuevo Valor
       AADD(aLines,cName+":="+CTOO(uValue,"C"))
     ENDIF

   ENDIF

   AEVAL(aLines,{|a,i|cMemo:=cMemo+IIF(Empty(cMemo),"",CRLF)+a})

   DPWRITE(cFile,cMemo)
 
RETURN .T.

/*
// Edici¥n del Programa Fuente
*/
FUNCTION CREATESCR() // oFrmLbx)
   LOCAL cTable:=oFrmLbx:cTable
   LOCAL cForm :=cFileNoExt(oFrmLbx:cForm)
   LOCAL cFile :=oDp:cPathScr+Alltrim(cForm)+".SCR"
   LOCAL oTable,cSql,lFound

   cTable:=ALLTRIM(cTable)

   cSql:="SELECT PRG_CODIGO FROM DPPROGRA WHERE PRG_CODIGO"+GetWhere("=",cForm)
   
   oTable:=OpenTable(cSql,.T.)
   lFound:=oTable:lFound
   oTable:End()
/*
   IF !lFound .AND. !MsgNoYes("Desea crear Programa "+cForm+" en este momento ? ","Programa "+cForm+" no está creado ")
      RETURN .F.
   ENDIF
*/
   IF lFound .AND. !MsgNoYes("Desea generar Nuevamente el Programa "+cForm+" en este momento ? ","Programa "+cForm+" ya está creado ")
      RETURN .F.
   ENDIF

   oDp:nNumLbx:=0
   CursorWait()
   
   Ejecutar("SCRCREATE",oFrmLbx:cTable,cForm)


//   DPXBASEEDIT(3,oFrmLbx:cTable) 
 
RETURN NIL
// EOF

