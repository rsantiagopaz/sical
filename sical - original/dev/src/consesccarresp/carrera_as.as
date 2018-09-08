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

[Bindable] private var _xmlCarrera : XML = <carreras  />;
[Bindable] private var httpCarrera : HTTPServices = new HTTPServices;
private var _accion : String;


public function get xmlCarrera():XML{return _xmlCarrera.copy();}
public function set xmlCarrera(car:XML):void{
	_xmlCarrera = car;
	_accion = "editar";
}
public function set xmlCarrera2(car:XML):void{
	_xmlCarrera = car;
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
	//carrera los data providers de los combos
	//cmbNivel.dataProvider = (parentApplication.CARRERAS.xmlNiveles.niveles);		
	//preparo el httpservice
	httpCarrera.url = "carreras/carreras.php";
	httpCarrera.addEventListener("acceso",acceso);
	// escucho evento de los botones
	btnCancel.addEventListener("click",fncCerrar);
	if (_accion == "editar") {			
		/*for (i = 0;i < parentApplication.CARRERAS.xmlNiveles.niveles.length();i++) {
			if (parentApplication.CARRERAS.xmlNiveles.niveles[i].@id_nivel == _xmlCarrera.@id_nivel) {
				cmbNivel.selectedIndex = i;
				break;	
			}					
		}*/	
		gridEspacios.dataProvider=parentApplication.consesccarresp.xmlCarreras.carrera.(@id_carrera==_xmlCarrera.@id_carrera).espacio;		
		txtCodigo.text = _xmlCarrera.@codigo;
		txtNombre.text = _xmlCarrera.@nombre;			
		//btnGrabar.addEventListener("click",fncEdit);
	} else if (_accion == "eliminar") {
		this.currentState = "eliminar";
		txtCodigo.text = _xmlCarrera.@codigo;
		txtNombre.text = _xmlCarrera.@nombre;
		/*for (i = 0;i < parentApplication.CARRERAS.xmlNiveles.niveles.length();i++) {
			if (parentApplication.CARRERAS.xmlNiveles.niveles[i].@id_nivel == _xmlCarrera.@id_nivel) {
				cmbNivel.selectedIndex = i;
				break;	
			}					
		}*/
		//btnEliminar.addEventListener("click",fncDelete);
	} 
	else
		//btnGrabar.addEventListener("click",fncAdd);		
	//posiciono el cursor
	txtNombre.setFocus();
}

private function fncArmarxmlCarrera():void{
	_xmlCarrera.@nombre=txtNombre.text;
	_xmlCarrera.@codigo=txtCodigo.text;
	if (_accion != "editar")
		_xmlCarrera.@id_carrera="";
	//_xmlCarrera.@id_nivel=cmbNivel.selectedItem.@id_nivel;
	//_xmlCarrera.@nivel=cmbNivel.selectedItem.@nivel;		
}		

private function fncCerrar(e:Event):void
{
	PopUpManager.removePopUp(this)	
}

private function fncAdd(e:Event):void
{
	if (fncValidar()) {
		fncArmarxmlCarrera();			
		httpCarrera.addEventListener(ResultEvent.RESULT,fncResultAdd);
		httpCarrera.send({rutina:"insert", xmlCarrera:_xmlCarrera.toXMLString()});
	}
}

private function fncResultAdd(e:Event):void{
	_xmlCarrera.@id_carrera = httpCarrera.lastResult.insert_id;
	_xmlCarrera.@codigo = httpCarrera.lastResult.codigos.@cc;
				
	Alert.show("El alta se registro con exito","carrera");
	dispatchEvent(new Event("EventAlta"));	
	
	httpCarrera.removeEventListener(ResultEvent.RESULT,fncResultAdd);
}

private function fncResultEdit(e:Event):void{		
	var existe_codigo : String =  httpCarrera.lastResult.codigos.@cc;
	if (existe_codigo=="0"){					
		Alert.show("La modificación se registró con exito","espacio");
		dispatchEvent(new Event("EventEdit"));	
	}else{
		Alert.show("El codigo de carrera ingresado ya existe","ERROR");	
	}
	httpCarrera.removeEventListener(ResultEvent.RESULT,fncResultEdit);
}

private function fncResultDelete(e:Event):void{		
	Alert.show("La eliminación se registro con exito","carrera");
	dispatchEvent(new Event("EventDelete"));			
	httpCarrera.removeEventListener(ResultEvent.RESULT,fncResultDelete);
}

private function fncEdit(e:Event):void
{
	if (fncValidar()) {
		fncArmarxmlCarrera();			
		httpCarrera.addEventListener(ResultEvent.RESULT,fncResultEdit);
		httpCarrera.send({rutina:"update", xmlCarrera:_xmlCarrera.toXMLString()});
	}
}

private function fncDelete(e:Event):void
{
	Alert.show("¿Realmente desea Eliminar la carrera "+ _xmlCarrera.@nombre+"?", "Confirmar", Alert.OK | Alert.CANCEL, this, fncConfirmEliminarCarrera, null, Alert.OK);		
}

private function fncConfirmEliminarCarrera(e:CloseEvent):void
{		
	if (e.detail==Alert.OK){
		httpCarrera.addEventListener(ResultEvent.RESULT,fncResultDelete);
		httpCarrera.send({rutina:"delete", xmlCarrera:_xmlCarrera.toXMLString()}); 
	}
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