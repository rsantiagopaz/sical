import clases.HTTPServices;

import flash.events.Event;

import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;

include "../control_acceso.as";
include "../asincludes/numericSort.as";

[Bindable] private var _xmlLlamados:XML = <llamados></llamados>;	
private var httpDatos:HTTPServices = new HTTPServices;
private var _idLlamado:String;
private var _nroLlamado:String;
private var _descripcion:String;
private var _idNivel:String;

public function get xmlLlamados():XML { return _xmlLlamados }
public function get idLlamado():String { return _idLlamado }
public function get idNivel():String { return _idNivel }
public function get nroLlamado():String { return _nroLlamado }
public function get descripcion():String { return _descripcion }

public function fncInit():void
{
	_xmlLlamados = <llamados></llamados>;
	httpDatos.url = "conscantinscript/llamados.php";
	httpDatos.addEventListener("acceso",acceso);
	httpDatos.addEventListener(ResultEvent.RESULT,fncCargarDatos)
	httpDatos.send({rutina:"traer_llamados"});		
	btnCerrar.addEventListener("click" ,fncCerrar);
}

private function fncCargarDatos(e:Event):void {
	_xmlLlamados.appendChild(httpDatos.lastResult.llamados);		
}

private function fncCerrar(e:Event):void
{
	dispatchEvent(new Event("eventClose"));	
}		

public function fncSeleccionar():void
{
	var xmlLlamados : XML = _xmlLlamados.llamados[(gridLlamados.selectedItem as XML).childIndex()];
	_idLlamado = xmlLlamados.@id_llamado;
	_nroLlamado = xmlLlamados.@nro_llamado;
	_descripcion = xmlLlamados.@descripcion;
	_idNivel = xmlLlamados.@id_nivel;
	dispatchEvent(new Event("EventSeleccionar"));
}

public function fncVerDetalle():void
{
	//Creo los contenedores para enviar datos y recibir respuesta
	var enviar:URLRequest = new URLRequest("conscantinscript/listado_inscriptos.php");
	var recibir:URLLoader = new URLLoader();
 		 
	//Creo la variable que va a ir dentro de enviar, con los campos que tiene que recibir el PHP.
	var variables:URLVariables = new URLVariables();
	
	variables.id_llamado = gridLlamados.selectedItem.@id_llamado;						
				
	//Indico que voy a enviar variables dentro de la petición
	enviar.data = variables;
	
	navigateToURL(enviar);
}