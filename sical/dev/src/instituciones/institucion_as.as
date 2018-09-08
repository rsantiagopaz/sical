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

[Bindable] private var _xmlInstitucion : XML = <instituciones  />;
[Bindable] private var httpInstitucion : HTTPServices = new HTTPServices;
[Bindable] private var xmlDepartamentos : XML = <departamentos></departamentos>;
private var _accion : String;


public function get xmlInstitucion():XML{return _xmlInstitucion.copy();}
public function set xmlInstitucion(esc:XML):void{
	_xmlInstitucion = esc;
	_accion = "editar";
}
public function set xmlInstitucion2(esc:XML):void{
	_xmlInstitucion = esc;
	_accion = "eliminar";
}

public function modificar():void{
	
}	
private function fncInit():void
{
	var i:int;
	//preparo el PopUp Para que se cierre con esc y marco el default button
	this.defaultButton = btnGrabar;
	this.addEventListener(KeyboardEvent.KEY_UP,function(e:KeyboardEvent):void{if (e.keyCode==27) btnCancel.dispatchEvent(new MouseEvent(MouseEvent.CLICK))});
	//cargo los data providers de los combos
	cmbNivel.dataProvider = (parentApplication.INSTITUCIONES.xmlProvincias.provincias);		
	//preparo el httpservice
	httpInstitucion.url = "instituciones/instituciones.php";
	httpInstitucion.addEventListener("acceso",acceso);
	// escucho evento de los botones
	if (_accion == "editar") {			
		txtNombre.text = _xmlInstitucion.@denominacion;
		for (i = 0;i < parentApplication.INSTITUCIONES.xmlProvincias.provincias.length();i++) {
			if (parentApplication.INSTITUCIONES.xmlProvincias.provincias[i].@id_provincia == _xmlInstitucion.@id_provincia) {
				cmbNivel.selectedIndex = i;
				break;	
			}					
		}
		btnGrabar.addEventListener("click",fncEdit);
	} else if (_accion == "eliminar") {
		this.currentState = "eliminar";			
		txtNombre.text = _xmlInstitucion.@denominacion;
		for (i = 0;i < parentApplication.INSTITUCIONES.xmlProvincias.provincias.length();i++) {
			if (parentApplication.INSTITUCIONES.xmlProvincias.provincias[i].@id_provincia == _xmlInstitucion.@id_provincia) {
				cmbNivel.selectedIndex = i;
				break;	
			}					
		}
		btnEliminar.addEventListener("click",fncDelete);
	} else
		btnGrabar.addEventListener("click",fncAdd);
	btnCancel.addEventListener("click",fncCerrar);		
	//posiciono el cursor
	txtNombre.setFocus();
}

private function fncEdit(e:Event):void
{
	if (fncValidar()) {
		fncArmarXmlInstitucion();			
		httpInstitucion.addEventListener(ResultEvent.RESULT,fncResultEdit);
		httpInstitucion.send({rutina:"update", xmlInstitucion:_xmlInstitucion.toXMLString()});
	}
}

private function fncResultEdit(e:Event):void{		
	var existe_codigo : String =  httpInstitucion.lastResult.denominaciones.@cc;
	if (existe_codigo=="0"){
		Alert.show("La modificación se registró con exito","institucion");
		dispatchEvent(new Event("EventEdit"));	
	}else{
		Alert.show("El nombre de institución ingresado ya existe","ERROR");	
	}
	httpInstitucion.removeEventListener(ResultEvent.RESULT,fncResultEdit);
}

private function fncDelete(e:Event):void
{
	Alert.show("¿Realmente desea Eliminar la Institucion "+ _xmlInstitucion.@denominacion+"?", "Confirmar", Alert.OK | Alert.CANCEL, this, fncConfirmEliminarInstitucion, null, Alert.OK);		
}

private function fncConfirmEliminarInstitucion(e:CloseEvent):void
{		
	if (e.detail==Alert.OK){
		httpInstitucion.addEventListener(ResultEvent.RESULT,fncResultDelete);
		httpInstitucion.send({rutina:"delete", xmlInstitucion:_xmlInstitucion.toXMLString()});
	}
}

private function fncResultDelete(e:Event):void{		
	Alert.show("La eliminación se registro con exito","institucion");
	dispatchEvent(new Event("EventDelete"));			
	httpInstitucion.removeEventListener(ResultEvent.RESULT,fncResultDelete);
}

private function fncArmarXmlInstitucion():void{
	_xmlInstitucion.@denominacion=txtNombre.text;		
	if (_accion != "editar")
		_xmlInstitucion.@id_institucion="";
	_xmlInstitucion.@id_provincia=cmbNivel.selectedItem.@id_provincia
	_xmlInstitucion.@provincia=cmbNivel.selectedItem.@provincia;		
}

private function fncCerrar(e:Event):void
{
	PopUpManager.removePopUp(this)	
}

private function fncAdd(e:Event):void
{
	if (fncValidar()) {
		fncArmarXmlInstitucion();
		httpInstitucion.addEventListener(ResultEvent.RESULT,fncResultAdd);
		httpInstitucion.send({rutina:"insert", xmlInstitucion:_xmlInstitucion.toXMLString()});
	}
}

private function fncResultAdd(e:Event):void{
	_xmlInstitucion.@id_institucion = httpInstitucion.lastResult.insert_id;
	var existe_codigo : String =  httpInstitucion.lastResult.denominaciones.@cc;
	if (existe_codigo=="0"){
		Alert.show("El alta se registro con exito","Institucion");
		dispatchEvent(new Event("EventAlta"));	
	}else{
		Alert.show("El nombre de institucion ingresado ya existe","ERROR");	
	}
	httpInstitucion.removeEventListener(ResultEvent.RESULT,fncResultAdd);
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