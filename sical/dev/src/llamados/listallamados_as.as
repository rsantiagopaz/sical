import clases.HTTPServices;

import flash.events.Event;

import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;

include "../control_acceso.as";

[Bindable] private var _xmlLlamados:XML = <llamados></llamados>;	
private var httpDatos:HTTPServices = new HTTPServices;
private var _idLlamado:String;
private var _nroLlamado:String;
private var _descripcion:String;
private var _idNivel:String;
private var _idTipoClasif:String;

public function get xmlLlamados():XML { return _xmlLlamados }
public function get idLlamado():String { return _idLlamado }
public function get idNivel():String { return _idNivel }
public function get idTipoClasif():String { return _idTipoClasif }
public function get nroLlamado():String { return _nroLlamado }
public function get descripcion():String { return _descripcion }

public function fncInit():void
{
	httpDatos.url = "llamados/llamados.php";
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
	PopUpManager.removePopUp(this)	
}		

public function fncSeleccionar():void
{
	var xmlLlamados : XML = _xmlLlamados.llamados[(gridLlamados.selectedItem as XML).childIndex()];
	_idLlamado = xmlLlamados.@id_llamado;
	_nroLlamado = xmlLlamados.@nro_llamado;
	_descripcion = xmlLlamados.@descripcion;
	_idNivel = xmlLlamados.@id_nivel;
	_idTipoClasif = xmlLlamados.@id_tipo_clasificacion;
	dispatchEvent(new Event("EventSeleccionar"));
}
	