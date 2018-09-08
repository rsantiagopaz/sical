import clases.HTTPServices;

import carreras.carrera;

import flash.events.Event;

import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;


include "../control_acceso.as";
include "../asincludes/numericSort.as";

[Bindable] private var _xmlCarreras:XML = <carreras></carreras>;
[Bindable] private var _xmlNiveles:XML = <niveles></niveles>;	
private var httpDatos:HTTPServices = new HTTPServices;
private var httpDatos2:HTTPServices = new HTTPServices;
private var twCarrera:carrera;

public function get xmlNiveles():XML { return _xmlNiveles }	


public function fncInit():void
{		
	httpDatos.url = "carreras/carreras.php";
	httpDatos.addEventListener("acceso",acceso);
	httpDatos.addEventListener(ResultEvent.RESULT,fncCargarDatos);		
	httpDatos2.url = "carreras/carreras.php";
	httpDatos2.addEventListener("acceso",acceso);
	httpDatos2.addEventListener(ResultEvent.RESULT,fncCargarDatos2)
	httpDatos2.send({rutina:"traer_datos2"});
	btnNuevaCarrera.addEventListener("click" ,fncAgregarCarrera);
	btnCerrar.addEventListener("click" ,fncCerrar);
	txtNombre.addEventListener("change",fncTraerCarreras);
	btnBuscar.addEventListener("click",fncTraerEscuelasBoton);
}

private function fncTraerCarreras(e:Event):void{
	if (txtNombre.text.length==3){
		httpDatos.send({rutina:"traer_datos",filter:txtNombre.text});
	}
	if(txtNombre.text.length>3){
	
  		gridCarreras.dataProvider.filterFunction = filtroTexto;
        gridCarreras.dataProvider.refresh();			
	}
}

private function filtroTexto (item : Object) : Boolean
{
	return item.@nombre.toString().substr(0, txtNombre.text.length).toLowerCase() == txtNombre.text.toLowerCase();   
}

private function fncTraerEscuelasBoton(e:Event):void{
	httpDatos.send({rutina:"traer_datos",filter:txtNombre.text});
}

private function fncCargarDatos(e:Event):void {
	_xmlCarreras = <carreras></carreras>;
	_xmlCarreras.appendChild(httpDatos.lastResult.carreras);		
}

private function fncCargarDatos2(e:Event):void {	
	_xmlNiveles.appendChild(httpDatos2.lastResult.niveles);		
}

private function fncCerrar(e:Event):void{
	dispatchEvent(new Event("eventClose"));
}

private function fncAgregarCarrera(e:Event):void
{
	twCarrera = new carrera;
	twCarrera.addEventListener("EventAlta",fncAltaCarreras);
	PopUpManager.addPopUp(twCarrera,this,true);
	PopUpManager.centerPopUp(twCarrera);
}

private function fncAltaCarreras(e:Event):void{
	_xmlCarreras.appendChild(twCarrera.xmlCarrera);
	PopUpManager.removePopUp(e.target as carrera);
}

public function fncEditar():void
{
	twCarrera = new carrera;
	twCarrera.xmlCarrera =  (gridCarreras.selectedItem as XML).copy();
	twCarrera.addEventListener("EventEdit",fncEditarCarrera);
	PopUpManager.addPopUp(twCarrera,this,true);
	PopUpManager.centerPopUp(twCarrera);
}

public function fncEliminar():void
{
	twCarrera = new carrera;
	twCarrera.xmlCarrera2 =  (gridCarreras.selectedItem as XML).copy();
	twCarrera.addEventListener("EventDelete",fncEliminarCarrera);
	PopUpManager.addPopUp(twCarrera,this,true);
	PopUpManager.centerPopUp(twCarrera);
}

private function fncEditarCarrera(e:Event):void
{
	_xmlCarreras.carreras[(gridCarreras.selectedItem as XML).childIndex()] = twCarrera.xmlCarrera;
	PopUpManager.removePopUp(e.target as carrera);		
}

private function fncEliminarCarrera(e:Event):void
{
	delete _xmlCarreras.carreras[(gridCarreras.selectedItem as XML).childIndex()];
	PopUpManager.removePopUp(e.target as carrera);		
}
