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

[Bindable] private var _xmlReclamo : XML = <reclamos  />;
[Bindable] private var httpReclamo : HTTPServices = new HTTPServices;
private var _accion : String;


public function get xmlReclamo():XML{return _xmlReclamo.copy();}
public function set xmlReclamo(car:XML):void{
	_xmlReclamo = car;
	_accion = "editar";
}
public function set xmlReclamo2(car:XML):void{
	_xmlReclamo = car;
	_accion = "eliminar";
}
public function set xmlReclamo3(car:XML):void{
	_xmlReclamo = car;
	_accion = "responder";
}
public function modificar():void{
	
}	
private function fncInit():void
{
	var i:int;
	//preparo el PopUp Para que se cierre con esc y marco el default button
	this.defaultButton = btnGrabar;
	this.addEventListener(KeyboardEvent.KEY_UP,function(e:KeyboardEvent):void{if (e.keyCode==27) btnCancel.dispatchEvent(new MouseEvent(MouseEvent.CLICK))});
	//reclamo los data providers de los combos
	cmbMotivo.dataProvider = (parentApplication.RECLAMOS.xmlMotivos.motivos);		
	//preparo el httpservice
	httpReclamo.url = "reclamos/reclamos.php";
	httpReclamo.addEventListener("acceso",acceso);
	// escucho evento de los botones
	btnCancel.addEventListener("click",fncCerrar);
	if (_accion == "editar") {			
		for (i = 0;i < parentApplication.RECLAMOS.xmlMotivos.motivos.length();i++) {
			if (parentApplication.RECLAMOS.xmlMotivos.motivos[i].@id_tipo_reclamo_ent == _xmlReclamo.@id_reclamo_entrada) {
				cmbMotivo.selectedIndex = i;
				break;	
			}					
		}						
		txaObservaciones.text = _xmlReclamo.@observaciones_reclamo;			
		btnGrabar.addEventListener("click",fncEdit);
	} else if (_accion == "eliminar") {
		this.currentState = "eliminar";			
		txaObservaciones.text = _xmlReclamo.@observaciones_reclamo;
		for (i = 0;i < parentApplication.RECLAMOS.xmlMotivos.motivos.length();i++) {
			if (parentApplication.RECLAMOS.xmlMotivos.motivos[i].@id_tipo_reclamo_ent == _xmlReclamo.@id_reclamo_entrada) {
				cmbMotivo.selectedIndex = i;
				break;	
			}					
		}
		btnEliminar.addEventListener("click",fncDelete);
	} else if (_accion == "responder") {
		this.currentState = "responder";
		cmbMotivo.dataProvider = (parentApplication.RECLAMOS.xmlRespuestas.respuestas);
		for (i = 0;i < parentApplication.RECLAMOS.xmlRespuestas.respuestas.length();i++) {
			if (parentApplication.RECLAMOS.xmlRespuestas.respuestas[i].@id_tipo_reclamo_resp == _xmlReclamo.@id_reclamo_respuesta) {
				cmbMotivo.selectedIndex = i;
				break;	
			}					
		}						
		txaObservaciones.text = _xmlReclamo.@observaciones_respuesta;
		btnGrabar.addEventListener("click",fncResp);
	} 
	else
		btnGrabar.addEventListener("click",fncAdd);		
	//posiciono el cursor
	cmbMotivo.setFocus();
}

private function fncArmarxmlReclamo():void{
	_xmlReclamo.@observaciones_reclamo=txaObservaciones.text;		
	if (_accion != "editar" && _accion != "responder")
		_xmlReclamo.@id_reclamo="";
	if (_accion != "responder") {
		_xmlReclamo.@id_reclamo_entrada=cmbMotivo.selectedItem.@id_tipo_reclamo_ent;
		_xmlReclamo.@motivo=cmbMotivo.selectedItem.@descripcion;	
	} else {
		_xmlReclamo.@observaciones_respuesta=txaObservaciones.text;
		_xmlReclamo.@id_reclamo_respuesta=cmbMotivo.selectedItem.@id_tipo_reclamo_resp;
		_xmlReclamo.@respuesta=cmbMotivo.selectedItem.@descripcion;
	}	
}		

