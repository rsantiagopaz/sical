import clases.HTTPServices;

import cargos.cargo;

import flash.events.Event;

import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;


include "../control_acceso.as";
include "../asincludes/numericSort.as";

[Bindable] private var _xmlCargos:XML = <cargos></cargos>;
[Bindable] private var _xmlNiveles:XML = <niveles></niveles>;	
private var httpDatos:HTTPServices = new HTTPServices;
private var httpDatos2:HTTPServices = new HTTPServices;
private var twCargo:cargo;

public function get xmlNiveles():XML { return _xmlNiveles }	


public function fncInit():void
{		
	httpDatos.url = "cargos/cargos.php";
	httpDatos.addEventListener("acceso",acceso);
	httpDatos.addEventListener(ResultEvent.RESULT,fncCargarDatos)		
	httpDatos2.url = "cargos/cargos.php";
	httpDatos2.addEventListener("acceso",acceso);
	httpDatos2.addEventListener(ResultEvent.RESULT,fncCargarDatos2)
	httpDatos2.send({rutina:"traer_datos2"});
	btnNuevoCargo.addEventListener("click" ,fncAgregarCargo);
	btnCerrar.addEventListener("click" ,fncCerrar);
	txtNombre.addEventListener("change",fncTraerCargos);
	btnBuscar.addEventListener("click",fncTraerCargosBoton);
	txiCodigoC.addEventListener("focusOut",fncBuscarCargo);
	txiCodigoC.setFocus();
}

private function fncBuscarCargo(e:Event):void
{
	if (txiCodigoC.text != "") {
		httpDatos.send({rutina:"buscar_cargo_codigo",codigo:txiCodigoC.text,caso:"1"});	
	}		
}

private function fncTraerCargos(e:Event):void{
	if (chkComodin.selected == false) {
		if (txtNombre.text.length==3){
			httpDatos.send({rutina:"traer_datos",filter:txtNombre.text});
		}
		if(txtNombre.text.length>3){
		
	  		gridCargos.dataProvider.filterFunction = filtroTexto;
            gridCargos.dataProvider.refresh();			
		}
	}		
}

private function filtroTexto (item : Object) : Boolean
{
	return item.@denominacion.toString().substr(0, txtNombre.text.length).toLowerCase() == txtNombre.text.toLowerCase();   
}

private function fncTraerCargosBoton(e:Event):void{
	if (chkComodin.selected == false)
		httpDatos.send({rutina:"traer_datos",filter:txtNombre.text});
	else
		httpDatos.send({rutina:"buscar_cargo",filter:txtNombre.text,caso:"1"});
}

private function fncCargarDatos(e:Event):void {
	_xmlCargos = <cargos></cargos>;
	_xmlCargos.appendChild(httpDatos.lastResult.cargos);				
}

private function fncCargarDatos2(e:Event):void {		
	_xmlNiveles.appendChild(httpDatos2.lastResult.niveles);		
}

private function fncCerrar(e:Event):void{
	dispatchEvent(new Event("eventClose"));
}

private function fncAgregarCargo(e:Event):void
{
	twCargo = new cargo;
	twCargo.addEventListener("EventAlta",fncAltaCargos);
	PopUpManager.addPopUp(twCargo,this,true);
	PopUpManager.centerPopUp(twCargo);
}

private function fncAltaCargos(e:Event):void{
	_xmlCargos.appendChild(twCargo.xmlCargo);
	PopUpManager.removePopUp(e.target as cargo);
}

public function fncEditar():void
{
	twCargo = new cargo;
	twCargo.xmlCargo =  (gridCargos.selectedItem as XML).copy();
	twCargo.addEventListener("EventEdit",fncEditarCargo);
	PopUpManager.addPopUp(twCargo,this,true);
	PopUpManager.centerPopUp(twCargo);
}

public function fncEliminar():void
{
	twCargo = new cargo;
	twCargo.xmlCargo2 =  (gridCargos.selectedItem as XML).copy();
	twCargo.addEventListener("EventDelete",fncEliminarCargo);
	PopUpManager.addPopUp(twCargo,this,true);
	PopUpManager.centerPopUp(twCargo);
}

private function fncEditarCargo(e:Event):void
{
	_xmlCargos.cargos[(gridCargos.selectedItem as XML).childIndex()] = twCargo.xmlCargo;
	PopUpManager.removePopUp(e.target as cargo);		
}

private function fncEliminarCargo(e:Event):void
{
	delete _xmlCargos.cargos[(gridCargos.selectedItem as XML).childIndex()];
	PopUpManager.removePopUp(e.target as cargo);		
}

