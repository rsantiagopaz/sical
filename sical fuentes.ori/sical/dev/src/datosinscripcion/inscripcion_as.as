import clases.HTTPServices;

import mx.rpc.events.ResultEvent;

include "../control_acceso.as";

private var _idIngresoMovimiento : String;
[Bindable] private var _xmlDatosDocente : XML;
[Bindable] private var httpDatos : HTTPServices = new HTTPServices;
[Bindable] private var _idDocente:String;
[Bindable] private var _id_docente_llamado:String;
[Bindable] private var _idLlamado:String;
[Bindable] private var _idNivel:String;
[Bindable] private var _id_tipo_clasificacion:String;
[Bindable] private var _id_tipo_llamado:String;
[Bindable] private var _accion:String;

public function get idDocente():String { return _idDocente; }
public function get id_docente_llamado():String { return _id_docente_llamado; }
public function get idLlamado():String { return _idLlamado; }
public function get idNivel():String { return _idNivel; }
public function get accion():String { return _accion; }
	
public function fncInit(idNivel:String,id_docente_llamado:String,accion:String,id_tipo_clasificacion:String,id_tipo_llamado:String):void
{					
	_id_docente_llamado = id_docente_llamado;		
	_idNivel = idNivel;		
	_accion = accion;
	_id_tipo_clasificacion = id_tipo_clasificacion;
	_id_tipo_llamado = id_tipo_llamado;
	_xmlDatosDocente = new XML;
	//tomo el id de la inscripción y envio la busqueda para obtener los datos del docente
	httpDatos.url = "datosinscripcion/inscripcion.php";
	httpDatos.addEventListener("acceso",acceso);
	httpDatos.addEventListener(ResultEvent.RESULT,fncCargarDatos);
	httpDatos.send({rutina:"traer_datos", id_docente_llamado:_id_docente_llamado});
	tabFicha.selectedIndex = 0;
}

private function fncCerrar(e:Event):void{
	dispatchEvent(new Event("SelectPrincipal"));
}

public function get idIngresoMovimiento():String { return _idIngresoMovimiento; }
public function get xmlDatosDocente():XML { return _xmlDatosDocente; }

private function fncCargarDatos(e:ResultEvent):void
{
	_xmlDatosDocente = new XML;
	_xmlDatosDocente = httpDatos.lastResult as XML;	
	ModDatosGenerales.fncInit(_idNivel,_id_tipo_clasificacion,_id_tipo_llamado);
	if (ModTitulos) {ModTitulos.fncInit()};
	if (ModPostitulos) {ModPostitulos.fncInit()};
	if (ModCursos) {ModCursos.fncInit()};
	if (ModCongresos) {ModCongresos.fncInit()};
	if (ModCapacitacion) {ModCapacitacion.fncInit()};
	if (ModEventos) {ModEventos.fncInit()};
	if (ModConfirmacion) {ModConfirmacion.fncInit()};
}