private function fncCerrar(e:Event):void
{
	PopUpManager.removePopUp(this)	
}

private function fncAdd(e:Event):void
{
	if (fncValidar()) {
		fncArmarxmlReclamo();			
		httpReclamo.addEventListener(ResultEvent.RESULT,fncResultAdd);
		httpReclamo.send({rutina:"insert", xmlReclamo:_xmlReclamo.toXMLString(), id_docente_llamado:parentApplication.RECLAMOS.id_docente_llamado});
	}
}

private function fncResultAdd(e:Event):void{
	_xmlReclamo.@id_reclamo = httpReclamo.lastResult.insert.@id_reclamo;
	_xmlReclamo.@fecha_reclamo = httpReclamo.lastResult.fechareclamo.@fecha_reclamo;
	_xmlReclamo.@respuesta = '';	
				
	Alert.show("El alta se registro con exito","reclamo");
	dispatchEvent(new Event("EventAlta"));	
	
	httpReclamo.removeEventListener(ResultEvent.RESULT,fncResultAdd);
}

private function fncResultEdit(e:Event):void{
	var modif : String =  httpReclamo.lastResult.modific.@modif;
	if (modif == "S") {
		Alert.show("La modificación se registró con éxito","reclamo");
		dispatchEvent(new Event("EventEdit"));	
	} else {
		Alert.show("La modificación sólo puede efectuarse dentro de las 24 hs de efectuado el reclamo","ERROR");
	}			
	httpReclamo.removeEventListener(ResultEvent.RESULT,fncResultEdit);
}

private function fncResultResp(e:Event):void{				
	Alert.show("La respuesta se registró con éxito","reclamo");
	dispatchEvent(new Event("EventResp"));	
				
	httpReclamo.removeEventListener(ResultEvent.RESULT,fncResultResp);
}

private function fncResultDelete(e:Event):void{
	var modif : String =  httpReclamo.lastResult.modific.@modif;
	if (modif == "S") {
		Alert.show("La eliminación se registró con éxito","reclamo");
		dispatchEvent(new Event("EventDelete"));	
	} else {
		Alert.show("La eliminación sólo puede efectuarse dentro de las 24 hs de efectuado el reclamo","ERROR");
	}
	httpReclamo.removeEventListener(ResultEvent.RESULT,fncResultDelete);
}

private function fncEdit(e:Event):void
{
	if (fncValidar()) {
		fncArmarxmlReclamo();			
		httpReclamo.addEventListener(ResultEvent.RESULT,fncResultEdit);
		httpReclamo.send({rutina:"update", xmlReclamo:_xmlReclamo.toXMLString(), id_docente_llamado:parentApplication.RECLAMOS.id_docente_llamado});
	}
}

private function fncResp(e:Event):void
{
	if (fncValidar()) {
		fncArmarxmlReclamo();			
		httpReclamo.addEventListener(ResultEvent.RESULT,fncResultResp);
		httpReclamo.send({rutina:"responder", xmlReclamo:_xmlReclamo.toXMLString(), id_docente_llamado:parentApplication.RECLAMOS.id_docente_llamado});
	}
}

private function fncDelete(e:Event):void
{
	Alert.show("¿Realmente desea Eliminar el reclamo "+ _xmlReclamo.@nombre+"?", "Confirmar", Alert.OK | Alert.CANCEL, this, fncConfirmEliminarReclamo, null, Alert.OK);		
}

private function fncConfirmEliminarReclamo(e:CloseEvent):void
{		
	if (e.detail==Alert.OK){
		httpReclamo.addEventListener(ResultEvent.RESULT,fncResultDelete);
		httpReclamo.send({rutina:"delete", xmlReclamo:_xmlReclamo.toXMLString()}); 
	}
}

private function fncValidar():Boolean
{
	var error:Array = new Array;
	if (error.length>0) {
		((error[0] as ValidationResultEvent).target.source as UIComponent).setFocus();
		return false;
	}else{
		return true;	
	}	
}