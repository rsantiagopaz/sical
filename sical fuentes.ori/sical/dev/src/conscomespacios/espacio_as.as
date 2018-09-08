import clases.HTTPServices;

import flash.events.Event;

import mx.controls.Alert;
import mx.core.UIComponent;
import mx.events.CloseEvent;
import mx.events.ValidationResultEvent;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;
import mx.validators.Validator;

include "../control_acceso.as";
include "../asincludes/numericSort.as";

[Bindable] private var _xmlEspacio : XML = <carreras  />;
[Bindable] private var _xmlCarreras:XML = <carreras></carreras>;
[Bindable] private var httpCarrera : HTTPServices = new HTTPServices;
private var _accion : String;


public function get xmlEspacio():XML{return _xmlEspacio.copy();}
public function set xmlEspacio(car:XML):void{
	_xmlEspacio = car;
	_accion = "editar";
}
public function set xmlEspacio2(car:XML):void{
	_xmlEspacio = car;
	_accion = "eliminar";
}
public function modificar():void{
	
}	
private function fncInit():void
{
	var i:int;		
	//preparo el PopUp Para que se cierre con esc y marco el default button
	//this.defaultButton = btnGrabar;
	this.addEventListener(KeyboardEvent.KEY_UP,function(e:KeyboardEvent):void{if (e.keyCode==27) btnCancel.dispatchEvent(new MouseEvent(MouseEvent.CLICK))});				
	//preparo el httpservice
	httpCarrera.url = "conscomespacios/conscomespacios.php";
	httpCarrera.addEventListener("acceso",acceso);
	// escucho evento de los botones
	btnCancel.addEventListener("click",fncCerrar);
	if (_accion == "editar") {
		httpCarrera.addEventListener(ResultEvent.RESULT,fncCargarDatos);
		httpCarrera.send({rutina:"traer_carreras",id_espacio:_xmlEspacio.@id_espacio});					
		txtCodigo.text = _xmlEspacio.@codigo;
		txtNombre.text = _xmlEspacio.@denominacion;			
	} else if (_accion == "eliminar") {
		this.currentState = "eliminar";
		txtCodigo.text = _xmlEspacio.@codigo;
		txtNombre.text = _xmlEspacio.@denominacion;			
	} 
	else
		//btnGrabar.addEventListener("click",fncAdd);		
	//pocisino el cursor
	txtNombre.setFocus();
}

private function fncArmarxmlEspacio():void{
	_xmlEspacio.@nombre=txtNombre.text;
	_xmlEspacio.@codigo=txtCodigo.text;
	if (_accion != "editar")
		_xmlEspacio.@id_carrera="";
	//_xmlEspacio.@id_nivel=cmbNivel.selectedItem.@id_nivel;
	//_xmlEspacio.@nivel=cmbNivel.selectedItem.@nivel;		
}

private function fncCargarDatos(e:Event):void {
	_xmlCarreras = <carreras></carreras>;
	_xmlCarreras.appendChild(httpCarrera.lastResult.carreras);		
}	

private function fncCerrar(e:Event):void
{
	PopUpManager.removePopUp(this)	
}		
		
private function fncValidar():Boolean
{
	var error:Array = Validator.validateAll([validNombre]);
	if (error.length>0) {
		((error[0] as ValidationResultEvent).target.source as UIComponent).setFocus();
		return false;
	}else{
		return true;	
	}	
}