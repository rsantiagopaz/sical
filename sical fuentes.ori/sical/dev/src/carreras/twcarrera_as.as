import clases.HTTPServices;		

import flash.events.Event;

import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;


include "../control_acceso.as";

[Bindable] private var _xmlCarreras:XML = <carreras></carreras>;
[Bindable] private var _xmlNiveles:XML = <niveles></niveles>;	
private var httpDatos:HTTPServices = new HTTPServices;
private var httpDatos2:HTTPServices = new HTTPServices;	
private var _xmlCarrera:XML;
private var _caso:int;

public function get xmlNiveles():XML { return _xmlNiveles }	
public function get xmlCarrera():XML { return _xmlCarrera }
public function set todos(caso:int):void { _caso = caso }

public function fncInit():void
{		
	httpDatos.url = "carreras/carreras.php";
	httpDatos.addEventListener("acceso",acceso);
	httpDatos.addEventListener(ResultEvent.RESULT,fncCargarDatos);		
	httpDatos2.url = "carreras/carreras.php";
	httpDatos2.addEventListener("acceso",acceso);
	httpDatos2.addEventListener(ResultEvent.RESULT,fncCargarDatos2)
	httpDatos2.send({rutina:"traer_datos2"});		
	btnCerrar.addEventListener("click" ,fncCerrar);
	//txtNombre.addEventListener("change",fncTraerCarreras);
	btnBuscar.addEventListener("click",fncTraerCarrerasBoton);
	txtNombre.setFocus();
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

private function fncTraerCarrerasBoton(e:Event):void{
	httpDatos.send({rutina:"buscar_carrera",filter:txtNombre.text,caso:_caso});
}

private function fncCargarDatos(e:Event):void {
	_xmlCarreras = <carreras></carreras>;
	_xmlCarreras.appendChild(httpDatos.lastResult.carreras);
	//_xmlNiveles.appendChild(httpDatos.lastResult.niveles);		
}

private function fncCargarDatos2(e:Event):void {
	//_xmlCarreras.appendChild(httpDatos.lastResult.carreras);
	_xmlNiveles.appendChild(httpDatos2.lastResult.niveles);		
}

private function fncCerrar(e:Event):void{
	PopUpManager.removePopUp(this);
}		

public function fncSeleccionar():void
{
	_xmlCarrera =  (gridCarreras.selectedItem as XML).copy();
	dispatchEvent(new Event("EventConfirmarCarrera"));
}		

private function fncEliminarCarrera(e:Event):void
{
	delete _xmlCarreras.carreras[(gridCarreras.selectedItem as XML).childIndex()];
	PopUpManager.removePopUp(e.target as carrera);		
}
	