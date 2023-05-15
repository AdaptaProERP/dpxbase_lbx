// Programa   : LBXSETINI
// Fecha/Hora : 09/05/2003 16:24:28
// Propósito  : Indicar los Browser que posee buscadores Iniciales
// Creado Por : Juan Navas
// Llamado por: Menu Principal Definiciones y Mantenimiento
// Aplicación : Programación
// Tabla      : Todas las de Configuración

#INCLUDE "DPXBASE.CH"

PROCE MAIN()
  LOCAL aNombre:={},aSingular:={},aPaises,aEstados,aMncpio

  CursorWait()

  // Buscar dentro del Browse

  DEFAULT oDp:lLbxIniFind:=.F. 

  oEdit:=DPEDIT():New("Buscador Inicial en Listas (Browser)","forms\LBXSETFIND.edt","oEdit",.F.)
 
  oEdit:lDPINV      :=oDp:lDPINV
  oEdit:lDPCLIENTES :=oDp:lDPCLIENTES
  oEdit:lDPPROVEEDOR:=oDp:lDPPROVEEDOR
  oEdit:lDPCTA      :=oDp:lDPCTA      
  oEdit:lDPCTAEGRESO:=oDp:lDPCTAEGRESO
  oEdit:lLbxIniFind :=oDp:lLbxIniFind

  oEdit:lMsgBar   :=.F.

  oEdit:CreateWindow()

  @ 2,1 CHECKBOX oEdit:lDPINV       PROMPT oDp:DPINV
  @ 3,1 CHECKBOX oEdit:lDPCLIENTES  PROMPT oDp:DPCLIENTES
  @ 4,1 CHECKBOX oEdit:lDPPROVEEDOR PROMPT oDp:DPPROVEEDOR

  @ 5,1 CHECKBOX oEdit:lDPCTA       PROMPT oDp:DPCTA
  @ 6,1 CHECKBOX oEdit:lDPCTAEGRESO PROMPT oDp:DPCTAEGRESO


 @ 6,1 CHECKBOX oEdit:lLbxIniFind  PROMPT "En Formulario LBX"


  @ 1,1 SAY "Asigna Iniciador para la Búsqueda de Registros Específicos"

  @ 6,07 BUTTON "Aceptar " ACTION  oEdit:Aceptar()
  @ 6,10 BUTTON "Salir   " ACTION (oEdit:Close()) CANCEL

  oEdit:Activate(NIL)

RETURN NIL

/*
// Graba los Datos en el DataSet
*/
FUNCTION ACEPTAR()

  LOCAL oData,I

  oDp:lDPINV      :=oEdit:lDPINV
  oDp:lDPCLIENTES :=oEdit:lDPCLIENTES
  oDp:lDPPROVEEDOR:=oEdit:lDPPROVEEDOR
  oDp:lDPCTA      :=oEdit:lDPCTA      
  oDp:lDPCTAEGRESO:=oEdit:lDPCTAEGRESO
  oDp:lLbxIniFind :=oEdit:lLbxIniFind


  CursorWait()

  oData:=DATASET("LBXFIND","ALL")

  oData:Set("DPCLIENTES"    , oDp:lDPCLIENTES   ) // Buscador Inicial
  oData:Set("DPINV"         , oDp:lDPINV        ) // Buscador Inicial
  oData:Set("DPPROVEEDOR"   , oDp:lDPPROVEEDOR  ) // Buscador Inicial
  oData:Set("DPCTA"         , oDp:lDPCTA        ) // Buscador Inicial
  oData:Set("DPCTAEGRESO"   , oDp:lDPCTAEGRESO  ) // Buscador Inicial
  oData:Set("LBXINIFIND"    , oDp:lLbxIniFind   ) // Activa Buscador Inicial

  oData:Save()
  oData:End()

  oEdit:Close()

RETURN NIL

// EOF

