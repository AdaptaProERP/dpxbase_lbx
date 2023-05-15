// Programa   : LBXPOSTDELETE
// Fecha/Hora : 26/06/2015 12:18:49
// Propósito  : Ejecución post-Delete. 
//  00105 : Filtrar y Eliminar debe leer nuevamente el cursor para remover los registros eliminados del browse, sino pareciera que no los elimina si se vuelve a solicitar el filtrado.
// Creado Por : Juan Navas,
// Llamado por:
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(oLbx)

  // JN luego de remover el registro debe refrescar BRWFILTER
  oLbx:oBrw:CARGO:=NIL


RETURN .T.
