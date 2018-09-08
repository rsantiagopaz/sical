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

[Bindable] private var _xmlCargo : XML = <cargos  />;
[Bindable] private var httpCargo : HTTPServices = new HTTPServices;
private var _accion : String;


public function get xmlCargo():XML{return _xmlCargo.copy();}
public function set xmlCargo(car:XML):void{
	_xmlCargo = car;
	_accion = "editar";
}
public function set xmlCargo2(car:XML):void{
	_xmlCargo = car;
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
	cmbNivel.dataProvider = (parentApplication.CARGOS.xmlNiveles.niveles);		
	//preparo el httpservice
	httpCargo.url = "cargos/cargos.php";
	httpCargo.addEventListener("acceso",acceso);
	// escucho evento de los botones
	btnCancel.addEventListener("click",fncCerrar);
	if (_accion == "editar") {			
		if (_xmlCargo.@id_nivel == '2') {
			this.currentState = "iniprim";
		} else if (_xmlCargo.@id_nivel == '5') {
			this.currentState = "especadult";
		} else {
			this.currentState = "base";
		}
		for (i = 0;i < parentApplication.CARGOS.xmlNiveles.niveles.length();i++) {
			if (parentApplication.CARGOS.xmlNiveles.niveles[i].@id_nivel == _xmlCargo.@id_nivel) {
				cmbNivel.selectedIndex = i;
				break;	
			}					
		}			
		txtCodigo.text = _xmlCargo.@codigo;
		txtNombre.text = _xmlCargo.@denominacion;
		if (_xmlCargo.@id_nivel == '2') {
			if (_xmlCargo.@jornada_completa == 'Si')
				rbCompSi.selected = true;
			else
				rbCompNo.selected = true;
		}
		if (_xmlCargo.@id_nivel == '5') {
			if (_xmlCargo.@subtipo == 'Capacitación')					
				rbCapac.selected = true;
			else if (_xmlCargo.@subtipo == 'Especial')					
				rbEspec.selected = true;
			else
				rbAdult.selected = true;
		}
		btnGrabar.addEventListener("click",fncEdit);
	} else if (_accion == "eliminar") {
		this.currentState = "eliminar";
		txtCodigo.text = _xmlCargo.@codigo;
		txtNombre.text = _xmlCargo.@denominacion;
		for (i = 0;i < parentApplication.CARGOS.xmlNiveles.niveles.length();i++) {
			if (parentApplication.CARGOS.xmlNiveles.niveles[i].@id_nivel == _xmlCargo.@id_nivel) {
				cmbNivel.selectedIndex = i;
				break;	
			}					
		}
		btnEliminar.addEventListener("click",fncDelete);
	} else {
		if (cmbNivel.selectedItem.@id_nivel == '2') {
			this.currentState = "iniprim";
		} else if (cmbNivel.selectedItem.@id_nivel == '5') {
			this.currentState = "especadult";
		} else {
			this.currentState = "base";
		}
		btnGrabar.addEventListener("click",fncAdd);
	}			
	cmbNivel.addEventListener("change",fncChangeState);
	//posiciono el cursor
	txtNombre.setFocus();
}

private function fncArmarXmlCargo():void{
	_xmlCargo.@denominacion=txtNombre.text;
	_xmlCargo.@codigo=txtCodigo.text;
	if (_accion != "editar")
		_xmlCargo.@id_cargo="";
	_xmlCargo.@id_nivel=cmbNivel.selectedItem.@id_nivel
	_xmlCargo.@nivel=cmbNivel.selectedItem.@nivel;
	if (cmbNivel.selectedItem.@id_nivel == '2') {
		if (rbCompSi.selected == true)
			_xmlCargo.@jornada_completa = '1';
		else
			_xmlCargo.@jornada_completa = '0';
	} else
		_xmlCargo.@jornada_completa = '0';
	if (cmbNivel.selectedItem.@id_nivel == '5') {
		if (rbCapac.selected == true)
			_xmlCargo.@subtipo = 'C';
		else if (rbEspec.selected == true)
			_xmlCargo.@subtipo = 'E';
		else
			_xmlCargo.@subtipo = 'A';
	} else 
		_xmlCargo.@subtipo = '';
}

private function fncChangeState(e:Event):void
{
	if (cmbNivel.selectedItem.@id_nivel == '2') {
		this.currentState = "iniprim";
	} else if (cmbNivel.selectedItem.@id_nivel == '5') {
		this.currentState = "especadult";
	} else {
		this.currentState = "base";
	}
}

private function fncCerrar(e:Event):void
{
	PopUpManager.removePopUp(this)	
}

private function fncAdd(e:Event):void
{
	if (fncValidar()) {
		fncArmarXmlCargo();			
		httpCargo.addEventListener(ResultEvent.RESULT,fncResultAdd);
		httpCargo.send({rutina:"insert", xmlCargo:_xmlCargo.toXMLString()});
	}
}

private function fncResultAdd(e:Event):void{
	_xmlCargo.@id_cargo = httpCargo.lastResult.insert_id;
	_xmlCargo.@codigo = httpCargo.lastResult.codigos.@cc;
	
	if (_xmlCargo.@jornada_completa == '1')
		_xmlCargo.@jornada_completa = 'Si';
	else
		_xmlCargo.@jornada_completa = 'No';
	Alert.show("El alta se registro con exito","cargo");
	dispatchEvent(new Event("EventAlta"));	
	
	httpCargo.removeEventListener(ResultEvent.RESULT,fncResultAdd);
}

private function fncResultEdit(e:Event):void{		
	var existe_codigo : String =  httpCargo.lastResult.codigos.@cc;
	if (existe_codigo=="0"){
		if (_xmlCargo.@jornada_completa == '1')
			_xmlCargo.@jornada_completa = 'Si';
		else
			_xmlCargo.@jornada_completa = 'No';		
		Alert.show("La modificación se registró con exito","espacio");
		dispatchEvent(new Event("EventEdit"));	
	}else{
		Alert.show("El codigo de espacio ingresado ya existe","ERROR");	
	}
	httpCargo.removeEventListener(ResultEvent.RESULT,fncResultEdit);
}

private function fncResultDelete(e:Event):void{		
	Alert.show("La eliminación se registro con exito","cargo");
	dispatchEvent(new Event("EventDelete"));			
	httpCargo.removeEventListener(ResultEvent.RESULT,fncResultDelete);
}

private function fncEdit(e:Event):void
{
	if (fncValidar()) {
		fncArmarXmlCargo();
		httpCargo.addEventListener(ResultEvent.RESULT,fncResultEdit);
		httpCargo.send({rutina:"update", xmlCargo:_xmlCargo.toXMLString()});
	}
}

private function fncDelete(e:Event):void
{
	Alert.show("¿Realmente desea Eliminar el Cargo "+ _xmlCargo.@denominacion+"?", "Confirmar", Alert.OK | Alert.CANCEL, this, fncConfirmEliminarCargo, null, Alert.OK);		
}

private function fncConfirmEliminarCargo(e:CloseEvent):void
{		
	if (e.detail==Alert.OK){
		httpCargo.addEventListener(ResultEvent.RESULT,fncResultDelete);
		httpCargo.send({rutina:"delete", xmlCargo:_xmlCargo.toXMLString()}); 
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