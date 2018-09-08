import clases.HTTPServices;

import mx.controls.Alert;
import mx.events.CloseEvent;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;

import titulos.nuevo_titulo;

include "../control_acceso.as";

[Bindable] private var httpDatos : HTTPServices = new HTTPServices;
[Bindable] private var _xmlTitulos:XML = <titulos></titulos>;	
[Bindable] private var _xmlObs:XML = <observaciones></observaciones>;
private var _twNuevosTitulos:nuevo_titulo;

public function get xmlTitulos():XML{return _xmlTitulos.copy();}
public function get xmlObs():XML{return _xmlObs.copy();}

//inicializa las variales necesarias para el modulo
public function fncInit():void
{	
	this.currentState = (parentDocument.accion == 'B') ? 'baja' : '';	
		
	_xmlTitulos = <titulos></titulos>;
	_xmlTitulos.appendChild(this.parentDocument.xmlDatosDocente.titulo);	
	_xmlObs = <observaciones></observaciones>;
	httpDatos.url = "titulos/titulos.php";
	httpDatos.addEventListener(ResultEvent.RESULT,fncObsResult);		
	httpDatos.addEventListener("acceso",acceso);
	httpDatos.send({rutina:"traer_observaciones"});
	btnNuevoTitulo.addEventListener("click" ,fncAgregarTitulo);
	btnNuevoTitulo.setFocus();		
}

private function fncCerrar(e:Event):void{
	dispatchEvent(new Event("eventClose"));
}

private function fncAgregarTitulo(e:Event):void
{				
	_twNuevosTitulos = new nuevo_titulo;
	_twNuevosTitulos.addEventListener("EventConfirmarAntecedente",fncGrabarNuevoTitulo);
	PopUpManager.addPopUp(_twNuevosTitulos,this,true);
	PopUpManager.centerPopUp(_twNuevosTitulos);
}

private function fncGrabarNuevoTitulo(e:Event):void
{
	var xmlTitulo : XML = _twNuevosTitulos.xmlTitulo;
	var existente : Boolean = false;
	for (var i:int = 0;i < _xmlTitulos.titulo.length();i++) {
		if (xmlTitulo.@codigo == _xmlTitulos.titulo[i].@codigo) {
			existente = true;
		}
	}
	if (existente == true) {
		Alert.show("El Título " + xmlTitulo.@denominacion + " ya ha sido seleccionado","E R R O R");
	} else {
		_xmlTitulos.appendChild(xmlTitulo);		
		PopUpManager.removePopUp(e.target as nuevo_titulo);	
	}		
}

public function fncEliminarTitulo():void
{
	Alert.show("¿Realmente desea Eliminar el Título "+ gridTitulos.selectedItem.@denominacion+"?", "Confirmar", Alert.OK | Alert.CANCEL, this, fncConfirmEliminarTitulo, null, Alert.OK);
}

private function fncConfirmEliminarTitulo(e:CloseEvent):void
{
	var xmlTitulo : XML = _xmlTitulos.titulo[(gridTitulos.selectedItem as XML).childIndex()];
	if (e.detail==Alert.OK) {			
		delete _xmlTitulos.titulo[(gridTitulos.selectedItem as XML).childIndex()]; 
	}
}

private function fncObsResult(e:Event) : void 			
{
	var xmlObs:XML = <observaciones Id_observ_titulo="" codigo="" observacion=""/>
	_xmlObs.appendChild(xmlObs);
	_xmlObs.appendChild(httpDatos.lastResult.observaciones);				 	
}
