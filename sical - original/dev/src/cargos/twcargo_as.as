import clases.HTTPServices;

import flash.events.Event;

import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;


include "../control_acceso.as";

[Bindable] private var _xmlCargos:XML = <cargos></cargos>;
[Bindable] private var _xmlNiveles:XML = <niveles></niveles>;	
private var httpDatos:HTTPServices = new HTTPServices;
private var httpDatos2:HTTPServices = new HTTPServices;	
private var _xmlCargo:XML;
private var _caso:int;

public function get xmlNiveles():XML { return _xmlNiveles }
public function get xmlCargo():XML { return _xmlCargo }
public function set todos(caso:int):void { _caso = caso }


public function fncInit():void
{		
	httpDatos.url = "cargos/cargos.php";
	httpDatos.addEventListener("acceso",acceso);
	httpDatos.addEventListener(ResultEvent.RESULT,fncCargarDatos)		
	httpDatos2.url = "cargos/cargos.php";
	httpDatos2.addEventListener("acceso",acceso);
	httpDatos2.addEventListener(ResultEvent.RESULT,fncCargarDatos2)
	httpDatos2.send({rutina:"traer_datos2"});		
	btnCerrar.addEventListener("click" ,fncCerrar);	
	btnBuscar.addEventListener("click",fncTraerCargosBoton);
	txtNombre.setFocus();
}

private function fncTraerCargos(e:Event):void{
	if (txtNombre.text.length==3){
		httpDatos.send({rutina:"traer_datos",filter:txtNombre.text});
	}
	if(txtNombre.text.length>3){
	
  		gridCargos.dataProvider.filterFunction = filtroTexto;
        gridCargos.dataProvider.refresh();			
	}
}

private function filtroTexto (item : Object) : Boolean
{
	return item.@denominacion.toString().substr(0, txtNombre.text.length).toLowerCase() == txtNombre.text.toLowerCase();   
}

private function fncTraerCargosBoton(e:Event):void{
	httpDatos.send({rutina:"buscar_cargo",filter:txtNombre.text,caso:_caso});
}

private function fncCargarDatos(e:Event):void {
	_xmlCargos = <cargos></cargos>;
	_xmlCargos.appendChild(httpDatos.lastResult.cargos);			
}

private function fncCargarDatos2(e:Event):void {	
	_xmlNiveles.appendChild(httpDatos2.lastResult.niveles);		
}

private function fncCerrar(e:Event):void{
	PopUpManager.removePopUp(this);
}		

public function fncSeleccionar():void
{
	_xmlCargo =  (gridCargos.selectedItem as XML).copy();
	dispatchEvent(new Event("EventConfirmarCargo"));
}		

private function fncEliminarCargo(e:Event):void
{
	delete _xmlCargos.cargos[(gridCargos.selectedItem as XML).childIndex()];
	PopUpManager.removePopUp(e.target as cargo);		
}
	